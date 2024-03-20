-- Credits to Altlexon, Aniwatch
getgenv().map_tas = {
    ["Blue Moon"] = "bm1",
    ["Poisonous Chasm"] = "pc1",
    ["Mirage Saloon"] = "ms1",
    ["Decaying Silo"] = "ds1",
    ["Ignis Peaks"] = "igp1";
    ["Active Volcanic Mines"] = "avm1",
    ["Snowy Stronghold"] = "ssh1",
    ["Sandswept Ruins"] = "ssr1",
    ["Rustic Jungle"] = "rj1";
    ["Abandoned Harbour"] = "abhb1";
    ["##########"] = "testcm1";
}

repeat wait(1.25) until game:IsLoaded() or game.Loaded:wait()
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform())
pcall(function()
    game:GetService("ReplicatedStorage").Remote.ReqCharVars.OnClientInvoke = function() return{} end 
    game:GetService("ReplicatedStorage").Remote.FetchPos.OnClientInvoke = function() return wait(9e9) end
end)

local maps = extra_maps or {"Outlier of a Coppice Carcass", "Abyssal Tempest", "Spring Valley", "Kozui Peak", "Mirage Saloon", "Abandoned Harbour"}
local script = require(game.ReplicatedStorage.SharedModules.FE2Library)
local script2 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MenuGui").MapTest.Window.Content.Pages.MapList.Active_Frame.Container:GetChildren()

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

local function WindowToTAS()
    for _,v in pairs(maps) do
        if tostring(v) == tostring(workspace:WaitForChild("Lobby").GameInfo.SurfaceGui.Frame.MapName.Text) and BeforeLaunch() then
            if map_tas[tostring(v)] then
                return v
            end
        end
    end
    return nil
end

local function WindowToCM()
    for i, v in pairs(script2) do
        if v.ClassName == "Frame" and v.Name == "Map_Container" then
            if not maps[tostring(v:WaitForChild('Map_Frame')['Info_BG'].MapName.Text)] then
                table.insert(maps, v:WaitForChild('Map_Frame')['Info_BG'].MapName.Text)
            end
        end
    end

    for _,v in pairs(maps) do
        local NewMap = workspace:WaitForChild('Multiplayer'):FindFirstChild('NewMap')
        if not NewMap then return nil end
        print"Map loading."
        if tostring(v) == tostring(NewMap:WaitForChild('Settings'):GetAttribute("MapName")) then
            print"Map retrieved."
            if map_tas[tostring(v)] then
                print("Map fired.", v)
                return v
            end
        end
    end
    return nil
end

local Window = Fluent:CreateWindow({
    Title = "Hyperblox Panel",
    SubTitle = tostring(game:GetService("Players").LocalPlayer).."/ani.watch",
    TabWidth = 130,
    Size = UDim2.fromOffset(580, 300),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.P-- Used when theres no MinimizeKeybind
})

local save = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts["CL_MAIN_GameScript"]).takeAir
local TAS_AUTOPLAYER = false
local TAS_AUTOPLAYER2 = false
local godmode = false
local dubjump = false

local ws = 20
local jp = 50

local disX = 4
local disY = 1.25

local Tabs = {
    Main = Window:AddTab({ Title = "Essentials", Icon = "box" }),
    Task = Window:AddTab({ Title = "Tasks", Icon = "compass" }),
    Util = Window:AddTab({ Title = "Utilities", Icon = "info" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

for _,v in ipairs(getnilinstances()) do
	if v.Name == "CL_AntiExploit" then
		print('Anti-Cheat Deleted.')
		v:Destroy()
	end
end

local function TAS_INST()
	for _,v in pairs(map_tas) do
		local map = game:GetService("HttpService"):UrlEncode(v)
		local su = isfile("TAS/"..v..".json") print(su)
		if su == true then
			--clmain.newAlert(v.." TAS file already exists!",Color3.fromRGB(50,100,255))
		else
			local s, r = pcall(function()
                local tas = game:HttpGet("https://raw.githubusercontent.com/1337-svg/6731/index_client/files/"..map..".json")
				if not string.find(tas, "CFrame") then error(v..' file not exist') end
				writefile("TAS/"..v..".json", tas, true) -- minfile(tas) removed
			end)
			if s then
				--clmain.newAlert("Downloaded "..v.." TAS file succesfully!",Color3.fromRGB(0,255,0))
			else
                print(r)
				--.newAlert("Failed to download "..v.." TAS file. :(",Color3.fromRGB(255,0,0))
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
			                pcall(function()
                                getgenv().custom_map_name = "tas_"..tostring(math.random(-9999, 9999))
                                    loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/001'))()
			                end)
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

    local ERS = Tabs.Main:AddButton({
        Title = "Panic/Rejoin",
        Description = "Emergency (PRESS DELETE KEY)",
        Callback = function()
            if not IsOnMobile then
                local ER3

                ER3 = game:GetService("UserInputService").InputBegan:Connect(function(A, B)
                    if B then return end
                    if A.KeyCode == Enum.KeyCode.Delete then
                        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
                    end
                end)

                wait(5)
                ER3:Disconnect()
            else
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
            end
        end;
    })

    if game.PlaceId == 11951199229 or game.PlaceId == 12074120006 then
        local CM_AUTO = Tabs.Main:AddToggle("TAS_AP83", {
            Title = "Runtime/TAS [CM]", 
            Description = "Automate transcripts of community TAS/FE2 files.", 
            Default = false,
            Callback = function(v)
                TAS_AUTOPLAYER2 = v
            end
        })

        Tabs.Main:AddButton({
            Title = "Editor/TAS [CM]",
            Description = "Create your own Community TAS/Fe2 files.",
            Callback = function()
                Window:Dialog({
                    Title = "Confirmation",
                    Content = "Are you sure you want to open the CM TAS Editor?",
                    Buttons = {
                        {
                            Title = "Confirm",
                            Callback = function()
                                pcall(function()
                                    getgenv().custom_map_name_2 = "tascm_"..tostring(math.random(-9999, 9999))
                                    loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/001cm'))()
                                end)
                            end
                        },
                        {
                            Title = "Cancel",
                            Callback = function()
                                print("tascm_"..tostring(math.random(-9999, 9999)).." denied")
                            end
                        }
                    }
                })
            end
        })

    end

    -- UTIL SECTION
    local FE2_DUBJ = Tabs.Util:AddKeybind("TAS_FE2JUMP", {
        Title = "Infinite Jump",
        Mode = "Toggle",
        Default = "Z", 
        Callback = function(v)
            dubjump = v
        end
    })

    local FE2_INFAIR = Tabs.Util:AddToggle("TAS_INFAIR1", {
        Title = "Infinite Air", 
        Default = false,
        Callback = function(v)
            godmode = v
        end
    })

    local FE2_WalkSpeed = Tabs.Util:AddInput("FE2_UT1", {
        Title = "WalkSpeed",
        Default = 20,
        Placeholder = "20",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            ws = v
        end
    })

    local FE2_Jumppower = Tabs.Util:AddInput("FE2_UT2", {
        Title = "JumpPower",
        Default = 50,
        Placeholder = "50",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            jp = v
        end
    })

    local FE2_TP2 = Tabs.Util:AddKeybind("TAS_FE2TP", {
        Title = "Displacement",
        Mode = "Toggle",
        Default = "R", 
        Callback = function(v)
            local PlrCF = game:GetService("Players").LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame
            game:GetService("Players").LocalPlayer.Character:PivotTo(PlrCF * CFrame.new(0, disY, disX))
        end
    })

    local DIS_X = Tabs.Util:AddInput("FE2_UT33", {
        Title = "Offset X",
        Default = 4,
        Placeholder = "4",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            disX = v
        end
    })

    local DIS_Y = Tabs.Util:AddInput("FE2_UT22", {
        Title = "Offset Y",
        Default = 1.25,
        Placeholder = "1.25",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            disY = v
        end
    })

    -- TAS SECTION
    local Blue_Moon_TAS = Tabs.Task:AddInput("TOOL_004", {
        Title = "Blue Moon [CRAZY]",
        Default = "bm1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Blue Moon"] = v
        end
    })

    local Decaying_Silo_TAS = Tabs.Task:AddInput("TOOL_001", {
        Title = "Decaying Silo [CRAZY]",
        Default = "ds1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Decaying Silo"] = v
        end
    })

    local Ignis_Peeks_TAS = Tabs.Task:AddInput("TOOL_002", {
        Title = "Ignis Peaks [CRAZY]",
        Default = "igp1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Ignis Peaks"] = v
        end
    })

    local Mirage_Saloon_TAS = Tabs.Task:AddInput("TOOL_003", {
        Title = "Mirage Saloon [CRAZY][HL]",
        Default = "ms1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Mirage Saloon"] = v
        end
    })

    local Poisonous_Chasm_TAS = Tabs.Task:AddInput("TOOL_008", {
        Title = "Poisonous Chasm [CRAZY]",
        Default = "pc1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Poisonous Chasm"] = v
        end
    })

    local Active_Vol_Mines_TAS = Tabs.Task:AddInput("TOOL_005", {
        Title = "Active Volcanic Mines [CRAZY]",
        Default = "avm1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Active Volcanic Mines"] = v
        end
    })

    local Snowy_Stronghold = Tabs.Task:AddInput("TOOL_006", {
        Title = "Snowy Stronghold [CRAZY]",
        Default = "ssh1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Snowy Stronghold"] = v
        end
    })

    local Sandswept_Ruins = Tabs.Task:AddInput("TOOL_007", {
        Title = "Sandswept Ruins [CRAZY]",
        Default = "ssr1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Sandswept Ruins"] = v
        end
    })

    local Rustic_Jungle = Tabs.Task:AddInput("TOOL_009", {
        Title = "Rustic Jungle [CRAZY+]",
        Default = "rj1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Rustic Jungle"] = v
        end
    })

    local Abandoned_Harbour = Tabs.Task:AddInput("TOOL_010", {
        Title = "Abandoned Harbour [CRAZY+][HL]",
        Default = "abhb1",
        Placeholder = "FileName",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(v)
            map_tas["Abandoned Harbour"] = v
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
    game:GetService("RunService").Heartbeat:Connect(function()
        game:GetService("Players").LocalPlayer.Character:WaitForChild('Humanoid').WalkSpeed = ws
        game:GetService("Players").LocalPlayer.Character:WaitForChild('Humanoid').JumpPower = jp
    end)
end)

task.spawn(function()
    local SP = nil
    SP = game:GetService("UserInputService").InputBegan:Connect(function(A, B)
        if B then return end
        if dubjump == true then
            if A.KeyCode == Enum.KeyCode.Space then
                game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    while wait(3) do
        if Fluent.Unloaded then
            SP:Disconnect()
            break
        end
    end
end)

task.spawn(function()
	while wait(1/12) do
		if godmode == true then
			getsenv(game:GetService("Players").LocalPlayer.PlayerScripts["CL_MAIN_GameScript"]).takeAir = function()
				return 0
			end
		else
			getsenv(game:GetService("Players").LocalPlayer.PlayerScripts["CL_MAIN_GameScript"]).takeAir = save
		end
        if Fluent.Unloaded then break end
	end
end)

task.spawn(function()
    while wait(1) do
        if TAS_AUTOPLAYER2 == true then
            if WindowToCM() then 
                getgenv().selected_file_2 = map_tas[WindowToCM()]
                loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002cm'))()
            end
        end
        if Fluent.Unloaded then break end
    end
end)

task.spawn(function()
    while wait(1) do
        if TAS_AUTOPLAYER == true then
            if WindowToTAS() then 
                getgenv().selected_file = map_tas[WindowToTAS()]
                loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002'))()
            end
        end
        if Fluent.Unloaded then break end
    end
end)
