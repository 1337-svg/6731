-- Credits to Altlexon, Aniwatch
repeat wait(1) until game:IsLoaded() or game.Loaded:wait()
game:GetService("ReplicatedStorage").Remote.ReqCharVars.OnClientInvoke = function() return{} end 
game:GetService("ReplicatedStorage").Remote.FetchPos.OnClientInvoke = function() return wait(9e9) end

local maps = extra_maps or {"Outlier of a Coppice Carcass", "Abyssal Tempest", "Spring Valley", "Kozui Peak", "Mirage Saloon", "Abandoned Harbour"}
local script = require(game.ReplicatedStorage.SharedModules.FE2Library)
for i, v in pairs(script.getOfficialMapData()) do
    table.insert(maps, v.mapName)
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1337-svg/6731/index_client/settings/sm.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/1337-svg/6731/index_client/settings/im.lua"))()

local function BeforeLaunch()
    if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("GameGui").Loading.Visible == true then
        return true
    end
    return nil
end

local map_tas = {
    ["Blue Moon"] = "bm1",
    ["Mirage Saloon"] = "ms1",
    ["Decaying Silo"] = "ds1",
    ["Ignis Peaks"] = "igp1";
    ["Active Volcanic Mines"] = "avm1",
}

local function WindowToTAS()
    for _,v in pairs(maps) do
        if tostring(v) == tostring(workspace.Lobby.GameInfo.SurfaceGui.Frame.MapName.Text) and BeforeLaunch() then
            if map_tas[tostring(v)] then
                return v
            end
        end
    end
    return nil
end

local Window = Fluent:CreateWindow({
    Title = "Flood Panel",
    SubTitle = tostring(game:GetService("Players").LocalPlayer).."/ani.watch",
    TabWidth = 100,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local TAS_AUTOPLAYER = false
local Tabs = {
    Main = Window:AddTab({ Title = "Essentials", Icon = "box" }),
    Task = Window:AddTab({ Title = "Tasks", Icon = "compass" }),
    Util = Window:AddTab({ Title = "Utilities", Icon = "info" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local function TAS_INST()
	for _,json_map in pairs(map_tas) do
		local map = HttpService:UrlEncode(v)
		local installed = isfile(v..".json")
		if installed == true then clmain.newAlert(v.." Updated!", Color3.fromRGB(50,100,255))
		else
			local s, r = pcall(function()
                local tas = game:HttpGet("https://raw.githubusercontent.com/1337-svg/6731/index_client/files/"..json_map..".json")
				if not string.find(tas, "CFrame") then error(v..' file not exist') end
				writefile(v..".json", tas, true) -- minfile(tas) removed
			end)

			if s then
				clmain.newAlert("Downloaded TAS/"..v, Color3.fromRGB(0,255,0))
			else
                print(r)
				clmain.newAlert("Failed TAS/"..v, Color3.fromRGB(255,0,0))
			end
		end
		wait()
	end
end

do
    Tabs.Main:AddButton({
        Title = "Installation/TAS",
        Description = "Install available TAS/Fe2 files.",
        Callback = function()
            Window:Dialog({
                Title = "Confirmation",
                Content = "Are you sure you want to Install TAS Files?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            TAS_INST()
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Denied")
                        end
                    }
                }
            })
        end
    })

    local FE2_AUTO = Tabs.Main:AddToggle("TAS_AP", {
        Title = "Runtime/TAS", 
        Description = "Automate transcripts of TAS/FE2 files.", 
        Default = false,
        Callback = function(v)
            TAS_AUTOPLAYER = v
        end
    })

    Tabs.Main:AddButton({
        Title = "Editor/TAS",
        Description = "Create your own TAS/Fe2 files.",
        Callback = function()
            Window:Dialog({
                Title = "Confirmation",
                Content = "Are you sure you want to open the TAS Editor?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            getgenv().custom_map_name = "tas_"..tostring(math.random(-9999, 9999))
                            loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/001'))()
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("tas_"..tostring(math.random(-9999, 9999)).." denied")
                        end
                    }
                }
            })
        end
    })

    -- TAS SECTION
    local Decaying_Silo_TAS = Tabs.Task:AddInput("TOOL_001", {
        Title = "Decaying Silo",
        Default = "ds1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Decaying Silo"] = v
        end
    })

    local Ignis_Peeks_TAS = Tabs.Task:AddInput("TOOL_002", {
        Title = "Ignis Peaks",
        Default = "igp1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Ignis Peaks"] = v
        end
    })

    local Mirage_Saloon_TAS = Tabs.Task:AddInput("TOOL_003", {
        Title = "Mirage Saloon",
        Default = "ms1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Mirage Saloon"] = v
        end
    })

    local Blue_Moon_TAS = Tabs.Task:AddInput("TOOL_004", {
        Title = "Blue Moon",
        Default = "bm1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Blue Moon"] = v
        end
    })

    local Active_Vol_Mines_TAS = Tabs.Task:AddInput("TOOL_005", {
        Title = "Active Volcanic Mines",
        Default = "avm1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Active Volcanic Mines"] = v
        end
    })
end

-- Interface & Save Managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("SmartT@$")
SaveManager:SetFolder("SmartF3$")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = tostring(game:GetService("Players").LocalPlayer).."/ani.watch",
    Content = "discord.gg/oneclan",
    Duration = 5
})

task.spawn(function()
    while wait(1) and not Fluent.Unloaded do
        if TAS_AUTOPLAYER == true then
            if WindowToTAS() then 
                getgenv().selected_file = map_tas[WindowToTAS()]
                loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002'))()
            end
        end
    end
end)
