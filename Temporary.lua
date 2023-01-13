local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local window1 = library:CreateWindow("Autofarm")
local folder1 = window1:CreateFolder("Options")

local createdVelocities = {}
local errorTable = {}
local scriptFunctions = {
	["Main"] = {},
	["Side"] = {}
}

local Version = "PRE-RELEASE - 0.2" --try puffshroom farm, tryall functions
warn("----------------------------------------------------------")
print("Script Version "..Version)
print("You can view updates on our discord")
warn("-----------------------------------------------------------")

local localplayer = game.Players.LocalPlayer
local hrp, hum
local snailCFrame = CFrame.new(423.75528, 68.4725342, -169.562302, 0.999474823, -3.15616511e-08, -0.0324050412, 3.34170878e-08, 1, 5.67160541e-08, 0.0324050412, -5.77691495e-08, 0.999474823)

getgenv().Executed = not getgenv().Executed
local ExecState = getgenv().Executed

local function Announce(title, text)
	game.StarterGui:SetCore("SendNotification", {
		Title = tostring(title);
		Text = tostring(text)
	})
end

local playerHive
local playerBees = 0
spawn(function()
	while not playerHive do
		local combs = workspace.Honeycombs:GetChildren()
		for i = 1, #combs, 1 do
			if combs[i]:FindFirstChild("Owner") and combs[i].Owner.Value == localplayer then
				playerHive = combs[i]
				break
			end
		end
		wait()
	end

	local cells = playerHive.Cells:GetChildren()
	for i = 1, #cells, 1 do
		if cells[i].CellType.Value ~= "Empty" then
			playerBees += 1
		end
	end
end)

local function reportError(message)
	if not errorTable[message] then
		errorTable[message] = true
	end
	print(message)
end

local getTool = game:GetService("ReplicatedStorage").Events.PlayerActivesCommand

local function SpawnSplinker()
	game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
end

local function CreateVelocity()
	local antivelocity = Instance.new("BodyVelocity")
	antivelocity.Parent = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
	antivelocity.Name = "BodyVelocityR"
	antivelocity.Velocity = Vector3.new(0,0,0)
	antivelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	createdVelocities[#createdVelocities + 1] = antivelocity
end

local function DestroyVelocity()
	for i = #createdVelocities, 1, -1 do
		createdVelocities[i]:Destroy()
		createdVelocities[i] = nil
	end
end

local sproutsFolder = game:GetService("Workspace").Particles.Folder2


local monsterSpawners = workspace.MonsterSpawners
local MonsterSpawners = {
	Spider = monsterSpawners["Spider Cave"],
	Rhino = {
		CloverField = monsterSpawners["Rhino Bush"],
		BlueflowerField = monsterSpawners["Rhino Cave 1"],
		BambooField = monsterSpawners["Rhino Cave 3"],
	};
	Werewol = monsterSpawners.WerewolfCave,
	Scorpion = monsterSpawners.RoseBush,
	Ladybug = {
		CloverField = monsterSpawners["Ladybug Bush"],
		MushroomField = monsterSpawners["MushroomBush"],
		StrawberryField = monsterSpawners["Ladybug Bush 2"],
	};
	Mantis = {
		PineTreeField = monsterSpawners.ForestMantis1,
		PineappleField = monsterSpawners.PineappleMantis1,
	};
}

local FieldsFolder = workspace.FlowerZones
local Fields = FieldsFolder:GetChildren()

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
local excludedDecalNames = {
	["BasicIcon"] = true,
	["TreatIcon"] = true,
	["EvictionIcon"] = true,
	["RoboPassIcon"] = true,
	["SprinklerBuilderIcon"] = true,
	["SpiritPetalIcon"] = true,
	["BeequipStorageSlotIcon"] = true,
	["GummyBounds"] = true,
	["BeequipCaseSlotIcon"] = true,
}

local FieldToFarm, FieldFarming
local decals = game:GetService("ReplicatedStorage").EggTypes:GetChildren()

for i = 1, #decals do
	local v = decals[i]
	if v:IsA("Decal") and not excludedDecalNames[v.Name] then
		RareTokensDecals[#RareTokensDecals + 1] = v.Texture
	end
end


local function GetCollector()
	return localplayer.Character:FindFirstChildOfClass("Tool") or localplayer.Backpack:FindFirstChildOfClass("Tool")
end

local function checkDistance(regionPart, part, sizeY)
	local regionPos = regionPart.Position
	local regionSize = regionPart.Size
	local minX = regionPos.X - regionSize.X / 2
	local maxX = regionPos.X + regionSize.X / 2
	local minZ = regionPos.Z - regionSize.Z / 2
	local maxZ = regionPos.Z + regionSize.Z / 2
	local minY = regionPos.Y - (sizeY/3 or regionSize.Y/2)
	local maxY = regionPos.Y + (sizeY/2 or regionSize.Y/2)

	local partPos = part.Position
	return (partPos.X < maxX and partPos.X > minX and partPos.Z < maxZ and partPos.Z > minZ and partPos.Y < maxY and partPos.Y > minY)
end

local function getField(part)
	for i = 1, #Fields, 1 do
		if checkDistance(Fields[i], part, 75) then
			return Fields[i]
		end
	end
end

scriptFunctions.Main.Autofarm = {
	["Enabled"] = false,
	["Paused"] = false,
	["FieldChosen"] = nil
}


folder1:Dropdown("Choose field", Fields, true, function(option)
	scriptFunctions.Main.Autofarm.FieldChosen = FieldsFolder[option]
	Announce("Autofarm", "New Target Field: "..option)
end)

print("Please choose target field")
Announce("WARNING", "Please choose target field")

local tempNum = 0
while ExecState == getgenv().Executed and not scriptFunctions.Main.Autofarm.FieldChosen and wait() do
	tempNum += 1
	if tempNum == 200 then
		tempNum = 0
		Announce("WARNING", "Please choose target field")
	end
end

local UI = {
	["Settings"] = {},
	["Markers"] = {}
}

UI.Settings.MyScreenGui = Instance.new("ScreenGui")
UI.Settings.MyFrame = Instance.new("Frame")
local Name = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local Scrollingframe = Instance.new("ScrollingFrame")

function UI.Settings:Setup(frame, text)
	local newFrame = Instance.new("TextLabel")

	newFrame.Parent = Scrollingframe
	newFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	newFrame.BackgroundTransparency = 1.000
	newFrame.BorderSizePixel = 0
	newFrame.ClipsDescendants = true
	newFrame.Position = UDim2.new(0.055555556, 0, 0, 0)
	newFrame.Size = UDim2.new(0, 197, 0, 25)
	newFrame.Font = Enum.Font.Gotham
	newFrame.Text = text
	newFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	newFrame.TextSize = 15.000
	newFrame.TextWrapped = true
	newFrame.TextXAlignment = Enum.TextXAlignment.Left
	newFrame.TextYAlignment = Enum.TextYAlignment.Bottom

	UI.Markers[frame] = newFrame
end

local UIListLayout = Instance.new("UIListLayout")
UI.Settings.MyScreenGui.Name = "MyScreenGui"
UI.Settings.MyScreenGui.Parent = game.CoreGui
UI.Settings.MyScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.Settings.MyFrame.Parent = UI.Settings.MyScreenGui
UI.Settings.MyFrame.BackgroundColor3 = Color3.fromRGB(74, 74, 74)
UI.Settings.MyFrame.BorderSizePixel = 0
UI.Settings.MyFrame.Position = UDim2.new(0.552, 0, 0.049, 0)
UI.Settings.MyFrame.Size = UDim2.new(0, 216, 0, 563)
Name.Name = "Name"
Name.Parent = UI.Settings.MyFrame
Name.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
Name.BorderSizePixel = 0
Name.Size = UDim2.new(0, 216, 0, 44)
TextLabel.Parent = Name
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.ClipsDescendants = true
TextLabel.Size = UDim2.new(0, 216, 0, 44)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "Script achievements"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 20.000
Scrollingframe.Name = "Scrolling frame"
Scrollingframe.Parent = UI.Settings.MyFrame
Scrollingframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Scrollingframe.BackgroundTransparency = 1.000
Scrollingframe.BorderSizePixel = 0
Scrollingframe.Position = UDim2.new(0, 0, 0.0781527534, 0)
Scrollingframe.Selectable = false
Scrollingframe.Size = UDim2.new(0, 216, 0, 519)
Scrollingframe.CanvasPosition = Vector2.new(0, 0)

UIListLayout.Parent = Scrollingframe
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

UI.Settings:Setup("HoneyGainedInst", "Honey gained:")
UI.Settings:Setup("SproutsFarmedInst", "Sprouts farmed:")
UI.Settings:Setup("PuffFarmedInst", "Puffshrooms farmed:")
UI.Settings:Setup("ViciousKilledInst", "Vicious killed:")
UI.Settings:Setup("MondoKilledInst", "Mondo's killed:")
UI.Settings:Setup("WindyKilledInst", "Windy bees killed:")
UI.Settings:Setup("TextLabel_8", "-----Tokens Recieved-----")
UI.Settings:Setup("Mythic", "Mythic Eggs:")
UI.Settings:Setup("Star", "Star Eggs:")
UI.Settings:Setup("StarTreat", "Star treats:")
UI.Settings:Setup("ColourEggs", "Colour Eggs:")
UI.Settings:Setup("SuperSmoothie", "Super Smoothies:")
UI.Settings:Setup("PurplePotion", "Purple potions:")
UI.Settings:Setup("StarJelly", "Star Jellies:")
UI.Settings:Setup("MagicBean", "Magic beans:")
UI.Settings:Setup("Micro-Converter", "Micro Converters:")
UI.Settings:Setup("TropicalDrink", "Tropical drinks:")
UI.Settings:Setup("Neonberry", "Neonberries:")
UI.Settings:Setup("Bitterberry", "Bitterberries:")
UI.Settings:Setup("CloudVial", "Cloud vials:")
UI.Settings:Setup("MarshmellowBee", "Marshmellow bees:")
UI.Settings:Setup("FieldDice", "Field dices:")
UI.Settings:Setup("Glitter", "Glitters:")
UI.Settings:Setup("Enzymes", "Enzymes:")
UI.Settings:Setup("Oil", "Oils:")
UI.Settings:Setup("Glue", "Glues:")
UI.Settings:Setup("RedExtract", "Red Extracts:")
UI.Settings:Setup("BlueExtract", "Blue Extracts:")
UI.Settings:Setup("Mooncharm", "Mooncharms:")
UI.Settings:Setup("Ticket", "Tickets:")
UI.Settings:Setup("Coconut", "Coconuts:")
UI.Settings:Setup("RoyalJelly", "Royal Jellies:")
UI.Settings:Setup("Gumdrops", "Gumdrops:")
UI.Settings:Setup("Strawberry", "Strawberries:")
UI.Settings:Setup("Pineapple", "Pineapples:")
UI.Settings:Setup("TextLabel_37", "")
UI.Settings:Setup("Sunflowerseed", "Sunflower Seeds:")
UI.Settings:Setup("Blueberry", "Blueberries:")

UI.Settings.MyScreenGui.Enabled = false

-------------------- not mine --------------------
local UIS = game:GetService('UserInputService')
local frame = UI.Settings.MyFrame
local dragToggle = nil
local dragSpeed = 0.25
local dragStart = nil
local startPos = nil

local function updateInput(input)
 local delta = input.Position - dragStart
 local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
 game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

frame.InputBegan:Connect(function(input)
 if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
  dragToggle = true
  dragStart = input.Position
  startPos = frame.Position
  input.Changed:Connect(function()
   if input.UserInputState == Enum.UserInputState.End then
    dragToggle = false
   end
  end)
 end
end)

UIS.InputChanged:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
  if dragToggle then
   updateInput(input)
  end
 end
end)

local numbers = {{"k"}, {"Mil"}, {"Bil"}, {"Tril"}, {"Quad"}, {"Quint"}, {"Sext"}, {"Sept"}, {"Oct"}, {"Non"}, {"Dec"}, {"Und"}, {"Duo"}, {"Tred"}, {"Quat"}, {"Quind"}, {"Sexdecillion"}, {"Septen-decillion"}, {"Octodecillion"}, {"Novemdecillion"}, {"Vigintillion"}}
local last = 1000
for i, v in pairs(numbers) do
    table.insert(v, 1, last)
    last = last*1000
end

local function Calculate(number)
    local word = {1, ""}
    for i, v in pairs(numbers) do
        if number >= v[1] then
            word = v
        end
    end
    if string.sub((number/word[1]), 3, 3) ~= "." then
        return string.sub((number/word[1]), 1, 3) .. word[2]
    else
        return string.sub((number/word[1]), 1, 2) .. word[2]
    end
end
-----------------------------------------------------------------

local GetDataEvent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats

local main = {}
main.StartValues = {}

main.StartHoneyAmount = GetDataEvent:InvokeServer().Totals.Honey

for i, v in pairs(GetDataEvent:InvokeServer().Totals.EggsReceived) do
    main.StartValues[i] = v
end

setmetatable(main.StartValues, {
    __index = function(table, index)
        print("Tried to get "..tostring(index).." from table main.StartValues which was nil. Returned 0, metatable 1")
        return 0
    end
})

main.DefaultLength = {}

for i, v in pairs(GetDataEvent:InvokeServer().Totals.EggsReceived) do
    if UI.Markers[i] then
        main.DefaultLength[i] = UI.Markers[i].Text
    end
end

main.HoneySaved = nil

main.CurrentColourEggs = 0
main.DEFColourEggs = 0
main.SaveColourEggs = 0
local filename = "LukeBSS.json"
local def = {
    HoneySaved = 0,
    SproutsFarmed = 0,
	PuffFarmed = 0,
    ViciousKilled = 0,
    MondoKilled = 0,
	WindyKilled = 0,
    ColourEggsNum = 0,
}
for i, v in pairs(GetDataEvent:InvokeServer().Totals.EggsReceived) do
    if UI.Markers[i] then
        def[i] = 0
    end
end
main.ColourEggs = 0
for i, v in pairs(main.StartValues) do
    if i == "Diamond" then
        main.ColourEggs = main.ColourEggs + main.StartValues.Diamond
    elseif i == "Gold" then
        main.ColourEggs = main.ColourEggs + main.StartValues.Gold
    elseif i == "Silver" then
        main.ColourEggs = main.ColourEggs + main.StartValues.Silver
    elseif i == "GiftedSilver" then
        main.ColourEggs = main.ColourEggs + main.StartValues.GiftedSilver
    elseif i == "GiftedGold" then
        main.ColourEggs = main.ColourEggs + main.StartValues.GiftedGold
    end
end
main.SavedValues = {}
if not pcall(function() readfile(filename) end) then writefile(filename, game:GetService("HttpService"):JSONEncode(def)) end
main.Settings = game:GetService("HttpService"):JSONDecode(readfile(filename))
main.HoneySaved = main.Settings.HoneySaved
main.SproutsFarmed = main.Settings.SproutsFarmed
main.PuffFarmed = main.Settings.PuffFarmed
main.ViciousKilled = main.Settings.ViciousKilled
main.MondoKilled = main.Settings.MondoKilled
main.WindyKilled = main.Settings.WindyKilled
main.SaveColourEggs = main.Settings.ColourEggsNum

for i, v in pairs(GetDataEvent:InvokeServer().Totals.EggsReceived) do
    if UI.Markers[i] and main.Settings[i] then
        main.SavedValues[i] = main.Settings[i]
    else
        if UI.Markers[i] then
            main.SavedValues[i] = 0
        end
    end
end

setmetatable(main, {
    __index = function(table, index)
        print("Tried to get "..tostring(index).." from table main which was nil. Returned 0, metatable 2")
        main[index] = 0
        return 0
    end
})

function save()
    main.Settings.HoneySaved = main.HoneyToSave
    main.Settings.SproutsFarmed = main.SproutsFarmed
	main.Settings.PuffFarmed = main.PuffFarmed
    main.Settings.ViciousKilled = main.ViciousKilled
    main.Settings.MondoKilled = main.MondoKilled
	main.Settings.WindyKilled = main.WindyKilled
    main.Settings.ColourEggsNum = main.SaveColourEggs
    for i, v in pairs(GetDataEvent:InvokeServer().Totals.EggsReceived) do
        if UI.Markers[i] then
            main.Settings[i] = v - main.StartValues[i] + main.SavedValues[i]
        end
    end
    writefile(filename,game:GetService("HttpService"):JSONEncode(main.Settings))
end

spawn(function()
    while wait(1) and ExecState == getgenv().Executed do
        main.HoneyToSave = GetDataEvent:InvokeServer().Totals.Honey - main.StartHoneyAmount + main.HoneySaved
        UI.Markers.HoneyGainedInst.Text = "Honey Gained: "..tostring(Calculate(math.floor(main.HoneyToSave + main.HoneySaved)))
        UI.Markers.SproutsFarmedInst.Text = "Sprouts farmed: "..tostring(main.SproutsFarmed)
		UI.Markers.PuffFarmedInst.Text = "Puffshrooms farmed: "..tostring(main.PuffFarmed)
    	UI.Markers.ViciousKilledInst.Text = "Vicious killed: "..tostring(main.ViciousKilled)
        UI.Markers.MondoKilledInst.Text = "Mondo killed: "..tostring(main.MondoKilled)
		UI.Markers.WindyKilledInst.Text = "Windy bees killed: "..tostring(main.WindyKilled)

        for i, v in pairs(GetDataEvent:InvokeServer().Totals.EggsReceived) do
            if UI.Markers[i] then
				print(UI.Markers[i].Text)
                UI.Markers[i].Text = main.DefaultLength[i].." "..tostring(v - main.StartValues[i] + main.SavedValues[i])
			end
        end
        local gaga = GetDataEvent:InvokeServer().Totals.EggsReceived
        local vla = main.CurrentColourEggs
        for i, v in pairs(main.StartValues) do
            if i == "Diamond" then
                main.CurrentColourEggs = main.CurrentColourEggs + gaga.Diamond
            elseif i == "Gold" then
                main.CurrentColourEggs = main.CurrentColourEggs + gaga.Gold
            elseif i == "Silver" then
                main.CurrentColourEggs = main.CurrentColourEggs + gaga.Silver
            elseif i == "GiftedSilver" then
                main.CurrentColourEggs = main.CurrentColourEggs + gaga.GiftedSilver
            elseif i == "GiftedGold" then
                main.CurrentColourEggs = main.CurrentColourEggs + gaga.GiftedGold
            end
        end
        main.CurrentColourEggs = main.CurrentColourEggs - vla
        main.DEFColourEggs = main.CurrentColourEggs - main.ColourEggs
        main.SaveColourEggs = main.DEFColourEggs + main.SaveColourEggs
        UI.Markers.ColourEggs.Text = "Colour Eggs: "..tostring(main.DEFColourEggs)
		save()
    end
	UI.Settings.MyScreenGui:Destroy()
	UI.Settings.MyFrame:Destroy()
end)

folder1:Toggle("Script achievements", function(state)
    UI.Settings.MyScreenGui.Enabled = state
end)

local VS = game:GetService("VirtualUser")
local function PressKey(key)
	VS:CaptureController()
	VS:TypeKey(key)
end
localplayer.Idled:Connect(function()
	VS:CaptureController()
	VS:ClickButton2(Vector2.new())
end)

local temp = workspace.Collectibles:GetChildren()
for i = 1, #temp, 1 do
	if temp[i]["Transparency"] and temp[i].Transparency ~= 0 then
		temp[i]:Destroy()
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

local function ConvertToMeters(studs)
	return studs / (25/7)
end

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)

local function Tween(position, build, speed)
	hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
	tweenInfo.Time = (hrp.Position - position.Position).magnitude / (speed or 180)

	local newPos = {
		CFrame = position
	}
	local TweenProcess = tweenService:Create(hrp, tweenInfo, newPos)
	CreateVelocity()
	TweenProcess:Play()

	while TweenProcess.Status == Enum.TweenStatus.Playing do
		wait()
	end

	DestroyVelocity()
	if build then
		SpawnSplinker()
	end
end


local GetDataEvent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats

local function Teleport(location, build)
	hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")

	hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
	hrp.CFrame = location

	if build then
		wait(.5)
		SpawnSplinker()
	end
end

if workspace:FindFirstChild("FieldDecos") then
	workspace.FieldDecos:Destroy() 
end

scriptFunctions.Main.DodgeMobs = {
	["Active"] = false,
	["Paused"] = false,
}

function scriptFunctions.Main.DodgeMobs:Function()
	local upVec = Vector3.new(0, 15, 0)
	local biggestRadius, nearest, shortestMag, partB, monsters

	while true do
		if scriptFunctions.Main.DodgeMobs.Active and not scriptFunctions.Main.DodgeMobs.Paused then
			biggestRadius = 0
			nearest = nil
			shortestMag = math.huge
			partB = nil
			monsters = workspace.Monsters:GetChildren()
			hrp = localplayer.Character:FindFirstChild("HumanoidRootPart")

			for _, v in pairs(monsters) do
				if hrp and v["PrimaryPart"] and v:FindFirstChild("LookAt") and v.LookAt.Value and (hrp.Position - v.PrimaryPart.Position).magnitude <= ConvertToStuds(15) and not v.Name:find("Mondo") and not v.Name:find("Vicious") and not v.Name:find("Snail") and not v.Name:find("King") and not v.Name:find("Coconut") and not v.Name:find("Windy") then
					partB = v.PrimaryPart
					biggestRadius = math.max(biggestRadius, (v:FindFirstChild("Config") or v:WaitForChild("Config")).AttackRadius.Value)
					local tempMag = (partB.Position - hrp.Position).magnitude
					if tempMag < shortestMag then
						shortestMag = tempMag
						nearest = v
					end
				end
			end

			if nearest then
				partB = nearest.PrimaryPart
				CreateVelocity()
				hrp.CFrame = hrp.CFrame + upVec
				wait(1.8)
				hrp.CFrame = partB.CFrame - (partB.CFrame.LookVector * (biggestRadius + 2.5))
				DestroyVelocity()
			end
		end
		if ExecState ~= getgenv().Executed then break end
		wait()
	end
end
coroutine.resume(coroutine.create(function()
	scriptFunctions.Main.DodgeMobs:Function()
end))

FieldFarming = scriptFunctions.Main.Autofarm.FieldChosen
temp, tempNum = nil, nil

local Speed, ActivateToys, CustomSpeed

folder1:Toggle("Autofarm", function(state)
	scriptFunctions.Main.Autofarm.Enabled = state
end)

local puffCFrame = nil

scriptFunctions.Main.CollectTokens = {
	["Active"] = false,
	["Paused"] = false,
	["Event"] = false,
	["Speed"] = false,
	["Free"] = false,
	["Puffsrooming"] = false
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

	local function Collect(token, fast)
		hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
		hrp.CFrame = CFrame.lookAt(hrp.Position, token.Position + Vector3.new(0, hrp.Position.Y - token.Position.Y, 0))
		hum:MoveTo(token.Position + (hrp.CFrame.LookVector * 3))
		token:SetAttribute("Farmed", 1)

		local start_time = os.clock()
		local end_time = start_time + 2.5
		while Check(token) and os.clock() <= end_time and not self.Paused and self.Active do
			if fast then
				hum.WalkSpeed = 95
			end
			if (hrp.Position - token.Position).Magnitude <= 8 then
				break
			end
			wait()
		end
		hum:ChangeState("Idle")
	end

	local function newToken(newChild)
		if not (newChild["Position"] and newChild["CFrame"] and newChild.Parent) then
			local start_time = os.clock()
			while not (newChild["Position"] and newChild["CFrame"] and newChild.Parent and os.clock() > (start_time + 5)) do
				wait()
			end
			if os.clock() > (start_time + 5) then
				newChild:Destroy()
				return
			end
		end
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
		local frontDecal = newChild:FindFirstChild("FrontDecal")
		local mag = ConvertToMeters((newChild.Position - hrp.Position).Magnitude)

		if frontDecal and ((mag <= 40) or (mag > 40 and table.find(RareTokensDecals, frontDecal.Texture))) then
			table.insert(tokensTable, newChild)
			repeat wait() until not (newChild or newChild.Parent) or newChild.Transparency >= 0.9
				
			for i, v in pairs(tokensTable) do
				if v == newChild then
					table.remove(tokensTable, i)
				end
			end
		end
	end

	connection = workspace.Collectibles.ChildAdded:Connect(newToken)
	
	local function DoTurn()
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

		if not (self.Event and self.Free and self.Paused and self.Puffsrooming) then
			if workspace.Particles:FindFirstChild("Crosshair") then
				local particles, count = workspace.Particles:GetChildren(), 0
				local obj

				for i = 1, #particles, 1 do
					obj = particles[i]
					if obj.Name == "Crosshair" and checkDistance(FieldToFarm or FieldFarming, obj, 50) then
						if (counter % 2) == 0 then
							obj.Name = "Current"
							Collect(obj, true)
							repeat wait() until not workspace.Particles:FindFirstChild("Current")
							wait(0.2)
							break
						else
							obj.Name = "Activated"
							Teleport(obj.CFrame)
							count += 1
							if count >= 3 then
								count = 0
								break
							end
							wait(0.2)
						end
					end
				end

				counter += 1
			end
		end

		for i = 1, #tokensTable, 1 do
			local v = tokensTable[i]

			if v then
				local frontDecal = v:FindFirstChild("FrontDecal")
				if v:GetAttribute("Farmed") or not frontDecal then
					table.remove(tokensTable, i)
					continue
				end

				if frontDecal and frontDecal.Texture == "rbxassetid://1629547638" then
					Collect(v, true)
					table.remove(tokensTable, i)
				end
			end
		end

		local frontDecal, mag

		for i = 1, #tokensTable, 1 do
			local v = tokensTable[i]

			if v then
				frontDecal = v:FindFirstChild("FrontDecal")
				mag = ConvertToMeters((hrp.Position - v.Position).Magnitude)

				if frontDecal then
					if self.Event then
						if mag <= 25 and table.find(RareTokensDecals, frontDecal.Texture) then
							Collect(v, true)
							table.remove(tokensTable, i)
							break
						end
					elseif self.Puffsrooming then
						if mag <= 25 and (v.Position - puffCFrame.Position).Magnitude <= ConvertToStuds(7) then
							Collect(v, self.Speed or Speed)
							table.remove(tokensTable, i)
							break
						end
					else
						if (self.Free and mag <= 25) or (not self.Free and checkDistance(FieldToFarm or FieldFarming, v, 50)) then
							Collect(v, self.Speed or Speed)
							table.remove(tokensTable, i)
							break
						end
					end
				end
			end
		end
	end

	while wait() and ExecState == getgenv().Executed do
		if self.Active and not self.Paused then
			self.Free = not scriptFunctions.Main.Autofarm.Enabled
			s, e = pcall(DoTurn)
			if e then print("Collect tokens error: "..e) end
		end
	end
	self.Active = false
	connection:Disconnect()
end
coroutine.resume(coroutine.create(function()
	scriptFunctions.Main.CollectTokens:Function()
end))

folder1:Toggle("Auto-Collect Tokens", function(state)
	scriptFunctions.Main.CollectTokens.Active = state
end)

folder1:Toggle("Farm Sprouts", function(state)
	scriptFunctions.Main.FarmSprout.Enabled = state
end)

folder1:Toggle("Auto Quest (Beta)", function(state)
	scriptFunctions.Main.AutoQuest.Enabled = state
end)

folder1:Toggle("Hunt Vicious Bee", function(state)
	scriptFunctions.Main.HuntVicious.Enabled = state
end)

folder1:Toggle("Hunt Windy Bee (Beta)", function(state)
	scriptFunctions.Main.HuntWindy.Enabled = state
end)

folder1:Toggle("Hunt Mondo Chick", function(state)
	scriptFunctions.Main.HuntMondo.Enabled = state
end)

folder1:Toggle("Dodge mobs", function(state)
	scriptFunctions.Main.DodgeMobs.Active = state
end)

folder1:Toggle("Activate Toys", function(state)
    ActivateToys = state
end)

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
	while wait() and ExecState == getgenv().Executed do
		if self.Active then
			if not playerHive then
				Announce("WARNING", "Claim Hive please.")
				wait(5)
				continue
			end

			local cell = playerHive.Cells["C"..tostring(self.SpinSettings.LeftToRightJ)..","..tostring(self.SpinSettings.BottomToTopJ)]
			local cellBee = cell.CellType

			while self.Active and not table.find(MythicBees, cellBee.Value) and ExecState == getgenv().Executed do
				local Event = game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg
				Event:InvokeServer(tonumber(self.SpinSettings.LeftToRightJ), tonumber(self.SpinSettings.BottomToTopJ), "RoyalJelly")
				wait(0.05)
				cellBee = cell.CellType
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

folder1:Button("Farm Snail", function()
	local functions = scriptFunctions.Main
	if not functions.Autofarm.Enabled and functions.CollectTokens.Active then
		Teleport(snailCFrame, false)
	else
		Announce("WARNING", "You have to disable Autofarm and enable Token Collection.")
	end
end)

local HiveCommandEvent = game:GetService("ReplicatedStorage").Events.PlayerHiveCommand
local CollectTokens = scriptFunctions.Main.CollectTokens
local pollen = localplayer.CoreStats.Pollen

local function ConvertHoney()
	CollectTokens.Paused = true
	local targetPos = localplayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0,math.rad(180),0) + Vector3.new(0,0,5)
	Teleport(targetPos, false)
	wait(1)
	HiveCommandEvent:FireServer("ToggleHoneyMaking")
	while wait() and pollen.Value > 0 do
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
		if (hrp.Position - targetPos.Position).Magnitude > 8 then
			return ConvertHoney()
		end
	end
	wait(8)
	CollectTokens.Paused = false
end

local NPCFolder = workspace.NPCs

scriptFunctions.Main.HuntVicious = {
	["Enabled"] = false,
	["Paused"] = false
}

function scriptFunctions.Main.HuntVicious:Activate()
	local upVector = Vector3.new(0,20,0)

	local function TryHunt()
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

		local viciousParticle = workspace.Particles:FindFirstChild("Vicious")
		if viciousParticle then
			hrp.CFrame = viciousParticle.CFrame + Vector3.new(0, 10, 0)
			wait(2)
			CreateVelocity()

			while wait() and ExecState == getgenv().Executed and viciousParticle and scriptFunctions.Main.HuntVicious.Enabled and not scriptFunctions.Main.HuntVicious.Paused do
				hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
				for _, collectible in pairs(workspace.Collectibles:GetChildren()) do
					if not collectible:GetAttribute("Collected") and collectible:FindFirstChild("FrontDecal") and collectible.FrontDecal.Texture == "rbxassetid://1629547638" and (collectible.Position - viciousParticle.Position).magnitude >= ConvertToStuds(4.5) then
						DestroyVelocity()
						wait()
						Teleport(collectible.CFrame, false)
						collectible:SetAttribute("Collected", 1)
						wait(0.2)
						CreateVelocity()
					end
				end

				if #createdVelocities == 0 then
					CreateVelocity()
				end
				hrp.CFrame = viciousParticle.CFrame + (viciousParticle.CFrame.rightVector * 10) + upVector
				viciousParticle = workspace.Particles:FindFirstChild("Vicious")
			end

			if not viciousParticle then
				main.ViciousKilled += 1
			end
			DestroyVelocity()
		end
	end

	while scriptFunctions.Main.HuntVicious.Enabled and not scriptFunctions.Main.HuntVicious.Paused and ExecState == getgenv().Executed and wait() do
		local success, error = pcall(TryHunt)
		if not success and error then
			DestroyVelocity()
			reportError("HuntVicious Error: " .. error)
			wait()
		else
			break
		end
	end
end

local function GetLevel(text)
	return tonumber(text:match("%d+"))
end

scriptFunctions.Side.CheckForUnfinishedAction = {
	["Excluded"] = {},
}

local function CheckForUnfinishedAction()
	local npcs = NPCFolder:GetChildren()
	local excluded = scriptFunctions.Side.CheckForUnfinishedAction.Excluded

	for i, v in ipairs(npcs) do
		if v.Name ~= "Gummy Bear" and not excluded[v.Name] then
			local alertGui = v.Platform.AlertPos.AlertGui
			if alertGui.ImageLabel.ImageTransparency == 0 then
				if v:FindFirstChild("Circle") then
					Teleport(v.Circle.CFrame + Vector3.new(0, 5, 0), false)
					wait(0.3)
					PressKey("e")
					local screenGui = localplayer.PlayerGui.ScreenGui
					local start_time = os.clock()
					while screenGui.NPC.Visible == true and os.clock() < (start_time + 30) do
						for _, x in pairs(getconnections(screenGui.NPC.ButtonOverlay.MouseButton1Click)) do
							x:Fire()
						end
						wait(0.2)
					end
					if os.clock() < start_time + 30 then
						return CheckForUnfinishedAction()
					else
						scriptFunctions.Side.CheckForUnfinishedAction.Excluded[v.Name] = true
					end
				end
			end
		end
	end
end

local function KillMob(text)
	local pattern = "([%a]+)"
	local monster = string.match(text, pattern)
	print("Monster: " .. monster)

	local spawner
	for i, v in pairs(MonsterSpawners) do
		if type(v) == "table" then
			for field, spawnerObject in pairs(v) do
				if string.find(field, monster) then
					spawner = spawnerObject
					break
				end
			end
		elseif string.find(i, monster) then
			spawner = v
			break
		end
	end

	if not spawner then
		print("Error: could not find spawner for monster " .. monster)
		return
	end

	local field
	for fieldName, fieldObject in pairs(Fields) do
		if string.find(fieldName, SpawnerFieldTable[spawner.Name]) then
			field = fieldObject
			break
		end
	end
	Teleport(field.CFrame, true)

	local lastKilledTime = GetDataEvent:InvokeServer().MonsterTimes[spawner.Name]
	local monsterType = nil
	for _, v in pairs(game:GetService("ReplicatedStorage").MonsterTypes:GetChildren()) do
		if string.find(v.Name, monster) then
			monsterType = v
			break
		end
	end
	local monsterSpawnTime = lastKilledTime + require(monsterType).Stats.RespawnCooldown
	while lastKilledTime == GetDataEvent:InvokeServer().MonsterTimes[spawner.Name] do
		wait(1)
	end
end

scriptFunctions.Main.PuffshroomFarm = {
	["Enabled"] = false,
	["Paused"] = false,
	["ConvertHoney"] = true,
	["Rarities"] = {"Mythic", "Legendary", "Epic", "Rare"},
}

local puffFolder = workspace.Happenings.Puffshrooms

function scriptFunctions.Main.PuffshroomFarm:Function()

	local function GetLevelP(shroom)
		if shroom == 0 then return shroom end
		for i, v in pairs(shroom:GetChildren()) do
			if v.Name:find("Top") and v:FindFirstChild("Attachment") and v.Attachment.Gui:FindFirstChild("NameRow") then
				local lvlHolder = v.Attachment.Gui.NameRow.TextLabel
				local lvlStr = string.match(lvlHolder.Text, "[%d]+")
				local lvl = tonumber(lvlStr)
				return lvl
			end
		end
	end

	local function getCFrame(shroom)
		local tempT, v = shroom:GetChildren()
		for c = 1, #tempT do
			v = tempT[c]
			if string.find(v.Name, "Stem") then
				return v.CFrame
			end
		end
	end
	
	local function Try()
		local target, v, highestLVL

		while #puffFolder:GetChildren() > 0 and self.Enabled and not self.Paused and ExecState == getgenv().Executed do
			local puffTable = puffFolder:GetChildren()
			highestLVL, puffCFrame, target, v = 0, nil, nil, nil

			for _, x in ipairs(self.Rarities) do
				for b = 1, #puffTable do
					v = puffTable[b]
					if string.find(v.Name, x) then
						target = v
						puffCFrame = getCFrame(v)
						break
					else
						if GetLevelP(v) >= 10 then
							highestLVL = v
						end
					end
				end
				if target then
					break
				end
			end

			if not target then
				if highestLVL == 0 then
					for i = 1, #puffTable do
						v = puffTable[i]
						highestLVL = math.max(GetLevelP(v), GetLevelP(highestLVL))
						puffCFrame = getCFrame(v)
					end
				end
				target = highestLVL
			end

			scriptFunctions.Main.CollectTokens.Puffsrooming = true

			while wait() and self.Enabled and not self.Paused and ExecState == getgenv().Executed do
				hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
				hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")

				if Speed then
					hum.WalkSpeed = Speed
				end

				if (hrp.Position - puffCFrame.Position).Magnitude > ConvertToStuds(7) then
					Teleport(puffCFrame, true)
				end
				GetCollector().ClickEvent:FireServer(CFrame.new())

				if not (target or target.Parent) then
					scriptFunctions.Main.CollectTokens.Puffsrooming = false
					scriptFunctions.Main.CollectTokens.Event = true
					wait(6)
					scriptFunctions.Main.CollectTokens.Event = false
					main.PuffFarmed += 1
					break
				end

				if (localplayer.CoreStats.Pollen.Value / localplayer.CoreStats.Capacity.Value) >= 0.99 and self.ConvertHoney then
					ConvertHoney()
				end

			end

		end
	end

	local s, e

	while self.Enabled and ExecState == getgenv().Executed and not self.Paused do
		s, e = pcall(Try)

		if not s and e then
			reportError("Puffshroom farm error: ")
			wait()
		end
	end
end

folder1:Toggle("Farm Puffshrooms (Alpha)", function(state)
	scriptFunctions.Main.PuffshroomFarm.Enabled = state
	if state then
		Announce("Honey Conversion during puffshroom farm", "If you prefer to not convert honey during puffs you disable it in options.")
	end
end)

folder5:Toggle("Don't convert during Puff", function(state)
    scriptFunctions.Main.PuffshroomFarm.ConvertHoney = state
end)

scriptFunctions.Main.AutoQuest = {
	["Enabled"] = false,
	["Paused"] = false,
	["QuestFarming"] = false,
	["FieldSaved"] = nil
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
					self.FieldSaved = nil
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
						print("Farming: "..theLeastQuest.Description.Text)
						return
					end
				end

				if theLeastQuest.Description.Text:find("Red") then
					self.FieldSaved = FieldToFarm
					FieldToFarm = Fields["Pepper Patch"]
					self.QuestFarming = theLeastQuest
					print("Farming: "..theLeastQuest.Description.Text)
				elseif theLeastQuest.Description.Text:find("Blue") then
					for i, v in pairs(Fields) do
						if v.Name:find("Pine Tree") then
							self.FieldSaved = FieldToFarm
							FieldToFarm = v
							break
						end
					end
					self.QuestFarming = theLeastQuest
					print("Farming: "..theLeastQuest.Description.Text)
				elseif theLeastQuest.Description.Text:find("White") then
					for i, v in pairs(Fields) do
						if v.Name:find("Coconut") then
							self.FieldSaved = FieldToFarm
							FieldToFarm = v
							break
						end
					end
					self.QuestFarming = theLeastQuest
					print("Farming: "..theLeastQuest.Description.Text)
				end
			end 
		else
			if self.QuestFarming then
				self.QuestFarming = false
				FieldToFarm = self.FieldSaved
				self.FieldSaved = nil
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
function scriptFunctions.Main.FarmSprout:Activate()
	local function Farm(sprout, field)
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart")
		hum = localplayer.Character:FindFirstChild("Humanoid")

		while wait() and sprout and sprout.Parent and ExecState == getgenv().Executed and not self.Paused and self.Enabled do
			GetCollector().ClickEvent:FireServer(CFrame.new())
			if not checkDistance(field, hrp, 50) then
				Teleport(field.CFrame + Vector3.new(0,3,0), true)
			end
			if Speed then
				hum.WalkSpeed = CustomSpeed or math.random(70, 80)
			end
			if (localplayer.CoreStats.Pollen.Value / localplayer.CoreStats.Capacity.Value) >= 0.99 then
				ConvertHoney()
			end
		end

		if not (sprout or sprout.Parent) then
			local startTime = os.time()
			local endTime = startTime + 40
			scriptFunctions.Main.CollectTokens.Event = true
			while os.time() < endTime and self.Enabled and not self.Paused do
				wait()
			end
			scriptFunctions.Main.CollectTokens.Event = false
			main.SproutsFarmed += 1
		end
	end

	for i, v in pairs(sproutsFolder:GetChildren()) do
		if v.Name == "Sprout" and v.Transparency ~= 1 and v:GetAttribute("Current") then
			local fieldSaved = FieldToFarm
			local field = getField(v)
			FieldToFarm = field
			Farm(v, field)
			FieldToFarm = fieldSaved
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

	local function getTrueWindy()
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
		for i, v in pairs(windyFolder:GetChildren()) do
			if v.Name == "Windy" then
				Teleport(v.CFrame, false)
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
		return trueWindy
	end

	local function Try()
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
		if windyFolder:FindFirstChild("Windy") then
			local trueWindy = getTrueWindy()
			local newField, currentLevel

			while self.Enabled and not self.Paused and windyFolder:FindFirstChild("Windy") and wait() do
				repeat
					newField = getField(trueWindy)
					wait()
				until not self.Enabled or self.Paused or newField

				CreateVelocity()
				local lastlvl = GetWindyLevel()
				scriptFunctions.Main.CollectTokens.Paused = true
				repeat
					hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

					for _, collectible in pairs(workspace.Collectibles:GetChildren()) do
						if not collectible:GetAttribute("Collected") and collectible:FindFirstChild("FrontDecal") and collectible.FrontDecal.Texture == "rbxassetid://1629547638" then
							DestroyVelocity()
							wait()
							Teleport(collectible.CFrame, false)
							collectible:SetAttribute("Collected", 1)
							wait(0.2)
							CreateVelocity()
						end
					end

					if #createdVelocities == 0 then
						CreateVelocity()
					end

					localplayer.Character:WaitForChild("HumanoidRootPart").CFrame = trueWindy.CFrame + upVector
					wait()

					currentLevel = GetWindyLevel()

				until currentLevel and currentLevel > lastlvl or not self.Enabled or self.Paused or not getField(trueWindy) or not windyFolder:FindFirstChild("Windy")

				DestroyVelocity()
				scriptFunctions.Main.CollectTokens.Paused = false
				newField, currentLevel = false, nil

				if currentLevel and currentLevel <= lastlvl and self.Enabled and not self.Paused then
					continue
				end

				wait(10)
				repeat
					newField = getField(trueWindy)
					wait()
				until not self.Enabled or self.Paused or newField or not windyFolder:FindFirstChild("Windy")
				newField = false
			end

			if not windyFolder:FindFirstChild("Windy") then
				main.WindyKilled += 1
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
		until s or not self.Enabled or self.Paused or not windyFolder:FindFirstChild("Windy")
		scriptFunctions.Main.CollectTokens.Paused = false
		FieldToFarm = fieldSave
	end
end


scriptFunctions.Main.HuntMondo = {
	["Enabled"] = false,
	["Paused"] = false
}
function scriptFunctions.Main.HuntMondo:Activate()
	local targetVector = Vector3.new(30, 0, 0)
	local saveField, s, e
	local monsters = workspace.Monsters

	local function Try()
		for i, v in pairs(workspace.Monsters:GetChildren()) do
			if v.Name:find("Mondo") then
				local currField = getField(v.Torso)
				CreateVelocity()
				repeat
					hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
					for _, collectible in pairs(workspace.Collectibles:GetChildren()) do
						if not collectible:GetAttribute("Collected") and collectible:FindFirstChild("FrontDecal") and collectible.FrontDecal.Texture == "rbxassetid://1629547638" and (collectible.Position - v.Torso.Position).magnitude >= ConvertToStuds(5) then
							DestroyVelocity()
							wait()
							Teleport(collectible.CFrame, false)
							collectible:SetAttribute("Collected", 1)
							wait(0.2)
							CreateVelocity()
						end
					end
					if #createdVelocities <= 0 then
						CreateVelocity()
					end
					hrp.CFrame = v.Torso.CFrame + targetVector
					wait()
				until not monsters:FindFirstChild(v.Name) or not self.Enabled or self.Paused

				DestroyVelocity()

				if not monsters:FindFirstChild(v.Name) then
					Teleport(currField.CFrame + Vector3.new(0,6,0), false)

					scriptFunctions.Main.CollectTokens.Event = true
					local startTime = os.time()
					local endTime = startTime + 58
					repeat
						wait()
					until os.time() >= endTime or not self.Enabled or self.Paused
					DestroyVelocity()
					scriptFunctions.Main.CollectTokens.Event = false
					main.MondoKilled += 1
					break
				end
			end
		end
	end
	repeat
		s, e = pcall(Try)
		if not s and e then
			DestroyVelocity()
			reportError("HuntMondo Error: "..e)
			wait()
		end
	until s or not self.Enabled or self.Paused
	scriptFunctions.Main.CollectTokens.Event = false
end

Announce("VERSION "..Version, "Updates in console - press f9")

local mainFunctions

while wait() and ExecState == getgenv().Executed do
	mainFunctions = scriptFunctions.Main

	if Speed then
		hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
		hum.WalkSpeed = CustomSpeed or math.random(70, 80)
	end

	if mainFunctions.PuffshroomFarm.Enabled then
		if #puffFolder:GetChildren() >= 1 then
			mainFunctions.PuffshroomFarm:Function()
		end
	end

	if mainFunctions.FarmSprout.Enabled then
		mainFunctions.FarmSprout:Activate()
	end

	if mainFunctions.HuntWindy.Enabled then
		mainFunctions.HuntWindy:Activate()
	end

	if mainFunctions.HuntVicious.Enabled then
		mainFunctions.HuntVicious:Activate()
	end

	if mainFunctions.HuntMondo.Enabled then
		for i, v in pairs(game:GetService("Workspace").Monsters:GetChildren()) do
			if v.Name:find("Mondo") then
				mainFunctions.HuntMondo:Activate()
			end
		end
	end

	if mainFunctions.AutoQuest.Enabled then
		mainFunctions.AutoQuest:Activate()
	end 

	if ActivateToys then
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
		local newVec = Vector3.new(0,3,0)
		local toysFolder = workspace.Toys
		for i, v in pairs(GetDataEvent:InvokeServer().ToyTimes) do
			local toy = toysFolder:FindFirstChild(i)
			if toy and not toy:GetAttribute("Wrong") and toy:FindFirstChild("Cooldown") and not toy.Name:find("Memory") and not toy.Name:find("Converter") and not toy.Name:find("Amulet") and not toy.Name:find("Ant") and not toy.Name:find("Royal") and not toy.Name:find("Snowbear") then
				local nextTime = v + toy.Cooldown.Value
				if os.time() > nextTime and toy:FindFirstChild("Platform"):FindFirstChild("Circle") then
					Teleport(toy.Platform.Circle.CFrame + newVec)
					wait(0.3)
					local guiColor = localplayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3
					if guiColor == Color3.fromRGB(201,39,28) then
						toy:SetAttribute("Wrong", 1)
					end
					PressKey("e")
					wait(1)
				end
			end
		end
	end

	hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
	if mainFunctions.Autofarm.Enabled and not mainFunctions.Autofarm.Paused then
		local s, e = pcall(function()
			if not FieldToFarm then
				FieldFarming = mainFunctions.Autofarm.FieldChosen
			else
				FieldFarming = FieldToFarm
			end
			GetCollector().ClickEvent:FireServer(CFrame.new())
			if not checkDistance(FieldFarming, hrp, 50) then
				Teleport(FieldFarming.CFrame + Vector3.new(0,3,0), true)
			end
			if (localplayer.CoreStats.Pollen.Value / localplayer.CoreStats.Capacity.Value) >= 0.99 then
				ConvertHoney()
			end
		end)
		if e then
			reportError("Autofarm Error: "..e)
		end
	end
end
