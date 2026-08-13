# Decompiler

Uso direto via GitHub:

```lua
local Params = {
    RepoURL = "https://raw.githubusercontent.com/Pudim71/KkSaiko-Decompiler/main/",
    SSI = "saveinstance",
}
local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
local Options = {}
synsaveinstance(Options)
```

Arquivos principais:
- `saveinstance.luau` - versão principal sem comentários
- `saveinstance.lua` - versão Lua sem comentários
- `Tools/` - ferramentas auxiliares
