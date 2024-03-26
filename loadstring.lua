-- Credits to Altlexon, Aniwatch
if getgenv().already_loaded then return end
if not map_tas then
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
        ["Desolate Domain"] = "dsdm1";
    }
end

repeat wait(1) until game:IsLoaded() or game.Loaded:wait()
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform())
pcall(function()
    game:GetService("ReplicatedStorage").Remote.ReqCharVars.OnClientInvoke = function() return{} end 
    game:GetService("ReplicatedStorage").Remote.FetchPos.OnClientInvoke = function() return wait(9e9) end
end)

local maps = {}
local script = require(game.ReplicatedStorage.SharedModules.FE2Library)
local script2 
if game.PlaceId == 11951199229 or game.PlaceId == 12074120006 then
    script2 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MenuGui").MapTest.Window.Content.Pages.MapList.Active_Frame.Container:GetChildren()
end

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
    --[[for _,v in pairs(maps) do
        if tostring(v) == tostring(workspace:WaitForChild("Lobby").GameInfo.SurfaceGui.Frame.MapName.Text) and BeforeLaunch() then
            if map_tas[tostring(v)] then
                return v
            end
        end
    end]]

    for _,v in pairs(maps) do
        local NewMap = workspace:WaitForChild('Multiplayer'):FindFirstChild('NewMap')
        if not NewMap then return nil end
        -- print"Map loading."
        if tostring(v) == tostring(NewMap:WaitForChild('Settings'):GetAttribute("MapName")) then
            -- print"Map retrieved."
            if map_tas[tostring(v)] then
                print("Map fired.", v)
                return v
            end
        end
    end
    return nil
end

local function WindowToCM()
    for i,_ in pairs(map_tas) do
        if not maps[tostring(i)] then
            table.insert(maps, i)
        end
    end

    for _,v in pairs(maps) do
        local NewMap = workspace:WaitForChild('Multiplayer'):FindFirstChild('NewMap')
        if not NewMap then return nil end
       -- print"Map loading."
        if tostring(v) == tostring(NewMap:WaitForChild('Settings'):GetAttribute("MapName")) then
           -- print"Map retrieved."
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
    TabWidth = 110,
    Size = UDim2.fromOffset(615, 300),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.Semicolon -- Used when theres no MinimizeKeybind
})

local notif_ingame = getsenv(game.Players.LocalPlayer.PlayerScripts["CL_MAIN_GameScript"])
local save = notif_ingame.newAlert

local save = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts["CL_MAIN_GameScript"]).takeAir
local TAS_AUTOPLAYER = false
local TAS_AUTOPLAYER2 = false
local godmode = false
local dubjump = false
local amp = false
local legit = false
local pre_rec = nil
local vertDX, vertLN = 10, 0
local horzDX, horzLN = 5, 3
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

local function _Notification(scr, sat)
    -- notif_ingame.newAlert("Granted transcript installation!", Color3.fromRGB(0, 168, 17))
    spawn(function()
        wait(1/30)
        pcall(function()
            notif_ingame.newAlert(scr, sat)
        end)
    end)
end

local function DownloadTAS()
    for _,v in pairs(map_tas) do
        local selected = game:GetService('HttpService'):UrlEncode(v)
        local downloaded = isfile("TAS/"..v..".json")
        if downloaded == true then
            _Notification("TAS/"..v.." is already downloaded.", Color3.fromRGB(177, 255, 51))
        else
            local success,_ = pcall(function()
                local tas = game:HttpGet("https://raw.githubusercontent.com/1337-svg/6731/index_client/files/"..selected..".json")
                if not string.find(tas, "CFrame") then error(v..' file not exist') end
				writefile("TAS/"..v..".json", tas, true)
            end)

            if success then
                _Notification("TAS/"..v.." has been downloaded.", Color3.fromRGB(43, 68, 255))
            else
                _Notification("TAS/"..v.." has failed to download.", Color3.fromRGB(255, 150, 51))
            end
        end
        wait(1/10)
    end
end

do
    Tabs.Main:AddButton({
        Title = "Installation/TAS",
        Description = "Install available TAS/FE2 files.",
        Callback = function()
            Window:Dialog({
                Title = "Confirmation",
                Content = "Are you sure you want to Install TAS Files?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            _Notification("Granted transcript installation!", Color3.fromRGB(0, 168, 17))
                            DownloadTAS()
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            _Notification("Denied transcript installation.", Color3.fromRGB(171, 0, 43))
                        end
                    }
                }
            })
        end
    })

    Tabs.Main:AddInput("no_name_thing", {
        Title = "Identifier/TAS",
        Default = "nil",
        Description = "Name for TAS/FE2 files.",
        Placeholder = "nil",
        Numeric = false, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            local one, two = isfile("TAS/"..v..".json"), isfile("CM_TAS/"..v..".json")
            if one == true or two == true then
                Window:Dialog({
                Title = "Confirmation",
                Content = "Are you sure you want to overwrite TAS/"..v.."?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            _Notification("Granted transcript overwrition", Color3.fromRGB(171, 0, 43))
                            DownloadTAS()
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            _Notification("Denied transcript overwrition", Color3.fromRGB(0, 168, 17))
                        end
                    }
                }
            })
        end
            end
            pre_rec = v
        end
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
            Description = "Create your own Community TAS/FE2 files.",
            Callback = function()
                if not pre_rec then
                    _Notification("Identifier/TAS has not been set", Color3.fromRGB(171, 0, 43))
                    return nil
                end

                Window:Dialog({
                    Title = "Confirmation",
                    Content = "Are you sure you want to open the CM TAS Editor?",
                    Buttons = {
                        {
                            Title = "Confirm",
                            Callback = function()
                                pcall(function()
                                    _Notification("Granted transcript "..pre_rec, Color3.fromRGB(99, 255, 242))
                                    getgenv().custom_map_name_2 = pre_rec or "tascm_"..tostring(math.random(-9999, 9999))
                                    loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/001cm'))()
                                end)
                            end
                        },
                        {
                            Title = "Cancel",
                            Callback = function()
                                _Notification("Denied transcript "..pre_rec, Color3.fromRGB(171, 0, 43))
                            end
                        }
                    }
                })
            end
        })
    else
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
            Description = "Create your own TAS/FE2 files.",
            Callback = function()
                if not pre_rec then
                    _Notification("Identifier/TAS has not been set", Color3.fromRGB(171, 0, 43))
                    return nil
                end

                Window:Dialog({
                    Title = "Confirmation",
                    Content = "Are you sure you want to open the TAS Editor?",
                    Buttons = {
                        {
                            Title = "Confirm",
                            Callback = function()
                                pcall(function()
                                    _Notification("Granted transcript "..pre_rec, Color3.fromRGB(99, 255, 242))
                                    getgenv().custom_map_name = pre_rec or "tas_"..tostring(math.random(-9999, 9999))
                                    loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/001'))()
                                end)
                            end
                        },
                        {
                            Title = "Cancel",
                            Callback = function()
                                _Notification("Denied transcript "..pre_rec, Color3.fromRGB(171, 0, 43))
                            end
                        }
                    }
                })
            end
        })
    end

    

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

    local FE2_LEGIT = Tabs.Main:AddToggle("TAP_LEGIT", {
        Title = "Legitimate", 
        Description = "Tone down the evasiveness of certain options.", 
        Default = false,
        Callback = function(v)
        	legit = v
        end
    })

    local FE2_RESTRC = Tabs.Main:AddInput("LEGIT_0063", {
        Title = "Legitimate/Restriction",
        Default = "3",
        Description = "How legitimate you want to be.",
        Placeholder = "3",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            horzLN = v
        end
    })

    local FE2_FloorLEGIT = Tabs.Main:AddInput("LEGIT_0012", {
        Title = "Legitimate/Floor",
        Default = "8",
        Description = "How far you can infinite jump from a platform.",
        Placeholder = "8",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            vertDX = v
        end
    })

    local FE2_HorzLEGIT = Tabs.Main:AddInput("LEGIT_001", {
        Title = "Legitimate/Wall",
        Default = "5",
        Description = "How far you can 'wallhop' from a wall.",
        Placeholder = "5",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(v)
            horzDX = v
        end
    })

    -- UTIL SECTION
    local FE2_DUBJ = Tabs.Util:AddKeybind("TAS_FE2jump", {
        Title = "Infinite Jump",
        Mode = "Toggle",
        Default = "Z", 
        Callback = function(v)
            dubjump = v
        end
    })

    local FE2_DUBJ2 = Tabs.Util:AddKeybind("TAS_FE2amp", {
        Title = "Speed/Jump Boost",
        Mode = "Toggle",
        Default = "X", 
        Callback = function(v)
            amp = v
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
        Title = "Offseter (Teleport)",
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
    for i,v in pairs(map_tas) do
        Tabs.Task:AddInput(tostring(math.random(-5000, 5000)), {
            Title = tostring(i),
            Default = tostring(v),
            Placeholder = "FileName",
            Numeric = false,
            Callback = function(cb)
                map_tas[tostring(i)] = cb
            end
        })
    end

    --[[
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
    })]]
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
	local Highlight = Instance.new('Highlight')
	Highlight.FillColor, Highlight.FillTransparency = Color3.fromRGB(255, 0, 4), .75
	Highlight.OutlineColor, Highlight.OutlineTransparency = Color3.fromRGB(255, 102, 105), .1
	Highlight.Name, Highlight.Adornee = tostring(math.random(-10000, 10000)), nil
	Highlight.Enabled, Highlight.Parent = true, nil

    local CN = nil
	CN = game:GetService("RunService").Heartbeat:Connect(function()
		local null = 0
		if amp == true then
            Highlight.Parent = workspace
			Highlight.Adornee = game:GetService("Players").LocalPlayer.Character
			null = 5
		else
            Highlight.Parent = nil
			Highlight.Adornee = nil
		end
		
		game:GetService("Players").LocalPlayer.Character:WaitForChild('Humanoid').WalkSpeed = ws + (null)
		game:GetService("Players").LocalPlayer.Character:WaitForChild('Humanoid').JumpPower = jp + (null * 2)
        if Fluent.Unloaded then CN:Disconnect() end
	end)
end)

local Start = tick()
local InLine = false
local function QueueReset(a)
	Start = tick()
	if InLine == false then
		InLine = true
		local connection
		connection = game:GetService('RunService').Heartbeat:Connect(function()
			local hm: Part = game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid')
			if (tick() - Start) > a then
				hm.AutoRotate = true
				InLine = false
				connection:Disconnect()
			end
		end)
	end
end

local function RayToDotVector(ray)
	local char = game:GetService('Players').LocalPlayer.Character or game:GetService('Players').LocalPlayer.CharacterAdded:Wait()
	local RootPart = char:WaitForChild('HumanoidRootPart')
	local SurfaceCorrelationOffset = Vector3.new(
		math.clamp(ray.Instance.CFrame:PointToObjectSpace(RootPart.Position).X, -(ray.Instance.Size/2) .X, (ray.Instance.Size/2).X), 
		math.clamp(ray.Instance.CFrame:PointToObjectSpace(RootPart.Position).Y, -(ray.Instance.Size/2).Y, (ray.Instance.Size/2).Y), 
		math.clamp(ray.Instance.CFrame:PointToObjectSpace(RootPart.Position).Z, -(ray.Instance.Size/2).Z, (ray.Instance.Size/2).Z)
	)

	local PositionRelativeToSurface = (ray.Instance.CFrame * CFrame.new(SurfaceCorrelationOffset))
	local DirectionRelativeToSurface = Vector3.new((PositionRelativeToSurface - RootPart.Position).X, 0, (PositionRelativeToSurface - RootPart.Position).Z).Unit

	local Dot = math.pi - math.acos(RootPart.CFrame.LookVector:Dot(ray.Normal.Unit))
	local Cross = RootPart.CFrame.LookVector:Cross(DirectionRelativeToSurface)
	
	local DIR = nil
	local Correction, Dividend = nil
	if Cross.Y < 0 then Correction = math.abs(Dot - math.pi/2) DIR = -2
	else Correction = Dot - math.pi/2 DIR = 2
	end

	Dividend = math.abs(Dot/math.pi)
	return Correction, DIR
end

local function Wallhop()
	local char = game:GetService('Players').LocalPlayer.Character or game:GetService('Players').LocalPlayer.CharacterAdded:Wait()
	local rp: Part = char:WaitForChild('HumanoidRootPart')
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
	
	local floor = workspace:Blockcast(rp.CFrame, Vector3.new(horzLN, .5, horzLN), rp.CFrame.UpVector * -vertDX, params)
	local champion, inc = false, 0
	local comparsion = {}
	for i = 1, 7 do
		local result = workspace:Raycast((rp.CFrame * CFrame.new(0, -2, 0)).Position, (rp.CFrame.Rotation * CFrame.Angles(0, math.rad(inc), 0)).LookVector * horzDX, params)
		if result then
			comparsion[i] = result
		end
		inc += 45
	end
	
	local lowestvalue, lowestindex = nil
	for i, v in pairs(comparsion) do
		if not lowestvalue then lowestindex = i lowestvalue = v
		else
			if lowestvalue.Distance >= v.Distance then
				lowestindex = i
				lowestvalue = v
			end
		end
	end

	if lowestindex and lowestvalue.Instance.ClassName ~= "TrussPart" then
		QueueReset(.2)
	elseif lowestvalue.Instance.ClassName == "TrussPart" then
		task.delay(1/60, function()
			char.Humanoid.AutoRotate = true
		end)
	else
		char.Humanoid.AutoRotate = true
	end

	return floor, lowestvalue
end

task.spawn(function()
	local SP = nil
	SP = game:GetService("UserInputService").InputBegan:Connect(function(A, B)
		if B then return end
		local char = game:GetService('Players').LocalPlayer.Character or game:GetService('Players').LocalPlayer.CharacterAdded:Wait()
		local rp: Part = char:WaitForChild('HumanoidRootPart')
		if dubjump == true then
			if A.KeyCode == Enum.KeyCode.Space then
				if legit then
					local IsFloor, IsWall = Wallhop()
					if IsWall then
						if game:GetService("Players").LocalPlayer.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Running then
							char.Humanoid.AutoRotate = false
							local perfection, randomizer = RayToDotVector(IsWall)
							rp.CFrame = (rp.CFrame * CFrame.Angles(0, perfection + randomizer, 0))
						end
						game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					elseif IsFloor then
						game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				else
				    game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
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
    local s, r = pcall(function()
	while wait(1) do
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
    if r then warn(r) end
end)

if game.PlaceId == 11951199229 or game.PlaceId == 12074120006 then
    task.spawn(function()
        while wait(.33) do
            if TAS_AUTOPLAYER2 == true then
                if WindowToCM() then
                    if WindowToCM() == "Abandoned Harbour" then
                        if workspace.Multiplayer:WaitForChild('NewMap')._Variants:FindFirstChild('_Vairant') then
                            getgenv().selected_file_2 = "abhb1_r2"
                            loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002cm'))()
                        elseif workspace.Multiplayer:WaitForChild('NewMap')._Variants:FindFirstChild('_Variant') then
                            getgenv().selected_file_2 = "abhb1_r2"
                            loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002cm'))()
                        end
                    else
                        getgenv().selected_file_2 = map_tas[WindowToCM()]
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002cm'))()
                    end
                end
            end
            if Fluent.Unloaded then break end
        end
    end)
else
    task.spawn(function()
        while wait(.33) do
            if TAS_AUTOPLAYER == true then
                local s,r = pcall(function()
                    if WindowToTAS() then
                        if WindowToTAS() == "Abandoned Harbour" then
                            if workspace.Multiplayer:WaitForChild('NewMap')._Variants:FindFirstChild('_Vairant') then
                                getgenv().selected_file = "abhb1_r2"
                                loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002'))()
                            elseif workspace.Multiplayer:WaitForChild('NewMap')._Variants:FindFirstChild('_Variant') then
                                getgenv().selected_file = "abhb1_r2"
                                loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002'))()
                            end
                        else
                            getgenv().selected_file = map_tas[WindowToTAS()]
                            loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/6731/index_client/002'))()
                        end
                    end
                end)
                if r then warn(r) end
            end
            if Fluent.Unloaded then break end
        end
    end)
end
getgenv().already_loaded = true
spawn(function()
	while wait(5) do
		if Fluent.Unloaded then
			getgenv().already_loaded = nil
			break
		end
	end
end)
