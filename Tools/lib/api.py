import os, requests, json, time

SCRIPT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CACHE_FILE = os.path.join(SCRIPT_DIR, "api_dump_cache.json")
CACHE_TTL = 60 * 60 * 2

FALLBACK_DUMP_URL = "https://raw.githubusercontent.com/setup-rbxcdn/roblox-full-api-dumps/refs/heads/main/full-dumps/{}-Full-API-Dump.json"

def fetch(u):
    try:
        r = requests.get(u.strip())
        r.raise_for_status()
        return r
    except:
        return None

def parse_version(v):
    return tuple(int(x) for x in v.split("."))

def get_version_history_latest():
    try:
        txt = requests.get("https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/refs/heads/roblox/version-history.json").text
        for line in reversed(txt.splitlines()):
            if "version-" in line:
                parts = line.strip().strip(",")
                k, v = parts.split(":")
                return k.strip().strip('"'), v.strip().strip('"')
    except:
        pass

def get_clientsettings(url):
    try:
        data = fetch(url).json()
        return data.get("version"), data.get("clientVersionUpload")
    except:
        return None

def get_latest_version():
    candidates = []
    vh = get_version_history_latest()
    if vh: candidates.append(vh)
    zb = get_clientsettings("https://clientsettingscdn.roblox.com/v2/client-version/WindowsStudio64/channel/zbeta")
    if zb: candidates.append(zb)
    live = get_clientsettings("https://clientsettingscdn.roblox.com/v2/client-version/WindowsStudio64")
    if live: candidates.append(live)
    if not candidates: return None, None
    candidates.sort(key=lambda x: parse_version(x[0]), reverse=True)
    return candidates[0]

def load_cache(api_version):
    if not os.path.exists(CACHE_FILE): return None, None
    try:
        with open(CACHE_FILE, "r") as f: data = json.load(f)
        if api_version in data:
            entry = data[api_version]
            if time.time() - entry["time"] < CACHE_TTL:
                class CachedResponse:
                    def __init__(self, text):
                        self.text = text
                        self._json = None
                    def json(self):
                        if self._json is None: self._json = json.loads(self.text)
                        return self._json
                return CachedResponse(entry["dump"]), entry.get("version_hash")
    except:
        pass
    return None, None

def save_cache(resp_obj, api_version, version_hash):
    try:
        data = json.load(open(CACHE_FILE, "r")) if os.path.exists(CACHE_FILE) else {}
        dump_text = resp_obj if isinstance(resp_obj, str) else (resp_obj.text if hasattr(resp_obj, "text") else json.dumps(resp_obj.json()))
        data[api_version] = {"time": time.time(), "dump": dump_text, "version_hash": version_hash}
        with open(CACHE_FILE, "w") as f: json.dump(data, f)
    except:
        pass

def get_api_response(vh=None):
    if vh: return fetch(FALLBACK_DUMP_URL.format(vh)), vh
    vh, ver = get_latest_version()
    if not vh: raise Exception("Could not get version info")
    resp, cached_vh = load_cache(vh)
    if resp: return resp, cached_vh
    resp = fetch(FALLBACK_DUMP_URL.format(vh))
    if resp: save_cache(resp, vh, vh)
    return resp, vh
