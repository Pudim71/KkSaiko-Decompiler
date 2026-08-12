-- Exemplo de uso do saveinstance corrigido
-- Este script carrega e executa o saveinstance da forma correta

local Params = {
	RepoURL = "https://raw.githubusercontent.com/Pudim71/KkSaiko-Decompiler/main/",
	SSI = "saveinstance",
}

local function loadSaveInstance()
	local url = Params.RepoURL .. Params.SSI .. ".luau"
	
	local success, response = pcall(function()
		return game:HttpGet(url, true)
	end)
	
	if not success then
		warn("Failed to fetch saveinstance from: " .. url)
		return nil
	end
	
	local loadSuccess, synsaveinstance = pcall(function()
		return loadstring(response, Params.SSI)()
	end)
	
	if not loadSuccess then
		warn("Failed to load saveinstance: " .. tostring(synsaveinstance))
		return nil
	end
	
	return synsaveinstance
end

-- Carregar o saveinstance
local synsaveinstance = loadSaveInstance()

if not synsaveinstance then
	error("Could not load saveinstance!")
	return
end

-- Configurar opções (ver documentação do saveinstance para mais opções)
local Options = {
	-- BoostFPS = true,
	-- ShutdownWhenDone = false,
}

-- Executar saveinstance
print("Starting saveinstance...")
synsaveinstance(Options)
