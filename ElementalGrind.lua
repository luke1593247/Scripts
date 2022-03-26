
getgenv().WantedElements = {
    "Dragon";
    "Destruction";
    "Heaven's Wrath";
    "Acceleration";
    "Arc of the Elements";
    "Time";
    "Hydra";
    "Illusion";
    "Cosmic";
    "Phoenix";
    "Solar";
    "Necromancer";
    "Telekinesis";
    "Sound"; 
    "Armament";
    "Plasma";
    "Radiation";
    "Chaos";
    "Lava";
    "Prism";
    "Illusion";
    "Lunar";

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local localplayer = game.Players.LocalPlayer
main = {
    windows = {};
}
main.Commons = "nil"
main.Uncommons = "nil"
main.Rares = "nil"
main.Legends = "nil"
main.Myths = "nil"
main.TotalSpins = "nil"
local filename = "ElementalGrindSavedData.json"
local default = {
Spins = 0;
Commons = 0;
Uncommons = 0;
Rares = 0;
Legends = 0;
Myths = 0;
}
if not pcall(function() readfile(filename) end) then writefile(filename, game:GetService("HttpService"):JSONEncode(default)) end

main.Settings = game:GetService("HttpService"):JSONDecode(readfile(filename))
main.TotalSpins = main.Settings.Spins
main.Commons = main.Settings.Commons
main.Uncommons = main.Settings.Uncommons
main.Rares = main.Settings.Rares
main.Legends = main.Settings.Legends
main.Myths = main.Settings.Myths

function save()
    main.Settings.Spins = main.TotalSpins
    main.Settings.Commons = main.Commons
    main.Settings.Uncommons = main.Uncommons
    main.Settings.Rares = main.Rares
    main.Settings.Legends = main.Legends
    main.Settings.Myths = main.Myths
    writefile(filename,game:GetService("HttpService"):JSONEncode(main.Settings))
end

spawn(function()
    while wait(5) do
        save()
    end
end)

main.values = {}

main.functions = {}

main.WantedElements = {}
main.NotificationVolume = 2
main.ElementRarities = {
    Wind = "Common";
    Earth = "Common";
    Water = "Common";
    Wood = "Common";
    Lightning = "Common";
    Ice = "Common";
    Light = "Common";
    Dark = "Common";
    Sand = "Common";
    Poison = "Common";
    Fire = "Common";
    Blood = "Uncommon";
    Metal = "Uncommon";
    Explosion = "Uncommon";
    Nova = "Uncommon";
    Armament = "Rare";
    Plasma = "Rare";
    Radiation = "Rare";
    Chaos = "Rare";
    Sound = "Rare";
    Lava = "Rare";
    Mechanization = "Rare";
    Prism = "Legend";
    Illusion = "Legend";
    Lunar = "Legend";
    Hydra = "Legend";
    Cosmic = "Legend";
    Phoenix = "Legend";
    Solar = "Legend";
    Necromancer = "Myth";
    Telekinesis = "Myth";
    Destruction = "Myth";
    Time = "Myth";
    ["Arc of the Elements"] = "Myth";
    Acceleration = "Myth";
    ["Heaven's Wrath"] = "Myth";
    Dragon = "Myth";
}

print("---------------Wanted Elements-----------------")
for i, v in pairs(getgenv().WantedElements) do
    table.insert(main.WantedElements, v)
    print(v)
end
print("------------------------------------------------")


local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()

main.window1 = {}

main.window1.Gui = library:CreateWindow("Autofarm")
main.window1.folder1 = main.window1.Gui:CreateFolder("Options")


main.window1.folder1:Toggle("Element Farm", function(state)
    main.ElementFarm = state
end)

main.currentElementRarity = "nil"

main.window1.folder1:Toggle("Level Farm", function(state)
    main.LevelFarm = state
end)

main.ShowLuck = false

main.window1.folder1:Toggle("Show Luck Stats", function(state)
    main.ShowLuck = state
end)

main.Song = Instance.new("Sound")
main.Song.Looped = false
main.Song.SoundId = "rbxassetid://204032720"
main.Song.Parent = game.CoreGui
main.Song.Volume = 2

main.window1.folder1:Toggle("Sound Notification if I get wanted element", function(state)
    main.SoundNotif = state
end)

main.window1.folder1:Box("Volume", "number", function(state)
    main.Song.Volume = state
end)

main.window1.folder1:Button("Play Notification", function()
    main.Song:Play()
end)

main.window1.folder1:Button("Print Luck Stats", function()
    print("Please mind that your luck stats will be more precise the more total spins you have, best 5k+")
    wait()
    print("Total Spins: "..tostring(main.TotalSpins).." Ideal Spins: 5k+")
    print("Luck = {\n Common's = "..tostring((main.Commons / main.TotalSpins) * 100).."%\n Uncommon's = Your's: "..tostring((main.Uncommons / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 10) * 100).."%\n Rare's = Your's: "..tostring((main.Rares / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 250) * 100).."%\n Legend's = Your's: "..tostring((main.Legends / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 1250) * 100).."%\n Myth's = Your's: "..tostring((main.Myths / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 2500) * 100).."%\n}")
end)

main.Events = {}

main.ServerSpins = 0

main.Events.GetElement = game:GetService("ReplicatedStorage").Client.GetElement
main.Events.Spin = game:GetService("ReplicatedStorage").Client.Spin
main.Events.GetSpins = game:GetService("ReplicatedStorage").Client.GetSpins
main.PlayerGui = localplayer.PlayerGui
main.currentElement = tostring(main.Events.GetElement:InvokeServer())

local VS = game:GetService("VirtualUser")

function main.functions.Spin()
    main.ServerSpins = main.ServerSpins + 1
    if main.TotalSpins ~= "nil" then
        main.TotalSpins = main.TotalSpins + 1
    end       
    main.Events.Spin:InvokeServer()
    wait()
    main.currentElement = tostring(main.Events.GetElement:InvokeServer())
    wait()
    if main.ElementRarities[main.currentElement] ~= nil then
        main.currentElementRarity = main.ElementRarities[main.currentElement]
    else
        main.currentElementRarity = "Unknown"
    end
    print("New Element: "..main.currentElement..", Rarity: "..main.currentElementRarity..", Spins Remaining: "..tostring(main.Events.GetSpins:InvokeServer()).."  ||||  Spinned: "..tostring(main.ServerSpins).." Times, Total Spins: "..tostring(main.TotalSpins))
    if main.ElementRarities[main.currentElement] ~= nil then
        if main.ElementRarities[main.currentElement] == "Common" and main.Commons ~= "nil" then
            main.Commons = main.Commons + 1
        elseif main.ElementRarities[main.currentElement] == "Uncommon" and main.Uncommons ~= "nil" then
            main.Uncommons = main.Uncommons + 1
        elseif main.ElementRarities[main.currentElement] == "Rare" and main.Rares ~= "nil" then
            main.Rares = main.Rares + 1
        elseif main.ElementRarities[main.currentElement] == "Legend" and main.Legends ~= "nil" then
            main.Legends = main.Legends + 1
        elseif main.ElementRarities[main.currentElement] == "Myth" and main.Myths ~= "nil" then
            main.Myths = main.Myths + 1
        end
        if main.ShowLuck == true then
            print("Please mind that your luck stats will be more precise the more total spins you have, best 5k+")
            wait()
            print("Total Spins: "..tostring(main.TotalSpins)..", Ideal Spins: 5k+")
            print("Luck = {\n Common's = "..tostring((main.Commons / main.TotalSpins) * 100).."%\n Uncommon's = Your's: "..tostring((main.Uncommons / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 10) * 100).."%\n Rare's = Your's: "..tostring((main.Rares / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 250) * 100).."%\n Legend's = Your's: "..tostring((main.Legends / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 1250) * 100).."%\n Myth's = Your's: "..tostring((main.Myths / main.TotalSpins) * 100).."%, Default: "..tostring((1 / 2500) * 100).."%\n}")
        end
    end
    if table.find(main.WantedElements, main.currentElement) ~= nil then
        print("Wanted Element Obtained: "..main.currentElement)
        main.ElementFarm = "Done"
        if main.SoundNotif then
            main.Song:Play()
        end
    end
    repeat wait() until not localplayer:FindFirstChild("SpinCooldown")
end

main.functions.ToMenu = function()
    if not main.PlayerGui.IntroGui.Enabled then
        local hum = localplayer.Character:WaitForChildOfClass("Humanoid")
        hum.Health = 0
        repeat wait() until main.PlayerGui.IntroGui.Enabled
    end
end

main.FarmPart = Instance.new("Part")
main.FarmPart.Parent = workspace
main.FarmPart.Anchored = true
main.FarmPart.Transparency = 1
main.FarmPart.CanCollide = true
main.FarmPart.Position = Vector3.new(math.random(0,20), math.random(40000,50000), math.random(0,20))
main.FarmPart.Size = Vector3.new(math.random(90,150),math.random(1,10),math.random(90,150))

function main.functions.SpawnIfPossible()
    if main.PlayerGui.IntroGui.Enabled then
        game:GetService("ReplicatedStorage").Client.Intro:InvokeServer()
        game:GetService("ReplicatedStorage").Client.StartGame:InvokeServer()
        workspace.CurrentCamera.CameraType = "Custom"
        workspace.CurrentCamera.CameraSubject = localplayer.Character:WaitForChild("Humanoid")
        main.PlayerGui.IntroGui.Enabled = false
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = main.FarmPart.CFrame + Vector3.new(0,11,0)
    else
        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - main.FarmPart.Position).magnitude >= 150 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = main.FarmPart.CFrame + Vector3.new(0,11,0)
        end
    end
end


game.Players.LocalPlayer.Idled:Connect(function()
    VS:CaptureController()
    VS:ClickButton2(Vector2.new())
end)

local verification = table.find(main.WantedElements, main.currentElement)

while wait() do
    if main.ElementFarm == true then
        if verification then
            break
        end
        local s, e = pcall(function()
            if main.Events.GetSpins:InvokeServer() < 1 then
                if main.PlayerGui.IntroGui.Enabled then
                    main.functions.SpawnIfPossible()
                end
                local stepA = main.PlayerGui.StatsGui.BarsFrame.Level
                local newString = stepA.Text:gsub("Level ", "")
                local level = tonumber(newString)
                while level < 2 and wait() do
                    for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if v:IsA("Tool") then
                            v.Parent = game.Players.LocalPlayer.Backpack
                        end
                    end

                    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if not v.Name:find(")") then
                            v.Parent = game.Players.LocalPlayer.Character
                            wait()
                            v:Activate()
                            wait()
                            v:Deactivate()
                            v.Parent = game.Players.LocalPlayer.Backpack
                        end
                    end
                end
            end
            main.functions.ToMenu()
            main.functions.Spin()
        end)
        if e then
            print("Element farm: "..e)
        end
    end

    if main.LevelFarm and main.ElementFarm ~= true then
        local s, e = pcall(function()
            main.functions.SpawnIfPossible()
            for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = game.Players.LocalPlayer.Backpack
                end
            end

            for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if not v.Name:find(")") then
                    v.Parent = game.Players.LocalPlayer.Character
                    wait()
                    v:Activate()
                    wait()
                    v:Deactivate()
                    v.Parent = game.Players.LocalPlayer.Backpack
                end
            end
        end)
        if e then
            print("Level farm: "..e)
        end
    end
end
print("You already have your wanted element.")