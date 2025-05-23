server = nil
service = nil
Routine = nil
GetEnv = nil
origEnv = nil
logError = nil

--// Special Variables
return function(Vargs, GetEnv)
	local env = GetEnv(nil, {script = script})
	setfenv(1, env)

	local server = Vargs.Server
	local service = Vargs.Service

	local Functions, Admin, Anti, Core, HTTP, Logs, Remote, Process, Variables, Settings
	local function Init()
		Functions = server.Functions
		Admin = server.Admin
		Anti = server.Anti
		Core = server.Core
		HTTP = server.HTTP
		Logs = server.Logs
		Remote = server.Remote
		Process = server.Process
		Variables = server.Variables
		Settings = server.Settings

		Variables.BanMessage = Settings.BanMessage
		Variables.LockMessage = Settings.LockMessage
		Variables.SizeLimit = Settings.SizeLimit or Variables.SizeLimit
		Variables.ChatCreateRobloxCommands = Settings.ChatCreateRobloxCommands == nil and Variables.ChatCreateRobloxCommands or Settings.ChatCreateRobloxCommands
		Variables.DisableRejoinAtMaxPlayers = Settings.DisableRejoinAtMaxPlayers or Variables.DisableRejoinAtMaxPlayers

		for _, v in Settings.Cameras or {} do
			local cam = service.New("Part", {
				Parent = workspace;
				Name = `Camera: {v.Name}`;
				Position = v.Position;
				Anchored = true;
				CanCollide = false;
				Locked = true;
				Size = Vector3.new(1, 1, 1);
				Transparency = 1;
			})

			table.insert(Variables.Cameras, {Brick = cam, Name = v.Name})
		end

		for _, v in Settings.MusicList or {} do table.insert(Variables.MusicList, v) end
		for _, v in Settings.InsertList or {} do table.insert(Variables.InsertList, v) end
		for _, v in Settings.CapeList or {} do table.insert(Variables.Capes, v) end
		for k, v in Settings.Aliases or {} do Variables.Aliases[k] = v end
		for k, v in Settings.Waypoints or {} do Variables.Waypoints[k] = v end

		Variables.Init = nil
		Logs:AddLog("Script", "Variables Module Initialized")
	end

	local function AfterInit(data)
		Variables.RunAfterInit = nil
		Logs:AddLog("Script", "Finished Variables AfterInit")
	end

	local Lighting = service.Lighting
	local atmosphere = Lighting:FindFirstChildWhichIsA("Atmosphere")

	server.Variables = {
		Init = Init,
		RunAfterInit = AfterInit,
		ZaWarudo = false,
		CodeName = service.HttpService:GenerateGUID(false),
		IsStudio = service.RunService:IsStudio(), -- Used to check if Adonis is running inside Roblox Studio as things like TeleportService and DataStores (if API Access is disabled) do not work in Studio
		AuthorizedToReply = {},
		FrozenObjects = {},
		ScriptBuilder = {},
		ScriptEditor = {},
		CachedDonors = {},
		Aliases = {},
		ReturnPoints = {},
		BanMessage = "Banned",
		PlayerJoinFilters = {};
		LockMessage = "Not Whitelisted",
		DonorPass = {1348327, 1990427, 1911740, 167686, 98593, "6878510605", 5212082, 5212081}, --// Strings are items; numbers are gamepasses
		WebPanel_Initiated = false,
		DeveloperWhitelist = {1237666, 76328606, 698712377},
		HTTPCheckUrl = "https://www.google.com/humans.txt",
		IPInfoUrl = "https://ipinfo.io/json",
		SizeLimit = 20,
		ChatCreateRobloxCommands = true,
		OriginalGravity = workspace.Gravity,
		DisableRejoinAtMaxPlayers = false,
		DexNames = {"Dex_Explorer", "Dex_Client", "Dex_Intro", "Dex_MainMenu", "Dex_ExplorerSelections", "Dex_Context", "Dex_Window", "Dex_SidesGui", "Dex_BrickColor", "Dex_AboutWindow", "Dex_SettingsWindow"},
		AnimatedFaces = {
			-- R15 (Hopefully)
			14719428401, 12936561806, 12936887700, 12937016609, 12937135097, 12939014597, 12945364777, 12945456452, 14374800823, 14367118483, 13674780763,
			13675154281, 13675471354, 14637766494, 14695685417, 13675435245, 14638202807, 13684039612, 13684329978, 13684434516, 13684479531, 13691523700,
			14769032055, 13691867290, 13692882504, 13702714010, 14182901840, 14719365169, 14754580931, 14478188128, 14755068153, 14760215320, 14524485191,
			14525129330, 13001896404, 14719225657, 14640105786, 13820802344, 14638466361, 13821294344, 14840473015, 13822584343, 14701679873, 13822985393,
			13823226706, 14719266373, 14192299483, 14192630651, 14192804513, 14192863652, 14192993380, 14193224583, 14205130925, 14205179825, 13020957350,
			13021695400, 12995139274, 12733096025, 12732440273, 14377306239, 12859102530, 14521518488, 14918993907, 14401304993, 12860895688, 10704977958,
			14380344401, 14366112499, 10725526074, 11402532474, 10725092133, 11445572546, 14192828782, 13702851678, 12929417417, 13675436366, 14755069931,
			14374802942, 14638203853, 12939016971, 11564337259, 13691524922, 14719366846, 12945457988, 14760102190, 13675155984, 14367119766, 14205146154,
			14377320953, 14193020364, 11116786674, 13822986276, 14638467750, 10998132528, 13675472848, 14182904315, 12936914000, 12936596034, 14524488089,
			14478215763, 13684480556, 13822585823, 14754581557, 14401306473, 11821976793, 14193703522, 14760226358,
			-- R6
			14366393007, 18446596298,
			-- R15 custom UGC heads are not supported currently! (And probably never will be lol)
			-- If there are any heads with baked in faces made by Roblox that are not here tell Adonis maintainers immediatly!
		},

		LightingSettings = {
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
			Brightness = Lighting.Brightness,
			TimeOfDay = Lighting.TimeOfDay,
			FogColor = Lighting.FogColor,
			FogEnd = Lighting.FogEnd,
			FogStart = Lighting.FogStart,
			GlobalShadows = Lighting.GlobalShadows,
			Outlines = Lighting.Outlines,
			ShadowColor = Lighting.ShadowColor,
			ColorShift_Bottom = Lighting.ColorShift_Bottom,
			ColorShift_Top = Lighting.ColorShift_Top,
			GeographicLatitude = Lighting.GeographicLatitude,
			Name = Lighting.Name,
		},

		OriginalLightingSettings = {
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
			Brightness = Lighting.Brightness,
			TimeOfDay = Lighting.TimeOfDay,
			FogColor = Lighting.FogColor,
			FogEnd = Lighting.FogEnd,
			FogStart = Lighting.FogStart,
			GlobalShadows = Lighting.GlobalShadows,
			Outlines = Lighting.Outlines,
			ShadowColor = Lighting.ShadowColor,
			ColorShift_Bottom = Lighting.ColorShift_Bottom,
			ColorShift_Top = Lighting.ColorShift_Top,
			GeographicLatitude = Lighting.GeographicLatitude,
			Name = Lighting.Name,
			Sky = Lighting:FindFirstChildOfClass("Sky") and Lighting:FindFirstChildOfClass("Sky"):Clone(),
		},

		AtmosphereSettings = {
			Name = atmosphere and atmosphere.Name,
			Density = atmosphere and atmosphere.Density,
			Offset = atmosphere and atmosphere.Offset,
			Color = atmosphere and atmosphere.Color,
			Decay = atmosphere and atmosphere.Decay,
			Glare = atmosphere and atmosphere.Glare,
			Haze = atmosphere and atmosphere.Haze,
		},

		OriginalAtmosphereSettings = {
			Name = atmosphere and atmosphere.Name,
			Density = atmosphere and atmosphere.Density,
			Offset = atmosphere and atmosphere.Offset,
			Color = atmosphere and atmosphere.Color,
			Decay = atmosphere and atmosphere.Decay,
			Glare = atmosphere and atmosphere.Glare,
			Haze = atmosphere and atmosphere.Haze,
		},

		PMtickets = {};

		HelpRequests = {};

		Objects = {};

		InsertedObjects = {};

		CommandLoops = {};

		SavedTools = {};

		Waypoints = {};

		Cameras = {};

		Jails = {};

		LocalEffects = {};

		TrackingTable = {};

		DisguiseBindings = {};

		IncognitoPlayers = {};

		MusicList = {
			{Name = "crabrave", 				ID = 5410086218},
			{Name = "shiawase", 				ID = 5409360995},
			{Name = "unchartedwaters", 			ID = 7028907200},
			{Name = "glow", 					ID = 7028856935},
			{Name = "good4me", 					ID = 7029051434},
			{Name = "bloom", 					ID = 7029024726},
			{Name = "safe&sound", 				ID = 7024233823},
			{Name = "shaku", 					ID = 7024332460},
			{Name = "fromdust&ashes", 			ID = 7024254685},
			{Name = "loveis", 					ID = 7029092469},
			{Name = "playitcool", 				ID = 7029017448},
			{Name = "still", 					ID = 7023771708},
			{Name = "sleep", 					ID = 7023407320},
			{Name = "whatareyouwaitingfor", 	ID = 7028977687},
			{Name = "balance", 					ID = 7024183256},
			{Name = "brokenglass", 				ID = 7028799370},
			{Name = "thelanguageofangels", 		ID = 7029031068},
			{Name = "imprints", 				ID = 7023704173},
			{Name = "foundareason", 			ID = 7028919492},
			{Name = "newhorizons", 				ID = 7028518546},
			{Name = "whatsitlike", 				ID = 7028997537},
			{Name = "destroyme",				ID = 7023617400},
			{Name = "consellations", 			ID = 7023733671},
			{Name = "wish", 					ID = 7023670701},
			{Name = "samemistake", 				ID = 7024101188},
			{Name = "whereibelong", 			ID = 7028527348},
			{Name = "rainingtacos", 			ID = 142376088},
		};

		InsertList = {};

		Capes = {
			{Name = "crossota", 	Material = "Neon", 		Color = "Cyan", 			ID = 420260457},
			{Name = "jamiejr99", 	Material = "Neon",		Color = "Cashmere",			ID = 429297485},
			{Name = "new yeller", 	Material = "Fabric", 	Color = "New Yeller"},
			{Name = "pastel blue", 	Material = "Fabric", 	Color = "Pastel Blue"},
			{Name = "dusty rose", 	Material = "Fabric", 	Color = "Dusty Rose"},
			{Name = "cga brown", 	Material = "Fabric", 	Color = "CGA brown"},
			{Name = "random", 		Material = "Fabric", 	Color = (BrickColor.random()).Name},
			{Name = "shiny", 		Material = "Plastic", 	Color = "Institutional white",		Reflectance = 1},
			{Name = "gold",			Material = "Plastic", 	Color = "Bright yellow",		Reflectance = 0.4},
			{Name = "kohl",			Material = "Fabric", 	Color = "Really black", 		ID = 108597653},
			{Name = "script", 		Material = "Plastic", 	Color = "White", 			ID = 151359194},
			{Name = "batman", 		Material = "Fabric", 	Color = "Institutional white", 		ID = 108597669},
			{Name = "epix", 		Material = "Plastic", 	Color = "Really black", 		ID = 149442745},
			{Name = "superman", 	Material = "Fabric", 	Color = "Bright blue", 			ID = 108597677},
			{Name = "swag", 		Material = "Fabric", 	Color = "Pink", 			ID = 109301474},
			{Name = "donor", 		Material = "Plastic", 	Color = "White", 			ID = 149009184},
			{Name = "gomodern", 	Material = "Plastic", 	Color = "Really black", 		ID = 149438175},
			{Name = "admin", 		Material = "Plastic", 	Color = "White", 			ID = 149092195},
			{Name = "giovannis", 	Material = "Plastic", 	Color = "White", 			ID = 149808729},
			{Name = "godofdonuts", 	Material = "Plastic", 	Color = "Institutional white",		ID = 151034443},
			{Name = "host", 		Material = "Plastic", 	Color = "Really black", 		ID = 152299000},
			{Name = "cohost", 		Material = "Plastic", 	Color = "Really black", 		ID = 152298950},
			{Name = "trainer",		Material = "Plastic", 	Color = "Really black", 		ID = 152298976},
			{Name = "ba", 			Material = "Plastic", 	Color = "White", 			ID = 172528001}
		};

		Blacklist = {
			Enabled = (server.Settings.BlacklistEnabled ~= nil and server.Settings.BlacklistEnabled) or true,
			Lists = {
				Settings = server.Settings.Blacklist
			},
		};

		Whitelist = {
			Enabled = server.Settings.WhitelistEnabled,
			Lists = {
				Settings = server.Settings.Whitelist
			},
		};

		Starter = {
			Health = {};
			Speed = {};
		}
	}
end
