import os, sys, re
p = os.path.dirname(os.path.abspath(__file__))
while p != os.path.dirname(p) and not os.path.exists(os.path.join(p, "lib")):
    p = os.path.dirname(p)
sys.path.insert(0, os.path.join(p, "lib"))
from api import get_api_response
from dump import write_dump_file

def fetch(vh=None):
    resp, vh = get_api_response(vh)
    out = f"{vh}\n\n"
    count = 0
    for cls in resp.json()["Classes"]:
        cname = cls.get("Name", "Unknown")
        added = False
        for m in cls.get("Members", []):
            if m.get("MemberType") != "Property": continue
            vt = m.get("ValueType", {})
            if not isinstance(vt, dict) or vt.get("Name") != "Content": continue
            default = m.get("Default")
            if "api_dump_" in str(default): continue
            default = re.sub(r"\s+", "", str(default))
            out += f"{cname}.{m['Name']} {{default: \"{default}\"}}\n"
            count += 1
            added = True
        if added: out += "\n"
    out += f"\n---\nTotal: {count}\n"
    return out

if __name__ == "__main__":
    try:
        c = fetch(sys.argv[1] if len(sys.argv) > 1 else None)
        print(c)
        write_dump_file(c, "Dump", os.path.dirname(__file__))
    except Exception as e:
        print(f"Error: {e}")
