import os, sys
p = os.path.dirname(os.path.abspath(__file__))
while p != os.path.dirname(p) and not os.path.exists(os.path.join(p, "lib")):
    p = os.path.dirname(p)
sys.path.insert(0, os.path.join(p, "lib"))
from api import get_api_response
from dump import write_dump_file, array_to_dictionary
import requests

def fetch(vh=None):
    resp, vh = get_api_response(vh)
    data = resp.json()
    dtypes, dtypes_set, save_t, load_t = [], set(), {}, {}
    for c in data["Classes"]:
        for m in c["Members"]:
            if m["MemberType"] == "Property":
                ser = m["Serialization"]
                vt = m["ValueType"]
                if vt["Category"] in ["Enum", "Class"]: continue
                name = vt["Name"]
                if ser["CanSave"]: save_t[name] = True
                elif name not in save_t: save_t[name] = False
                if ser["CanLoad"]: load_t[name] = True
                elif name not in load_t: load_t[name] = False
                if name not in dtypes_set:
                    dtypes_set.add(name)
                    dtypes.append(name)
    return vh, dtypes, dtypes_set, save_t, load_t

if __name__ == "__main__":
    try:
        vh, dtypes, dtypes_set, save_t, load_t = fetch(sys.argv[1] if len(sys.argv) > 1 else None)
        dtypes.sort()
        lines = ["=== DATATYPES ==="]
        for d in dtypes:
            ind = []
            if save_t.get(d): ind.append("{CanSave}")
            if load_t.get(d): ind.append("{CanLoad}")
            if (save_t.get(d) and not load_t.get(d)) or (load_t.get(d) and not save_t.get(d)):
                ind.append("-> Has descriptor")
            lines.append(f"{d} {' '.join(ind)}")
        lines.append(f"\n=== ANALYSIS ===")
        lines.append(f"Total datatypes: {len(dtypes)}")
        content = "\n".join(lines) + "\n"
        full = f"{vh}\n\n{content}"
        print(content)
        write_dump_file(full, "Dump", os.path.dirname(__file__))
    except Exception as e:
        print(f"Error: {e}")
