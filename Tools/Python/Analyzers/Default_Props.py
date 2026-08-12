import os, sys
p = os.path.dirname(os.path.abspath(__file__))
while p != os.path.dirname(p) and not os.path.exists(os.path.join(p, "lib")):
    p = os.path.dirname(p)
sys.path.insert(0, os.path.join(p, "lib"))
from api import get_api_response
from dump import write_dump_file

def build_map(data):
    props = {}
    for cls in data["Classes"]:
        cn = cls.get("Name")
        if not cn: continue
        for m in cls.get("Members", []):
            if m.get("MemberType") == "Property":
                props[f"{cn}.{m.get('Name')}"] = m.get("Default")
    return props

def compare(vh=None):
    resp, vh = get_api_response(vh)
    p1 = build_map(resp.json())
    keys = sorted(p1.keys())
    out = f"Version: {vh}\n" + "=" * 80 + "\n\n"
    for k in keys:
        v1 = p1.get(k)
        if v1 and not str(v1).startswith("__api_dump_"):
            out += f"{k} = {repr(v1)[:80]}\n"
    out += f"\n" + "=" * 80 + f"\nTotal properties: {len(keys)}\n"
    return out

if __name__ == "__main__":
    try:
        content = compare(sys.argv[1] if len(sys.argv) > 1 else None)
        print(content)
        write_dump_file(content, "Dump", os.path.dirname(__file__))
    except Exception as e:
        print(f"Error: {e}")
