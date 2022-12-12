local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local window1 = library:CreateWindow("Autofarm")
local folder1 = window1:CreateFolder("Options")

local createdVelocities = {}
local errorTable = {}
local scriptFunctions = {
    ["Main"] = {},
    ["Side"] = {}
}
local playerData = {}


local Version = "PRE-RELEASE - 0.0.4" -- colleting precise bee ability
warn("----------------------------------------------------------")
print("Script Version "..Version)
warn("-----------------------------------------------------------")

local localplayer = game.Players.LocalPlayer
local hrp, hum

getgenv().Executed = not getgenv().Executed
local ExecState = getgenv().Executed

local function Announce(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = tostring(title);
        Text = tostring(text)
    })
end

spawn(function()
    local done = false
    while not done and wait() do
        for i, v in pairs(workspace.Honeycombs:GetChildren()) do
            if v:FindFirstChild("Owner") and v.Owner.Value == localplayer then
                playerData.Hive = v
                playerData.Bees = 0
                done = true
                for a, b in pairs(v.Cells:GetChildren()) do
                    if b.CellType and b.CellType.Value ~= "Empty" then
                       playerData.Bees += 1
                    end
                end
            end
            wait()
        end
    end
end)

--[[local https = game:GetService("HttpService")
local errorWebhook = "https://hooks.hyra.io/api/webhooks/978695761007091752/yIhzc0EdsHah1LtY7VZ4zcZmsyH6f6e3KSWH-K6ixmG6wr33goU2aI6NoKIJ4D_mBKMy"

local function postSync(webhook, message)
    local data
	if type(message) == "string" then
		data = {
			["content"] = message
		}
	else
		data = message
	end
	local passData = https:JSONEncode(data)
	local s, e
	repeat
		s, e = pcall(function()
			syn.request({
                Url = "https://hooks.hyra.io/api/webhooks/978695761007091752/yIhzc0EdsHah1LtY7VZ4zcZmsyH6f6e3KSWH-K6ixmG6wr33goU2aI6NoKIJ4D_mBKMy",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = passData
             })
		end)
		if e then
			print(e)
			wait(5)
		end
	until s
end --]]

local function reportError(message)
    print(message)
	if not table.find(errorTable, message) then
		table.insert(errorTable, message)
        
		local finalMessage = "```lua\n"..message.."```"
        --postSync(errorWebhook, finalMessage)
	end
end

local function SpawnSplinker()
    game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
end

local function CreateVelocity()
    local antivelocity = Instance.new("BodyVelocity")
    antivelocity.Parent = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
    antivelocity.Name = "BodyVelocityR"
    antivelocity.Velocity = Vector3.new(0,0,0)
    antivelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    table.insert(createdVelocities, antivelocity)
end

local function DestroyVelocity()
    if #createdVelocities >= 1 then
        for i, v in pairs(createdVelocities) do
            v:Destroy()
            table.remove(createdVelocities, i)
        end
    end
end

local sproutsFolder = game:GetService("Workspace").Particles.Folder2

local MonsterSpawners = {
    Spider = game:GetService("Workspace").MonsterSpawners["Spider Cave"],
    Rhino = {
        CloverField = game:GetService("Workspace").MonsterSpawners["Rhino Bush"],
        BlueflowerField = game:GetService("Workspace").MonsterSpawners["Rhino Cave 1"],
        BambooField = game:GetService("Workspace").MonsterSpawners["Rhino Cave 3"],
    };
    Werewol = game:GetService("Workspace").MonsterSpawners.WerewolfCave,
    Scorpion = game:GetService("Workspace").MonsterSpawners.RoseBush,
    Ladybug = {
        CloverField = game:GetService("Workspace").MonsterSpawners["Ladybug Bush"],
        MushroomField = game:GetService("Workspace").MonsterSpawners["MushroomBush"],
        StrawberryField = game:GetService("Workspace").MonsterSpawners["Ladybug Bush 2"],
    };
    Mantis = {
        PineTreeField = game:GetService("Workspace").MonsterSpawners.ForestMantis1,
        PineappleField = game:GetService("Workspace").MonsterSpawners.PineappleMantis1,
    };
}

local Fields = {}
local FieldsFolder = workspace.FlowerZones

for i, v in pairs(FieldsFolder:GetChildren()) do
    Fields[v.Name] =  v
end

local SpawnerFieldTable = {
    ["Spider Cave"] = "Spider",
    ["Rhino Bush"] = "Clover",
    ["Rhino Cave 1"] = "Blueflower",
    ["Rhino Cave 3"] = "Bamboo",
    ["WerewolfCave"] = "Cactus",
    ["RoseBush"] = "Rose",
    ["Ladubug Bush"] = "Clover",
    ["MushroomBush"] = "Mushroom",
    ["Ladybug Bush 2"] = "Strawberry",
    ["ForestMantis1"] = "Tree",
    ["PineappleMantis1"] = "Pineapple",
}

local RareTokensDecals = {}
for i, v in pairs(game:GetService("ReplicatedStorage").EggTypes:GetChildren()) do
    if v:IsA("Decal") and v.Name ~= "BasicIcon" and v.Name ~= "TreatIcon" and v.Name ~= "EvictionIcon" and v.Name ~= "RoboPassIcon" and v.Name ~= "SprinklerBuilderIcon" and v.Name ~= "SpiritPetalIcon" and v.Name ~= "BeequipStorageSlotIcon" and v.Name ~= "GummyBounds" and v.Name ~= "BeequipCaseSlotIcon" then
        table.insert(RareTokensDecals, v.Texture)
    end
end

local function GetCollector()
    return localplayer.Character:FindFirstChildOfClass("Tool") or localplayer.Backpack:FindFirstChildOfClass("Tool")
end

local function checkDistance(regionPart, part, sizeY)
    local pos, size = regionPart.Position, regionPart.Size
    local minX, maxX, minZ, maxZ, minY, maxY = pos.X - size.X / 2, pos.X + size.X / 2, pos.Z - size.Z / 2, pos.Z + size.Z / 2, pos.Y - (sizeY/3 or size.Y/2), pos.Y + (sizeY/2 or size.Y/2)
    pos, size = part.Position, part.Size
    return (pos.X < maxX and pos.X > minX and pos.Z < maxZ and pos.Z > minZ and pos.Y < maxY and pos.Y > minY)
end

local function getField(part)
    local s, e
    local function Try()
        for i, v in pairs(Fields) do
            if checkDistance(v, part, 50) then
                return v
            end
        end
        return nil
    end
    repeat
        s, e = pcall(Try)
        if not s and e then
            reportError("GetField Error: "..e)
            wait()
        end
    until s
    return e
end


local FieldChosen, FieldToFarm
local temp = {}
for i, v in pairs(Fields) do
    table.insert(temp, i)
end
folder1:Dropdown("Choose field", temp, true, function(option)
    FieldChosen = Fields[option]
    Announce("Autofarm", "New Target Field: "..FieldChosen.Name)
end)

print("Please choose target field")
Announce("WARNING", "Please choose target field")

local tempNum = 0 
while ExecState == getgenv().Executed and not FieldChosen and wait() do
    tempNum += 1
    if tempNum == 200 then
        tempNum = 0
        Announce("WARNING", "Please choose target field")
    end
end

local VS = game:GetService("VirtualUser")
local function PressKey(key)
    VS:CaptureController()
    VS:TypeKey(key)
end
localplayer.Idled:Connect(function()
    VS:CaptureController()
    VS:ClickButton2(Vector2.new())
end)

for i, v in pairs(workspace.Collectibles:GetChildren()) do
    if v.Transparency ~= 0 then
        v:Destroy()
    end
end

local monitorDying = coroutine.create(function()
    local con
    localplayer.CharacterAdded:Connect(function(char)
        repeat wait() until char:FindFirstChild("Humanoid")
        if con then
            con:Disconnect()
        end
        con = char.Humanoid.Died:Connect(function()
            createdVelocities = {}
        end)
    end)
    if localplayer.Character:FindFirstChild("Humanoid") then
        con = localplayer.Character.Humanoid.Died:Connect(function()
            createdVelocities = {}
        end)
    end
end)
coroutine.resume(monitorDying)

local function ConvertToStuds(meters)
    return meters * (25/7)
end

local tweenService = game:GetService("TweenService")

local function Tween(position, build, speed)
    local tweenInfo, timePeriod, newPos
    local s, e

    local function TryTween()
        newPos = {
            CFrame = position
        }
        local TweenProcess = tweenService:Create(hrp, tweenInfo, newPos)
        CreateVelocity()
        TweenProcess:Play()
        wait(time)
        DestroyVelocity()
        if build then
            SpawnSplinker()
        end
    end

    repeat
        hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
        timePeriod = (hrp.Position - position.Position).magnitude / (speed or 180) -- speed
        tweenInfo = TweenInfo.new(timePeriod, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
        s, e = pcall(TryTween)
        if e then
            DestroyVelocity()
            wait()
            local feedbackMessage = "Tween Failed: "..e
            reportError(feedbackMessage)
        end
    until s
end

local GetDataEvent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats

local function Teleport(location, build)
    CreateVelocity()
    hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = location
    wait()
    DestroyVelocity()
    if build then
        wait(.5)
        SpawnSplinker()
    end
end

for i, v in pairs(workspace.FieldDecos:GetChildren()) do
    v:Destroy()
end

scriptFunctions.Main.DodgeMobs = {
    ["Active"] = false,
    ["Paused"] = false,
}

function scriptFunctions.Main.DodgeMobs:Function()
    local s, e
    local biggestRadius, shortestDelay, nearest, shortestMag, PartB
    local reverse = false
    local upVec = Vector3.new(0,15,0)

    local function Dodge()
        hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
        local tempMag

        for i, v in pairs(workspace.Monsters:GetChildren()) do
            if hrp and v.PrimaryPart and v.LookAt.Value and (hrp.Position - v.PrimaryPart.Position).magnitude <= ConvertToStuds(15) and not v.Name:find("Mondo") and not v.Name:find("Vicious") and not v.Name:find("Snail") and not v.Name:find("King") and not v.Name:find("Coconut") and not v.Name:find("Windy") then
                PartB = v.PrimaryPart
                if not biggestRadius or biggestRadius < (v:FindFirstChild("Config") or v:WaitForChild("Config")).AttackRadius.Value then
                    biggestRadius = (v:FindFirstChild("Config") or v:WaitForChild("Config")).AttackRadius.Value
                end
                if not shortestDelay or shortestDelay > (v:FindFirstChild("Config") or v:WaitForChild("Config")).AttackDelay.Value then
                    shortestDelay = (v:FindFirstChild("Config") or v:WaitForChild("Config")).AttackDelay.Value
                end
                tempMag = (PartB.Position - hrp.Position).magnitude
                if not shortestMag or shortestMag > tempMag then
                    shortestMag = tempMag
                    nearest = v
                end
                wait()
            end
        end
        
        if nearest then
            PartB = nearest.PrimaryPart
            CreateVelocity()
            hrp.CFrame += upVec
            wait(1.8)
            if reverse then
                hrp.CFrame = PartB.CFrame + (PartB.CFrame.LookVector*(biggestRadius + 2.5))
            else
                hrp.CFrame = PartB.CFrame - (PartB.CFrame.LookVector*(biggestRadius + 2.5))
            end
            -- hrp.CFrame = CFrame.lookAt(hrp.Position, PartB.Position + Vector3.new(0, localplayer.Character:WaitForChild("HumanoidRootPart").Position.Y - PartB.Position.Y, 0))
            DestroyVelocity()
        end
    end

    while wait() and ExecState == getgenv().Executed do
        if self.Active and not self.Paused then
            s, e  = pcall(Dodge)
            if e then
                DestroyVelocity()
                reportError("Dodge Mobs Error: "..e)
            end
        end
    end
end
coroutine.resume(coroutine.create(function()
    scriptFunctions.Main.DodgeMobs:Function()
end))


FieldToFarm = FieldChosen
temp, tempNum = nil, nil

local Speed, ActivateToys, CustomSpeed

folder1:Toggle("Autofarm", function(state)
    scriptFunctions.Main.Autofarm.Enabled = state
end)

scriptFunctions.Main.CollectTokens = {
    ["Active"] = false,
    ["Paused"] = false,
    ["Speed"] = false,
    ["Event"] = false,
    ["Free"] = false,
}
function scriptFunctions.Main.CollectTokens:Function()
    local tokensTable = {}
    local connection, s ,e
    local counter = 0

    local function Check(token)
        for i, v in pairs(tokensTable) do
            if v == token then
                return true
            end
        end
        return false
    end

    local function Collect(Token, Fast, check)
        local finished = false
        hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
        if Fast then
            hum.WalkSpeed = 95
        end
        hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        hrp.CFrame = CFrame.lookAt(hrp.Position, Token.Position + Vector3.new(0, hrp.Position.Y - Token.Position.Y, 0))
        hrp.Anchored = false
        hum:MoveTo(Token.Position + (hrp.CFrame.LookVector*3))
        Token:SetAttribute("Farmed", 1)
        local con
        con = hum.MoveToFinished:Connect(function()
            finished = true
            con:Disconnect()
            con = nil
        end)
        local startTime = os.clock()
        local endTime = startTime + 2.5
        while wait() and os.clock() <= endTime and not finished do 
            if Fast then
                hum.WalkSpeed = 95
            end
            if check and not Check(Token) then
                break
            end
        end
        if con then con:Disconnect() end
    end

    connection = workspace.Collectibles.ChildAdded:Connect(function(newChild)
        if newChild["Position"] and newChild["CFrame"] and newChild.Parent then
            if self.Free or (not self.Free and checkDistance(FieldToFarm, newChild, 50)) then
                local currentField = FieldToFarm
                table.insert(tokensTable, newChild)
                repeat wait() until not currentField == FieldToFarm or not newChild or not newChild.Parent or newChild.Transparency >= 0.9
                for i, v in pairs(tokensTable) do
                    if v == newChild then
                        table.remove(tokensTable, i)
                    end
                end
            end
        end
    end)

    local function DoTurn()
        hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

        if not self.Event and not self.Free then
            if workspace.Particles:FindFirstChild("Crosshair") then
                if (counter % 2) == 0 then
                    for i, v in pairs(workspace.Particles:GetChildren()) do
                        if v.Name == "Crosshair" then
                            v.Name = "Current"
                            Collect(v, true)
                            repeat wait() until not workspace.Particles:FindFirstChild("Current")
                            wait(0.1)
                        end
                    end
                else
                    wait(0.8)
                    for i, v in pairs(workspace.Particles:GetChildren()) do
                        if v.Name == "Crosshair" then
                            hrp.CFrame = v.CFrame
                            v.Name = "Activated"
                            wait(0.1)
                        end
                    end
                end
                counter += 1
            end
        end

        for i, v in pairs(tokensTable) do
            if not v:GetAttribute("Farmed") and v:FindFirstChild("FrontDecal") and v.FrontDecal.Texture == "rbxassetid://1629547638" then
                Collect(v, self.Speed or Speed, true)
                table.remove(tokensTable, i)
            end
        end
        
        for i, v in pairs(tokensTable) do
            if not self.Event then
                if not v:GetAttribute("Farmed") and v:FindFirstChild("FrontDecal") then
                    Collect(v, self.Speed or Speed, true)
                end
                table.remove(tokensTable, i)
            else
                if not v:GetAttribute("Farmed") and v:FindFirstChild("FrontDecal") and table.find(RareTokensDecals, v.FrontDecal.Texture) then
                    Collect(v, true, true)
                end
                table.remove(tokensTable, i)
            end
            if not self.Active or self.Paused then
                return
            end
            break
        end
    end

    while wait() and ExecState == getgenv().Executed do
        if self.Active and not self.Paused then
            s, e = pcall(DoTurn)
            if e then print("Collect tokens error: "..e) end
        end
    end
    connection:Disconnect()
end
coroutine.resume(coroutine.create(function()
    scriptFunctions.Main.CollectTokens:Function()
end)) -- ENDED HERE

folder1:Toggle("Auto-Collect Tokens", function(state)
    scriptFunctions.Main.CollectTokens.Active = state
end)

folder1:Toggle("Farm Sprouts", function(state)
    scriptFunctions.Main.FarmSprout.Enabled = state
end)

folder1:Toggle("Auto Quest (Alpha)", function(state)
    scriptFunctions.Main.AutoQuest.Enabled = state
end)

folder1:Toggle("Hunt Vicious Bee", function(state)
    scriptFunctions.Main.HuntVicious.Enabled = state
end)

folder1:Toggle("Hunt Windy Bee (Alpha)", function(state)
    scriptFunctions.Main.HuntWindy.Enabled = state
end)

folder1:Toggle("Hunt Mondo Chick", function(state)
    scriptFunctions.Main.HuntMondo.Enabled = state
end)

--[[folder1:Toggle("Dodge mobs", function(state)
    scriptFunctions.Main.DodgeMobs.Active = state
end)--]]

--[[folder1:Toggle("Activate Toys", function(state)
    ActivateToys = state
end)--]]

folder1:Toggle("Speed", function(state)
    Speed = state
end)

local window4 = library:CreateWindow("Spin Until Mythic")
local folder4 = window4:CreateFolder("Options")
local window5 = library:CreateWindow("Customizations")
local folder5 = window5:CreateFolder("Settings")

folder5:Box("Custom Speed", "number", function(value)
    CustomSpeed = value
end)

folder4:Label("SET UNTIL LEGENDARY AND CHOOSE BEE CELL!", {
    TextSize = 11;
    TextColor = Color3.fromRGB(58, 250, 0);
    BgColor = Color3.fromRGB(69,69,69);
})

local MythicBees = {"FuzzyBee", "VectorBee", "SpicyBee", "TadpoleBee", "BuoyantBee", "PreciseBee"}

scriptFunctions.Main.SpinMythics = {
    ["Active"] = false,
    ["SpinSettings"] = {}
}

folder4:Box("LeftToRight", "number", function(value)
    scriptFunctions.Main.SpinMythics.SpinSettings.LeftToRightJ = value
end)
folder4:Box("BottomToTop", "number", function(value)
    scriptFunctions.Main.SpinMythics.SpinSettings.BottomToTopJ = value
end)

function scriptFunctions.Main.SpinMythics:Function()
    local ourHive
    while wait() and ExecState == getgenv().Executed do
        if self.Active then
            if not ourHive then
                for i, v in pairs(workspace.Honeycombs:GetChildren()) do
                    if v:FindFirstChild("Owner") and v.Owner.Value == localplayer then
                        ourHive = v
                    end
                end
            end

            local cell = ourHive.Cells["C"..tostring(self.SpinSettings.LeftToRightJ)..","..tostring(self.SpinSettings.BottomToTopJ)]
            local cellBee = cell.CellType

            while self.Active and wait() and not table.find(MythicBees, cellBee.Value) or not cell:FindFirstChild("GiftedCell") do
                local Event = game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg
                Event:InvokeServer(tonumber(self.SpinSettings.LeftToRightJ), tonumber(self.SpinSettings.BottomToTopJ), "RoyalJelly")
            end
        end
    end
end
coroutine.resume(coroutine.create(function()
    scriptFunctions.Main.SpinMythics:Function()
end))

folder4:Toggle("Enabled", function(state)
    scriptFunctions.Main.SpinMythics.Active = state
end)

folder1:Button("Find Vicious Bee", function()
    for i, v in pairs(game:GetService("Workspace").Particles:GetChildren()) do
        if v.Name:find("Vicious") then
            Announce("Announcement", v.Name.." Bee found!!!")
            return
        end
    end
    Announce("Announcement", "There is not any vicious bee in the server.")
end)

local HiveCommandEvent = game:GetService("ReplicatedStorage").Events.PlayerHiveCommand
local function ConvertHoney()
    scriptFunctions.Main.CollectTokens.Paused = true
    Teleport(localplayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0,math.rad(180),0) + Vector3.new(0,0,8), false)
    wait(1)
    HiveCommandEvent:FireServer("ToggleHoneyMaking")
    repeat
        wait(1)
    until localplayer.CoreStats.Pollen.Value <= 0
    wait(8)
    scriptFunctions.Main.CollectTokens.Paused = false
end

local NPCFolder = workspace.NPCs

scriptFunctions.Main.HuntVicious = {
    ["Enabled"] = false,
    ["Paused"] = false
}

function scriptFunctions.Main.HuntVicious:Activate()
    local s, e, fieldSave
    local upVector = Vector3.new(0,20,0)
    local function TryHunt()
        for i, v in pairs(game:GetService("Workspace").Particles:GetChildren()) do
            if v.Name:find("Vicious") then
                if not fieldSave then
                    FieldToFarm = getField(v)
                end
                hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = v.CFrame + Vector3.new(0,10,0)
                wait(2)
                CreateVelocity()
                repeat
                    hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

                    for a, b in pairs(workspace.Collectibles:GetChildren()) do
                        if not b:GetAttribute("Collected") and b:FindFirstChild("FrontDecal") and b.FrontDecal.Texture == "rbxassetid://1629547638" and (b.Position - v.Position).magnitude >= ConvertToStuds(4.5) then
                            DestroyVelocity()
                            wait()
                            hrp.CFrame = b.CFrame
                            b:SetAttribute("Collected", 1)
                            wait(0.2)
                            CreateVelocity()
                        end
                    end
                    
                    if #createdVelocities == 0 then
                        CreateVelocity()
                    end
                   hrp.CFrame = v.CFrame + (v.CFrame.rightVector*10) + upVector
                    wait()
                until not workspace.Particles:FindFirstChild("Vicious") or not self.Enabled or self.Paused
                FieldToFarm = fieldSave
                DestroyVelocity()
            end
        end
    end

    repeat
        s, e = pcall(TryHunt)
        if e then
            if fieldSave then
                FieldToFarm = fieldSave
            end
            DestroyVelocity()
            reportError("HuntVicious Error: "..e)
            wait()
        end
    until s or not self.Enabled or self.Paused
end

local function GetLevel(text)
    local lvlstr = string.match(text, "[%d]+")
    local lvl = tonumber(lvlstr)
    return lvl
end

local function CheckForUnfinishedAction()
    for i, v in pairs(NPCFolder:GetChildren()) do
        if v.Platform.AlertPos.AlertGui.ImageLabel.ImageTransparency == 0 and v.Name ~= "Gummy Bear" then
            if v:FindFirstChild("Circle") then
                Teleport(v.Circle.CFrame + Vector3.new(0,5,0), false)
                wait(0.3)
                PressKey("e")
                repeat
                    for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click)) do
                        v:Fire()
                    end
                    wait(0.2)
                until game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.Visible == false
                CheckForUnfinishedAction()
            end
        end
    end
end

local killMobsData = {}
local function KillMob(text) -- REWRITE
    local function Try()
        for b, c in pairs(MonsterSpawners) do
            if text:find(tostring(b)) then
                if type(c) == "table" then
                    for d, e in pairs(c) do
                        for osu, ozu in pairs(game:GetService("ReplicatedStorage").MonsterTypes:GetChildren()) do
                            if string.find(ozu.Name, b) then
                                killMobsData.LastKilledTime = GetDataEvent:InvokeServer().MonsterTimes[e.Name]
                                killMobsData.MonsterSpawnTime = killMobsData.LastKilledTime + require(ozu).Stats.RespawnCooldown
                            end
                        end
                        if killMobsData.MonsterSpawnTime < os.time() then
                                for ab, cd in pairs(SpawnerFieldTable) do
                                    local spawnerField
                                    for abcd, efgh in pairs(Fields) do
                                        if string.find(string.lower(abcd), string.lower(cd)) then
                                            spawnerField = efgh
                                        end
                                    end

                                    if e.Name == ab then
                                        Teleport(spawnerField.CFrame, true)
                                        hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
                                        repeat
                                            if Speed then
                                                hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
                                                hum.WalkSpeed = CustomSpeed or math.random(70, 80)
                                            end
                                            wait()
                                        until killMobsData.LastKilledTime ~= GetDataEvent:InvokeServer().MonsterTimes[e.Name]
                                        wait(5)
                                    end
                                end
                        end 
                    end      
                else
                    for osu, ozu in pairs(game:GetService("ReplicatedStorage").MonsterTypes:GetChildren()) do
                        if string.find(ozu.Name, b) then
                            killMobsData.LastKilledTime = GetDataEvent:InvokeServer().MonsterTimes[c.Name]
                            killMobsData.MonsterSpawnTime = killMobsData.LastKilledTime + require(ozu).Stats.RespawnCooldown
                        end
                    end
                    if killMobsData.MonsterSpawnTime < os.time() then
                            for ab, cd in pairs(SpawnerFieldTable) do
                                local spawnerField
                                for abcd, efgh in pairs(Fields) do
                                    if string.find(string.lower(abcd), string.lower(cd)) then
                                        spawnerField = efgh
                                    end
                                end
                                if c.Name == ab then
                                    Teleport(spawnerField.CFrame, true)
                                    hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
                                    repeat
                                        if Speed then
                                            hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
                                            hum.WalkSpeed = CustomSpeed or math.random(70, 80)
                                        end
                                        wait()
                                    until GetDataEvent:InvokeServer().MonsterTimes[c.Name] ~= killMobsData.LastKilledTime
                                    wait(5)
                                end
                            end
                    end       
                end
            end
        end
    end
    
    local s, e = pcall(Try)
    if not s and e then
        reportError("KillMob Error: "..e)
        wait()
    end
end

scriptFunctions.Main.AutoQuest = {
    ["Enabled"] = false,
    ["Paused"] = false,
    ["QuestFarming"] = false,
    ["FieldSaved"] = false
}
function scriptFunctions.Main.AutoQuest:Activate()
    local questFolder = localplayer.PlayerGui.ScreenGui.Menus.Children.Quests.Content
    local s, e

    local function Try()
        CheckForUnfinishedAction()
        if questFolder:FindFirstChild("Frame") then
            local theLeast = math.huge
            local theLeastQuest

            if self.QuestFarming then
                if self.QuestFarming.Description.Text:find("Complete!") then
                    print("Farming quest finished: "..self.QuestFarming.Description.Text)
                    self.QuestFarming = false
                    FieldToFarm = self.FieldSaved
                    scriptFunctions.Main.Autofarm.AdaptField = true    
                end
            end

            for i, v in pairs(questFolder.Frame:GetDescendants()) do
                if v.Name == "TaskBar" and not string.find(v.Description.Text, "Complete!") then
                    if not self.QuestFarming and v.Description.Text:find("Collect") and (v.Description.Text:find("Pollen") or v.Description.Text:find("Goo")) then
                        if v.Description.Text:find("Field") or v.Description.Text:find("Patch") or v.Description.Text:find("Forest") then
                            local str1 = string.gsub(v.Description.Text, ",", "")
                            local lvl = GetLevel(str1)
                            if lvl < theLeast then
                                theLeast = lvl
                                theLeastQuest = v
                            end
                        else
                            if v.Description.Text:find("Red") then
                                local str1 = string.gsub(v.Description.Text, ",", "")
                                local lvl = GetLevel(str1)
                                if lvl < theLeast then
                                    theLeast = lvl
                                    theLeastQuest = v
                                end
                            elseif v.Description.Text:find("Blue") then
                                local str1 = string.gsub(v.Description.Text, ",", "")
                                local lvl = GetLevel(str1)
                                if lvl < theLeast then
                                    theLeast = lvl
                                    theLeastQuest = v
                                end
                            elseif v.Description.Text:find("White") then
                                local str1 = string.gsub(v.Description.Text, ",", "")
                                local lvl = GetLevel(str1)
                                if lvl < theLeast then
                                    theLeast = lvl
                                    theLeastQuest = v
                                end
                            end
                        end
                    elseif v.Description.Text:find("Defeat") then
                        scriptFunctions.Main.CollectTokens.Paused = true
                        KillMob(v.Description.Text)
                        scriptFunctions.Main.CollectTokens.Paused = false
                    end
                end
            end

            if not self.QuestFarming then
                for a, b in pairs(Fields) do
                    if theLeastQuest.Description.Text:find(a) then
                        self.FieldSaved = FieldToFarm
                        FieldToFarm = b
                        self.QuestFarming = theLeastQuest
                        scriptFunctions.Main.Autofarm.AdaptField = false
                        print("Farming: "..theLeastQuest.Description.Text)
                        return
                    end
                end

                if theLeastQuest.Description.Text:find("Red") then
                    self.FieldSaved = FieldToFarm
                    FieldToFarm = Fields["Pepper Patch"]
                    self.QuestFarming = theLeastQuest
                    scriptFunctions.Main.Autofarm.AdaptField = false
                    print("Farming: "..theLeastQuest.Description.Text)
                elseif theLeastQuest.Description.Text:find("Blue") then
                    self.FieldSaved = FieldToFarm
                    for i, v in pairs(Fields) do
                        if v.Name:find("Pine Tree") then
                            FieldToFarm = v
                        end
                    end
                    self.QuestFarming = theLeastQuest
                    scriptFunctions.Main.Autofarm.AdaptField = false
                    print("Farming: "..theLeastQuest.Description.Text)
                elseif theLeastQuest.Description.Text:find("White") then
                    self.FieldSaved = FieldToFarm
                    for i, v in pairs(Fields) do
                        if v.Name:find("Coconut") then
                            FieldToFarm = v
                        end
                    end
                    scriptFunctions.Main.Autofarm.AdaptField = false
                    self.QuestFarming = theLeastQuest
                    print("Farming: "..theLeastQuest.Description.Text)
                end
            end 
        else
            if self.QuestFarming then
                self.QuestFarming = false
                FieldToFarm = self.FieldSaved
                scriptFunctions.Main.Autofarm.AdaptField = true
            end
            Announce("WARNING", "Open Quest Tab!")
            wait(5)
        end
    end

    s, e = pcall(Try)

    if not s and e then
        reportError("AutoQuest Error: "..e)
    end
end

scriptFunctions.Main.FarmSprout = {
    ["Enabled"] = false,
    ["Paused"] = false,
}
function scriptFunctions.Main.FarmSprout:Activate() -- REMAKE

    local function Farm()
        while self.Enabled and not self.Paused and sproutsFolder:FindFirstChild("Sprout") and sproutsFolder.Sprout:GetAttribute("Current") and wait() do
            hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
            hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
            GetCollector().ClickEvent:FireServer(CFrame.new())
            if not checkDistance(FieldToFarm, hrp, 50) then
                Teleport(FieldToFarm.CFrame + Vector3.new(0,3,0), true)
            end
            if Speed then
                hum.WalkSpeed = CustomSpeed or math.random(70, 80)
            end
            if (localplayer.CoreStats.Pollen.Value / localplayer.CoreStats.Capacity.Value) >= 0.99 then
                ConvertHoney()
            end
        end
        local startTime = os.time()
        local endTime = startTime + 40
        scriptFunctions.Main.CollectTokens.Event = true
        repeat
            wait()
        until os.time() >= endTime or not self.Enabled or self.Paused
        scriptFunctions.Main.CollectTokens.Event = false
    end

    for i, v in pairs(sproutsFolder:GetChildren()) do
        if v.Name == "Sprout" and v.Transparency ~= 1 then
            local fieldSave = FieldToFarm
            FieldToFarm = getField(v)
            v:SetAttribute("Current", 1)
            local s, e
            repeat
                s, e = pcall(Farm)
                if not s and e then
                    reportError("FarmSprout Error: "..e)
                    wait()
                end
            until s or not scriptFunctions.Main.FarmSprout.Enabled or scriptFunctions.Main.FarmSprout.Paused
            scriptFunctions.Main.CollectTokens.Event = false
            FieldToFarm = fieldSave
        end
    end
end

scriptFunctions.Main.HuntWindy = {
    ["Enabled"] = false,
    ["Paused"] = false
}
function scriptFunctions.Main.HuntWindy:Activate()
    local windyFolder, upVector = workspace.NPCBees, Vector3.new(0,22,0)
    local s, e

    local function GetWindyLevel()
        for i, v in pairs(workspace.Monsters:GetChildren()) do
            if v.Name:find("Windy") then
                local lvl = GetLevel(v.Name)
                return lvl
            end
        end
    end

    local function Try()
        hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
        if windyFolder:FindFirstChild("Windy") then
            for i, v in pairs(windyFolder:GetChildren()) do
                if v.Name == "Windy" then
                    hrp.CFrame = v.CFrame
                    wait(0.8)
                end
            end
            wait(3)
            local trueWindy
            for i, v in pairs(windyFolder:GetChildren()) do
                if v.Name == "Windy" and v:FindFirstChild("Sound") then
                    trueWindy = v
                end
            end

            while self.Enabled and not self.Paused and windyFolder:FindFirstChild("Windy") and wait() do
                local newField
                repeat 
                    newField = getField(trueWindy)
                    wait()
                until not self.Enabled or self.Paused or newField

                CreateVelocity()
                local lastlvl = GetWindyLevel()
                scriptFunctions.Main.CollectTokens.Paused = true
                repeat
                    hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

                    for a, b in pairs(workspace.Collectibles:GetChildren()) do
                        if not b:GetAttribute("Collected") and b:FindFirstChild("FrontDecal") and b.FrontDecal.Texture == "rbxassetid://1629547638" then
                            DestroyVelocity()
                            hrp.CFrame = b.CFrame
                            b:SetAttribute("Collected", 1)
                            wait(0.2)
                            CreateVelocity()
                        end
                    end
                    
                    if #createdVelocities == 0 then
                        CreateVelocity()
                    end

                    localplayer.Character:WaitForChild("HumanoidRootPart").CFrame = trueWindy.CFrame + upVector
                    wait()

                    local currentLevel = GetWindyLevel()

                until currentLevel and currentLevel > lastlvl or not self.Enabled or self.Paused
                DestroyVelocity()
                scriptFunctions.Main.CollectTokens.Paused = false
                wait(10)
                repeat
                    newField = getField(trueWindy)
                    wait()
                until not self.Enabled or self.Paused or newField
            end
        end
    end
 
    if windyFolder:FindFirstChild("Windy") then
        local fieldSave = FieldToFarm
        repeat
            s, e = pcall(Try)
            if not s and e then
                DestroyVelocity()
                reportError("HuntWindy Error: "..e)
                wait()
            end
        until s or not self.Enabled or self.Paused
        scriptFunctions.Main.CollectTokens.Paused = false
        FieldToFarm = fieldSave
    end
end


scriptFunctions.Main.HuntMondo = {
    ["Enabled"] = false,
    ["Paused"] = false
}
function scriptFunctions.Main.HuntMondo:Activate() -- REMAKE
    local targetVector = Vector3.new(30, 0, 0)
    local saveField, s, e

    local function Try()
        for i, v in pairs(workspace.Monsters:GetChildren()) do
            if v.Name:find("Mondo") then
                if not saveField then
                    saveField = FieldToFarm
                end
                FieldToFarm = getField(v.Torso)
                CreateVelocity()
                repeat
                    hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
                    for a, b in pairs(workspace.Collectibles:GetChildren()) do
                        if not b:GetAttribute("Collected") and b:FindFirstChild("FrontDecal") and b.FrontDecal.Texture == "rbxassetid://1629547638" and (b.Position - v.Torso.Position).magnitude >= ConvertToStuds(4.5) then
                            DestroyVelocity()
                            wait()
                            hrp.CFrame = b.CFrame
                            b:SetAttribute("Collected", 1)
                            wait(0.2)
                            CreateVelocity()
                        end
                    end
                    if #createdVelocities <= 0 then
                        CreateVelocity()
                    end
                    hrp.CFrame = v.Torso.CFrame + targetVector
                    wait()
                until not game:GetService("Workspace").Monsters:FindFirstChild(v.Name) or not self.Enabled or self.Paused
                DestroyVelocity()
                Teleport(FieldToFarm.CFrame + Vector3.new(0,3,0), false)
                if self.Enabled and not self.Paused then
                    scriptFunctions.Main.CollectTokens.Event = true
                    local startTime = os.time()
                    local endTime = startTime + 58
                    repeat 
                        wait()
                    until os.time() >= endTime or not self.Enabled or self.Paused
                    FieldToFarm = saveField
                    DestroyVelocity()
                    scriptFunctions.Main.CollectTokens.Event = false
                end
            end
        end
    end
    repeat
        s, e = pcall(Try)
        if e then
            if saveField then
                FieldToFarm = saveField
            end
            DestroyVelocity()
            reportError("HuntMondo Error: "..e)
            wait()
        end
    until s or not self.Enabled or self.Paused
    scriptFunctions.Main.CollectTokens.Event = false
end

Announce("VERSION "..Version, "Updates in console - press f9")

scriptFunctions.Main.Autofarm = {
    ["Enabled"] = false,
    ["Paused"] = false,
    ["AdaptField"] = true
}

while wait() and ExecState == getgenv().Executed do -- CHECK
        if Speed then
            hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
            hum.WalkSpeed = CustomSpeed or math.random(70, 80)
        end

        if scriptFunctions.Main.FarmSprout.Enabled then
            scriptFunctions.Main.FarmSprout:Activate()
        end

        if scriptFunctions.Main.HuntWindy.Enabled then
            scriptFunctions.Main.HuntWindy:Activate()
        end

        if scriptFunctions.Main.HuntVicious.Enabled then
            scriptFunctions.Main.HuntVicious:Activate()
        end

        if scriptFunctions.Main.HuntMondo.Enabled then
            for i, v in pairs(game:GetService("Workspace").Monsters:GetChildren()) do
                if v.Name:find("Mondo") then
                    scriptFunctions.Main.HuntMondo:Activate()
                end
            end
        end

        if scriptFunctions.Main.AutoQuest.Enabled then
            scriptFunctions.Main.AutoQuest:Activate()
        end 

        --[[local skip = false
        if ActivateToys then
            hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
            local newVec = Vector3.new(0,3,0)
            local toysFolder = workspace.Toys
            for i, v in pairs(GetDataEvent:InvokeServer().ToyTimes) do
                local toy = toysFolder:FindFirstChild(i)
                if toy and not toy:GetAttribute("Wrong") and toy:FindFirstChild("Cooldown") and not toy.Name:find("Memory") and not toy.Name:find("Converter") and not toy.Name:find("Amulet") and not toy.Name:find("Ant") and not toy.Name:find("Royal") and not toy.Name:find("Snowbear") then
                    local lastTime = v
                    local nextTime = v + toy.Cooldown.Value
                    if os.time() > nextTime and toy:FindFirstChild("Platform"):FindFirstChild("Circle") then
                        hrp.CFrame = toy.Platform.Circle.CFrame + newVec
                        wait(0.3)
                        local guiColor = localplayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3
                        if guiColor == Color3.fromRGB(201,39,28) then
                            toy:SetAttribute("Wrong", 1)
                        end
                        PressKey("e")
                        wait(1)
                        skip = true
                    end
                end
            end
        end--]]
        --if not skip then
            hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
            if scriptFunctions.Main.Autofarm.Enabled and not scriptFunctions.Main.Autofarm.Paused then
                local s, e = pcall(function()
                    if scriptFunctions.Main.Autofarm.AdaptField and FieldChosen then
                        FieldToFarm = FieldChosen
                        FieldChosen = nil
                    end
                    GetCollector().ClickEvent:FireServer(CFrame.new())
                    if not checkDistance(FieldToFarm, hrp, 50) then
                        Teleport(FieldToFarm.CFrame + Vector3.new(0,3,0), true)
                    end
                    if (localplayer.CoreStats.Pollen.Value / localplayer.CoreStats.Capacity.Value) >= 0.99 then
                        ConvertHoney()
                    end
                end)
                if e then
                    reportError("Autofarm Error: "..e)
                end
            end
       -- end
end
