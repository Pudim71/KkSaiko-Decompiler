local Params = {
    RepoURL = "https://raw.githubusercontent.com/Pudim71/KkSaiko-Decompiler/main/",
    SSI = "saveinstance",
}
local content = game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true)
content = content:gsub("^\xEF\xBB\xBF", "", 1)
content = content:gsub('(hasLinkedSource and "")', '(hasLinkedSource and "" or "")')
local synsaveinstance = loadstring(content, Params.SSI)()
local Options = {}
synsaveinstance(Options)
