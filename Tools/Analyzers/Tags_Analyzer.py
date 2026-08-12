import os, sys, json
p = os.path.dirname(os.path.abspath(__file__))
while p != os.path.dirname(p) and not os.path.exists(os.path.join(p, "lib")):
    p = os.path.dirname(p)
sys.path.insert(0, os.path.join(p, "lib"))
from api import get_api_response
from dump import write_dump_file

def tag_key(t):
    if isinstance(t, str): return (0, t, "")
    if isinstance(t, dict): return (1, "", json.dumps(t, sort_keys=True))
    return (2, str(t), "")

def get_tags(data):
    tags = {}
    for c in data["Classes"]:
        cn = c.get("Name")
        if not cn: continue
        ct = c.get("Tags", [])
        tags[cn] = {"cmp": sorted(ct, key=tag_key), "raw": ct}
        for m in c.get("Members", []):
            mn, mt = m.get("Name"), m.get("MemberType")
            if mt in ("Property", "Function", "Event", "Callback"):
                key = f"{cn}.{mn}"
                t = m.get("Tags", [])
                tags[key] = {"cmp": sorted(t, key=tag_key), "type": mt, "raw": t}
    return tags

def compare(vh=None):
    resp, vh = get_api_response(vh)
    tags = get_tags(resp.json())
    out = f"Version: {vh}\n" + "=" * 80 + "\n\n"
    
    for k in sorted(tags.keys()):
        v = tags[k]["raw"]
        if v:
            out += f"{k}\n  {v}\n"

    out += f"\n" + "=" * 80 + f"\nTotal with tags: {sum(1 for v in tags.values() if v['raw'])}\n"
    return out

if __name__ == "__main__":
    try:
        content = compare(sys.argv[1] if len(sys.argv) > 1 else None)
        print(content)
        write_dump_file(content, "Dump", os.path.dirname(__file__))
    except Exception as e:
        print(f"Error: {e}")
