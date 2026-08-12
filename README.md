# Decompiler

## Estrutura
- `Tools/` - Ferramentas Python e Lua
- `website/` - Site Next.js para servir o saveinstance.luau

## Deploy do Website

1. Crie um repositório privado no GitHub com o `saveinstance.luau`
2. Faça upload da pasta `website/` para a Vercel
3. Configure as variáveis de ambiente na Vercel:
   - `PAGE_PASSWORD` - senha da página
   - `GITHUB_TOKEN` - token do GitHub com permissão de repositório
   - `GITHUB_OWNER` - dono do repositório
   - `GITHUB_REPO` - nome do repositório

## Como usar

1. Acesse o site e faça login com a senha
2. Copie o script do loader
3. Execute no Roblox:

```lua
loadstring(game:HttpGet("https://SEU_SITE.vercel.app/api/saveinstance"))()
```

O servidor irá:
1. Tornar o repositório público
2. Ler o arquivo `saveinstance.luau`
3. Tornar o repositório privado novamente
4. Retornar o código para o Roblox executar
