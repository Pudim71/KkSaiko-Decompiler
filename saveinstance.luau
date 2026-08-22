local function string_find(s, pattern, init)
	return string.find(s, pattern, init, true)
end

local function arrayToDict(t, mixedMode, valueOverride, typeStrict)
	local tmp = {}

	if mixedMode then
		for any1, any2 in next, t do
			if type(any1) == "number" then
				tmp[any2] = valueOverride or true
			elseif type(any2) == "table" then
				tmp[any1] = arrayToDict(any2, mixedMode)
			else
				tmp[any1] = any2
			end
		end
	else
		for _, key in next, t do
			if not typeStrict or typeStrict and type(key) == typeStrict then
				tmp[key] = true
			end
		end
	end

	return tmp
end

local global_container
do
	local filename = "UniversalMethodFinder"

	local finder
	finder, global_container = loadstring(
		game:HttpGet("https://raw.githubusercontent.com/luau/SomeHub/main/" .. filename .. ".luau", true),
		filename
	)()

	finder({
		request = 'string.find(...,"request",nil,true) and not string.find(...,"internal",nil,true)',
		base64encode = 'local a={...}local b=a[1]local function c(a,b)return string.find(a,b,nil,true)end;return c(b,"encode")and(c(b,"base64")or c(string.lower(tostring(a[2])),"base64"))',
		cloneref = 'string.find(...,"clone",nil,true) and string.find(...,"ref",nil,true)',
		decompile = '(string.find(...,"decomp",nil,true) and string.sub(...,#...) ~= "s")',
		gethiddenproperty = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"prop",nil,true) and string.sub(...,#...) ~= "s"',
		gethui = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"ui",nil,true)',
		getcon = 'string.find(...,"get",nil,true) and (string.find(...,"conn",nil,true) or string.find(...,"sig",nil,true)) and string.sub(...,#(...))=="s"',
		getnilinstances = 'string.find(...,"nil",nil,true) and string.find(...,"get",nil,true) and string.sub(...,#...) == "s"',
		getscriptbytecode = 'string.find(...,"get",nil,true) and string.find(...,"script",nil,true) and string.find(...,"bytecode",nil,true)',
		hash = 'local a={...}local b=a[1]local function c(a,b)return string.find(a,b,nil,true)end;return c(b,"hash")and c(string.lower(tostring(a[2])),"crypt")',
		protectgui = 'string.find(...,"protect",nil,true) and string.find(...,"ui",nil,true) and not string.find(...,"un",nil,true)',
		setthreadidentity = 'string.find(...,"identity",nil,true) and string.find(...,"set",nil,true)',
	}, true, 10)
end

local identify_executor = identifyexecutor or getexecutorname or whatexecutor

local EXECUTOR_NAME = identify_executor and identify_executor() or ""

local cloneref = global_container.cloneref
local gethiddenproperty = global_container.gethiddenproperty
local gethiddenproperty_fallback

local appendfile = appendfile
local isfile = isfile
local readfile = readfile
local writefile = writefile

local getscriptbytecode = global_container.getscriptbytecode
local base64encode = global_container.base64encode

local service = setmetatable({}, {
	__index = function(self, serviceName)
		local o, s = pcall(Instance.new, serviceName)
		local Service = o and s
			or game:GetService(serviceName)
			or settings():GetService(serviceName)
			or UserSettings():GetService(serviceName)

		if cloneref then
			Service = cloneref(Service)
		end
		if Service then
			self[serviceName] = Service
		end
		return Service
	end,
})

local sharedStringId = 1e15
local sharedStrings = setmetatable({}, {
	__index = function(self, str)
		local id = base64encode(tostring(sharedStringId))
		sharedStringId = sharedStringId + 1

		self[str] = id
		return id
	end,
})

local inheritedProperties = {}
local defaultInstances = {}
local referents, refSize = setmetatable({}, { __mode = "ks" }), 0

local function getRef(instance)
	local ref = referents[instance]
	if not ref then
		ref = refSize
		referents[instance] = ref
		refSize = refSize + 1
	end
	return ref
end

local function index(self, index_name)
	return self[index_name]
end

local FULL_VERSION

if not pcall(function()
	FULL_VERSION = version()
end) then
	if not pcall(function()
		FULL_VERSION = settings():GetService("DebugSettings").RobloxVersion
	end) then
		if not pcall(function()
			FULL_VERSION = service.RunService:GetRobloxVersion()
		end) then
			FULL_VERSION = "UNKNOWN"
		end
	end
end

local CLIENT_VERSION = tonumber(string.match(FULL_VERSION, "%d+%.(%d+)")) or 9e9
local __BREAK = "__BREAK" .. service.HttpService:GenerateGUID(false)

local Attribute_Type_Ids =
	{
		["nil"] = 0x01,
		string = 0x02,
		boolean = 0x03,
		int32 = 0x04,
		number = 0x06,
		ValueArray = 0x07,
		ValueTable = 0x08,
		UDim = 0x09,
		UDim2 = 0x0A,
		Ray = 0x0B,
		Faces = 0x0C,
		Axes = 0x0D,
		BrickColor = 0x0E,
		Color3 = 0x0F,
		Vector2 = 0x10,
		Vector3 = 0x11,
		Vector2int16 = 0x12,
		Vector3int16 = 0x13,
		CFrame = 0x14,
		EnumItem = 0x15,
		NumberSequence = 0x17,
		NumberSequenceKeypoint = 0x18,
		ColorSequence = 0x19,
		ColorSequenceKeypoint = 0x1A,
		NumberRange = 0x1B,
		Rect = 0x1C,
		PhysicalProperties = 0x1D,
		Color3uint8 = 0x1E,
		Region3 = 0x1F,
		Region3int16 = 0x20,
		Font = 0x21,
		SecurityCapabilities = 0x22,
		Path2DControlPoint = 0x23,
		TweenInfo = 0x24,
	}

local CFrame_Rotation_Ids = {
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x02,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x03,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x05,
	["\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x06,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x07,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x09,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x0a,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x0c,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0d,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0e,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x10,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128"] = 0x11,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x14,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128"] = 0x15,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x17,
	["\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128"] = 0x18,
	["\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x19,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x1b,
	["\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x1c,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x1e,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x1f,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x20,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x22,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128"] = 0x23,
}
local rotationBuffer = buffer.create(36)
local EMPTY_BUFFER = buffer.create(0)
local BASE_CAPABILITIES
pcall(function()
	BASE_CAPABILITIES = SecurityCapabilities.new()
end)
local CAPABILITY_BITS = {
	Plugin = 2 ^ 0,
	LocalUser = 2 ^ 1,
	WritePlayer = 2 ^ 2,
	RobloxScript = 2 ^ 3,
	RobloxEngine = 2 ^ 4,
	NotAccessible = 2 ^ 5,
	RunClientScript = 2 ^ 8,
	RunServerScript = 2 ^ 9,
	Unknown = 2 ^ 10,
	AccessOutsideWrite = 2 ^ 11,
	Unassigned = 2 ^ 15,
	LoadUnownedAsset = 2 ^ 16,
	LoadString = 2 ^ 17,
	ScriptGlobals = 2 ^ 18,
	CreateInstances = 2 ^ 19,
	Basic = 2 ^ 20,
	Audio = 2 ^ 21,
	DataStore = 2 ^ 22,
	Network = 2 ^ 23,
	Physics = 2 ^ 24,
	UI = 2 ^ 25,
	CSG = 2 ^ 26,
	Chat = 2 ^ 27,
	Animation = 2 ^ 28,
	AvatarAppearance = 2 ^ 29,
	Input = 2 ^ 30,
	Environment = 2 ^ 31,
	RemoteEvent = 2 ^ 32,
	LegacySound = 2 ^ 33,
	Players = 2 ^ 34,
	CapabilityControl = 2 ^ 35,
	AssetRead = 2 ^ 36,
	AssetManagement = 2 ^ 37,
	DynamicGeneration = 2 ^ 38,
	PlatformAvatarEditing = 2 ^ 39,
	AssetCreateUpdate = 2 ^ 40,
	Capture = 2 ^ 41,
	SensitiveInput = 2 ^ 42,
	Monetization = 2 ^ 43,
	LoadOwnedAsset = 2 ^ 44,
	Social = 2 ^ 45,
	ServerCommunication = 2 ^ 46,
	Logging = 2 ^ 47,
	PromptExternalPurchase = 2 ^ 48,
	Groups = 2 ^ 49,
	Teleport = 2 ^ 50,
	Consequences = 2 ^ 51,
	Material = 2 ^ 52,
	AvatarBehavior = 2 ^ 53,
	RemoteCommand = 2 ^ 59,
	InternalTest = 2 ^ 60,
	PluginOrOpenCloud = 2 ^ 61,
	Assistant = 2 ^ 62,
	Restricted = 2 ^ 63,
}

local function countCapabilityBits(raw)
	local result = 0
	for _, flag in next, string.split(tostring(raw), " | ") do
		local bit = CAPABILITY_BITS[flag]
		if bit then
			result = result + bit
		end
	end
	return result
end

local function countBits(...)
	local Value = 0

	for i, bit in next, { ... } do
		if bit then
			Value = Value + 2 ^ (i - 1)
		end
	end

	return Value
end

local function cframeToQuaternion(cframe)
	local _, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	local trace = R00 + R11 + R22
	local S, qW, qX, qY, qZ
	if trace > 0 then
		S = math.sqrt(1 + trace) * 2
		qW = 0.25 * S
		qX = (R21 - R12) / S
		qY = (R02 - R20) / S
		qZ = (R10 - R01) / S
	elseif (R00 > R11) and (R00 > R22) then
		S = math.sqrt(1 + R00 - R11 - R22) * 2
		qW = (R21 - R12) / S
		qX = 0.25 * S
		qY = (R01 + R10) / S
		qZ = (R02 + R20) / S
	elseif R11 > R22 then
		S = math.sqrt(1 + R11 - R00 - R22) * 2
		qW = (R02 - R20) / S
		qX = (R01 + R10) / S
		qY = 0.25 * S
		qZ = (R12 + R21) / S
	else
		S = math.sqrt(1 + R22 - R00 - R11) * 2
		qW = (R10 - R01) / S
		qX = (R02 + R20) / S
		qY = (R12 + R21) / S
		qZ = 0.25 * S
	end
	if qW < 0 then
		qW, qX, qY, qZ = -qW, -qX, -qY, -qZ
	end
	return qX, qY, qZ, qW
end

local function classifyTable(t)
	local len = #t
	if len > 0 then
		local n = 0
		for _ in next, t do
			n = n + 1
		end
		if n == len then
			return "ValueArray"
		end
	end
	local n, maxIndex = 0, 0
	for k in next, t do
		n = n + 1
		if type(k) == "number" and k > maxIndex and k == math.floor(k) and k >= 1 then
			maxIndex = k
		end
	end
	return (maxIndex > 0 and maxIndex == n) and "ValueArray" or "ValueTable"
end

local function resolveTypeName(value)
	local t = typeof(value)
	if t == "table" then
		return classifyTable(value)
	end
	return t
end

local Binary_Encoders
Binary_Encoders = {
	_packMultiple = function(encoder, value1, value2, value3)
		local buf1, size1 = encoder(value1)
		local buf2, size2 = encoder(value2)

		local len = size1 + size2
		local buf3, size3

		if value3 ~= nil then
			buf3, size3 = encoder(value3)
			len = len + size3
		end

		local b = buffer.create(len)

		buffer.copy(b, 0, buf1)
		buffer.copy(b, size1, buf2)

		if value3 ~= nil then
			buffer.copy(b, size1 + size2, buf3)
		end

		return b, len
	end,
	_makeSequence = function(keypoint_handler, keypointSize)
		return function(raw)
			local keypoints = raw.Keypoints
			local n = #keypoints

			local len = 4 + keypointSize * n
			local b = buffer.create(len)

			buffer.writeu32(b, 0, n)

			local offset = 4
			for _, keypoint in next, keypoints do
				keypoint_handler(keypoint, b, offset)
				offset = offset + keypointSize
			end

			return b, len
		end
	end,
	_writeI64LE = function(b, offset, raw)
		local low = bit32.band(raw, 0xFFFFFFFF)
		local high = (raw - low) / 0x100000000

		buffer.writei32(b, offset, low)
		buffer.writei32(b, offset + 4, high)
	end,
	_packF32 = nil,
	_packI16 = nil,
	_makeVectorPacker = function(writeFunc, elementSize)
		return function(X, Y, Z)
			local len = Z and (elementSize * 3) or (elementSize * 2)
			local b = buffer.create(len)

			writeFunc(b, 0, X)
			writeFunc(b, elementSize, Y)
			if Z then
				writeFunc(b, elementSize * 2, Z)
			end

			return b, len
		end
	end,
	["nil"] = function(raw)
		return EMPTY_BUFFER, 0
	end,
	["string"] = function(raw)
		local raw_len = #raw
		local len = 4 + raw_len

		local b = buffer.create(len)

		buffer.writeu32(b, 0, raw_len)
		buffer.writestring(b, 4, raw)

		return b, len
	end,
	["boolean"] = function(raw)
		local b = buffer.create(1)

		buffer.writeu8(b, 0, raw and 1 or 0)

		return b, 1
	end,
	["number"] = function(raw)
		local b = buffer.create(8)

		buffer.writef64(b, 0, raw)

		return b, 8
	end,
	["ValueArray"] = function(raw)
		local n = 0
		for k in next, raw do
			if type(k) == "number" and k > n and k == math.floor(k) and k >= 1 then
				n = k
			end
		end

		local bufs = table.create(n)
		local total = 4
		local count = 0

		for i = 1, n do
			local __DARKLUA_CONTINUE_9 = false
			repeat
				local value = raw[i]
				local b, size

				if value == nil then
					b = buffer.create(1)
					buffer.writeu8(b, 0, 0x01)
					size = 1
				else
					local valueTypeName = resolveTypeName(value)
					local typeId = Attribute_Type_Ids[valueTypeName]
					local descriptor = Binary_Encoders[valueTypeName]
					if not descriptor then
						__DARKLUA_CONTINUE_9 = true
						break
					end
					local dataBuf, dataSize = descriptor(value)

					b = buffer.create(1 + dataSize)
					buffer.writeu8(b, 0, typeId)
					buffer.copy(b, 1, dataBuf)
					size = 1 + dataSize
				end

				count = count + 1
				bufs[count] = b
				total = total + size
				__DARKLUA_CONTINUE_9 = true
			until true
			if not __DARKLUA_CONTINUE_9 then
				break
			end
		end

		local b = buffer.create(total)
		buffer.writeu32(b, 0, count)

		local offset = 4
		for i = 1, count do
			local bb = bufs[i]
			buffer.copy(b, offset, bb)
			offset = offset + buffer.len(bb)
		end

		return b, total
	end,
	["ValueTable"] = function(raw)
		local keys = {}
		local keyMap = {}
		local n = 0

		for k in next, raw do
			n = n + 1
			local keyStr = tostring(k)
			keys[n] = keyStr
			keyMap[keyStr] = k
		end

		table.sort(keys)

		local bufs = table.create(n)
		local total = 4
		local count = 0

		for i = 1, n do
			local __DARKLUA_CONTINUE_12 = false
			repeat
				local keyStr = keys[i]
				local value = raw[keyMap[keyStr]]

				local valueTypeName = resolveTypeName(value)
				local typeId = Attribute_Type_Ids[valueTypeName]
				local descriptor = Binary_Encoders[valueTypeName]
				if not descriptor then
					__DARKLUA_CONTINUE_12 = true
					break
				end
				local dataBuf, dataSize = descriptor(value)

				local keyLen = #keyStr
				local size = 4 + keyLen + 1 + dataSize
				local b = buffer.create(size)

				buffer.writeu32(b, 0, keyLen)
				buffer.writestring(b, 4, keyStr)
				buffer.writeu8(b, 4 + keyLen, typeId)
				buffer.copy(b, 4 + keyLen + 1, dataBuf)

				count = count + 1
				bufs[count] = b
				total = total + size
				__DARKLUA_CONTINUE_12 = true
			until true
			if not __DARKLUA_CONTINUE_12 then
				break
			end
		end

		local b = buffer.create(total)
		buffer.writeu32(b, 0, count)

		local offset = 4
		for i = 1, count do
			local bb = bufs[i]
			buffer.copy(b, offset, bb)
			offset = offset + buffer.len(bb)
		end

		return b, total
	end,
	["UDim"] = function(raw)
		local b = buffer.create(8)

		buffer.writef32(b, 0, raw.Scale)
		buffer.writei32(b, 4, raw.Offset)

		return b, 8
	end,
	["UDim2"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["UDim"], raw.X, raw.Y)
	end,
	["Ray"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["Vector3"], raw.Origin, raw.Direction)
	end,
	["Faces"] = function(raw)
		local b = buffer.create(4)

		buffer.writeu32(b, 0, countBits(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front))

		return b, 4
	end,
	["Axes"] = function(raw)
		local b = buffer.create(4)

		buffer.writeu32(b, 0, countBits(raw.X, raw.Y, raw.Z))

		return b, 4
	end,
	["BrickColor"] = function(raw)
		local b = buffer.create(4)

		buffer.writeu32(b, 0, raw.Number)

		return b, 4
	end,
	["Color3"] = function(raw)
		return Binary_Encoders._packF32(raw.R, raw.G, raw.B)
	end,
	["Vector2"] = function(raw)
		return Binary_Encoders._packF32(raw.X, raw.Y)
	end,
	["Vector3"] = function(raw)
		return Binary_Encoders._packF32(raw.X, raw.Y, raw.Z)
	end,
	["Vector2int16"] = function(raw)
		return Binary_Encoders._packI16(raw.X, raw.Y)
	end,
	["Vector3int16"] = function(raw)
		return Binary_Encoders._packI16(raw.X, raw.Y, raw.Z)
	end,
	["CFrame"] = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()

		buffer.writef32(rotationBuffer, 0, R00)
		buffer.writef32(rotationBuffer, 4, R01)
		buffer.writef32(rotationBuffer, 8, R02)
		buffer.writef32(rotationBuffer, 12, R10)
		buffer.writef32(rotationBuffer, 16, R11)
		buffer.writef32(rotationBuffer, 20, R12)
		buffer.writef32(rotationBuffer, 24, R20)
		buffer.writef32(rotationBuffer, 28, R21)
		buffer.writef32(rotationBuffer, 32, R22)

		local rotation_ID = CFrame_Rotation_Ids[buffer.tostring(rotationBuffer)]

		local len = rotation_ID and 13 or 49
		local b = buffer.create(len)

		local _packF32 = Binary_Encoders._packF32
		local position = _packF32(X, Y, Z)
		buffer.copy(b, 0, position)
		if rotation_ID then
			buffer.writeu8(b, 12, rotation_ID)
		else
			buffer.writeu8(b, 12, 0x0)

			local xBasis = _packF32(R00, R01, R02)
			buffer.copy(b, 13, xBasis)
			local yBasis = _packF32(R10, R11, R12)
			buffer.copy(b, 13 + 12, yBasis)
			local zBasis = _packF32(R20, R21, R22)
			buffer.copy(b, 13 + 24, zBasis)

		end

		return b, len
	end,
	["EnumItem"] = function(raw)
		local nameBuf, nameSize = Binary_Encoders["string"](tostring(raw.EnumType))

		local len = nameSize + 4
		local b = buffer.create(len)

		buffer.copy(b, 0, nameBuf)
		buffer.writeu32(b, nameSize, raw.Value)

		return b, len
	end,
	["NumberSequence"] = nil,
	["NumberSequenceKeypoint"] = function(keypoint, b, offset)
		if not b then
			return Binary_Encoders._packF32(keypoint.Envelope, keypoint.Time, keypoint.Value)
		end

		buffer.writef32(b, offset, keypoint.Envelope)
		offset = offset + 4
		buffer.writef32(b, offset, keypoint.Time)
		offset = offset + 4
		buffer.writef32(b, offset, keypoint.Value)
	end,
	["ColorSequence"] = nil,
	["ColorSequenceKeypoint"] = function(keypoint, b, offset)
		local value = Binary_Encoders["Color3"](keypoint.Value)

		if not b then
			b = buffer.create(20)
			offset = 0
		end

		buffer.writef32(b, offset, 0)
		offset = offset + 4
		buffer.writef32(b, offset, keypoint.Time)
		offset = offset + 4
		buffer.copy(b, offset, value)

		return b, 20
	end,
	["NumberRange"] = function(raw)
		return Binary_Encoders._packF32(raw.Min, raw.Max)
	end,
	["Rect"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["Vector2"], raw.Min, raw.Max)
	end,
	["PhysicalProperties"] = function(raw)
		local b = buffer.create(25)

		buffer.writeu8(b, 0, 1)

		buffer.writef32(b, 1, raw.Density)
		buffer.writef32(b, 5, raw.Friction)
		buffer.writef32(b, 9, raw.Elasticity)
		buffer.writef32(b, 13, raw.FrictionWeight)
		buffer.writef32(b, 17, raw.ElasticityWeight)
		buffer.writef32(b, 21, raw.AcousticAbsorption)

		return b, 25
	end,
	["Color3uint8"] = function(raw)
		local b = buffer.create(3)

		buffer.writeu8(b, 0, math.floor(raw.R * 255))
		buffer.writeu8(b, 1, math.floor(raw.G * 255))
		buffer.writeu8(b, 2, math.floor(raw.B * 255))

		return b, 3
	end,
	["Region3"] = function(raw)
		local Translation = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5

		return Binary_Encoders._packMultiple(
			Binary_Encoders["Vector3"],
			Translation - HalfSize,
			Translation + HalfSize
		)
	end,
	["Region3int16"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["Vector3int16"], raw.Min, raw.Max)
	end,
	["Font"] = function(raw)
		local encoder = Binary_Encoders["string"]

		local familyBuf, familySize = encoder(raw.Family)
		local faceIdBuf, faceIdSize = encoder("")

		local len = 3 + familySize + faceIdSize
		local b = buffer.create(len)

		local hasWeight, weight = pcall(index, raw, "Weight")
		local hasStyle, style = pcall(index, raw, "Style")

		buffer.writeu16(b, 0, hasWeight and weight.Value or 0)
		buffer.writeu8(b, 2, hasStyle and style.Value or 0)

		buffer.copy(b, 3, familyBuf)
		buffer.copy(b, 3 + familySize, faceIdBuf)

		return b, len
	end,
	["SecurityCapabilities"] = function(raw)
		local b = buffer.create(8)

		if raw == BASE_CAPABILITIES then
			return b, 8
		end

		Binary_Encoders._writeI64LE(b, 0, countCapabilityBits(raw))

		return b, 8
	end,
	["Path2DControlPoint"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["UDim2"], raw.Position, raw.LeftTangent, raw.RightTangent)
	end,
	["TweenInfo"] = function(raw)
		local b = buffer.create(21)

		buffer.writef32(b, 0, raw.Time)
		buffer.writef32(b, 4, raw.DelayTime)
		buffer.writei32(b, 8, raw.RepeatCount)
		buffer.writeu32(b, 12, raw.EasingStyle.Value)
		buffer.writeu32(b, 16, raw.EasingDirection.Value)
		buffer.writeu8(b, 20, raw.Reverses and 1 or 0)

		return b, 21
	end,
}

do
	Binary_Encoders["NumberSequence"] = Binary_Encoders._makeSequence(Binary_Encoders["NumberSequenceKeypoint"], 12)

	Binary_Encoders["ColorSequence"] = Binary_Encoders._makeSequence(Binary_Encoders["ColorSequenceKeypoint"], 20)
end

do
	Binary_Encoders._packF32 = Binary_Encoders._makeVectorPacker(buffer.writef32, 4)

	Binary_Encoders._packI16 = Binary_Encoders._makeVectorPacker(buffer.writei16, 2)
end

local ESCAPES_PATTERN = "[&<>\"'\0\1-\9\11-\12\14-\31\127-\255]"
local ESCAPES = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	['"'] = "&#34;",
	["'"] = "&#39;",
	["\0"] = "",
}

for rangeStart, rangeEnd in string.gmatch(ESCAPES_PATTERN, "(.)%-(.)") do
	for charCode = string.byte(rangeStart), string.byte(rangeEnd) do
		ESCAPES[string.char(charCode)] = "&#" .. charCode .. ";"
	end
end

local XML_Encoders
XML_Encoders = {
	_cdata = function(raw)
		return "<![CDATA[" .. raw .. "]]>"
	end,
	_protectedString = function(raw)
		return string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES) or XML_Encoders._cdata(raw)
	end,
	_normalizeNumber = function(raw)
		if raw ~= raw then
			return "NAN"
		elseif raw == math.huge then
			return "INF"
		elseif raw == -math.huge then
			return "-INF"
		end

		return raw
	end,
	_normalizeRange = function(raw)
		return raw ~= raw and "0" or raw
	end,
	_minMax = function(min, max, encoder)
		return "<min>" .. encoder(min) .. "</min><max>" .. encoder(max) .. "</max>"
	end,
	_makeSequence = function(keypoint_handler)
		return function(raw)
			local sequence = ""

			for _, keypoint in next, raw.Keypoints do
				sequence = sequence .. keypoint_handler(keypoint)
			end

			return sequence
		end
	end,
	_vector = function(X, Y, Z)
		local Value = "<X>" .. X .. "</X><Y>" .. Y .. "</Y>"

		if Z then
			Value = Value .. "<Z>" .. Z .. "</Z>"
		end

		return Value
	end,
	Axes = function(raw)
		return "<axes>" .. countBits(raw.X, raw.Y, raw.Z) .. "</axes>"
	end,

	BinaryString = function(raw)
		return raw == "" and "" or base64encode(raw)
	end,

	BrickColor = function(raw)
		return raw.Number
	end,
	CFrame = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()
		return XML_Encoders._vector(X, Y, Z)
			.. "<R00>"
			.. R00
			.. "</R00><R01>"
			.. R01
			.. "</R01><R02>"
			.. R02
			.. "</R02><R10>"
			.. R10
			.. "</R10><R11>"
			.. R11
			.. "</R11><R12>"
			.. R12
			.. "</R12><R20>"
			.. R20
			.. "</R20><R21>"
			.. R21
			.. "</R21><R22>"
			.. R22
			.. "</R22>",
			"CoordinateFrame"
	end,
	Color3 = function(raw)
		return "<R>" .. raw.R .. "</R><G>" .. raw.G .. "</G><B>" .. raw.B .. "</B>"
	end,
	Color3uint8 = function(raw)
		return 0xFF000000
			+ (math.floor(raw.R * 255) * 0x10000)
			+ (math.floor(raw.G * 255) * 0x100)
			+ math.floor(raw.B * 255)
	end,
	ColorSequence = nil,
	ColorSequenceKeypoint = function(keypoint)
		local _normalizeRange = XML_Encoders._normalizeRange

		local color3 = keypoint.Value

		return _normalizeRange(keypoint.Time)
			.. " "
			.. _normalizeRange(color3.R)
			.. " "
			.. _normalizeRange(color3.G)
			.. " "
			.. _normalizeRange(color3.B)
			.. " 0 "
	end,
	Content = function(raw)
		local SourceType = raw.SourceType
		return SourceType == Enum.ContentSourceType.None and "<null></null>"
			or SourceType == Enum.ContentSourceType.Uri and "<uri>" .. XML_Encoders.string(raw.Uri) .. "</uri>"
			or SourceType == Enum.ContentSourceType.Object and "<Ref>" .. getRef(raw.Object) .. "</Ref>"
	end,
	ContentId = function(raw)
		return raw == "" and "<null></null>" or "<url>" .. XML_Encoders.string(raw) .. "</url>", "Content"
	end,
	CoordinateFrame = function(raw)
		return "<CFrame>" .. XML_Encoders.CFrame(raw) .. "</CFrame>"
	end,
	EnumItem = function(raw)
		return raw.Value, "token"
	end,
	Faces = function(raw)
		return "<faces>" .. countBits(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front) .. "</faces>"
	end,
	Font = function(raw)
		local hasWeight, weight = pcall(index, raw, "Weight")
		local hasStyle, style = pcall(index, raw, "Style")

		return "<Family>"
			.. XML_Encoders.ContentId(raw.Family)
			.. "</Family><Weight>"
			.. (hasWeight and XML_Encoders.EnumItem(weight) or "")
			.. "</Weight><Style>"
			.. (hasStyle and style.Name or "")
			.. "</Style>"
	end,
	NetAssetRef = nil,
	NumberRange = function(raw)
		local _normalizeRange = XML_Encoders._normalizeRange

		return _normalizeRange(raw.Min) .. " " .. _normalizeRange(raw.Max)
	end,
	NumberSequence = nil,
	NumberSequenceKeypoint = function(keypoint)
		local _normalizeRange = XML_Encoders._normalizeRange

		return _normalizeRange(keypoint.Time)
			.. " "
			.. _normalizeRange(keypoint.Value)
			.. " "
			.. _normalizeRange(keypoint.Envelope)
			.. " "
	end,

PhysicalProperties = function(raw)

		local CustomPhysics = "<CustomPhysics>" .. XML_Encoders.bool(raw and true or false) .. "</CustomPhysics>"

		return raw
				and CustomPhysics .. "<Density>" .. raw.Density .. "</Density><Friction>" .. raw.Friction .. "</Friction><Elasticity>" .. raw.Elasticity .. "</Elasticity><FrictionWeight>" .. raw.FrictionWeight .. "</FrictionWeight><ElasticityWeight>" .. raw.ElasticityWeight .. "</ElasticityWeight><AcousticAbsorption>" .. raw.AcousticAbsorption .. "</AcousticAbsorption>"
			or CustomPhysics
	end,
	Ray = function(raw)
		local vector3 = XML_Encoders.Vector3

		return "<origin>" .. vector3(raw.Origin) .. "</origin><direction>" .. vector3(raw.Direction) .. "</direction>"
	end,
	Rect = function(raw)
		return XML_Encoders._minMax(raw.Min, raw.Max, XML_Encoders.Vector2), "Rect2D"
	end,
	Region3 = function(raw)
		local Translation = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5

		return XML_Encoders._minMax(
			Translation - HalfSize,
			Translation + HalfSize,
			XML_Encoders.Vector3
		)
	end,
	Region3int16 = function(raw)
		return XML_Encoders._minMax(raw.Min, raw.Max, XML_Encoders.Vector3int16)
	end,

	SharedString = function(raw)
		return sharedStrings[XML_Encoders.BinaryString(raw)]
	end,
	SecurityCapabilities = function(raw)
		if raw == BASE_CAPABILITIES then
			return 0
		end

		return countCapabilityBits(raw)
	end,
	TweenInfo = function(raw)
		local _normalizeNumber = XML_Encoders._normalizeNumber
		return "Time:"
			.. _normalizeNumber(raw.Time)
			.. " DelayTime:"
			.. _normalizeNumber(raw.DelayTime)
			.. " RepeatCount:"
			.. _normalizeNumber(raw.RepeatCount)
			.. " Reverses:"
			.. (raw.Reverses and "True" or "False")
			.. " EasingDirection:"
			.. raw.EasingDirection.Name
			.. " EasingStyle:"
			.. raw.EasingStyle.Name
	end,
	UDim = function(raw)
		return "<S>" .. raw.Scale .. "</S><O>" .. raw.Offset .. "</O>"
	end,
	UDim2 = function(raw)
		local X, Y = raw.X, raw.Y

		return "<XS>"
			.. X.Scale
			.. "</XS><XO>"
			.. X.Offset
			.. "</XO><YS>"
			.. Y.Scale
			.. "</YS><YO>"
			.. Y.Offset
			.. "</YO>"
	end,

	UniqueId = function(raw)
return string.gsub(raw, "-", "")
	end,

	Vector2 = function(raw)
		return XML_Encoders._vector(raw.X, raw.Y)
	end,
	Vector2int16 = nil,
	Vector3 = function(raw)
		return XML_Encoders._vector(raw.X, raw.Y, raw.Z)
	end,
	Vector3int16 = nil,
	bool = function(raw)
		return raw and "true" or "false"
	end,
	double = nil,
	float = nil,
	int = nil,
	int64 = nil,
	string = function(raw)
		return (raw == nil or raw == "") and ""
			or string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES)
			or XML_Encoders._cdata(string.gsub(raw, "\0", ""))
	end,
}

do
	XML_Encoders.NumberSequence = XML_Encoders._makeSequence(XML_Encoders.NumberSequenceKeypoint)

	XML_Encoders.ColorSequence = XML_Encoders._makeSequence(XML_Encoders.ColorSequenceKeypoint)
end

for encoderName, redirectName in
	next,
	{
		NetAssetRef = "SharedString",
		Vector2int16 = "Vector2",
		Vector3int16 = "Vector3",
		double = "_normalizeNumber",
		float = "_normalizeNumber",
		int = "_normalizeNumber",
		int64 = "_normalizeNumber",
	}
do
	XML_Encoders[encoderName] = XML_Encoders[redirectName]
end

local ClassList, FetchAPI

do
	local ClassPropertyExceptions = arrayToDict({
		Whitelist = {
			MeshPart = { "CollisionFidelity" },
			PartOperation = { "CollisionFidelity" },
			TriangleMeshPart = { "CollisionFidelity" },
		},
		Blacklist = {
			LuaSourceContainer = { "ScriptGuid" },
			Instance = { "UniqueId", "HistoryId" },
		},
	}, true)

	local function AttributesSerialize(attrs, header_bytes)
		local count = 0
		local buffer_size = 4
		local sorted = {}
		local formatted = table.clone(attrs)

		if header_bytes then
			buffer_size = buffer_size + #header_bytes
		end

		for attr, val in next, attrs do
			local __DARKLUA_CONTINUE_18 = false
			repeat
				local t = resolveTypeName(val)

				local encoder = Binary_Encoders[t]
				if not encoder then
					__DARKLUA_CONTINUE_18 = true
					break
				end

				count = count + 1
				sorted[count] = attr

				local attr_size

				formatted[attr], attr_size = encoder(val)

				buffer_size = buffer_size + (5 + #attr + attr_size)
				__DARKLUA_CONTINUE_18 = true
			until true
			if not __DARKLUA_CONTINUE_18 then
				break
			end
		end

		table.sort(sorted)

		local b = buffer.create(buffer_size)

		local offset = 0

		if header_bytes then
			for _, header_byte in next, header_bytes do
				buffer.writeu8(b, offset, header_byte)
				offset = offset + 1
			end
		end

		buffer.writeu32(b, offset, count)
		offset = offset + 4

		local stringEncoder = Binary_Encoders["string"]
		for _, attr in next, sorted do
			local nameBuf, nameSize = stringEncoder(attr)

			buffer.copy(b, offset, nameBuf)
			offset = offset + nameSize

			buffer.writeu8(b, offset, Attribute_Type_Ids[resolveTypeName(attrs[attr])])
			offset = offset + 1

			local bb = formatted[attr]

			buffer.copy(b, offset, bb)
			offset = offset + buffer.len(bb)
		end

		return buffer.tostring(b)
	end

	local function AttenuationSerialize(attenuations)
		if not next(attenuations) then
			return "\0"
		end

		local count = 0

		local sorted = {}

		for key in next, attenuations do
			count = count + 1
			sorted[count] = key
		end

		table.sort(sorted)

		local b = buffer.create(1 + count * 8)

		local offset = 1
		for _, key in next, sorted do
			buffer.writef32(b, offset, key)
			offset = offset + 4
			buffer.writef32(b, offset, attenuations[key])
			offset = offset + 4
		end

		return buffer.tostring(b)
	end

	local function TransformsSerialize(transforms)
		local n = #transforms

		if n == 0 then
			return "\1\0\0\0\0\0\0\0"
		end

		local b = buffer.create(8 + n * 48)

		buffer.writeu32(b, 0, 1)
		buffer.writeu32(b, 4, n)

		local _packF32 = Binary_Encoders._packF32

		local offset = 8
		for _, transform in next, transforms do
			local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = transform:GetComponents()

			local xBasis = _packF32(R00, R01, R02)
			buffer.copy(b, offset, xBasis)
			offset = offset + 12

			local yBasis = _packF32(R10, R11, R12)
			buffer.copy(b, offset, yBasis)
			offset = offset + 12

			local zBasis = _packF32(R20, R21, R22)
			buffer.copy(b, offset, zBasis)
			offset = offset + 12

			local position = _packF32(X, Y, Z)
			buffer.copy(b, offset, position)
			offset = offset + 12
		end

		return buffer.tostring(b)
	end

	local function ServiceVisibilitySerialize(wantVisible)
		local ExplorerServiceVisibilityService = game:GetService("ExplorerServiceVisibilityService")
		local stringEncoder = Binary_Encoders["string"]
		local typeId = Attribute_Type_Ids["string"]

		local count = 0
		local buffer_size = 4
		local names = {}
		local formatted = {}

		for _, service in next, game:GetChildren() do
			if ExplorerServiceVisibilityService:GetServiceVisibility(service) == wantVisible then
				local name = service.ClassName
				local buf, size = stringEncoder(name)

				count = count + 1
				names[count] = name
				formatted[name] = buf

				buffer_size = buffer_size + (
						1 + size
					)
			end
		end

		if count == 0 then
			return "\0\0\0\0"
		end

		table.sort(names)

		local b = buffer.create(buffer_size)
		buffer.writeu32(b, 0, count)

		local offset = 4
		for _, name in next, names do
			buffer.writeu8(b, offset, typeId)
			offset = offset + 1

			local bb = formatted[name]
			buffer.copy(b, offset, bb)
			offset = offset + buffer.len(bb)
		end

		return buffer.tostring(b)
	end

	local function encodeTimeTicks(time)
		local scaled = time * 2400
		if not (scaled >= -2147483648.0 and scaled < 2147483648.0) then
			return -2147483648
		end
		return math.round(scaled)
	end

	local function writeTimesSection(b, offset, keys)
		buffer.writeu32(b, offset, 1)
		offset = offset + 4
		buffer.writeu32(b, offset, #keys)
		offset = offset + 4
		for _, key in next, keys do
			buffer.writei32(b, offset, encodeTimeTicks(key.Time))
			offset = offset + 4
		end
		return offset
	end

	local function deriveTangentValueCurve(keys, i)
		local key = keys[i]
		local isFirst = (i == 1)
		local isLast = (i == #keys)
		if isLast then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Linear then
			local nextKey = keys[i + 1]
			local t = 1 / (nextKey.Time - key.Time)
			return t, t
		end
		if isFirst then
			return 0, 0
		end
		local prevKey = keys[i - 1]
		local deltaPrev = key.Time - prevKey.Time
		if prevKey.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		elseif prevKey.Interpolation == Enum.KeyInterpolationMode.Linear then
			local t = 1 / deltaPrev
			return t, t
		else
			local nextKey = keys[i + 1]
			local deltaNext = nextKey.Time - key.Time
			local t = (1 / deltaPrev + 1 / deltaNext) / 2
			return t, t
		end
	end

	local function deriveTangentFloatCurve(keys, i)
		local key = keys[i]
		local isFirst = (i == 1)
		local isLast = (i == #keys)
		if isLast then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Linear then
			local nextKey = keys[i + 1]
			local slope = (nextKey.Value - key.Value) / (nextKey.Time - key.Time)
			return slope, slope
		end
		if isFirst then
			return 0, 0
		end
		local prevKey = keys[i - 1]
		if prevKey.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		elseif prevKey.Interpolation == Enum.KeyInterpolationMode.Linear then
			local slope = (key.Value - prevKey.Value) / (key.Time - prevKey.Time)
			return slope, slope
		else
			return 0, 0
		end
	end

	local NotScriptableFixes = {
		Instance = {
			AttributesSerialize = function(instance)
				local attrs = instance:GetAttributes()

				if not next(attrs) then
					return ""
				end

				return AttributesSerialize(attrs)
			end,
			DefinesCapabilities = "Sandboxed",
			Tags = function(instance)
				local tags = service.CollectionService:GetTags(instance)

				if #tags == 0 then
					return ""
				end

				return table.concat(tags, "\0")
			end,
		},
		Path2D = {
			PropertiesSerialize = function(instance)
				local control_points = instance:GetControlPoints()
				local n = #control_points

				if n == 0 then
					return "\0\0\0\0"
				end

				local b = buffer.create(4 + n * 49)
				buffer.writeu32(b, 0, n)

				local typeId = Attribute_Type_Ids["Path2DControlPoint"]
				local encoder = Binary_Encoders["Path2DControlPoint"]

				local offset = 4
				for i, point in next, control_points do
					local buf, bufSize = encoder(point)

					buffer.writeu8(b, offset, typeId)
					offset = offset + 1

					buffer.copy(b, offset, buf)
					offset = offset + bufSize
				end

				return buffer.tostring(b)
			end,
		},
PlayerEmulatorService = {
			SerializedEmulatedPolicyInfo = function(instance)
				local EmulatedPolicyInfo = instance:GetEmulatedPolicyInfo()

				if not next(EmulatedPolicyInfo) then
					return ""
				end

				return AttributesSerialize(EmulatedPolicyInfo)
			end,
		},
		StyleRule = {
			PropertiesSerialize = function(instance)
				local props = instance:GetProperties()

				if not next(props) then
					return "\0\0\0\0"
				end

				return AttributesSerialize(props)
			end,
			PropertyTransitionsSerialize = function(instance)
				local transitions = instance:GetPropertyTransitions()

				if not next(transitions) then
					return "\2\0\0\0\0\0"
				end

				return AttributesSerialize(transitions, { 0x02, 0x00 })
			end,
		},
		StyleQuery = {
			ConditionsSerialize = function(instance)
				local props = instance:GetConditions()

				if not next(props) then
					return "\0\0\0\0"
				end

				return AttributesSerialize(props)
			end,
		},
		FloatCurve = {
			ValuesAndTimes = function(instance)
				local keys = instance:GetKeys()

				if #keys == 0 then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local valuesPayloadSize = #keys * 14
				local b = buffer.create(8 + valuesPayloadSize + 8 + (#keys * 4))

				buffer.writeu32(b, 0, 2)
				buffer.writeu32(b, 4, #keys)

				local offset = 8
				for i, key in next, keys do
					local lt, rt = key.LeftTangent, key.RightTangent
					local mode = countBits(lt, rt)

					if mode == 0 then
						lt, rt = deriveTangentFloatCurve(keys, i)
					elseif mode == 1 then
						rt = lt
					elseif mode == 2 then
						lt = rt
					end

					buffer.writeu8(b, offset, key.Interpolation.Value)
					offset = offset + 1
					buffer.writeu8(b, offset, mode)
					offset = offset + 1
					buffer.writef32(b, offset, key.Value)
					offset = offset + 4
					buffer.writef32(b, offset, lt)
					offset = offset + 4
					buffer.writef32(b, offset, rt)
					offset = offset + 4
				end

				offset = writeTimesSection(b, offset, keys)

				return buffer.tostring(b)
			end,
		},
		RotationCurve = {
			ValuesAndTimes = function(instance)
				local keys = instance:GetKeys()

				if #keys == 0 then
					return "\1\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local perKeySize = 1 + 16 + 4 + 4
				local b = buffer.create(8 + (#keys * perKeySize) + 8 + (#keys * 4))

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, #keys)

				local offset = 8
				for _, key in next, keys do
					local lt = key.LeftTangent or 0
					local rt = key.RightTangent or 0
					local qx, qy, qz, qw = cframeToQuaternion(key.Value)

					buffer.writeu8(b, offset, 12 + key.Interpolation.Value)
					offset = offset + 1
					buffer.writef32(b, offset, qx)
					offset = offset + 4
					buffer.writef32(b, offset, qy)
					offset = offset + 4
					buffer.writef32(b, offset, qz)
					offset = offset + 4
					buffer.writef32(b, offset, qw)
					offset = offset + 4
					buffer.writef32(b, offset, lt)
					offset = offset + 4
					buffer.writef32(b, offset, rt)
					offset = offset + 4
				end

				offset = writeTimesSection(b, offset, keys)

				return buffer.tostring(b)
			end,
		},
		ValueCurve = {
			ValuesAndTimes = function(instance)
				local keys = instance:GetKeys()

				if #keys == 0 then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local valueTypeName = instance.ValueType

				local typeId = Attribute_Type_Ids[valueTypeName]

				if not typeId then
					valueTypeName = resolveTypeName(keys[1].Value)

					typeId = Attribute_Type_Ids[valueTypeName]
				end

				local encoder = Binary_Encoders[valueTypeName]

				if not encoder then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local n = #keys
				local bufs = table.create(n)
				local sizes = table.create(n)
				local valuesPayloadSize = 0

				for i, key in next, keys do
					local dataBuf, dataSize = encoder(key.Value)
					bufs[i] = dataBuf
					sizes[i] = dataSize
					valuesPayloadSize = valuesPayloadSize + (1 + 1 + 4 + 1 + dataSize + 4 + 4)
				end

				local b = buffer.create(8 + valuesPayloadSize + 8 + 4 * n)
				buffer.writeu32(b, 0, 2)
				buffer.writeu32(b, 4, n)

				local offset = 8
				for i, key in next, keys do
					local lt, rt = key.LeftTangent, key.RightTangent
					local dataSize = sizes[i]

					buffer.writeu8(b, offset, key.Interpolation.Value)
					offset = offset + 1
					buffer.writeu8(b, offset, countBits(lt, rt))
					offset = offset + 1
					buffer.writeu32(b, offset, dataSize + 1)
					offset = offset + 4
					buffer.writeu8(b, offset, typeId)
					offset = offset + 1
					buffer.copy(b, offset, bufs[i])
					offset = offset + dataSize

					if lt == nil and rt == nil then
						lt, rt = deriveTangentValueCurve(keys, i)
					elseif lt == nil then
						lt = rt
					elseif rt == nil then
						rt = lt
					end

					buffer.writef32(b, offset, lt)
					offset = offset + 4
					buffer.writef32(b, offset, rt)
					offset = offset + 4
				end

				offset = writeTimesSection(b, offset, keys)

				return buffer.tostring(b)
			end,
		},
		MarkerCurve = {
			ValuesAndTimes = function(instance)
				local markers = instance:GetMarkers()
				local n = #markers

				if n == 0 then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local strings_size = 0
				for _, marker in next, markers do
					strings_size = strings_size + (#marker.Value + 1)
				end

				local b = buffer.create(8 + strings_size + 8 + (n * 4))

				buffer.writeu32(b, 0, 2)
				buffer.writeu32(b, 4, n)

				local offset = 8
				for _, marker in next, markers do
					local value = marker.Value
					buffer.writestring(b, offset, value)
					offset = offset + (#value + 1)
				end

				offset = writeTimesSection(b, offset, markers)

				return buffer.tostring(b)
			end,
		},
		AnimationNodeDefinition = {
			InputPinData = function(instance)
				local input_pins = instance:GetInputPins()

				local n = #input_pins

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local buffer_size = 8

				for _, pin in next, input_pins do
					buffer_size = buffer_size + (4 + #pin)
				end

				local b = buffer.create(buffer_size)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local encoder = Binary_Encoders["string"]
				local offset = 8
				for _, pin in next, input_pins do
					local pinBuf, pinSize = encoder(pin)

					buffer.copy(b, offset, pinBuf)
					offset = offset + pinSize
				end

				return buffer.tostring(b)
			end,
		},
		AnimationClip = {
			GuidBinaryString = function(instance)
				local cleanGuid = string.gsub(instance.Guid, "[{}-]", "")
				local bytes = buffer.create(16)

				for i = 0, 15 do
					local hexByte = string.sub(cleanGuid, (i * 2) + 1, (i * 2) + 2)
					local val = tonumber(hexByte, 16) or 0
					buffer.writeu8(bytes, i, val)
				end

				return buffer.tostring(bytes)
			end,
		},
		AnimationRigData = {
			label = function(instance)
				local labels = instance:GetLabels()
				local n = #labels

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local b = buffer.create(8 + n * 4)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local offset = 8

				for _, label in next, labels do
					buffer.writeu32(b, offset, label)
					offset = offset + 4
				end

				return buffer.tostring(b)
			end,
			name = function(instance)
				local names = instance:GetNames()
				local n = #names

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local buffer_size = 8

				for _, name in next, names do
					buffer_size = buffer_size + (4 + #name)
				end

				local b = buffer.create(buffer_size)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local offset = 8

				for _, name in next, names do
					buffer.writeu32(b, offset, #name)
					offset = offset + 4
				end
				for _, name in next, names do
					buffer.writestring(b, offset, name)
					offset = offset + #name
				end

				return buffer.tostring(b)
			end,
			parent = function(instance)
				local parents = instance:GetParents()
				local n = #parents

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local b = buffer.create(8 + #parents * 2)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local offset = 8

				for _, parent in next, parents do
					buffer.writeu16(b, offset, parent)
					offset = offset + 2
				end

				return buffer.tostring(b)
			end,
			postTransform = function(instance)
				return TransformsSerialize(instance:GetPostTransforms())
			end,
			preTransform = function(instance)
				return TransformsSerialize(instance:GetPreTransforms())
			end,
			transform = function(instance)
				return TransformsSerialize(instance:GetTransforms())
			end,
		},
		AudioDeviceInput = {
			AccessList = function(instance)
				local userid_accesslist = instance:GetUserIdAccessList()

				local n = #userid_accesslist

				if n == 0 then
					return ""
				end

				local b = buffer.create(n * 8)

				local _writeI64LE = Binary_Encoders._writeI64LE

				local offset = 0
				for _, user_id in next, userid_accesslist do
					_writeI64LE(b, offset, user_id)
					offset = offset + 8
				end

				return buffer.tostring(b)
			end,
		},
		AudioEmitter = {
			AngleAttenuation = function(instance)
				return AttenuationSerialize(instance:GetAngleAttenuation())
			end,
			DistanceAttenuation = function(instance)
				return AttenuationSerialize(instance:GetDistanceAttenuation())
			end,
		},
		AudioListener = {
			AngleAttenuation = function(instance)
				return AttenuationSerialize(instance:GetAngleAttenuation())
			end,
			DistanceAttenuation = function(instance)
				return AttenuationSerialize(instance:GetDistanceAttenuation())
			end,
		},
		DebuggerBreakpoint = { line = "Line" },
		BallSocketConstraint = { MaxFrictionTorqueXml = "MaxFrictionTorque" },
		BasePart = {
			Color3uint8 = "Color",
			MaterialVariantSerialized = "MaterialVariant",
			size = "Size",
			siz = "Size",
		},
		DoubleConstrainedValue = { value = "Value" },
		IntConstrainedValue = { value = "Value" },

		CustomEvent = {
			PersistedCurrentValue = function(instance)
				local receiver = instance:GetAttachedReceivers()[1]
				if receiver then
					return receiver:GetCurrentValue()
				end

				local tempReceiver = Instance.new("CustomEventReceiver")
				local clone = Instance.fromExisting(instance)

				tempReceiver.Source = clone
				local value = tempReceiver:GetCurrentValue()

				tempReceiver:Destroy()
				clone:Destroy()

				return value
			end,
		},

		Terrain = {
			AcquisitionMethod = "LastUsedModificationMethod",
MaterialColors = function(instance)

				local TERRAIN_MATERIAL_COLORS =
					{
						Enum.Material.Grass,
						Enum.Material.Slate,
						Enum.Material.Concrete,
						Enum.Material.Brick,
						Enum.Material.Sand,
						Enum.Material.WoodPlanks,
						Enum.Material.Rock,
						Enum.Material.Glacier,
						Enum.Material.Snow,
						Enum.Material.Sandstone,
						Enum.Material.Mud,
						Enum.Material.Basalt,
						Enum.Material.Ground,
						Enum.Material.CrackedLava,
						Enum.Material.Asphalt,
						Enum.Material.Cobblestone,
						Enum.Material.Ice,
						Enum.Material.LeafyGrass,
						Enum.Material.Salt,
						Enum.Material.Limestone,
						Enum.Material.Pavement,
					}

				local b = buffer.create(69)
				local offset = 6

				for _, material in next, TERRAIN_MATERIAL_COLORS do
					local color = instance:GetMaterialColor(material)
					buffer.writeu8(b, offset, (color.R * 255))
					offset = offset + 1
					buffer.writeu8(b, offset, (color.G * 255))
					offset = offset + 1
					buffer.writeu8(b, offset, (color.B * 255))
					offset = offset + 1
				end

				return buffer.tostring(b)
			end,
		},
		BaseWrap = {
			TemporaryCageMeshContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TemporaryCageMeshId"))
			end,
		},
		MaterialVariant = {
			TexturePackContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TexturePack"))
			end,
		},
		TerrainDetail = {
			TexturePackContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TexturePack"))
			end,
		},
		WrapLayer = {
			TemporaryReferenceMeshContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TemporaryReferenceId"))
			end,
		},
		TriangleMeshPart = {
			FluidFidelityInternal = "FluidFidelity",
		},
		MeshPart = {
			InitialSize = "MeshSize",
			MeshID = "MeshId",
			VertexCount = function(instance)
				local meshId = instance.MeshId
				if meshId == "" then
					return __BREAK
				end
				return #service.UGCValidationService:GetMeshVerts(meshId)
			end,
		},
		PartOperation = {
			Content = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "AssetId"))
			end,
			InitialSize = "MeshSize",
		},
		Part = { shape = "Shape", shap = "Shape" },
		TrussPart = { style = "Style" },
		FormFactorPart = {
			formFactorRaw = "FormFactor",
		},
		Fire = { heat_xml = "Heat", size_xml = "Size" },
		Clothing = {
			Outfit1Content = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "Outfit1"))
			end,
			Outfit2Content = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "Outfit2"))
			end,
		},
		Humanoid = {
			Health_XML = "Health",
			InternalBodyScale = function(instance)
				local a = instance.RootPart

				if not a then
					return __BREAK
				end

				return instance:GetAccessoryHandleScale(a, Enum.BodyPartR15.RootPart)
			end,
			InternalHeadScale = function(instance)
				local a = instance.Parent and instance.Parent:FindFirstChild("Head")

				if not a then
					return __BREAK
				end

				return instance:GetAccessoryHandleScale(a, Enum.BodyPartR15.Head).X
			end,
			NetworkHumanoidState = function(instance)
				return instance:GetState()
			end,
		},
		HumanoidDescription = {
			AccessoryBlob = function(instance)
				local blob = {}

				for _, acc in next, instance:GetAccessories(false) do
					table.insert(blob, {
						AssetId = acc.AssetId,
						Order = acc.Order,
						AccessoryType = acc.AccessoryType.Name,
						Puffiness = acc.Puffiness,
					})
				end

				return service.HttpService:JSONEncode(blob)
			end,
			EmotesDataInternal = function(instance)
				local emotes_data = ""
				for name, ids in next, instance:GetEmotes() do
					emotes_data = emotes_data .. name .. "^" .. table.concat(ids, "^") .. "^\\"
				end
				return emotes_data
			end,
			EquippedEmotesDataInternal = function(instance)
				local equipped_emotes = instance:GetEquippedEmotes()
				if #equipped_emotes == 0 then
					return ""
				end

				local equipped_emotes_data = ""
				for _, emote in next, equipped_emotes do
					equipped_emotes_data = equipped_emotes_data .. emote.Slot .. "^" .. emote.Name .. "\\"
				end
				return equipped_emotes_data
			end,
		},
		LocalizationTable = {
			Contents = function(instance)
				return instance:GetContents()
			end,
		},
		MaterialService = { Use2022MaterialsXml = "Use2022Materials" },
		VideoPlayer = {
			PlayingReplicating = "IsPlaying",
		},

		Model = {
			ModelMeshCFrame = function(instance)
				return instance:GetModelCFrame()
			end,
			ModelMeshSize = function(instance)
				return instance:GetExtentsSize()
			end,
			Scale = function(instance)
				return instance:GetScale()
			end,
			ScaleFactor = function(instance)
				return instance:GetScale()
			end,
			WorldPivotData = "WorldPivot",
		},
		PackageLink = {
			PackageContentSerialize = "PackageContent",
			PackageIdSerialize = "PackageId",
			VersionIdSerialize = "VersionNumber",
		},
		Players = { MaxPlayersInternal = "MaxPlayers", PreferredPlayersInternal = "PreferredPlayers" },

		StarterPlayer = {
			AvatarJointUpgrade_SerializedRollout = "AvatarJointUpgrade",
		},
		Smoke = { size_xml = "Size", opacity_xml = "Opacity", riseVelocity_xml = "RiseVelocity" },
		Sound = {
			xmlRead_MinDistance_3 = "RollOffMinDistance",
			xmlRead_MaxDistance_3 = "RollOffMaxDistance",
		},
		ViewportFrame = {
			CameraCFrame = function(instance)
				local CurrentCamera = instance.CurrentCamera

				return CurrentCamera and CurrentCamera.CFrame or CFrame.identity
			end,
			CameraFieldOfView = function(instance)
				local CurrentCamera = instance.CurrentCamera

				return math.rad(CurrentCamera and CurrentCamera.FieldOfView or 70)
			end,
		},
		WeldConstraint = {
			CFrame0 = function(instance)
				local Part0, Part1 = instance.Part0, instance.Part1

				return Part0 and Part1 and Part0.CFrame:ToObjectSpace(Part1.CFrame) or CFrame.identity
			end,
			CFrame1 = function(instance)
				local Part0, Part1 = instance.Part0, instance.Part1

				return Part0 and Part1 and Part1.CFrame:ToObjectSpace(Part0.CFrame) or CFrame.identity
			end,
			Part0Internal = "Part0",
			Part1Internal = "Part1",
			State = function(instance)
				return countBits(instance.Enabled, instance.Active)
			end,
		},
		Workspace = {
			CollisionGroups = function()
				local registered = game:GetService("PhysicsService"):GetRegisteredCollisionGroups()

				local n = #registered
				if n == 0 then
					return ""
				end

				local parts = table.create(n)
				for i, group in next, registered do
					parts[i] = group.name .. "^" .. i - 1 .. "^" .. group.mask
				end
				return table.concat(parts, "\\")
			end,
		},
		WorldRoot = {
			CollisionGroupData = function()
				local collision_groups = game:GetService("PhysicsService"):GetRegisteredCollisionGroups()
				local n = #collision_groups

				if n == 0 then
					return "\1\0"
				end

				local buffer_size = 2

				for _, group in next, collision_groups do
					buffer_size = buffer_size
						+ (
							7 + #group.name
						)
				end

				local b = buffer.create(buffer_size)

				buffer.writeu8(b, 0, 1)
				buffer.writeu8(b, 1, n)

				local typeId_int32 = Attribute_Type_Ids["int32"]
				local offset = 2

				for i, group in next, collision_groups do
					local name, id, mask = group.name, i - 1, group.mask
					local name_len = #name

					buffer.writeu8(b, offset, id)
					offset = offset + 1

					buffer.writeu8(b, offset, typeId_int32)
					offset = offset + 1

					buffer.writei32(b, offset, mask)
					offset = offset + 4

					buffer.writeu8(b, offset, name_len)
					offset = offset + 1
					buffer.writestring(b, offset, name)
					offset = offset + name_len
				end

				return buffer.tostring(b)
			end,
		},

		ServiceVisibilityService = {
			HiddenServices = function()
				return ServiceVisibilitySerialize(false)
			end,
			VisibleServices = function()
				return ServiceVisibilitySerialize(true)
			end,
		},
	}
	for _, enum_item in next, Enum.Material:GetEnumItems() do
		NotScriptableFixes.MaterialService[enum_item.Name .. "Name"] = function(instance)
			return instance:GetBaseMaterialOverride(enum_item)
		end
	end

	NotScriptableFixes.Workspace.CollisionGroupData = NotScriptableFixes.WorldRoot.CollisionGroupData

	FetchAPI = function()
		local FILE_NAME = "API_DUMP.json"

		local API_Dump

		local Max_SecurityCapabilities = SecurityCapabilities.new(unpack(Enum.SecurityCapability:GetEnumItems()))
		local filter = { Security = Max_SecurityCapabilities, ExcludeDisplay = true, ExcludeInherited = true }

		local APIDUMP_FETCHERS = {
			[1] = function()
				local res = readfile(FILE_NAME)
				if res and res ~= "" then
					return service.HttpService:JSONDecode(res)[FULL_VERSION]
				end
			end,
			[2] = function()
				local client_version_str = tostring(CLIENT_VERSION)
				local dump
				local matching_versions, matched, is_matched, exact_match = {}, {}
				local function process_line(line, noinsert)
					local file_version, patch_commit, version_hash =
						string.match(line, '"%d+%.(%d+)%.([^"]+)": "(version%-[^"]+)')
					if file_version == client_version_str then
						is_matched = true
						if version_hash and not matched[version_hash] then
							matched[version_hash] = true
							if not noinsert then
								table.insert(matching_versions, version_hash)
							end
							if string.sub(FULL_VERSION, -#patch_commit) == patch_commit then
								return version_hash
							end
						end
					elseif is_matched then
						return false
					end
				end

				local function isFullDump(classes)
					for _, class in next, classes do
						for _, member in next, class.Members do
							if member.MemberType == "Property" then
								return member.Default ~= nil
							end
						end
					end
					return false
				end

				local function tryFetchDump(url)
					local ok, decoded = pcall(function()
						local raw = game:HttpGet(url, true)
						return service.HttpService:JSONDecode(raw)
					end)
					return ok and decoded.Classes or nil
				end

				local function fetchFullApiDump(hash)
					local decoded = tryFetchDump("https://setup.rbxcdn.com/" .. hash .. "-Full-API-Dump.json")
					if decoded and isFullDump(decoded) then
						return decoded
					end

					decoded = tryFetchDump(
						"https://raw.githubusercontent.com/setup-rbxcdn/roblox-full-api-dumps/refs/heads/main/full-dumps/"
							.. hash
							.. "-Full-API-Dump.json"
					)
					if decoded and isFullDump(decoded) then
						return decoded
					end

					return nil
				end

				do
					local o, r = pcall(
						game.HttpGet,
						game,
						"https://raw.githubusercontent.com/setup-rbxcdn/setup-rbxcdn.github.io/refs/heads/main/version-history/Windows/Studio64.json",
						true
					)
					if o then
						local version_history = string.split(r, "\n")
						version_history[#version_history] = nil
						for i = #version_history, 2, -1 do
							local res = process_line(version_history[i])
							if res == false then
								break
							elseif res then
								exact_match = res
							end
						end
					end
				end
				do
					local function fallback_channel(channel)
						local ok, res = pcall(function()
							return service.HttpService:JSONDecode(
								game:HttpGet(
									"https://clientsettingscdn.roblox.com/v2/client-version/WindowsStudio64"
										.. (channel and "/channel/" .. channel or ""),
									true
								)
							)
						end)
						if not ok then
							return
						end
						if res.version and res.clientVersionUpload then
							local line = '"' .. res.version .. '": "' .. res.clientVersionUpload
							return process_line(line, true)
						end
					end
					if not exact_match then
						exact_match = fallback_channel("zbeta") or fallback_channel()
					end
				end
				if exact_match then
					dump = fetchFullApiDump(exact_match)
				end
				if not dump then
					for _, version_hash in next, matching_versions do
						dump = fetchFullApiDump(version_hash)
						if dump then
							break
						end
					end
				end
				return dump
			end,
			[3] = function()
				local classes, classes_size = {}, 1

				for _, api_class in next, service.ReflectionService:GetClasses(filter) do
					local members, members_size = {}, 1
					local className = api_class.Name

					local class = {
						Name = className,
						Members = members,
						Superclass = api_class.Superclass or "<<<ROOT>>>",
					}
					local permits = api_class.Permits

					local tags = {}
					if api_class.Service then
						table.insert(tags, "Service")
					elseif permits and permits["GetService"] then
						table.insert(tags, "Service")
					elseif not permits or not permits["New"] then
						table.insert(tags, "NotCreatable")
					end

					if #tags ~= 0 then
						class.Tags = tags
					end

					local o, r = pcall(
						service.ReflectionService.GetPropertiesOfClass,
						service.ReflectionService,
						className,
						filter
					)
					if o then
						for _, property in next, r do
							local propertyName = property.Name

							local valueType = property.Type
							local valueType_Name = valueType.EngineType

							local category = valueType.Category

							local member_tags = {}

							if not next(property.Permits) then
								table.insert(member_tags, "NotScriptable")
							end

							if valueType_Name == "Enum" then
								category, valueType_Name = "Enum", valueType.EnumType
							elseif valueType_Name == "RefType" then
								category, valueType_Name = "Class", valueType.InstanceType
							else
								local renames = {
									CoordinateFrame = "CFrame",
									Rect2D = "Rect",
									Vector3Int16 = "Vector3int16",
									Vector2Int16 = "Vector2int16",
									Region3Int16 = "Region3int16",
								}
								valueType_Name = renames[valueType_Name] or valueType_Name
							end

							local member = {
								Name = propertyName,
								MemberType = "Property",
								ValueType = { Name = valueType_Name, Category = category },
								Serialization = { CanLoad = property.Serialized, CanSave = property.Serialized },
							}

							if #member_tags ~= 0 then
								member.Tags = member_tags
							end

							members[members_size] = member
							members_size = members_size + 1
						end
					end
					classes[classes_size] = class
					classes_size = classes_size + 1
				end

				return classes
			end,
			[4] = function()
				return service.HttpService:JSONDecode(
					game:HttpGet(
						"https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/Mini-API-Dump.json",
						true
					)
				).Classes
			end,
		}

		for i, fetcher in next, APIDUMP_FETCHERS do
			local o, r = pcall(fetcher)
			if o and r then
				API_Dump = r
				if i == 2 then
					if writefile then
						local ok, err =
							pcall(writefile, FILE_NAME, service.HttpService:JSONEncode({ [FULL_VERSION] = API_Dump }))
						if not ok then
							warn("[DEBUG] DUMP writefile error", err)
						end
					end
				end
				break
			elseif r ~= false and 2 < i then
				warn("[DEBUG] Failed to get", FULL_VERSION, "version API Dump, trying fallbacks..")
				warn("[DEBUG] Method number:", i, "Reason:", r)
			end
		end

		local classList = {}
		local tmp_classDict = {}

		local ClassesWhitelist, ClassesBlacklist = ClassPropertyExceptions.Whitelist, ClassPropertyExceptions.Blacklist

		local API_Dump_Decoded = API_Dump

		for _, API_Class in next, API_Dump_Decoded do
			local ClassName = API_Class.Name
			local props = {}

			for _, Member in next, API_Class.Members do
				local MemberType = Member.MemberType
				if MemberType == "Property" or MemberType == "Function" then
					props[Member.Name] = {
						ValueType = MemberType == "Property" and Member.ValueType.Name,
						MemberType = MemberType,
					}
				end
			end

			tmp_classDict[ClassName] = props
		end

		for _, API_Class in next, API_Dump_Decoded do
			local ClassProperties, ClassProperties_size = {}, 1
			local Class = {
				Properties = ClassProperties,
				Superclass = API_Class.Superclass,
				NotCreatable = nil,
			}

			local ClassName = API_Class.Name
			local ClassTags = API_Class.Tags

			if ClassTags then
				local Tags = arrayToDict(ClassTags, nil, nil, "string")
				Class.NotCreatable = Tags.NotCreatable
				Class.Service = Tags.Service
			end

			local NotScriptableFixClass = NotScriptableFixes[ClassName]

			local ClassWhitelist, ClassBlacklist = ClassesWhitelist[ClassName], ClassesBlacklist[ClassName]

			local ContentProperties
			for _, Member in next, API_Class.Members do
				if Member.MemberType == "Property" then
					local Serialization = Member.Serialization

					if Serialization.CanLoad then
						local PropertyName = Member.Name

						local ValueType = Member.ValueType
						local ValueType_Name = ValueType.Name

						if ValueType_Name == "Content" or ValueType_Name == "AssetContentMap" then
							if not ContentProperties then
								ContentProperties = {}

								local o, properties = pcall(
									service.ReflectionService.GetPropertiesOfClass,
									service.ReflectionService,
									ClassName,
									filter
								)
								if o then
									for _, property in next, properties do
										ContentProperties[property.Name] = property.Serialized
									end
								end
							end
							if ContentProperties[PropertyName] ~= nil then
								Serialization.CanSave = ContentProperties[PropertyName]
							end
						end

						if
							(Serialization.CanSave or ClassWhitelist and ClassWhitelist[PropertyName])
							and not (ClassBlacklist and ClassBlacklist[PropertyName])
						then
							local MemberTags = Member.Tags

							local Special, PreferredDescriptorName

							if MemberTags then
								for _, tag in next, MemberTags do
									if type(tag) == "table" then
										PreferredDescriptorName = tag.PreferredDescriptorName
										if PreferredDescriptorName and Special then
											break
										end
									elseif tag == "NotScriptable" then
										Special = true
										if PreferredDescriptorName then
											break
										end
									end
								end
							end

							local preferredDescriptorProp
							if PreferredDescriptorName then
								preferredDescriptorProp = tmp_classDict[ClassName][PreferredDescriptorName]

								if
									preferredDescriptorProp == nil
									or (
										preferredDescriptorProp.MemberType == "Property"
										and ValueType_Name ~= preferredDescriptorProp.ValueType
									)
								then
									PreferredDescriptorName = nil
								end
							end

							local Property = {
								Name = PropertyName,
								Category = ValueType.Category,
								ValueType = ValueType_Name,

								Special = Special,

								CanRead = nil,
							}

							if string.sub(ValueType_Name, 1, 8) == "Optional" then
								Property.Optional = string.sub(ValueType_Name, 9)
							end

							local NotScriptableFix = NotScriptableFixClass and NotScriptableFixClass[PropertyName]
							local accessFunc = PreferredDescriptorName
								and (
									preferredDescriptorProp.MemberType == "Property"
										and function(instance)
											return instance[PreferredDescriptorName]
										end
									or function(instance)
										return instance[PreferredDescriptorName](instance)
									end
								)

							Property.Fallback = NotScriptableFix
									and (type(NotScriptableFix) == "function" and NotScriptableFix or accessFunc and function(
										instance
									)
										local o, r = pcall(accessFunc, instance)
										if o then
											return r
										end
										return instance[NotScriptableFix]
									end or function(instance)
										return instance[NotScriptableFix]
									end)
								or accessFunc

							ClassProperties[ClassProperties_size] = Property
							ClassProperties_size = ClassProperties_size + 1

						end
					end
				end
			end

			classList[ClassName] = Class
		end

		return classList
	end
end

local GLOBAL_ENV = getgenv and getgenv() or _G or shared

local function synsaveinstance(CustomOptions, CustomOptions2)
	if GLOBAL_ENV.USSI then
		return
	end
	GLOBAL_ENV.USSI = true
local totalsize, chunks = 0, table.create(1)
	local savebuffer, savebuffer_size = {}, 1
	local header =
		'<!-- Decompiled By KkSaiko -->\n' ..
		'-- ██╗  ██╗██╗  ██╗███████╗ █████╗ ██╗██╗  ██╗ ██████╗     ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗██╗     ███████╗██████╗ \n' ..
		'-- ██║ ██╔╝██║ ██╔╝██╔════╝██╔══██╗██║██║ ██╔╝██╔═══██╗    ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║██║     ██╔════╝██╔══██╗\n' ..
		'-- █████╔╝ █████╔╝ ███████╗███████║██║█████╔╝ ██║   ██║    ██║  ██║█████╗  ██║     ██║   ██║██╔████╔██║██████╔╝██║██║     █████╗  ██████╔╝\n' ..
		'-- ██╔═██╗ ██╔═██╗ ╚════██║██╔══██║██║██╔═██╗ ██║   ██║    ██║  ██║██╔══╝  ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║██║     ██╔══╝  ██╔══██╗\n' ..
		'-- ██║  ██╗██║  ██╗███████║██║  ██║██║██║  ██╗╚██████╔╝    ██████╔╝███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ██║███████╗███████╗██║  ██║\n' ..
		'-- ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝\n' ..
		'<roblox version="4">'

	local StatusText

	local OPTIONS = {
		mode = "optimized",
		Decompile = true,
		scriptcache = true,
		DecompileTimeout = 10,
		BytecodeTimeout = 3,
		__DEBUG_MODE = false,

		DecompileJobless = false,
		DecompileIgnore = {
			"TextChatService",
			ModuleScript = nil,
		},
		IgnoreDefaultPlayerScripts = true,
		SaveBytecode = false,

		IgnoreProperties = {},

		IgnoreList = { "CoreGui", "CorePackages" },

		ExtraInstances = {},
		NilInstances = true,
		NilInstancesFixes = {},

		SaveCacheInterval = 0x1600 * 10,
		ShowStatus = true,
		KillAllScripts = true,
		SafeMode = false,
		BoostFPS = false,
		ShutdownWhenDone = false,
		AntiIdle = false,
		Anonymous = false,
		ReadMe = false,
		FilePath = false,
		AvoidFileOverwrite = true,
		Object = false,
		IsModel = false,

		IgnoreDefaultProperties = true,
		IgnoreNotArchivable = true,
		IgnorePropertiesOfNotScriptsOnScriptsMode = false,
		IgnoreSpecialProperties = arrayToDict({ "Fluxus", "Delta", "Solara" })[EXECUTOR_NAME] or false,

		IsolateLocalPlayer = true,
		IsolateLocalPlayerCharacter = false,
		IsolatePlayers = false,
		IsolateStarterPlayer = false,
		SavePlayerCharacters = false,

		SaveNotCreatable = false,
		NotCreatableFixes = {
			"AdvancedDragger",
			"AnimationTrack",
			"Breakpoints",
			"DebuggerWatch",
			"Dragger",
			"PlayerGui",
			"PlayerMouse",
			"PlayerMouse",
			"PlayerScripts",
			"ScreenshotHud",
			"ScriptDebugger",
			"StudioData",
			"TextChatMessage",
			"TextSource",
			"TouchTransmitter",
			"Translator",
			CloudLocalizationTable = "LocalizationTable",
			Platform = "Part",
			Status = "Model",
		},

		IgnoreSharedStrings = false,
		SharedStringOverwrite = false,
		TreatUnionsAsParts = false,
		AlternativeWritefile = not arrayToDict({ "WRD", "Xeno", "Zorara" })[EXECUTOR_NAME],

		OptionsAliases = {
			timeout = "DecompileTimeout",
			DecompileScripts = "Decompile",
			FileName = "FilePath",
			IgnoreArchivable = "IgnoreNotArchivable",
			IgnoreDefaultProps = "IgnoreDefaultProperties",
			InstancesBlacklist = "IgnoreList",
			SaveLocalPlayer = "IsolateLocalPlayer",
			IsolatePlayerGui = "IsolateLocalPlayer",
			SavePlayerGui = "IsolateLocalPlayer",
			SaveNonCreatable = "SaveNotCreatable",
			SaveNilInstances = "NilInstances",
			SavePlayers = "IsolatePlayers",
			SaveCharacters = "SavePlayerCharacters",
			StatusText = "ShowStatus",
		},
		OptionsAliasesInverse = {
			noscripts = "Decompile",
			RemovePlayers = "IsolatePlayers",
			RemovePlayerCharacters = "SavePlayerCharacters",
		},
	}
	local OPTIONS_lowercase, OptionsAliasesInverse_lowercase, CustomOptions_valid = {}, {}, {}

	do
		local function buildMap(dest, source, warnLabel)
			for k, v in next, source do
				local key = string.lower(k)

				if dest[key] then
					warn("DUPLICATE " .. warnLabel, k)
				else
					dest[key] = v
				end
			end
		end

		for o in next, OPTIONS do
			local option = string.lower(o)
			if OPTIONS_lowercase[option] then
				warn("DUPLICATE OPTION", o)
			else
				OPTIONS_lowercase[option] = o
			end
		end

		buildMap(OPTIONS_lowercase, OPTIONS.OptionsAliases, "ALIAS")

		buildMap(OptionsAliasesInverse_lowercase, OPTIONS.OptionsAliasesInverse, "INVERSE ALIAS")
	end

	do
		local function makeNilinstanceFix(Name, ClassName, Separate)
			return function(instance, instancePropertyOverrides)
				local Exists

				if not Separate then
					Exists = OPTIONS.NilInstancesFixes[Name]
				end

				local Fix

				local DoesntExist = not Exists
				if DoesntExist then
					Fix = Instance.new(ClassName)
					if not Separate then
						OPTIONS.NilInstancesFixes[Name] = Fix
					end
					instancePropertyOverrides[Fix] =
						{ __SaveSpecific = true, __Children = { instance }, Properties = { Name = Name } }
				else
					Fix = Exists
					table.insert(instancePropertyOverrides[Fix].__Children, instance)
				end

				if DoesntExist then
					return Fix
				end
			end
		end

		OPTIONS.NilInstancesFixes.Animator =
			makeNilinstanceFix("Animator has to be placed under Humanoid or AnimationController", "AnimationController")
		OPTIONS.NilInstancesFixes.AdPortal = makeNilinstanceFix("AdPortal must be parented to a Part", "Part")
		OPTIONS.NilInstancesFixes.Attachment =
			makeNilinstanceFix("Attachments must be parented to a BasePart or another Attachment", "Part")
		OPTIONS.NilInstancesFixes.BaseWrap = makeNilinstanceFix("BaseWrap must be parented to a MeshPart", "MeshPart")
		OPTIONS.NilInstancesFixes.PackageLink = makeNilinstanceFix("Package already has a PackageLink", "Folder", true)

		if CustomOptions2 and type(CustomOptions2) == "table" then
			local tmp = CustomOptions
			local Type = typeof(tmp)
			CustomOptions = CustomOptions2
			if Type == "Instance" then
				CustomOptions.Object = tmp
			elseif Type == "table" and typeof(tmp[1]) == "Instance" then
				CustomOptions.ExtraInstances = tmp
				OPTIONS.IsModel = true
			end
		end

		local Type = typeof(CustomOptions)

		if Type == "table" then
			if typeof(CustomOptions[1]) == "Instance" then
				OPTIONS.mode = "invalidmode"
				OPTIONS.ExtraInstances = CustomOptions
				OPTIONS.IsModel = true
				CustomOptions = {}
			else
				for key, value in next, CustomOptions do
					local k = string.lower(key)

					local option = OPTIONS_lowercase[k]
					local invert = false

					if not option then
						option = OptionsAliasesInverse_lowercase[k]
						invert = option ~= nil
					end

					if option then
						local finalValue
						if invert then
							finalValue = not value
						else
							finalValue = value
						end

						OPTIONS[option] = finalValue
						CustomOptions_valid[option] = true
					end
				end
			end
		elseif Type == "Instance" then
			OPTIONS.mode = "invalidmode"
			OPTIONS.Object = CustomOptions
			CustomOptions = {}
		else
			CustomOptions = {}
		end
	end

	if not writefile and not OPTIONS.Callback then
		local function coreCall(method, ...)
			local StarterGui = service.StarterGui
			method = StarterGui[method]
			if not method then
				return
			end

			for _ = 1, 10 do
				local success, result = pcall(method, StarterGui, ...)
				if success then
					return result
				end
				task.wait(1)
			end
		end

		local text = 'Function "writefile" is NOT available\nUse the Option "Callback" instead for now (check docs)'

		coreCall("SetCore", "SendNotification", {
			Title = "SAVEINSTANCE ERROR",
			Text = text,
			Duration = 15,
			Icon = "rbxassetid://9072920609",
		})
		coreCall("SetCore", "SendNotification", {
			Title = "SAVEINSTANCE ERROR",
			Text = "Please ask your executor's developers to add writefile",
			Duration = 15,
			Icon = "rbxassetid://9072920609",
		})

		warn(text)

		GLOBAL_ENV.USSI = nil
		return
	end

	if OPTIONS.IgnoreDefaultPlayerScripts then
		local DecompileIgnore = OPTIONS.DecompileIgnore

		local default_scripts = arrayToDict({
			ModuleScript = { "PlayerModule" },
			LocalScript = {
				"BubbleChat",
				"ChatScript",
				"PlayerScriptsLoader",
				"RbxCharacterSounds",
			},
		}, true)

		local function ignorePath(path)
			if path then
				for _, child in next, path:GetChildren() do
					local class_match = default_scripts[child.ClassName]
					if class_match then
						local name_match = class_match[child.Name]
						if name_match then
							table.insert(DecompileIgnore, child)
						end
					end
				end
			end
		end

		ignorePath(service.StarterPlayer:FindFirstChildOfClass("StarterPlayerScripts"))

		local LocalPlayer = service.Players.LocalPlayer
		if LocalPlayer then
			ignorePath(LocalPlayer:FindFirstChildOfClass("PlayerScripts"))
		end
	end

	local InstancesOverrides = setmetatable({}, { __mode = "ks" })

	local DecompileIgnore, IgnoreList, IgnoreProperties, NotCreatableFixes =
		arrayToDict(OPTIONS.DecompileIgnore, true),
		arrayToDict(OPTIONS.IgnoreList, true),
		arrayToDict(OPTIONS.IgnoreProperties),
		arrayToDict(OPTIONS.NotCreatableFixes, true, "Folder")

	local __DEBUG_MODE = OPTIONS.__DEBUG_MODE

	if __DEBUG_MODE and type(__DEBUG_MODE) ~= "function" then
		__DEBUG_MODE = warn
	end

	local LP_UserId, LP_Name, ANON_UserId, ANON_Name, AnonymizableTypes

	do
		local anonymous = OPTIONS.Anonymous
		local lp = service.Players.LocalPlayer

		if anonymous and lp then
			AnonymizableTypes = arrayToDict({ "double", "float", "int", "int64", "string" })
			LP_UserId, LP_Name = lp.UserId, lp.Name

			local istable = type(anonymous) == "table"
			ANON_UserId = istable and anonymous.UserId or 1
			ANON_Name = istable and anonymous.Name or "Roblox"
		end
	end

	local FilePath = OPTIONS.FilePath
	local SaveCacheInterval = OPTIONS.SaveCacheInterval
	local ToSaveInstance = OPTIONS.Object
	local IsModel = OPTIONS.IsModel

	if ToSaveInstance and CustomOptions.IsModel == nil then
		IsModel = true
	end

	local IgnoreDefaultProperties = OPTIONS.IgnoreDefaultProperties
	local IgnoreNotArchivable = not OPTIONS.IgnoreNotArchivable
	local IgnorePropertiesOfNotScriptsOnScriptsMode = OPTIONS.IgnorePropertiesOfNotScriptsOnScriptsMode

	local old_gethiddenproperty
	if OPTIONS and gethiddenproperty then
		old_gethiddenproperty = gethiddenproperty
		gethiddenproperty = nil
	end

	local SaveNotCreatable = OPTIONS.SaveNotCreatable
	local TreatUnionsAsParts = OPTIONS.TreatUnionsAsParts

	local DecompileJobless = OPTIONS.DecompileJobless
	if DecompileJobless then
		OPTIONS.scriptcache = true
	end
	local ScriptCache = OPTIONS.scriptcache and getscriptbytecode

	local IgnoreSharedStrings = OPTIONS.IgnoreSharedStrings
	local SharedStringOverwrite = OPTIONS.SharedStringOverwrite

	local ldeccache = GLOBAL_ENV.USSI_scriptcache

	local DecompileIgnoring, ToSaveList, ldecompile, placename, elapse_t, SaveNotCreatableWillBeEnabled, RecoveredScripts

	if OPTIONS.ReadMe then
		RecoveredScripts = {}
	end

	if ScriptCache and not ldeccache then
		ldeccache = {}
		GLOBAL_ENV.USSI_scriptcache = ldeccache
	end

	if ToSaveInstance == game then
		OPTIONS.mode = "full"
		ToSaveInstance = nil
		IsModel = nil
	end

	local function isLuaSourceContainer(instance)
		return instance:IsA("LuaSourceContainer")
	end

	do
		local mode = string.lower(OPTIONS.mode)
		local tmp = table.clone(OPTIONS.ExtraInstances)

		local PlaceName = game.PlaceId

		pcall(function()
			PlaceName = PlaceName .. " " .. service.MarketplaceService:GetProductInfoAsync(PlaceName).Name
		end)

		local function sanitizeFileName(str)
			return string.sub(string.gsub(string.gsub(string.gsub(str, "[^%w _]", ""), " +", " "), " +$", ""), 1, 240)
		end

		if ToSaveInstance then
			if mode == "optimized" then
				mode = "full"
			end

			for _, key in
				next,
				{
					"IsolateLocalPlayer",
					"IsolateLocalPlayerCharacter",
					"IsolatePlayers",
					"IsolateStarterPlayer",
					"NilInstances",
				}
			do
				if CustomOptions_valid[key] == nil then
					OPTIONS[key] = false
				end
			end
		end

		local filetype = IsModel and ".rbxmx" or ".rbxlx"

		if FilePath then
			local hasExtension = string.match(FilePath, "%.[^/\\]+$") ~= nil
			placename = hasExtension and FilePath or (FilePath .. filetype)
		elseif IsModel then
			placename =
				sanitizeFileName("model " .. PlaceName .. " " .. (ToSaveInstance or tmp[1] or game):GetFullName())
		else
			placename = sanitizeFileName("place " .. PlaceName)
		end

		if FilePath then
		elseif OPTIONS.AvoidFileOverwrite and isfile then
			local counter = 0
			local temp = placename

			while isfile(temp .. filetype) do
				counter = counter + 1
				temp = placename .. "(" .. counter .. ")"
			end

			placename = temp .. filetype
		else
			placename = placename .. filetype
		end

		if GLOBAL_ENV[placename] then
			return
		end

		GLOBAL_ENV[placename] = true
		GLOBAL_ENV.USSI = nil

		if mode ~= "scripts" then
			IgnorePropertiesOfNotScriptsOnScriptsMode = nil
		end

		local TempRoot = ToSaveInstance or game

		if mode == "full" then
			if not ToSaveInstance then
				local Children = TempRoot:GetChildren()
				if 0 < #Children then
					local tmp_dict = arrayToDict(tmp)
					for _, child in next, Children do
						if not tmp_dict[child] then
							table.insert(tmp, child)
						end
					end
				end
			end
		elseif mode == "optimized" then
			local tmp_dict = arrayToDict(tmp)

			for _, serviceName in
				next,
				{
					"Workspace",
					"Players",
					"Lighting",
					"MaterialService",
					"ReplicatedFirst",
					"ReplicatedStorage",

					"ServerScriptService",
					"ServerStorage",

					"StarterGui",
					"StarterPack",
					"StarterPlayer",
					"Teams",
					"SoundService",
					"Chat",
					"TextChatService",

					"LocalizationService",
					"JointsService",

				}
			do
				local _service = game:FindService(serviceName)
				if _service and not tmp_dict[_service] then
					table.insert(tmp, _service)
				end
			end
		elseif mode == "scripts" then
			local unique = {}
			for _, instance in next, TempRoot:GetDescendants() do
				if isLuaSourceContainer(instance) then
					local Parent = instance.Parent
					while Parent and Parent ~= TempRoot do
						instance = instance.Parent
						Parent = instance.Parent
					end
					if Parent then
						unique[instance] = true
					end
				end
			end
			for instance in next, unique do
				table.insert(tmp, instance)
			end
		end

		ToSaveList = tmp

		if ToSaveInstance then
			table.insert(ToSaveList, 1, ToSaveInstance)
		end
	end

	local IsolateLocalPlayer = OPTIONS.IsolateLocalPlayer
	local IsolateLocalPlayerCharacter = OPTIONS.IsolateLocalPlayerCharacter
	local IsolatePlayers = OPTIONS.IsolatePlayers
	local IsolateStarterPlayer = OPTIONS.IsolateStarterPlayer
	local NilInstances = OPTIONS.NilInstances

	if NilInstances and enablenilinstances then
		enablenilinstances()
	end
	local function get_size_format()
		local Size

		for i, unit in
			next,
			{
				"B",
				"KB",
				"MB",
				"GB",
				"TB",
			}
		do
			if totalsize < 0x400 ^ i then
				Size = math.floor(totalsize / (0x400 ^ (i - 1)) * 10) / 10 .. " " .. unit
				break
			end
		end

		return Size
	end

	local RunService = service.RunService
	local function wait_for_render()
		RunService.RenderStepped:Wait()
	end

	local LoadingText, LoadingThread, IsLoading = nil, nil, false

	local function ensureSpinner()
		if LoadingThread then
			return
		end
		LoadingThread = task.spawn(function()
			local chars = { "|", "/", "-", "\\" }
			local i = 0
			while true do
				while not IsLoading do
					task.wait()
				end

				while IsLoading do
					i = i % #chars + 1
					if StatusText and LoadingText then
						StatusText.Text = LoadingText .. " " .. chars[i]
					end
					task.wait(0.25)
				end
			end
		end)
	end

	local function run_with_loading(text, keepStatus, waitForRender, taskFunction, ...)
		local previousStatus
		if StatusText then
			if keepStatus then
				previousStatus = StatusText.Text
			end
			LoadingText = text
			IsLoading = true
			ensureSpinner()
			if waitForRender then
				wait_for_render()
			end
		end

		local result = { taskFunction(...) }

		if StatusText then
			IsLoading = false
			if previousStatus then
				StatusText.Text = previousStatus
			end
		end
		return unpack(result)
	end

	local function makeTimeoutHandler(timeout, f, timeout_return)
		if timeout < 0 then
			return function(...)
				return pcall(f, ...)
			end
		end

		local worker
		local pendingJob

		local function spawnWorker()
			return task.spawn(function()
				while true do
					while not pendingJob do
						task.wait()
					end

					local job = pendingJob
					pendingJob = nil

					local ok, result = pcall(f, unpack(job.args))

					if job.isCancelled then
						return
					end

					task.cancel(job.timeoutThread)

					local thread = job.thread
					while coroutine.status(thread) ~= "suspended" do
						task.wait()
					end

					coroutine.resume(thread, ok, result)
				end
			end)
		end

		return function(...)
			local thread = coroutine.running()
			local job = {
				thread = thread,
				args = { ... },
			}

			job.timeoutThread = task.delay(timeout, function()
				job.isCancelled = true
				worker = nil
				coroutine.resume(thread, nil, timeout_return)
			end)

			if not worker then
				worker = spawnWorker()
			end
			pendingJob = job

			return coroutine.yield()
		end
	end

	local getbytecode
	if getscriptbytecode then
		getbytecode = makeTimeoutHandler(OPTIONS.BytecodeTimeout, getscriptbytecode)
	end

	local SaveBytecode
	if OPTIONS.SaveBytecode and getscriptbytecode then
		SaveBytecode = function(script)
			local s, bytecode = getbytecode(script)

			if s and bytecode and bytecode ~= "" then
				return ""
			end
		end
	end

	do
		if not OPTIONS.Decompile then
			ldecompile = function()
				return ""
			end
		elseif decompile then
			local decomp = makeTimeoutHandler(OPTIONS.DecompileTimeout, decompile, "Decompiler timed out")

			ldecompile = function(script)
				local bytecode
				if ScriptCache then
					local s
					s, bytecode = getbytecode(script)
					local cached

					if s then
						if not bytecode or bytecode == "" then
				return ""
						end
						cached = ldeccache[bytecode]
					else
						bytecode = nil
					end

					if cached then
						if __DEBUG_MODE then
							__DEBUG_MODE("Found in Cache", script:GetFullName())
						end
						return cached
					end
				else
					if DecompileJobless then
						return ""
					end

				end

				local ok, result = run_with_loading("Decompiling " .. script.Name, true, nil, decomp, script)
				if not result then
					ok, result = false, "Empty Output"
				end

				local output
				if ok then
					result = string.gsub(result, "\0", "\\0")
					output = result
				else
					output = ""
				end

				if ScriptCache and bytecode then
					ldeccache[bytecode] = output
					if __DEBUG_MODE then
						__DEBUG_MODE("Cached", script:GetFullName())
					end
				end

				return output
			end
		else
			ldecompile = function()
				return ""
			end
		end
	end

	local function GetLocalPlayer()
		return service.Players.LocalPlayer
			or service.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			or service.Players.LocalPlayer
	end

	local function filterLinkedSource(str)
		local o, r = pcall(service.HttpService.JSONDecode, service.HttpService, str)
		if o and r.errors then
			return
		end
		return true
	end

	local function replaceClassName(instance, InstanceName, ClassName)
		local InstanceOverride
		if InstanceName ~= ClassName then
			InstanceOverride = InstancesOverrides[instance]
			if not InstanceOverride then
				InstanceOverride = { Properties = { Name = "[" .. ClassName .. "] " .. InstanceName } }
				InstancesOverrides[instance] = InstanceOverride
			end
		end
		return InstanceOverride
	end

	local function gsubCaseInsensitive(input, search, replacement)
		local inputLower = string.lower(input)
		search = string.lower(search)

		if not string_find(inputLower, search) then
			return input
		end

		local lastFinish = 0
		local subStrings = {}
		local search_len = #search
		local input_len = #input
		while search_len <= input_len - lastFinish do
			local init = lastFinish + 1

			local start, finish = string_find(inputLower, search, init)

			if start == nil then
				break
			end

			table.insert(subStrings, string.sub(input, init, start - 1))

			lastFinish = finish
		end

		if lastFinish == 0 then
			return input
		end

		table.insert(subStrings, string.sub(input, lastFinish + 1))

		return table.concat(subStrings, replacement)
	end

	local function filterPropVal(result, propertyName, category)
		return result == nil
			or result == "can't get value"
			or type(result) == "string"
				and (category == "Enum" or string_find(result, "Unable to get property " .. propertyName))
	end

	local function ReadProperty(instance, property, propertyName, special, category, optional)
		local raw = __BREAK

		local InstanceOverride = InstancesOverrides[instance]
		if InstanceOverride then
			local PropertiesOverride = InstanceOverride.Properties
			if PropertiesOverride then
				local PropertyOverride = PropertiesOverride[propertyName]
				if PropertyOverride ~= nil then
					return PropertyOverride
				end
			end
		end

		local CanRead = property.CanRead

		if CanRead == false then
			return __BREAK
		end

		if special then
			if gethiddenproperty then
				local ok, result = pcall(gethiddenproperty, instance, propertyName)

				if ok then
					raw = result
				end

				if filterPropVal(raw, propertyName, category) then
					if result ~= nil or not optional then
						if __DEBUG_MODE then
							__DEBUG_MODE("Filtered", propertyName)
						end
						property.CanRead = false
					end

					return __BREAK
				end
			end
		else
			if CanRead then
				raw = instance[propertyName]
			else
				local ok, result = pcall(index, instance, propertyName)

				if ok then
					raw = result
				elseif gethiddenproperty then
					ok, result = pcall(gethiddenproperty, instance, propertyName)

					if ok then
						raw = result

						property.Special = true
					end
				end

				property.CanRead = ok

				if not ok or filterPropVal(raw, propertyName, category) then
					return __BREAK
				end
			end
		end

		return raw
	end

	local function ReturnItem(className, instance)
		return '<Item class="' .. className .. '" referent="' .. getRef(instance) .. '"><Properties>'
	end

	local function ReturnProperty(tag, propertyName, value)
		return "<" .. tag .. ' name="' .. propertyName .. '">' .. value .. "</" .. tag .. ">"
	end

	local function ReturnValueAndTag(raw, valueType, encoder)
		local value, tag = (encoder or XML_Encoders[valueType])(raw)

		return value, tag or valueType
	end

	local function InheritsFix(fixes, className, instance)
		local Fix = fixes[className]
		if Fix then
			return Fix
		elseif Fix == nil then
			for class_name, fix in next, fixes do
				if instance:IsA(class_name) then
					return fix
				end
			end
		end
	end

	local function GetInheritedProps(className)
		local cached = inheritedProperties[className]
		if cached then
			return cached
		end

		local prop_list = {}
		local layer = ClassList[className]
		while layer do
			local layer_props = layer.Properties
			table.move(layer_props, 1, #layer_props, #prop_list + 1, prop_list)

			layer = ClassList[layer.Superclass]
		end
		inheritedProperties[className] = prop_list
		return prop_list
	end

	local function save_cache()
		local savestr = table.concat(savebuffer)

		local savestr_len = #savestr
		totalsize = totalsize + savestr_len

	table.insert(chunks, savestr)

		table.clear(savebuffer)
		savebuffer_size = 1

		if StatusText then
			StatusText.Text = "Saving.. Size: " .. get_size_format()
		end

		wait_for_render()
	end

	local function save_specific(className, properties)
		local Ref = Instance.new(className)
		local Item = ReturnItem(Ref.ClassName, Ref)

		for propertyName, val in next, properties do
			local whitelisted, value, tag

			if propertyName == "Source" then
				tag = "ProtectedString"
				value = XML_Encoders._protectedString(val)
				whitelisted = true
			elseif propertyName == "Name" then
				whitelisted = true
				value, tag = ReturnValueAndTag(val, "string")
			end

			if whitelisted then
				Item = Item .. ReturnProperty(tag, propertyName, value)
			end
		end
		Item = Item .. "</Properties>"
		return Item
	end

	local function save_hierarchy(hierarchy)
		for _, instance in next, hierarchy do
			local __DARKLUA_CONTINUE_87 = false
			repeat
				local InstanceOverride, ClassTagOverride, ClassNameOverride

				if not InstanceOverride then
					InstanceOverride = InstancesOverrides[instance]
					if InstanceOverride then
						ClassTagOverride = InstanceOverride.__ClassName
					end
				end
				local ClassName = instance.ClassName

				local InstanceName = instance.Name
				local SkipEntirely

				if not ClassTagOverride then
					if IgnoreNotArchivable and not instance.Archivable then
						__DARKLUA_CONTINUE_87 = true
						break
					end

					SkipEntirely = IgnoreList[instance]
					if SkipEntirely then
						__DARKLUA_CONTINUE_87 = true
						break
					end

					do
						local OnIgnoredList = IgnoreList[ClassName]
						if OnIgnoredList and (OnIgnoredList == true or OnIgnoredList[InstanceName]) then
							__DARKLUA_CONTINUE_87 = true
							break
						end
					end

					if not DecompileIgnoring then
						DecompileIgnoring = DecompileIgnore[instance]

						if DecompileIgnoring == nil then
							local DecompileIgnored = DecompileIgnore[ClassName]
							if DecompileIgnored then
								DecompileIgnoring = DecompileIgnored == true or DecompileIgnored[InstanceName]
							end
						end

						if DecompileIgnoring then
							DecompileIgnoring = instance
						elseif DecompileIgnoring == false then
							DecompileIgnoring = 1
						end
					end

					do
						local Fix = NotCreatableFixes[ClassName]

						if Fix then
							if SaveNotCreatable then
								ClassName, InstanceOverride = Fix, replaceClassName(instance, InstanceName, ClassName)
							else
								__DARKLUA_CONTINUE_87 = true
								break
							end
						else
							if TreatUnionsAsParts and instance:IsA("PartOperation") then
								ClassName, InstanceOverride =
									"Part", replaceClassName(instance, InstanceName, ClassName)
								ClassNameOverride = "BasePart"
							elseif not ClassList[ClassName] then
								if __DEBUG_MODE then
									__DEBUG_MODE("Class not Found", ClassName)
								end

								ClassTagOverride = ClassName
								ClassName = "Folder"
							end
						end
					end
				end
				if InstanceOverride and InstanceOverride.__SaveSpecific then
					savebuffer[savebuffer_size] = save_specific(ClassName, InstanceOverride.Properties)
					savebuffer_size = savebuffer_size + 1
				else
					savebuffer[savebuffer_size] = ReturnItem(ClassTagOverride or ClassName, instance)
					savebuffer_size = savebuffer_size + 1
					if not (IgnorePropertiesOfNotScriptsOnScriptsMode and not isLuaSourceContainer(instance)) then
						local default_instance, new_def_inst

						if IgnoreDefaultProperties then
							default_instance = defaultInstances[ClassName]
							if not default_instance then
								local Class = ClassList[ClassName]
								if not Class.NotCreatable then
									local ok, result = pcall(Instance.new, ClassName)

									if ok then
										new_def_inst = result

										default_instance = {}

										defaultInstances[ClassName] = default_instance
									else
										Class.NotCreatable = true
										if __DEBUG_MODE then
											__DEBUG_MODE("Failed to create default Instance", ClassName, result)
										end
									end
								elseif __DEBUG_MODE then
									__DEBUG_MODE("Unable to create default Instance (NotCreatable)", ClassName)
								end
							end
						end

						for _, Property in next, GetInheritedProps(ClassNameOverride or ClassName) do
							local __DARKLUA_CONTINUE_88 = false
							repeat
								local PropertyName = Property.Name

								if IgnoreProperties[PropertyName] then
									__DARKLUA_CONTINUE_88 = true
									break
								end

								local ValueType = Property.ValueType

								if IgnoreSharedStrings and ValueType == "SharedString" then
									__DARKLUA_CONTINUE_88 = true
									break
								end

								local Special, Category, Optional =
									Property.Special, Property.Category, Property.Optional
								local raw
								if
									not (
										ValueType == "ProtectedString"
										and PropertyName == "Source"
										and isLuaSourceContainer(instance)
									)
								then
									raw = ReadProperty(instance, Property, PropertyName, Special, Category, Optional)

									if raw == __BREAK then
										local GHPFFailed, Fallback = Property.GHPFFailed, Property.Fallback
										if GHPFFailed and not Fallback then
											__DARKLUA_CONTINUE_88 = true
											break
										end

										if not GHPFFailed then
											local ok, result = pcall(gethiddenproperty_fallback, instance, PropertyName)
											if result == nil and not Optional then
												ok = nil
											end

											if ok then
												raw = result
											else
												GHPFFailed = true
												Property.GHPFFailed = GHPFFailed
											end
										end

										if GHPFFailed and Fallback then
											local ok, result = pcall(Fallback, instance)

											if ok then
												raw = result
											else
												Property.Fallback = nil
												if __DEBUG_MODE then
													__DEBUG_MODE("Fix Failed", PropertyName, result)
												end
												__DARKLUA_CONTINUE_88 = true
												break
											end
										end

										if raw == __BREAK then
											__DARKLUA_CONTINUE_88 = true
											break
										end
									end

									if
										default_instance
										and Property.CanRead
										and not Property.Special
									then
										if new_def_inst then
											default_instance[PropertyName] = index(new_def_inst, PropertyName)
										end
										if default_instance[PropertyName] == raw then
											__DARKLUA_CONTINUE_88 = true
											break
										end
									end

								end
								if SharedStringOverwrite and ValueType == "BinaryString" then
									ValueType = "SharedString"
								end

								if AnonymizableTypes and AnonymizableTypes[ValueType] then
									if ValueType == "string" then
										raw = gsubCaseInsensitive(raw, LP_Name, ANON_Name)
									elseif raw == LP_UserId then
										raw = ANON_UserId
									end
								end

								local tag, value
								if Category == "Class" then
									tag = "Ref"
									if raw then
										if SaveNotCreatableWillBeEnabled then
											local Fix = NotCreatableFixes[raw.ClassName]
											if
												Fix
												and (
													PropertyName == "PlayerToHideFrom"
													or ValueType ~= "Instance" and ValueType ~= Fix
												)
											then
												__DARKLUA_CONTINUE_88 = true
												break
											end
										end

										value = getRef(raw)
									else
										value = "null"
									end
								elseif Category == "Enum" then
									value, tag = XML_Encoders.EnumItem(raw)
								else
									local encoder = XML_Encoders[ValueType]

									if encoder then
										value, tag = ReturnValueAndTag(raw, ValueType, encoder)
									elseif ValueType == "ProtectedString" then
										tag = ValueType

										if PropertyName == "Source" then
											if DecompileIgnoring then
												if DecompileIgnoring == 1 then
													DecompileIgnoring = nil
												end
												value = ""
											else
												local should_decompile = true
												local LinkedSource
												local o, LinkedSource_Url = pcall(index, instance, "LinkedSource")
												if not o then
													LinkedSource_Url = ""
												end
												local hasLinkedSource = LinkedSource_Url ~= ""
												local LinkedSource_type
												if hasLinkedSource then
													local Path = instance:GetFullName()
													if RecoveredScripts then
														table.insert(RecoveredScripts, Path)
													end

													LinkedSource = string.match(LinkedSource_Url, "%w+$")
													if LinkedSource then
														if ScriptCache then
															local cached = ldeccache[LinkedSource]

															if cached then
																value = cached
																should_decompile = nil
															end
														end
														if should_decompile then
															if DecompileJobless then
																value = ""
																should_decompile = nil
															end

															LinkedSource_type = string.find(LinkedSource, "%a")
																	and "hash"
																or "id"

															local asset = LinkedSource_type .. "=" .. LinkedSource

															local ok, source = pcall(function()
																return game:HttpGet(
																	"https://assetdelivery.roproxy.com/v1/asset/?"
																		.. asset
																)
															end)

															if ok and filterLinkedSource(source) then
																if ScriptCache then
																	ldeccache[LinkedSource] = source
																end

																value = source

																should_decompile = nil
															end
														end
													else
														warn(
															"FAILED TO EXTRACT ORIGINAL SCRIPT SOURCE (OPEN A GITHUB ISSUE): ",
															instance:GetFullName(),
															LinkedSource_Url
														)
													end
												end

												if should_decompile then
													local isLocalScript = instance:IsA("LocalScript")
													if
														isLocalScript
															and instance.RunContext == Enum.RunContext.Server
														or not isLocalScript
															and instance:IsA("Script")
															and instance.RunContext ~= Enum.RunContext.Client
													then
														value =
															""
													else
														value = ldecompile(instance)
														if SaveBytecode then
															local output = SaveBytecode(instance)
															if output then
																value = output .. value
															end
														end
													end
												end

value = "-- Decompiled By KkSaiko\n"
    .. "-- ██╗  ██╗██╗  ██╗███████╗ █████╗ ██╗██╗  ██╗ ██████╗     ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗██╗     ███████╗██████╗ \n"
    .. "-- ██║ ██╔╝██║ ██╔╝██╔════╝██╔══██╗██║██║ ██╔╝██╔═══██╗    ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║██║     ██╔════╝██╔══██╗\n"
    .. "-- █████╔╝ █████╔╝ ███████╗███████║██║█████╔╝ ██║   ██║    ██║  ██║█████╗  ██║     ██║   ██║██╔████╔██║██████╔╝██║██║     █████╗  ██████╔╝\n"
    .. "-- ██╔═██╗ ██╔═██╗ ╚════██║██╔══██║██║██╔═██╗ ██║   ██║    ██║  ██║██╔══╝  ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║██║     ██╔══╝  ██╔══██╗\n"
    .. "-- ██║  ██╗██║  ██╗███████║██║  ██║██║██║  ██╗╚██████╔╝    ██████╔╝███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ██║███████╗███████╗██║  ██║\n"
    .. "-- ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝\n"
    .. (hasLinkedSource and "" or "")
    .. value
											end
										end
										value = XML_Encoders._protectedString(value)
									else
										if Optional then
											encoder = XML_Encoders[Optional]

											if encoder then
												if raw == nil then
													__DARKLUA_CONTINUE_88 = true
													break
												else
													value, tag = ReturnValueAndTag(raw, ValueType, encoder)
												end
											end
										end
									end
								end

								if tag then
									savebuffer[savebuffer_size] = ReturnProperty(tag, PropertyName, value)
									savebuffer_size = savebuffer_size + 1
								else
									warn("UNSUPPORTED TYPE (OPEN A GITHUB ISSUE): ", ValueType, ClassName, PropertyName)
								end
								__DARKLUA_CONTINUE_88 = true
							until true
							if not __DARKLUA_CONTINUE_88 then
								break
							end
						end
					end
					savebuffer[savebuffer_size] = "</Properties>"
					savebuffer_size = savebuffer_size + 1

					if SaveCacheInterval < savebuffer_size then
						save_cache()
					end
				end

				if SkipEntirely ~= false then
					local Children = InstanceOverride and InstanceOverride.__Children or instance:GetChildren()

					if #Children ~= 0 then
						save_hierarchy(Children)
					end
				end

				if DecompileIgnoring and DecompileIgnoring == instance then
					DecompileIgnoring = nil
				end

				savebuffer[savebuffer_size] = "</Item>"
				savebuffer_size = savebuffer_size + 1
				__DARKLUA_CONTINUE_87 = true
			until true
			if not __DARKLUA_CONTINUE_87 then
				break
			end
		end
	end

	local function save_extra(name, instanceOrTable, saveProps, customClassName, source)
		if not customClassName then
			customClassName = "Folder"
		end

		local properties = { Name = name, Source = source }
		local hierarchy

		if instanceOrTable then
			if type(instanceOrTable) == "table" then
				hierarchy = instanceOrTable
			else
				hierarchy = instanceOrTable:GetChildren()
				if saveProps then
					InstancesOverrides[instanceOrTable] = {
						__ClassName = customClassName,
						Properties = properties,
					}

					save_hierarchy({ instanceOrTable })
				end
			end
		end

		if not saveProps then
			savebuffer[savebuffer_size] = save_specific(customClassName, properties)
			savebuffer_size = savebuffer_size + 1
			if hierarchy then
				save_hierarchy(hierarchy)
			end
			savebuffer[savebuffer_size] = "</Item>"
			savebuffer_size = savebuffer_size + 1
		end
	end

	local function save_game()
		do
			if IsModel then
				header = header .. '<Meta name="ExplicitAutoJoints">true</Meta>'
			end
			if writefile and not OPTIONS.Callback then
				writefile(placename, header)
			end
		end

		SaveNotCreatableWillBeEnabled = SaveNotCreatable
			or (IsolateLocalPlayer or IsolateLocalPlayerCharacter) and IsolateLocalPlayer
			or IsolatePlayers
			or NilInstances and global_container.getnilinstances

		save_hierarchy(ToSaveList)

		if IsolateLocalPlayer or IsolateLocalPlayerCharacter then
			local LocalPlayer = service.Players.LocalPlayer
			if LocalPlayer then
				if IsolateLocalPlayer then
					SaveNotCreatable = true
					save_extra("LocalPlayer", LocalPlayer, true)
				end
				if IsolateLocalPlayerCharacter then
					local LocalPlayerCharacter = LocalPlayer.Character
					if LocalPlayerCharacter then
						save_extra("LocalPlayer Character", LocalPlayerCharacter, true, "Model")
					end
				end
			end
		end

		if IsolateStarterPlayer then
			save_extra("StarterPlayer", service.StarterPlayer)
		end

		if IsolatePlayers then
			SaveNotCreatable = true
			save_extra("Players", service.Players)
		end

		if NilInstances and global_container.getnilinstances then
			local nil_instances, nil_instances_size = {}, 1

			local NilInstancesFixes = OPTIONS.NilInstancesFixes

			for _, instance in next, global_container.getnilinstances() do
				if instance == game then
					instance = nil
				else
					local ClassName = instance.ClassName

					local Fix = InheritsFix(NilInstancesFixes, ClassName, instance)

					if Fix then
						instance = Fix(instance, InstancesOverrides)
					end

					local Class = ClassList[ClassName]
					if Class then
						if Class.Service then
							instance = nil
						end
					end
				end
				if instance then
					nil_instances[nil_instances_size] = instance
					nil_instances_size = nil_instances_size + 1
				end
			end
			SaveNotCreatable = true
		save_extra("Nil Instances", nil_instances)
	end

	do
		local tmp = { "<SharedStrings>" }
			for value, id in next, sharedStrings do
				table.insert(tmp, '<SharedString md5="' .. id .. '">' .. value .. "</SharedString>")
			end

			if 1 < #tmp then
				savebuffer[savebuffer_size] = table.concat(tmp)
				savebuffer_size = savebuffer_size + 1
				savebuffer[savebuffer_size] = "</SharedStrings>"
				savebuffer_size = savebuffer_size + 1
			end
		end

		savebuffer[savebuffer_size] =
			"</roblox><!-- Decompiled By KkSaiko -->"
		savebuffer_size = savebuffer_size + 1
		save_cache()
		do
			local function buildFinalString(chunks)
				local parts = table.create(#chunks + 1)
				parts[1] = header

				table.move(chunks, 1, #chunks, 2, parts)

				return table.concat(parts)
			end

			local Callback = OPTIONS.Callback
			if Callback then
				Callback(buildFinalString(chunks), chunks)
			elseif OPTIONS.AlternativeWritefile and appendfile then
				local SEGMENT_SIZE = 4145728
				local totallen = 0
				for _, chunk in next, chunks do
					totallen = totallen + math.ceil(#chunk / SEGMENT_SIZE)
				end

				local currentlen = 0

				for _, chunk in next, chunks do
					local chunk_len = #chunk
					local offset = 1

					while offset <= chunk_len do
						local savestr = string.sub(chunk, offset, offset + SEGMENT_SIZE - 1)

						run_with_loading(
							"Writing to File " .. math.round(currentlen / totallen * 100) .. "% (Depends on Exec)",
							nil,
							true,
							appendfile,
							placename,
							savestr
						)

						currentlen = currentlen + 1
						offset = offset + SEGMENT_SIZE

						if offset <= chunk_len then
							task.wait()
						end
					end
				end
			else
				run_with_loading(
					"Writing " .. get_size_format() .. " to File (Depends on Exec)",
					nil,
					true,
					writefile,
					placename,
					buildFinalString(chunks)
				)
			end
		end
	end

	local Connections = {}
	local function Connect(event, func)
		table.insert(Connections, event:Connect(func))
	end
	local function Cleanup()
		for _, connection in next, Connections do
			connection:Disconnect()
		end
		GLOBAL_ENV[placename] = nil
	end
	do
		local Players = service.Players

		if IgnoreList.Model ~= true then
			local function ignoreCharacter(player)
				Connect(player.CharacterAdded, function(character)
					IgnoreList[character] = true
				end)

				local Character = player.Character
				if Character then
					IgnoreList[Character] = true
				end
			end

			if not OPTIONS.SavePlayerCharacters then
				Connect(Players.PlayerAdded, function(player)
					ignoreCharacter(player)
				end)

				for _, player in next, Players:GetPlayers() do
					ignoreCharacter(player)
				end
			else
				IgnoreNotArchivable = false
				if IsolateLocalPlayerCharacter then
					task.spawn(function()
						ignoreCharacter(GetLocalPlayer())
					end)
				end
			end
		end
		if IsolateLocalPlayer and IgnoreList.Player ~= true then
			task.spawn(function()
				IgnoreList[GetLocalPlayer()] = true
			end)
		end
	end

	if OPTIONS.KillAllScripts and not GLOBAL_ENV.USSI_KAS then
		GLOBAL_ENV.USSI_KAS = true
		game:GetService("ScriptContext"):SetTimeout(math.clamp(SaveCacheInterval * 0.000047, 20, 30))

		local self = coroutine.running()
		do
			local islclosure = islclosure
			local isexecutorclosure = isexecutorclosure or checkclosure or isourclosure
			local hookfunction = EXECUTOR_NAME ~= "Volt" and hookfunction

			local done = {}
			local function filterNkill(f)
				if not f then
					return
				end

				for _, v in next, table.clone(f()) do
					if not done[v] then
						done[v] = true

						local _type = type(v)
						if _type == "thread" then
							if v ~= self then
								pcall(coroutine.close, v)
							end
						elseif _type == "function" then
							if
								(not islclosure or islclosure(v))
								and (not isexecutorclosure or not isexecutorclosure(v))
							then
								if hookfunction then
									pcall(hookfunction, v, coroutine.yield)
								end
							end
						end
					end
				end
			end

			filterNkill(debug and debug.getregistry or getreg or getregistry)
			filterNkill(getallthreads)
			filterNkill(getgc)
		end
	end

	if IsolateStarterPlayer then
		IgnoreList.StarterPlayer = false
	end

	if IsolatePlayers then
		IgnoreList.Players = false
	end

	if OPTIONS.ShowStatus then
		do
			local Exists = GLOBAL_ENV.USSI_statustext
			if Exists then
				Exists:Destroy()
			end
		end

		local StatusGui = Instance.new("ScreenGui")

		GLOBAL_ENV.USSI_statustext = StatusGui

		StatusGui.DisplayOrder = 2e9
		pcall(function()
			StatusGui.OnTopOfCoreBlur = true
		end)

		StatusText = Instance.new("TextLabel")

		StatusText.Text = "Saving..."

		StatusText.BackgroundTransparency = 1
		StatusText.Font = Enum.Font.Code
		StatusText.AnchorPoint = Vector2.new(1)
		StatusText.Position = UDim2.new(1)
		StatusText.Size = UDim2.new(0.3, 0, 0, 20)

		StatusText.TextColor3 = Color3.new(1, 1, 1)
		StatusText.TextScaled = true
		StatusText.TextStrokeTransparency = 0.7
		StatusText.TextXAlignment = Enum.TextXAlignment.Right
		StatusText.TextYAlignment = Enum.TextYAlignment.Top

		StatusText.Parent = StatusGui

		local function randomString()
			local length = math.random(10, 20)
			local randomarray = table.create(length)
			for i = 1, length do
				randomarray[i] = string.char(math.random(32, 126))
			end
			return table.concat(randomarray)
		end

		if global_container.gethui then
			StatusGui.Name = randomString()
			StatusGui.Parent = global_container.gethui()
		else
			if global_container.protectgui then
				StatusGui.Name = randomString()
				global_container.protectgui(StatusGui)
				StatusGui.Parent = game:GetService("CoreGui")
			else
				local RobloxGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
				if RobloxGui then
					StatusGui.Parent = RobloxGui
				else
					StatusGui.Name = randomString()
					StatusGui.Parent = game:GetService("CoreGui")
				end
			end
		end
	end

	do
		if OPTIONS.SafeMode then
			local LocalPlayer = GetLocalPlayer()

			local PlayerScripts = LocalPlayer:FindFirstChildOfClass("PlayerScripts")
			if PlayerScripts then
				local function makeInstanceOverride(instance)
					local children = instance:GetChildren()
					InstancesOverrides[instance] = {
						__Children = children,
					}
					for _, child in next, children do
						makeInstanceOverride(child)
					end
				end
				makeInstanceOverride(PlayerScripts)

				InstancesOverrides[LocalPlayer] = {
					__Children = LocalPlayer:GetChildren(),
					Properties = { Name = "[" .. LocalPlayer.ClassName .. "] " .. LocalPlayer.Name },
				}
			end

			if CustomOptions_valid["BoostFPS"] == nil then
				OPTIONS.BoostFPS = true
			end
		end

		if OPTIONS.BoostFPS then
			pcall(function()
				service.RunService:Set3dRenderingEnabled(false)
			end)
		end

		if OPTIONS.AntiIdle then
			local Idled = GetLocalPlayer().Idled
			Connect(Idled, function()
				service.VirtualInputManager:SendMouseWheelEvent(
					service.UserInputService:GetMouseLocation().X,
					service.UserInputService:GetMouseLocation().Y,
					true,
					game
				)
			end)
		end

		if not ClassList then
			do
				local UGCValidationService

				gethiddenproperty_fallback = function(instance, propertyName)
					if not UGCValidationService then
						UGCValidationService = service.UGCValidationService
					end
					return UGCValidationService:GetPropertyValue(instance, propertyName)
				end
				if gethiddenproperty then
					local o, r = pcall(gethiddenproperty, workspace, "StreamOutBehavior")
					if not o or r ~= nil and typeof(r) ~= "EnumItem" then
						gethiddenproperty = nil
					else
						o, r =
							pcall(gethiddenproperty, Instance.new("AnimationRigData", Instance.new("Folder")), "parent")

						if o and r ~= nil and type(r) ~= "string" then
							gethiddenproperty = nil
						end
					end
				end
				local function benchmark(funcs, ...)
					local ranking = table.create(2)
					for i, f in next, funcs do
						local start = os.clock()
						for _ = 1, 50 do
							f(...)
						end
						ranking[i] = { t = os.clock() - start, f = f }
					end
					table.sort(ranking, function(a, b)
						return a.t < b.t
					end)
					return ranking[1].f
				end

				local test_str = string.rep("\1\0\0\0\1\2\3\4\5\6\7", 50)

				do
					if
						not bit32.byteswap
						or not (function()
							local o, r = pcall(bit32.byteswap, 2712847316)
							if not o then
								return
							end
							return r == 3569595041
						end)()
					then
						local b32 = table.clone(bit32)

						b32.byteswap = function(n)
							return bit32.bor(
								bit32.lshift(n, 24),
								bit32.band(bit32.lshift(n, 8), 0xFF0000),
								bit32.band(bit32.rshift(n, 8), 0xFF00),
								bit32.rshift(n, 24)
							)
						end
						if table.isfrozen(bit32) then
							b32 = table.freeze(b32)
						end
						GLOBAL_ENV.bit32 = b32
					end

					local rbxcrypt_base64encode
					pcall(function()
						local b64_enc_buf = loadstring(
							game:HttpGet(
								"https://raw.githubusercontent.com/daily3014/rbx-cryptography/refs/heads/main/src/Utilities/Base64.luau",
								true
							),
							"Base64"
						)().Encode
						rbxcrypt_base64encode = function(raw)
							return buffer.tostring(b64_enc_buf(buffer.fromstring(raw)))
						end
					end)

					local EncodingService = game:GetService("EncodingService")
					local EncodingService_base64encode = function(raw)
						return buffer.tostring(EncodingService:Base64Encode(buffer.fromstring(raw)))
					end

					if base64encode and base64encode("\1\0\0\0\1") == "AQAAAAE=" then
						if rbxcrypt_base64encode then
							base64encode = benchmark(
								{ base64encode, rbxcrypt_base64encode, EncodingService_base64encode },
								test_str
							)
						end
					else
						base64encode = rbxcrypt_base64encode
					end

					if not base64encode then
						warn("base64encode not found")
						Cleanup()
						return
					end
				end
			end
			do
				local ok, result = pcall(FetchAPI)
				if ok then
					ClassList = result
				else
					warn("Failed to load the API Dump")
					warn(result)
					Cleanup()
					return
				end
			end
		end

		elapse_t = os.clock()

		local ok, err = xpcall(save_game, function(err)
			return debug.traceback(err)
		end)

		if OPTIONS.BoostFPS then
			pcall(function()
				local max = 5
				task.delay(
					math.clamp(max - (os.clock() - elapse_t), 0, max),
					service.GuiService.ClearError,
					service.GuiService
				)
				service.RunService:Set3dRenderingEnabled(true)
			end)
		end

		if old_gethiddenproperty then
			gethiddenproperty = old_gethiddenproperty
		end

		Cleanup()

		elapse_t = os.clock() - elapse_t
		local Log10 = math.log10(elapse_t)
		local ExtraTime = 10

		if StatusText then
			task.spawn(function()
				if ok then
					StatusText.Text = string.format("Saved! Time %.3f seconds; Size %s", elapse_t, get_size_format())
					StatusText.TextColor3 = Color3.new(0, 1)
					task.wait(Log10 * 2 + ExtraTime)
				else
					if LoadingThread then
						task.cancel(LoadingThread)
						LoadingThread = nil
					end
					StatusText.Text = "Failed! Check F9 console for more info"
					StatusText.TextColor3 = Color3.new(1)
					warn("Error found while saving:")
					warn(err)
					task.wait(Log10 + ExtraTime)
				end
				StatusText:Destroy()
			end)
		end

		if OPTIONS.ShutdownWhenDone and ok then
			task.wait(Log10 * 2 + ExtraTime)
			game:Shutdown()
		end
	end
end

return synsaveinstance
