local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local window1 = library:CreateWindow("Autofarm")
local folder1 = window1:CreateFolder("Options")

local createdVelocities = {}
local errorTable = {}
local scriptFunctions = {
	["Main"] = {},
	["Side"] = {}
}

local Version = "PRE-RELEASE - 0.1" --try to break after each token, tryall functions
warn("----------------------------------------------------------")
print("Script Version "..Version)
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
		if checkDistance(Fields[i], part, 50) then
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

	local function Collect(token, fast)
		hum = localplayer.Character:FindFirstChild("Humanoid") or localplayer.Character:WaitForChild("Humanoid")
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
		hrp.CFrame = CFrame.lookAt(hrp.Position, token.Position + Vector3.new(0, hrp.Position.Y - token.Position.Y, 0))
		hum:MoveTo(token.Position + (hrp.CFrame.LookVector * 3))
		token:SetAttribute("Farmed", 1)

		local start_time = os.clock()
		local end_time = start_time + 2.5
		while not self.Paused and self.Active and Check(token) and os.clock() <= end_time do
			if fast then
				hum.WalkSpeed = 95
			end
			if (hrp.Position - token.Position).Magnitude <= 2 then
				break
			end
			wait()
		end
		hum:ChangeState("Idle")
	end

	connection = workspace.Collectibles.ChildAdded:Connect(function(newChild)
		if not (newChild["Position"] and newChild["CFrame"] and newChild.Parent) then
			return
		end
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

		if (self.Free and (hrp.Position - newChild.Position).Magnitude < ConvertToStuds(25)) or (not self.Free and checkDistance(FieldToFarm or FieldFarming, newChild, 50)) then
			local freeOrigin = self.Free
			local currentField = FieldToFarm
			table.insert(tokensTable, newChild)


			local removed = false
			while not removed do
				if not currentField == (FieldToFarm or FieldFarming) or not newChild or not newChild.Parent or newChild.Transparency >= 0.9 or not freeOrigin == self.Free or self.Paused then
					for i, v in pairs(tokensTable) do
						if v == newChild then
							table.remove(tokensTable, i)
							removed = true
							break
						end
					end
				end
				wait()
			end
		end
	end)

	local function DoTurn()
		hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")

		if not self.Event and not self.Free and not self.Paused then
			if workspace.Particles:FindFirstChild("Crosshair") then
				local particles = workspace.Particles:GetChildren()
				local obj

				for i = 1, #particles, 1 do
					obj = particles[i]
					if obj.Name == "Crosshair" and checkDistance(FieldToFarm or FieldFarming, obj, 50) then
						if (counter % 2) == 0 then
							obj.Name = "Current"
							Collect(obj, true)
							repeat wait() until not workspace.Particles:FindFirstChild("Current")
							wait(0.5)
							break
						else
							obj.Name = "Activated"
							Teleport(obj.CFrame)
							wait(0.5)
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
				if (hrp.Position - v.Position).Magnitude > ConvertToStuds(30) or v:GetAttribute("Farmed") or not frontDecal then
					table.remove(tokensTable, i)
					continue
				end

				if frontDecal and frontDecal.Texture == "rbxassetid://1629547638" then
					Collect(v, self.Speed or Speed)
					table.remove(tokensTable, i)
				end

				if not self.Active or self.Paused then
					return
				end
			end
		end

		for i = 1, #tokensTable, 1 do
			local v = tokensTable[i]

			if v then
				local frontDecal = v:FindFirstChild("FrontDecal")
				if (hrp.Position - v.Position).Magnitude > ConvertToStuds(30) or v:GetAttribute("Farmed") or not frontDecal then
					table.remove(tokensTable, i)
					continue
				end

				if not self.Event and frontDecal then
					Collect(v, self.Speed or Speed)
					table.remove(tokensTable, i)
				elseif self.Event and frontDecal and table.find(RareTokensDecals, frontDecal.Texture) then
					Collect(v, true)
					table.remove(tokensTable, i)
				end

				if not self.Active or self.Paused then
					return
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
	Teleport(snailCFrame, false)
	Announce("Announcement", "Turn off autofarm and enable token collection.")
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
		if (hrp.Position - targetPos.Position).Magnitude > 2 then
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

		while scriptFunctions.Main.HuntVicious.Enabled and not scriptFunctions.Main.HuntVicious.Paused do
			local viciousParticle = workspace.Particles:FindFirstChild("Vicious")
			if viciousParticle then
				hrp.CFrame = viciousParticle.CFrame + Vector3.new(0, 10, 0)
				wait(2)
				CreateVelocity()

				while viciousParticle and scriptFunctions.Main.HuntVicious.Enabled and not scriptFunctions.Main.HuntVicious.Paused do
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
				DestroyVelocity()
			end
		end
	end

	while scriptFunctions.Main.HuntVicious.Enabled and not scriptFunctions.Main.HuntVicious.Paused and ExecState == getgenv().Executed and wait() do
		local success, error = pcall(TryHunt)
		if not success and error then
			DestroyVelocity()
			reportError("HuntVicious Error: " .. error)
			wait()
		end
	end
end

local function GetLevel(text)
	return tonumber(text:match("%d+"))
end

local function CheckForUnfinishedAction()
	local npcs = NPCFolder:GetChildren()
	for i, v in ipairs(npcs) do
		if v.Name ~= "Gummy Bear" then
			local alertGui = v.Platform.AlertPos.AlertGui
			if alertGui.ImageLabel.ImageTransparency == 0 then
				if v:FindFirstChild("Circle") then
					Teleport(v.Circle.CFrame + Vector3.new(0, 5, 0), false)
					wait(0.3)
					PressKey("e")
					local screenGui = localplayer.PlayerGui.ScreenGui
					while screenGui.NPC.Visible == true do
						for _, x in pairs(getconnections(screenGui.NPC.ButtonOverlay.MouseButton1Click)) do
							x:Fire()
						end
						wait(0.2)
					end
					CheckForUnfinishedAction()
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

		local startTime = os.time()
		local endTime = startTime + 40
		scriptFunctions.Main.CollectTokens.Event = true
		while os.time() < endTime and self.Enabled and not self.Paused do
			wait()
		end
		scriptFunctions.Main.CollectTokens.Event = false
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

				until currentLevel and currentLevel > lastlvl or not self.Enabled or self.Paused or not getField(trueWindy)

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
				until not self.Enabled or self.Paused or newField
				newField = false
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
				Teleport(currField.CFrame + Vector3.new(0,6,0), false)

				scriptFunctions.Main.CollectTokens.Event = true
				local startTime = os.time()
				local endTime = startTime + 58
				repeat 
					wait()
				until os.time() >= endTime or not self.Enabled or self.Paused
				DestroyVelocity()
				scriptFunctions.Main.CollectTokens.Event = false
				break
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

while wait() and ExecState == getgenv().Executed do

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

	hrp = localplayer.Character:FindFirstChild("HumanoidRootPart") or localplayer.Character:WaitForChild("HumanoidRootPart")
	if scriptFunctions.Main.Autofarm.Enabled and not scriptFunctions.Main.Autofarm.Paused then
		local s, e = pcall(function()
			if not FieldToFarm then
				FieldFarming = scriptFunctions.Main.Autofarm.FieldChosen
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
