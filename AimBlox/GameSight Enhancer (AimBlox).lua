------------------------------------------ CHECK IF PATCH ------------------------------------------

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

_G.ScriptIsPatched = false
_G.FullPatch = false

local function checkIfScriptIsPatched()
    local player = game:GetService("Players").LocalPlayer
    if _G.FullPatch then
        if player then
            player:Kick("\nSCRIPT IS CURRENTLY FULLY PATCHED\nJOIN FOR MORE UPDATES!\nhttps://discord.gg/GHcFCNpZcy")
        end
        return true
    elseif _G.ScriptIsPatched then
        local waitingForResponse = true
        Notification:Notify(
            {
                Title = "Script Notification", 
                Description = "The script may be patched. Do you want to continue?"
            },
            {
                OutlineColor = Color3.fromRGB(80, 80, 80), 
                Time = 999,
                Type = "option"
            },
            {
                Image = "http://www.roblox.com/asset/?id=6023426923", 
                ImageColor = Color3.fromRGB(255, 84, 84), 
                Callback = function(State)
                    if State == false then
                        print("Player chose to exit. Kicking player...")
                        if player then
                            player:Kick("\nREASON: FOR SECURITY PURPOSES\nDEVELOPERS ARE ACTIVELY WORKING ON FIXING THE ISSUES!\nJOIN FOR MORE UPDATES!\nhttps://discord.gg/GHcFCNpZcy")
                        end
                    else
                        print("Player chose to stay. Continuing script...")
                        waitingForResponse = false
                    end
                end
            }
        )
        while waitingForResponse do
            wait()
        end
        print("Continuing with the script...")
        return true
    end
    return false
end

checkIfScriptIsPatched()

------------------------------------------ MAIN TAB ------------------------------------------

local localPlayer = game.Players.LocalPlayer
local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
local userInputService = game:GetService("UserInputService")

getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AimBlox",
    LoadingTitle = "GameSight Enhancer",
    LoadingSubtitle = "By Carl",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ESPSettings",
        FileName = "ESPConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "GHcFCNpZcy",
        RememberJoins = false
     },
    KeySystem = false
})

------------------------------------------ ESP TAB ------------------------------------------

_G.ESPEnabled = false

local ESPTab = Window:CreateTab("ESP Settings", 4483362458)
local ESPSection = ESPTab:CreateSection("ESP Control")

local FillColorEnemy = Color3.fromRGB(255, 0, 0)
local OutlineColorEnemy = Color3.fromRGB(0, 255, 255)

local FillColorNeutral = Color3.fromRGB(255, 255, 0)
local OutlineColorNeutral = Color3.fromRGB(0, 0, 0)

local FillColorAlly = Color3.fromRGB(0, 255, 0)
local OutlineColorAlly = Color3.fromRGB(255, 255, 255)

local function updateESPColors()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("Highlight")
            if highlight then
                local playerTeam = player:GetAttribute("Team")
                local localTeam = localPlayer:GetAttribute("Team")

                if localTeam and playerTeam then
                    if playerTeam ~= localTeam then
                        highlight.FillColor = FillColorEnemy
                        highlight.OutlineColor = OutlineColorEnemy
                    else
                        highlight.FillColor = FillColorAlly
                        highlight.OutlineColor = OutlineColorAlly
                    end
                else
                    highlight.FillColor = FillColorNeutral
                    highlight.OutlineColor = OutlineColorNeutral
                end
            end
        end
    end
end

local EnemyFillColorPicker = ESPTab:CreateColorPicker({
    Name = "Enemy Fill Color",
    Color = FillColorEnemy,
    Flag = "EnemyFillColor",
    Callback = function(Value)
        FillColorEnemy = Value
        updateESPColors()
    end
})

local EnemyOutlineColorPicker = ESPTab:CreateColorPicker({
    Name = "Enemy Outline Color",
    Color = OutlineColorEnemy,
    Flag = "EnemyOutlineColor",
    Callback = function(Value)
        OutlineColorEnemy = Value
        updateESPColors()
    end
})

local NeutralFillColorPicker = ESPTab:CreateColorPicker({
    Name = "Neutral Fill Color",
    Color = FillColorNeutral,
    Flag = "NeutralFillColor",
    Callback = function(Value)
        FillColorNeutral = Value
        updateESPColors()
    end
})

local NeutralOutlineColorPicker = ESPTab:CreateColorPicker({
    Name = "Neutral Outline Color",
    Color = OutlineColorNeutral,
    Flag = "NeutralOutlineColor",
    Callback = function(Value)
        OutlineColorNeutral = Value
        updateESPColors()
    end
})

local AllyFillColorPicker = ESPTab:CreateColorPicker({
    Name = "Ally Fill Color",
    Color = FillColorAlly,
    Flag = "AllyFillColor",
    Callback = function(Value)
        FillColorAlly = Value
        updateESPColors()
    end
})

local AllyOutlineColorPicker = ESPTab:CreateColorPicker({
    Name = "Ally Outline Color",
    Color = OutlineColorAlly,
    Flag = "AllyOutlineColor",
    Callback = function(Value)
        OutlineColorAlly = Value
        updateESPColors()
    end
})

local function addESP(targetCharacter, isEnemy, isNeutral)
    if targetCharacter and not targetCharacter:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = targetCharacter
        highlight.Parent = targetCharacter

        if isEnemy then
            highlight.FillColor = FillColorEnemy
            highlight.OutlineColor = OutlineColorEnemy
        elseif isNeutral then
            highlight.FillColor = FillColorNeutral
            highlight.OutlineColor = OutlineColorNeutral
        else
            highlight.FillColor = FillColorAlly
            highlight.OutlineColor = OutlineColorAlly
        end

        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function removeESP(targetCharacter)
    if targetCharacter and targetCharacter:FindFirstChild("Highlight") then
        targetCharacter.Highlight:Destroy()
    end
end

local function removeESPFromAll()
    for _, player in pairs(game:GetService('Players'):GetPlayers()) do
        if player ~= localPlayer and player.Character then
            removeESP(player.Character)
        end
    end
end

local ESPToggle = ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        _G.ESPEnabled = Value
        if not Value then
            removeESPFromAll()
        end
    end,
})

------------------------------------------ AIM TAB ------------------------------------------

local AIMTab = Window:CreateTab("HITBOX Settings", 4483362458)
local AIMSection = AIMTab:CreateSection("HITBOX Control")

_G.HeadSize = 20
local MaxHeadSize = 45

_G.HeadTransparency = 0.5
local MaxTransparency = 1

if type(_G.HeadSize) ~= "number" or _G.HeadSize <= 0 then
    error("Invalid HeadSize: it must be a positive number.")
elseif _G.HeadSize > MaxHeadSize then
    _G.HeadSize = MaxHeadSize
end

local HeadSizeSlider = AIMTab:CreateSlider({
    Name = "Head Size",
    Range = {5, MaxHeadSize},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 20,
    Flag = "HeadSizeSlider",
    Callback = function(Value)
        _G.HeadSize = Value
        if Value > MaxHeadSize then
            Notification:Notify(
                {Title = "Hitbox Size Alert", Description = "Head Size cannot exceed " .. MaxHeadSize .. " studs."},
                {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 6.5, Type = "image"},
                {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 84, 84)}
            )           
            _G.HeadSize = MaxHeadSize
            HeadSizeSlider:Set(MaxHeadSize)
        end
    end,
})

local HeadTransparencySlider = AIMTab:CreateSlider({
    Name = "Head Transparency",
    Range = {0, MaxTransparency},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = _G.HeadTransparency,
    Flag = "HeadTransparencySlider",
    Callback = function(Value)
        _G.HeadTransparency = Value
    end,
})

game:GetService('RunService').RenderStepped:Connect(function()
    if _G.ESPEnabled then
        local localTeam = localPlayer:GetAttribute("Team")

        for _, player in pairs(game:GetService('Players'):GetPlayers()) do
            if player ~= localPlayer then
                pcall(function()
                    if player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            local playerTeam = player:GetAttribute("Team")
                            if localTeam and playerTeam then
                                if playerTeam ~= localTeam then
                                    head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                                    head.Transparency = _G.HeadTransparency
                                    head.BrickColor = BrickColor.new("Red")
                                    head.Material = Enum.Material.Neon
                                    head.CanCollide = false
                                    head.Massless = true
                                    addESP(player.Character, true, false)
                                else
                                    removeESP(player.Character)
                                end
                            elseif localTeam == "Neutral" then
                                head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                                head.Transparency = _G.HeadTransparency
                                head.BrickColor = BrickColor.new("Red")
                                head.Material = Enum.Material.Neon
                                head.CanCollide = false
                                head.Massless = true
                                addESP(player.Character, false, true)
                            else
                                removeESP(player.Character)
                            end
                        end
                    end
                end)
            end
        end
    end
end)

------------------------------------------ PLAYERS TAB ------------------------------------------

local PlayersTab = Window:CreateTab("PLAYER Settings", 4483362458)
local PlayersSection = PlayersTab:CreateSection("PLAYER Control")

_G.InfJumpEnabled = false

local function onJumpRequest()
    if _G.InfJumpEnabled then
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and character:FindFirstChild("HumanoidRootPart") then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end

userInputService.JumpRequest:Connect(onJumpRequest)

local InfJumpToggle = PlayersTab:CreateToggle({
    Name = "Enable Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        _G.InfJumpEnabled = Value
    end,
})

------------------------------------------ SETTINGS TAB ------------------------------------------

local SettingsTab = Window:CreateTab("Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Settings Control")

local savedHeadProperties = {}

local function saveLocalPlayerHeadProperties()
    if localPlayer and localPlayer.Character then
        local head = localPlayer.Character:FindFirstChild("Head")
        if head then
            savedHeadProperties = {
                Size = head.Size,
                Transparency = head.Transparency,
                BrickColor = head.BrickColor,
                Material = head.Material,
                CanCollide = head.CanCollide,
                Massless = head.Massless
            }
        end
    end
end

local DestroyButton = SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        removeESPFromAll()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head and savedHeadProperties then
                    head.Size = savedHeadProperties.Size or Vector3.new(2, 2, 2)
                    head.Transparency = savedHeadProperties.Transparency or 0
                    head.BrickColor = savedHeadProperties.BrickColor or BrickColor.new("Medium stone grey")
                    head.Material = savedHeadProperties.Material or Enum.Material.Plastic
                    head.CanCollide = savedHeadProperties.CanCollide or true
                    head.Massless = savedHeadProperties.Massless or false
                end
            end
        end
        _G.ESPEnabled = false
        _G.HeadSize = 20
        Rayfield:Destroy()
    end
})

saveLocalPlayerHeadProperties()
Rayfield:LoadConfiguration()