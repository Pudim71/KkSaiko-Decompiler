import os

def array_to_dictionary(t, h=None):
    if h == "adjust":
        return {k: array_to_dictionary(v, "adjust") if isinstance(v, dict) else v for k, v in t.items()}
    return {v: True for v in t if isinstance(v, str)}

def write_dump_file(content, filename="Dump", script_dir=None, skip_lines=1):
    if script_dir is None: script_dir = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(script_dir, filename)
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f: old = f.read().splitlines()
        new = content.splitlines()
        if "\n".join(old[skip_lines:]) == "\n".join(new[skip_lines:]): return False
    with open(path, "w", encoding="utf-8") as f: f.write(content)
    print("File written:", path)
    return True

def is_full_dump(data):
    if not data or "Classes" not in data: return False
    for c in data["Classes"]:
        for m in c.get("Members", []):
            if m.get("MemberType") == "Property": return "Default" in m
    return False

def is_full_dump(data):
    if not data or "Classes" not in data: return False
    for c in data["Classes"]:
        for m in c.get("Members", []):
            if m.get("MemberType") == "Property": return "Default" in m
    return False

def sort_v1_dump(data):
    if "Classes" in data and isinstance(data["Classes"], list):
        data["Classes"].sort(key=lambda x: x.get("Name", ""))
        for c in data["Classes"]:
            if "Members" in c and isinstance(c["Members"], list): c["Members"].sort(key=lambda x: x.get("Name", ""))
    if "Enums" in data and isinstance(data["Enums"], list):
        data["Enums"].sort(key=lambda x: x.get("Name", ""))
        for e in data["Enums"]:
            if "Items" in e and isinstance(e["Items"], list): e["Items"].sort(key=lambda x: x.get("Name", ""))
    return data

def normalize_v2_dump(data):
    class_names = {c.get("name") for c in data["classes"]}
    type_renames = {"CoordinateFrame": "CFrame", "Rect2D": "Rect", "Vector3Int16": "Vector3int16", "Vector2Int16": "Vector2int16"}
    def apply_rename(type_name): return type_renames.get(type_name, type_name)
    res = {"Classes": [], "Enums": []}
    for c in data["classes"]:
        nc = {"Name": c.get("name"), "Superclass": c.get("baseClass"), "Members": [], "Tags": []}
        c_tags = []
        if c.get("isScriptCreatable") == False: c_tags.extend(["NotCreatable", "NotReplicated"])
        elif c.get("isUserFacing") == False: c_tags.append("NotReplicated")
        if c.get("deprecated"): c_tags.append("Deprecated")
        if nc["Name"].endswith("Service"): c_tags.append("Service")
        nc["Tags"] = c_tags
        for m in c.get("members", []):
            nm = {"Name": m.get("name"), "MemberType": m.get("memberType"), "ThreadSafety": m.get("threadSafety")}
            m_tags = []
            if m.get("isYieldable"): m_tags.append("Yields")
            if m.get("isPublic") == False: m_tags.append("Hidden")
            if m.get("isScriptable") == False: m_tags.append("NotScriptable")
            if m.get("isReplicated") == False: m_tags.append("NotReplicated")
            if m.get("deprecated"): m_tags.append("Deprecated")
            if m.get("isAsync") == False: m_tags.append("NoYield")
            mt = m.get("type", {})
            if m.get("memberType") == "Property":
                if m.get("writeSecurity") == None: m_tags.append("ReadOnly")
                if m.get("readSecurity") == None: m_tags.append("WriteOnly")
                nm["Security"] = {"Read": m.get("readSecurity"), "Write": m.get("writeSecurity")}
                nm["Serialization"] = {"CanLoad": m.get("isSerialized"), "CanSave": m.get("isSerialized")}
                dv = mt.get("defaultValue")
                if dv is None: dv = mt.get("defaultValueMissingReason", "__api_dump_no_string_value__")
                if isinstance(dv, str) and dv.startswith("api_dump_"): dv = "__" + dv + "__"
                nm["Default"] = dv
                type_name = mt.get("type", "")
                category = "Enum" if mt.get("isEnum") else ("Class" if type_name in class_names else None)
                nm["ValueType"] = {"Name": apply_rename(type_name), "Category": category, "Capabilities": mt.get("capabilities")}
            elif m.get("memberType") in ["Function", "Event", "Callback"]:
                nm["Security"] = mt.get("security")
                nm["Parameters"] = [{"Name": a.get("identifier"), "Type": {"Name": apply_rename(a.get("type", "")), "Category": ("Enum" if mt.get("isEnum") else ("Class" if a.get("type") in class_names else None))}} for a in (mt.get("arguments", []))]
                r = (mt.get("results") or [{}])[0]
                nm["ReturnType"] = {"Name": apply_rename(r.get("type", "")), "Category": ("Enum" if mt.get("isEnum") else ("Class" if r.get("type") in class_names else None))}
            nm["Tags"] = m_tags
            nc["Members"].append(nm)
        res["Classes"].append(nc)
    res["Classes"].sort(key=lambda x: x["Name"])
    for e in data.get("enums", []):
        enum = {"Name": e.get("name"), "Items": [{"Name": k, "Value": v} for k, v in e.get("items", {}).items()]}
        res["Enums"].append(enum)
    res["Enums"].sort(key=lambda x: x["Name"])
    return res
