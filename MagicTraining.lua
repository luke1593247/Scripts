local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
getgenv().error = warn
local window1 = library:CreateWindow("Magic Training")
local folder = window1:CreateFolder("Options")
local folder1 = window1:CreateFolder("Key Options")

local flightInStarterGear, getItemsOnDeath, autoClashBot = false, false, false

local varsKey = {}

local localplayer = game:GetService("Players").LocalPlayer

local function clash()
    while wait() and autoClashBot do
        if localplayer.PlayerGui:WaitForChild("clashPrompt") then
            for i, v in pairs(localplayer.PlayerGui.clashPrompt:GetChildren()) do
                if v.Name == "marker" and math.random(1, 10) <= 2 then
                    wait(0.1)
                    firesignal(v.MouseButton1Click)
                end
            end
        else
            break
        end
    end
end

folder:Toggle("Auto-Clash Bot", function(state)
    autoClashBot = state

    if state then
        while autoClashBot and wait() do
            localplayer.PlayerGui:WaitForChild("clashPrompt")
            clash()
        end
    end
end)

folder1:Box("Deletrius", "string", function(key)
    varsKey.deletrius = key
end)
folder1:Box("Bombarda", "string", function(key)
    varsKey.bombarda = key
end)
folder1:Box("Impedimenta", "string", function(key)
    varsKey.impedimenta = key
end)
folder1:Box("Vulnera Sanentur", "string", function(key)
    varsKey["vulnera sanentur"] = key
end)
folder1:Box("Expulso", "string", function(key)
    varsKey.expulso = key
end)
folder1:Box("Duro", "string", function(key)
    varsKey.duro = key
end)
folder1:Box("appa", "string", function(key)
    varsKey.appa = key
end)
folder1:Box("expelliarmus", "string", function(key)
    varsKey.expelliarmus = key
end)
folder1:Box("baubillious", "string", function(key)
    varsKey.baubillious = key
end)

local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
local players = game:GetService("Players")

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
   for i, v in pairs(varsKey) do
       if tostring(key) == v then
            local A_1 = i
            local A_2 = "All"
             Event:FireServer(A_1, A_2)
             players:chat(i)
             break
       end
   end
end)
