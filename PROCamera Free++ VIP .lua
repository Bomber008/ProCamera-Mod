local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "ShawarmaSpectator"
local modOn = true
local godMode = false

if PlayerGui:FindFirstChild(GUI_NAME) then
    PlayerGui[GUI_NAME]:Destroy()
end

local StarterGui = game:GetService("StarterGui")

local gameUIHidden = false

local CORE_UI_TOGGLE = {
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu,
}

local function applyGameUIHidden(hidden)
    gameUIHidden = hidden
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, not hidden)
    end)
    for _, coreType in ipairs(CORE_UI_TOGGLE) do
        pcall(function()
            if coreType == Enum.CoreGuiType.Health and godMode then
                StarterGui:SetCoreGuiEnabled(coreType, true)
            else
                StarterGui:SetCoreGuiEnabled(coreType, not hidden)
            end
        end)
    end
    for _, obj in ipairs(PlayerGui:GetChildren()) do
        if obj:IsA("ScreenGui") and obj.Name ~= GUI_NAME then
            obj.Enabled = not hidden
        end
    end
end

PlayerGui.ChildAdded:Connect(function(obj)
    if not modOn or not gameUIHidden then return end
    if obj:IsA("ScreenGui") and obj.Name ~= GUI_NAME then
        task.wait(0.1)
        if obj.Parent == PlayerGui then
            obj.Enabled = false
        end
    end
end)

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

print("[ShawarmaSpectator] loaded — Play mode, press R or SEARCH")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 24, 20)
frame.BorderColor3 = Color3.fromRGB(255, 150, 45)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local HEADER_H = 30
local FOOTER_H = 40

local header = Instance.new("Frame", frame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.BackgroundColor3 = Color3.fromRGB(255, 215, 70)
header.BorderSizePixel = 0
header.Active = true
header.ClipsDescendants = true

for i = 0, 14 do
    local stripe = Instance.new("Frame", header)
    stripe.Size = UDim2.new(0, 6, 1, 0)
    stripe.Position = UDim2.new(0, i * 17, 0, 0)
    stripe.BackgroundColor3 = Color3.fromRGB(255, 130, 25)
    stripe.BorderSizePixel = 0
    stripe.BackgroundTransparency = 0.25
    stripe.ZIndex = 1
end

local title = Instance.new("TextLabel", header)
title.Position = UDim2.new(0, 8, 0, 0)
title.Size = UDim2.new(1, -36, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(55, 30, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.TextTruncate = Enum.TextTruncate.AtEnd
title.TextWrapped = false
title.Text = "🥙 NPC CAMERA"
title.ZIndex = 2

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -26, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 35)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Text = "X"
closeBtn.ZIndex = 3
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local footer = Instance.new("Frame", frame)
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, FOOTER_H)
footer.Position = UDim2.new(0, 0, 1, -FOOTER_H)
footer.BackgroundColor3 = Color3.fromRGB(34, 30, 26)
footer.BorderSizePixel = 0

local list = Instance.new("ScrollingFrame", frame)
list.Position = UDim2.new(0, 0, 0, HEADER_H)
list.Size = UDim2.new(1, 0, 1, -(HEADER_H + FOOTER_H))
list.BackgroundColor3 = Color3.fromRGB(38, 34, 30)
list.BorderSizePixel = 0
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 4)

local refresh = Instance.new("TextButton", footer)
refresh.Size = UDim2.new(0, 108, 0, 28)
refresh.Position = UDim2.new(0, 10, 0, 6)
refresh.Text = "SEARCH"
refresh.Font = Enum.Font.GothamBold
refresh.TextSize = 13
refresh.BackgroundColor3 = Color3.fromRGB(55, 165, 75)
refresh.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", refresh).CornerRadius = UDim.new(0, 8)

local resetBtn = Instance.new("TextButton", footer)
resetBtn.Size = UDim2.new(0, 108, 0, 28)
resetBtn.Position = UDim2.new(1, -118, 0, 6)
resetBtn.Text = "RESET"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 13
resetBtn.BackgroundColor3 = Color3.fromRGB(185, 85, 55)
resetBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 8)

local godHpLabel = Instance.new("TextLabel", frame)
godHpLabel.Size = UDim2.new(1, -8, 0, 20)
godHpLabel.Position = UDim2.new(0, 4, 1, -(FOOTER_H + 22))
godHpLabel.TextWrapped = true
godHpLabel.BackgroundTransparency = 1
godHpLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
godHpLabel.Font = Enum.Font.GothamBold
godHpLabel.TextSize = 10
godHpLabel.Text = ""
godHpLabel.Visible = false

local paintMode = false
local paintColorIndex = 1
local PAINT_COLORS = {
    { name = "Red", color = Color3.fromRGB(220, 55, 55) },
    { name = "Orange", color = Color3.fromRGB(230, 120, 40) },
    { name = "Yellow", color = Color3.fromRGB(235, 210, 50) },
    { name = "Green", color = Color3.fromRGB(55, 175, 75) },
    { name = "Cyan", color = Color3.fromRGB(50, 175, 210) },
    { name = "Blue", color = Color3.fromRGB(55, 95, 220) },
    { name = "Purple", color = Color3.fromRGB(140, 70, 200) },
    { name = "Pink", color = Color3.fromRGB(230, 100, 170) },
    { name = "White", color = Color3.fromRGB(240, 240, 240) },
    { name = "Gray", color = Color3.fromRGB(130, 130, 130) },
    { name = "Brown", color = Color3.fromRGB(120, 75, 45) },
    { name = "Black", color = Color3.fromRGB(30, 30, 30) },
}

closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local savedGuiEnabled = nil

local function setModPanelInput(enabled)
    frame.Active = enabled
    frame.Draggable = enabled
    header.Active = enabled
    closeBtn.Active = enabled
    refresh.Active = enabled
    resetBtn.Active = enabled
    list.Active = enabled
    list.ScrollingEnabled = enabled
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") then
            local btn = child:FindFirstChildWhichIsA("TextButton")
            if btn then
                btn.Active = enabled
            end
        end
    end
end

local function applyCameraMouseLock()
    mouseVisible = false
    UserInputService.MouseIconEnabled = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    setModPanelInput(false)
end

local function releaseCameraMouseLock()
    setModPanelInput(true)
    if not isSpectating and not isFreeCam then
        mouseVisible = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end

local targets = {}
local currentRoot = nil
local currentModel = nil
local lastNPC = nil
local includeInanimate = false
local INANIMATE_SEARCH_DIST = 25
local MAX_STANDALONE_PROP_VOLUME = 800000
local MAX_INANIMATE_PARTS = 200
local INANIMATE_BODY_PART_NAMES = {
    Head = true, Torso = true, UpperTorso = true, LowerTorso = true,
    LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
    RightUpperArm = true, RightLowerArm = true, RightHand = true,
    LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
    RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
    ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
    HumanoidRootPart = true, RootPart = true,
}
local camConn = nil
local isSpectating = false
local spectatePlayerFrozen = true
local isFreeCam = false
local stopFreeCam
local startFreeCam
local yaw = 0
local pitch = 0
local distance = 8
local height = 3
local sensitivity = 0.003
local smoothYaw = 0
local smoothPitch = 0
local smoothDistance = 8
local lerpSpeed = 0.11
local freeCamYaw = 0
local freeCamPitch = 0

local playZoom = 0.5
local ZOOM_MIN = 0.5
local ZOOM_MAX = 40

local function applyPlayZoomUnlock()
    pcall(function()
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end)
    pcall(function()
        local z = math.clamp(playZoom, ZOOM_MIN, ZOOM_MAX)
        if z <= ZOOM_MIN + 0.05 then
            LocalPlayer.CameraMinZoomDistance = ZOOM_MIN
            LocalPlayer.CameraMaxZoomDistance = ZOOM_MIN
        else
            LocalPlayer.CameraMinZoomDistance = z
            LocalPlayer.CameraMaxZoomDistance = z + 0.1
        end
    end)
end

local mouseVisible = true
UserInputService.MouseIconEnabled = true
UserInputService.MouseBehavior = Enum.MouseBehavior.Default

local keysDown = {W=false,A=false,S=false,D=false,E=false,C=false,Shift=false}

local walkSpeed = 16
local walkSpeedStep = 4
local walkSpeedMin = 4
local walkSpeedMax = 150

local function getHumanoid()
    local character = LocalPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local applyWalkSpeed

local DAY_CLOCK = 14
local NIGHT_CLOCK = 0
local savedLighting = nil
local customTimeIsNight = false
local lightingTween = nil

local function saveLightingIfNeeded()
    if savedLighting then return end
    savedLighting = {
        ClockTime = Lighting.ClockTime,
        TimeOfDay = Lighting.TimeOfDay,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
    }
end

local function restoreLighting()
    if lightingTween then
        lightingTween:Cancel()
        lightingTween = nil
    end
    if not savedLighting then return end
    pcall(function()
        Lighting.ClockTime = savedLighting.ClockTime
        Lighting.TimeOfDay = savedLighting.TimeOfDay
        Lighting.Brightness = savedLighting.Brightness
        Lighting.Ambient = savedLighting.Ambient
        Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
    end)
    savedLighting = nil
    customTimeIsNight = false
end

local function tweenLighting(targetClock, targetBrightness)
    saveLightingIfNeeded()
    if lightingTween then
        lightingTween:Cancel()
    end
    lightingTween = TweenService:Create(
        Lighting,
        TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        { ClockTime = targetClock, Brightness = targetBrightness }
    )
    lightingTween:Play()
    pcall(function()
        local hours = math.floor(targetClock)
        local minutes = math.floor((targetClock - hours) * 60)
        Lighting.TimeOfDay = string.format("%02d:%02d:00", hours, minutes)
    end)
end

local function toggleDayNight()
    customTimeIsNight = not customTimeIsNight
    local prevTitle = title.Text
    if customTimeIsNight then
        tweenLighting(NIGHT_CLOCK, 0.6)
        title.Text = "🌙 NIGHT"
    else
        tweenLighting(DAY_CLOCK, savedLighting and savedLighting.Brightness or 2)
        title.Text = "☀️ DAY"
    end
    task.delay(1.5, function()
        if title.Text == "🌙 NIGHT" or title.Text == "☀️ DAY" then
            title.Text = prevTitle
        end
    end)
end

local numKeys = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5,
    [Enum.KeyCode.Six] = 6,
    [Enum.KeyCode.Seven] = 7,
    [Enum.KeyCode.Eight] = 8,
    [Enum.KeyCode.Nine] = 9,
    [Enum.KeyCode.Zero] = 10,
    [Enum.KeyCode.Minus] = 11,
    [Enum.KeyCode.Equals] = 12,
    [Enum.KeyCode.Plus] = 12,
    [Enum.KeyCode.KeypadMinus] = 11,
}

local function getNumKeyIndex(input)
    return numKeys[input.KeyCode]
end

local function getKeyLabel(i)
    if i == 10 then return "0" end
    if i == 11 then return "-" end
    if i == 12 then return "=" end
    return tostring(i)
end

local function getPlayerCharacters()
    local chars = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            chars[player.Character] = true
        end
    end
    return chars
end

local function isPlayerCharacterModel(model)
    if not model or not model:IsA("Model") then return false end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character == model then
            return true
        end
    end
    return false
end

local function setMouseVisible(state)
    mouseVisible = state
    if mouseVisible then
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        setModPanelInput(true)
        if isFreeCam and savedGuiEnabled ~= nil then
            gui.Enabled = savedGuiEnabled
        end
        return
    end

    UserInputService.MouseIconEnabled = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    if isSpectating or isFreeCam then
        setModPanelInput(false)
        if isFreeCam then
            savedGuiEnabled = gui.Enabled
            gui.Enabled = false
        end
    end
end

UserInputService.InputChanged:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        if isSpectating and currentRoot and not isFreeCam and not mouseVisible then
            distance -= input.Position.Z * 2
            distance = math.clamp(distance, 2, 40)
        elseif modOn and not isSpectating and not isFreeCam and not mouseVisible then
            local delta = -input.Position.Z
            local step = math.max(0.2, playZoom * 0.12 + 0.25)
            playZoom = math.clamp(playZoom + delta * step, ZOOM_MIN, ZOOM_MAX)
            applyPlayZoomUnlock()
        end
        return
    end

    if gp then return end
    if mouseVisible then return end
end)

local function getRootPart(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model end
    if not model:IsA("Model") then return nil end

    if model:FindFirstChild("HumanoidRootPart") then return model.HumanoidRootPart end
    if model:FindFirstChild("RootPart") then return model.RootPart end
    if model:FindFirstChild("Torso") then return model.Torso end
    if model:FindFirstChild("UpperTorso") then return model.UpperTorso end
    if model:FindFirstChild("Head") then return model.Head end

    if model.PrimaryPart then return model.PrimaryPart end

    local biggest = nil
    local biggestSize = 0
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored then
            local size = part.Size.X * part.Size.Y * part.Size.Z
            if size > biggestSize then
                biggestSize = size
                biggest = part
            end
        end
    end
    if biggest then return biggest end

    return model:FindFirstChildOfClass("BasePart")
end

local function isLivingTarget(model, playerChars)
    if not model:IsA("Model") then return false end

    if playerChars[model] then return false end

    if model == LocalPlayer.Character then return false end

    if model.Name == "ShawarmaMorphOverlay" or model.Name == "ShawarmaMorphExtras" then
        return false
    end

    if model:FindFirstChildWhichIsA("Humanoid", true) then return true end

    if model:FindFirstChildWhichIsA("AnimationController", true) then return true end

    if model:FindFirstChildOfClass("BasePart") and model:FindFirstChildOfClass("Script") then
        -- Some props have Scripts for interaction; treat as living only if rig-like joints exist.
        if model:FindFirstChildWhichIsA("Motor6D", true)
            or model:FindFirstChildWhichIsA("Bone", true) then
            return true
        end
    end

    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("BasePart") then
            if child:FindFirstChildOfClass("BodyVelocity") or
               child:FindFirstChildOfClass("BodyGyro") or
               child:FindFirstChildOfClass("BodyPosition") or
               child:FindFirstChildOfClass("AlignPosition") or
               child:FindFirstChildOfClass("AlignOrientation") then
                return true
            end
        end
    end

    return false
end

local function isStandalonePropPart(part)
    if not part:IsA("BasePart") then return false end
    if part.Name == "ShawarmaMorphOverlay" or part.Name == "HumanoidRootPart" then return false end
    if part.Transparency >= 1 then return false end

    local hasVisual = part:IsA("MeshPart")
        or part:IsA("UnionOperation")
        or part:FindFirstChildOfClass("SpecialMesh")
        or part:FindFirstChildOfClass("Decal")
        or part:FindFirstChildOfClass("Texture")
    if not hasVisual then return false end

    local vol = part.Size.X * part.Size.Y * part.Size.Z
    if vol <= 0 or vol > MAX_STANDALONE_PROP_VOLUME then return false end

    return true
end

function isPropInsideLivingCharacter(inst, playerChars)
    local current = inst.Parent
    while current and current ~= Workspace do
        if current:IsA("Model") and isLivingTarget(current, playerChars) then
            return true
        end
        current = current.Parent
    end
    return false
end

function isPropWeldedToLiving(inst, playerChars)
    local parts = {}
    if inst:IsA("BasePart") then
        table.insert(parts, inst)
    elseif inst:IsA("Model") then
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("BasePart") then
                table.insert(parts, d)
            end
        end
    end

    for _, part in ipairs(parts) do
        for _, joint in ipairs(part:GetChildren()) do
            if joint:IsA("WeldConstraint") or joint:IsA("Weld") or joint:IsA("Motor6D") then
                local other = joint.Part0 == part and joint.Part1 or joint.Part0
                if other and other:IsA("BasePart") and other ~= part then
                    local owner = other:FindFirstAncestorOfClass("Model")
                    if owner and isLivingTarget(owner, playerChars) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function isRejectedInanimateProp(model, playerChars)
    if model:FindFirstAncestorOfClass("Accessory") then return true end
    if model:FindFirstAncestorOfClass("Tool") then return true end
    if isPropInsideLivingCharacter(model, playerChars) then return true end
    if isPropWeldedToLiving(model, playerChars) then return true end

    if not model:IsA("Model") then
        return false
    end

    local partCount = 0
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then
            partCount += 1
        end
    end

    if partCount <= 8 and INANIMATE_BODY_PART_NAMES[model.Name] then
        return true
    end

    local lower = model.Name:lower()
    if partCount <= 6 then
        if lower == "tail" or lower:find("tail$") or lower:sub(-4) == "tail" then return true end
        if lower == "ear" or lower == "ears" or lower:find("ear$") or lower:find("^ear") then return true end
        if lower:find("hair", 1, true) and partCount <= 4 then return true end
        if lower:find("horn", 1, true) and partCount <= 4 then return true end
        if lower:find("wing", 1, true) and partCount <= 6 then return true end
        if lower:find("beard", 1, true) or lower:find("mane", 1, true) then return true end
    end

    return false
end

local function isInanimateTarget(model, playerChars)
    if not includeInanimate then return false end
    local isModel = model:IsA("Model")
    local isPart = model:IsA("BasePart")
    if not isModel and not isPart then return false end
    if isModel and playerChars[model] then return false end
    if model == LocalPlayer.Character then return false end
    if model.Name == "ShawarmaMorphOverlay" then return false end
    if isRejectedInanimateProp(model, playerChars) then return false end
    if isModel and isLivingTarget(model, playerChars) then return false end

    if isPart then
        local parentModel = model:FindFirstAncestorOfClass("Model")
        if parentModel then
            if playerChars[parentModel] or parentModel == LocalPlayer.Character then
                return false
            end
            if parentModel.Name == "ShawarmaMorphOverlay" then return false end
            if isLivingTarget(parentModel, playerChars) then return false end
            local parentParts = 0
            for _, d in ipairs(parentModel:GetDescendants()) do
                if d:IsA("BasePart") then parentParts += 1 end
            end
            if parentParts > 0 and parentParts <= 150 then
                return false
            end
            if not isStandalonePropPart(model) then return false end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and model:IsDescendantOf(player.Character) then
            return false
        end
    end

    if not getRootPart(model) then return false end

    local partCount = 0
    if isPart then
        partCount = 1
    else
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then
                partCount += 1
            end
        end
    end
    if partCount == 0 or partCount > MAX_INANIMATE_PARTS then return false end

    return true
end

local function isSpectateTarget(model, playerChars)
    if includeInanimate then
        return isInanimateTarget(model, playerChars)
    end
    return isLivingTarget(model, playerChars)
end

local function resolveSpectateModel(model, playerChars)
    if not model:IsA("Model") or not isSpectateTarget(model, playerChars) then
        return nil
    end
    local top = model
    local parent = model.Parent
    while parent and parent:IsA("Model") and parent ~= Workspace do
        if isSpectateTarget(parent, playerChars) then
            top = parent
        end
        parent = parent.Parent
    end
    return top
end

local function isMorphableTarget(model)
    local playerChars = getPlayerCharacters()
    if includeInanimate then
        return isInanimateTarget(model, playerChars)
    end
    if model:FindFirstChildWhichIsA("Humanoid", true) then return true end
    if model:FindFirstChildWhichIsA("AnimationController", true) then return true end
    return false
end


local function isTargetAlive(entry)
    if not entry then return false end
    local root = entry.root
    local model = entry.model
    if not root or not root.Parent then return false end
    if model and not model.Parent then return false end
    return true
end

local function pruneDeadTargets()
    local alive = {}
    for _, entry in ipairs(targets) do
        if isTargetAlive(entry) then
            table.insert(alive, entry)
        end
    end
    targets = alive
end

local startCamera
local resetCamera
local handleTargetLost
local demorphCharacter
local morphIntoNpc
local isMorphed = false
local morphOverlay = nil
local setMorphAdjustKey
local clearMorphOverlay

do

local morphSourceName = nil
local savedDescription = nil
local savedMorphStats = nil
local morphOverlayConn = nil
local morphOverlayRevealConn = nil
local morphPartVisibility = {}
local morphAnimTracks = {}
local morphHipOffset = 0
local morphDropOffset = 2
local morphPropRotation = nil
local morphAnchorPart = nil
local morphPivotFix = CFrame.new()
local morphUseFullPivotFollow = false
local morphPropGroundLift = 0
local morphHeightAdj = 0
local morphYawAdj = 0
local morphPitchAdj = 0
local morphRollAdj = 0
local morphScale = 1
local morphKeysDown = { E = false, C = false, Z = false, X = false, V = false, B = false, N = false, M = false }
local morphHudTick = 0
local MORPH_HEIGHT_SPEED = 0.75
local MORPH_YAW_SPEED = math.rad(28)
local MORPH_PITCH_SPEED = math.rad(28)
local MORPH_ROLL_SPEED = math.rad(28)
local MORPH_SCALE_SPEED = 0.85
local MORPH_SCALE_MIN = 0.15
local MORPH_SCALE_MAX = 8
local MORPH_FAST_MULT = 3
local morphHideConn = nil
local morphNameConn = nil
local morphNameDisplay = nil
local morphUsedOverlay = false
local morphExtras = nil
local morphExtrasConn = nil
local morphExtraOffsets = {}
local morphAnimStateConn = nil
local morphIdleTrack = nil
local morphMoveTrack = nil

local STANDARD_MORPH_ANIMS = {
    R15 = {
        idle = "rbxassetid://507766388",
        walk = "rbxassetid://507777826",
        run = "rbxassetid://507767714",
    },
    R6 = {
        idle = "rbxassetid://180435792",
        walk = "rbxassetid://180426354",
        run = "rbxassetid://180426354",
    },
}

local R15_BODY_PARTS = {
    "Head", "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot",
}

local R6_BODY_PARTS = {
    "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
}

local STANDARD_BODY_NAMES = {}
for _, name in ipairs(R15_BODY_PARTS) do STANDARD_BODY_NAMES[name] = true end
for _, name in ipairs(R6_BODY_PARTS) do STANDARD_BODY_NAMES[name] = true end

local MORPH_SKIP_EXTRA_NAMES = {
    HumanoidRootPart = true,
    RootPart = true,
    Handle = true,
}

function isMorphSemivisibleShell(part)
    if not part:IsA("BasePart") then return false end
    local t = part.Transparency
    return t > 0 and t < 1
end

function partHasMorphVisualContent(part)
    if not part:IsA("BasePart") then return false end
    if part:IsA("MeshPart") and part.MeshId ~= "" then
        return true
    end
    if part:FindFirstChildOfClass("SpecialMesh") then
        return true
    end
    if part:FindFirstChildOfClass("SurfaceAppearance") then
        return true
    end
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            return true
        end
    end
    return false
end

function shouldRevealHiddenMorphPart(part)
    if not part:IsA("BasePart") then return false end
    if isMorphSemivisibleShell(part) then return false end
    if part.Transparency < 1 then return false end
    return partHasMorphVisualContent(part)
end

function isMorphExtraPart(part)
    if not part:IsA("BasePart") then return false end
    if STANDARD_BODY_NAMES[part.Name] or MORPH_SKIP_EXTRA_NAMES[part.Name] then return false end
    local lower = part.Name:lower()
    if lower:find("hitbox", 1, true) or lower:find("collider", 1, true)
        or lower:find("collision", 1, true) or lower:find("proxy", 1, true) then
        return false
    end
    if part:FindFirstAncestorOfClass("Accessory") then return false end
    if part:FindFirstAncestorOfClass("Tool") then return false end
    return true
end

function isMorphUtilityPart(part)
    if not part:IsA("BasePart") then return true end
    return part.Transparency >= 1 and not partHasMorphVisualContent(part)
end

function hasMorphRig(model)
    if not model then return false end
    return model:FindFirstChildWhichIsA("Humanoid", true) ~= nil
        or model:FindFirstChildWhichIsA("AnimationController", true) ~= nil
        or model:FindFirstChildWhichIsA("Motor6D", true) ~= nil
        or model:FindFirstChildWhichIsA("Bone", true) ~= nil
end

function getMotor6DRigRoots(model)
    local asPart1 = {}
    for _, m in ipairs(model:GetDescendants()) do
        if m:IsA("Motor6D") and m.Part1 and m.Part1:IsA("BasePart") then
            asPart1[m.Part1] = true
        end
    end
    local roots = {}
    for _, m in ipairs(model:GetDescendants()) do
        if m:IsA("Motor6D") and m.Part0 and m.Part0:IsA("BasePart") and not asPart1[m.Part0] then
            roots[m.Part0] = true
        end
    end
    return roots
end

function isInMotor6DChain(part, model)
    for _, m in ipairs(model:GetDescendants()) do
        if m:IsA("Motor6D") and (m.Part0 == part or m.Part1 == part) then
            return true
        end
    end
    return false
end

function isInBoneChain(part)
    if part:FindFirstAncestorWhichIsA("Bone") then return true end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("Bone") then return true end
    end
    return false
end

function shouldUnanchorMorphPart(part, model, rigRoots)
    if rigRoots[part] then return false end
    return isInMotor6DChain(part, model) or isInBoneChain(part)
end

function stabilizeMorphAssembly(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function applyMorphPartRevealRules(part)
    if not part:IsA("BasePart") or not isMorphExtraPart(part) then return end
    if shouldRevealHiddenMorphPart(part) then
        part.Transparency = 0
    end
    part.LocalTransparencyModifier = 0
end

function partHasFaceDecal(part)
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("Decal") and child.Name:lower() == "face" then
            return true
        end
    end
    return false
end

function partHasFaceGraphic(part)
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            return true
        end
    end
    return false
end

function isLikelyFaceOverlayName(name)
    local lower = name:lower()
    if lower == "face" or lower == "frontface" or lower == "facefront"
        or lower == "headface" then
        return true
    end
    return false
end

local MORPH_INTERIOR_FACE_TOKENS = {
    "mouth", "teeth", "tooth", "jaw", "tongue", "gum", "gums",
    "inner", "interior", "throat", "molar", "fang", "bite", "uvula",
}

function isInteriorFacePart(name)
    local lower = name:lower()
    for _, token in ipairs(MORPH_INTERIOR_FACE_TOKENS) do
        if lower:find(token, 1, true) then
            return true
        end
    end
    return false
end

function getNpcHead(model)
    local head = model and model:FindFirstChild("Head", true)
    if head and head:IsA("BasePart") then
        return head
    end
    return nil
end

function isPartInFrontOfHead(part, head)
    if not head or not part:IsA("BasePart") then return false end
    local localPos = head.CFrame:PointToObjectSpace(part.Position)
    local frontEdge = -head.Size.Z * 0.5
    return localPos.Z < frontEdge - 0.04
end

function isPartInUpperFrontFace(part, head)
    if not head or not part:IsA("BasePart") then return false end
    local localPos = head.CFrame:PointToObjectSpace(part.Position)
    local hs = head.Size * 0.5
    local frontEdge = -hs.Z
    return localPos.Z < frontEdge - 0.02 and localPos.Y > -hs.Y * 0.25
end

function isLikelyExteriorFaceShell(part, model, headAttached)
    if not part:IsA("BasePart") then return false end
    if isInteriorFacePart(part.Name) then return false end

    local head = getNpcHead(model)
    if not head or part == head then return false end

    if isLikelyFaceOverlayName(part.Name) then
        return true
    end

    if partHasFaceDecal(part) or partHasFaceGraphic(part) then
        if isPartInUpperFrontFace(part, head) or isPartInFrontOfHead(part, head) then
            return true
        end
    end

    if headAttached and headAttached[part] then
        if isPartInUpperFrontFace(part, head) then
            return true
        end
        if isPartInFrontOfHead(part, head) then
            local minDim = math.min(part.Size.X, part.Size.Y, part.Size.Z)
            if minDim < 0.4 or part.Transparency >= 1 then
                return true
            end
        end
    end

    return false
end

function shouldSkipGraftPart(part, model, headAttached, overlayModel)
    if not part or not part:IsA("BasePart") then
        return true
    end

    if overlayModel then
        return overlayModel:FindFirstChild(part.Name, true) ~= nil
    end

    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then
        return false
    end

    return isLikelyExteriorFaceShell(part, model, headAttached)
end

function buildHeadAttachedSet(model)
    local set = {}
    local head = model and model:FindFirstChild("Head", true)
    if not head or not head:IsA("BasePart") then return set end

    local links = {}
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("WeldConstraint") or d:IsA("Weld") or d:IsA("Motor6D") then
            local p0, p1 = d.Part0, d.Part1
            if p0 and p1 and p0:IsA("BasePart") and p1:IsA("BasePart") then
                links[p0] = links[p0] or {}
                links[p1] = links[p1] or {}
                table.insert(links[p0], p1)
                table.insert(links[p1], p0)
            end
        end
    end

    local queue = { head }
    local visited = { [head] = true }
    while #queue > 0 do
        local current = table.remove(queue, 1)
        for _, neighbor in ipairs(links[current] or {}) do
            if not visited[neighbor] then
                visited[neighbor] = true
                if neighbor ~= head then
                    set[neighbor] = true
                end
                table.insert(queue, neighbor)
            end
        end
    end
    return set
end

function applyNpcHeadToCharacter(fromModel, character)
    local fromHead = fromModel:FindFirstChild("Head", true)
    local toHead = character and character:FindFirstChild("Head")
    if not fromHead or not toHead or not fromHead:IsA("BasePart") or not toHead:IsA("BasePart") then
        return
    end

    toHead.Color = fromHead.Color
    toHead.Material = fromHead.Material
    toHead.Transparency = fromHead.Transparency

    if fromHead:IsA("MeshPart") and toHead:IsA("MeshPart") then
        toHead.MeshId = fromHead.MeshId
        if fromHead.TextureID ~= "" then
            toHead.TextureID = fromHead.TextureID
        end
    end

    local fromMesh = fromHead:FindFirstChildOfClass("SpecialMesh")
    local toMesh = toHead:FindFirstChildOfClass("SpecialMesh")
    if fromMesh and toMesh then
        toMesh.MeshType = fromMesh.MeshType
        toMesh.MeshId = fromMesh.MeshId
        if fromMesh.TextureId ~= "" then
            toMesh.TextureId = fromMesh.TextureId
        end
        toMesh.Scale = fromMesh.Scale
    end

    local fromDecals = {}
    for _, child in ipairs(fromHead:GetChildren()) do
        if child:IsA("Decal") then
            table.insert(fromDecals, child)
        end
    end
    if #fromDecals > 0 then
        for _, child in ipairs(toHead:GetChildren()) do
            if child:IsA("Decal") and child.Name == "face" then
                child:Destroy()
            end
        end
        for _, child in ipairs(fromDecals) do
            child:Clone().Parent = toHead
        end
    end
end

function clearMorphExtras()
    if morphExtrasConn then
        morphExtrasConn:Disconnect()
        morphExtrasConn = nil
    end
    if morphExtras then
        morphExtras:Destroy()
        morphExtras = nil
    end
    table.clear(morphExtraOffsets)
end

function isMorphInteractGui(gui)
    if not (gui:IsA("BillboardGui") or gui:IsA("SurfaceGui")) then return false end
    for _, c in ipairs(gui:GetDescendants()) do
        if c:IsA("TextButton") or c:IsA("ImageButton") then return true end
        if c:IsA("TextLabel") and c.Text:find("[", 1, true) then return true end
    end
    return false
end

function stripMorphInteractObjects(root)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("ProximityPrompt") or d:IsA("ClickDetector") then
            d:Destroy()
        elseif isMorphInteractGui(d) then
            d:Destroy()
        end
    end
end

local morphVisiblePrompts = {}

function isMorphOwnedPrompt(prompt)
    return morphOverlay and prompt:IsDescendantOf(morphOverlay)
end

ProximityPromptService.PromptShown:Connect(function(prompt)
    if isMorphOwnedPrompt(prompt) then return end
    morphVisiblePrompts[prompt] = true
end)

ProximityPromptService.PromptHidden:Connect(function(prompt)
    morphVisiblePrompts[prompt] = nil
end)

function getProximityPromptWorldPos(prompt)
    local parent = prompt.Parent
    if not parent then return nil end
    if parent:IsA("Attachment") then
        return parent.WorldPosition
    end
    if parent:IsA("BasePart") then
        return parent.Position
    end
    if parent:IsA("Model") then
        return parent:GetPivot().Position
    end
    return nil
end

function hasNearbyProximityPrompt()
    local character = LocalPlayer.Character
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    for _, inst in ipairs(Workspace:GetDescendants()) do
        if inst:IsA("ProximityPrompt") and inst.Enabled then
            if not isMorphOwnedPrompt(inst) then
                local pos = getProximityPromptWorldPos(inst)
                if pos and (hrp.Position - pos).Magnitude <= inst.MaxActivationDistance + 2 then
                    return true
                end
            end
        end
    end
    return false
end

function hasMorphInteractionPrompt()
    for prompt in pairs(morphVisiblePrompts) do
        if prompt.Parent and prompt.Enabled and not isMorphOwnedPrompt(prompt) then
            return true
        end
        morphVisiblePrompts[prompt] = nil
    end
    return hasNearbyProximityPrompt()
end

function canUseMorphAdjustKey(keyCode, gp)
    if keyCode == Enum.KeyCode.E then
        if gp then return false end
        if hasMorphInteractionPrompt() then return false end
    end
    return true
end

function sanitizeExtraClone(root)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
            d:Destroy()
        elseif d:IsA("Constraint") or d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
            d:Destroy()
        elseif d:IsA("BasePart") then
            d.Anchored = false
            d.CanCollide = false
            d.CanQuery = false
            d.CanTouch = false
            d.Massless = true
        end
    end
    stripMorphInteractObjects(root)
end

function revealOverlayExtraParts(overlay)
    if not overlay then return end
    for _, part in ipairs(overlay:GetDescendants()) do
        applyMorphPartRevealRules(part)
    end
    if morphOverlayRevealConn then
        morphOverlayRevealConn:Disconnect()
        morphOverlayRevealConn = nil
    end
    morphOverlayRevealConn = overlay.DescendantAdded:Connect(function(desc)
        applyMorphPartRevealRules(desc)
    end)
end

function attachMorphExtraParts(npcModel, anchorPart, overlayModel)
    clearMorphExtras()
    if not npcModel or not anchorPart or not anchorPart.Parent then return end

    local character = LocalPlayer.Character
    local npcRoot = getRootPart(npcModel)
    if not npcRoot then return end

    morphExtras = Instance.new("Model")
    morphExtras.Name = "ShawarmaMorphExtras"

    local seenNames = {}
    local npcHum = npcModel:FindFirstChildOfClass("Humanoid")

local headAttached = {}

if npcHum then
    headAttached = buildHeadAttachedSet(npcModel)
end
    for _, srcPart in ipairs(npcModel:GetDescendants()) do
        if isMorphExtraPart(srcPart)
        and not seenNames[srcPart:GetDebugId()]
        and not shouldSkipGraftPart(srcPart,npcModel,headAttached,overlayModel)
        then
            local skip = false
            if character and not overlayModel then
                local onPlayer = character:FindFirstChild(srcPart.Name, true)
                if onPlayer and onPlayer:IsA("BasePart") then
                    skip = true
                end
            end
            if not skip and overlayModel and overlayModel:FindFirstChild(srcPart.Name, true) then
                skip = true
            end
            if not skip then
                seenNames[srcPart:GetDebugId()] = true
                local clone = srcPart:Clone()
                clone.Name = "MorphExtra_" .. srcPart.Name
                sanitizeExtraClone(clone)
                applyMorphPartRevealRules(clone)
                clone.Parent = morphExtras
                morphExtraOffsets[clone] = anchorPart.CFrame:ToObjectSpace(srcPart.CFrame)
            end
        end
    end

    if not next(morphExtraOffsets) then
        morphExtras:Destroy()
        morphExtras = nil
        return
    end

    morphExtras.Parent = Workspace
    morphExtrasConn = RunService.RenderStepped:Connect(function()
        if not morphExtras or not anchorPart or not anchorPart.Parent then return end
        for clone, offset in pairs(morphExtraOffsets) do
            if clone.Parent and clone:IsA("BasePart") then
                clone.CFrame = anchorPart.CFrame * offset
            end
        end
    end)
end

function getModelFromRoot(root)
    if not root then return nil end
    local model = root:FindFirstAncestorOfClass("Model")
    if model then return model end
    if root.Parent and root.Parent:IsA("Model") then return root.Parent end
    return nil
end

function removeMorphAccessories(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") and child:GetAttribute("ShawarmaMorph") then
            child:Destroy()
        end
    end
end

function saveOriginalAppearance(character)
    savedDescription = nil
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            savedDescription = hum:GetAppliedDescription()
        end)
    end
end

function saveMorphStats(playerHum)
    savedMorphStats = {
        walkSpeed = walkSpeed,
        HipHeight = playerHum.HipHeight,
        JumpPower = playerHum.JumpPower,
        JumpHeight = playerHum.JumpHeight,
    }
end

function restoreMorphStats(playerHum)
    if not savedMorphStats or not playerHum then return end
    walkSpeed = savedMorphStats.walkSpeed
    playerHum.HipHeight = savedMorphStats.HipHeight
    playerHum.JumpPower = savedMorphStats.JumpPower
    pcall(function()
        playerHum.JumpHeight = savedMorphStats.JumpHeight
    end)
    if not playerLocked then
        playerHum.WalkSpeed = walkSpeed
    end
    savedMorphStats = nil
end

function copyPartVisuals(fromPart, toPart)
    toPart.Color = fromPart.Color
    toPart.Material = fromPart.Material
    toPart.Transparency = fromPart.Transparency
    if fromPart:IsA("MeshPart") and toPart:IsA("MeshPart") then
        toPart.MeshId = fromPart.MeshId
        toPart.TextureID = fromPart.TextureID
    end
    local fromSA = fromPart:FindFirstChildOfClass("SurfaceAppearance")
    if fromSA then
        local toSA = toPart:FindFirstChildOfClass("SurfaceAppearance")
        if toSA then toSA:Destroy() end
        fromSA:Clone().Parent = toPart
    end
    local fromMesh = fromPart:FindFirstChildOfClass("SpecialMesh")
    local toMesh = toPart:FindFirstChildOfClass("SpecialMesh")
    if fromMesh and toMesh then
        toMesh.MeshType = fromMesh.MeshType
        toMesh.MeshId = fromMesh.MeshId
        toMesh.TextureId = fromMesh.TextureId
        toMesh.Scale = fromMesh.Scale
    elseif fromMesh and not toMesh then
        local newMesh = fromMesh:Clone()
        newMesh.Parent = toPart
    end
end

function copyBodyVisuals(fromModel, toCharacter, skipStandardParts)
    local copied = {}
    for _, fromPart in ipairs(fromModel:GetDescendants()) do
        if fromPart:IsA("BasePart") then
            if not (skipStandardParts and STANDARD_BODY_NAMES[fromPart.Name]) then
                local toPart = toCharacter:FindFirstChild(fromPart.Name, true)
                if toPart and toPart:IsA("BasePart") and not copied[toPart] then
                    copyPartVisuals(fromPart, toPart)
                    copied[toPart] = true
                end
            end
        end
    end

    if skipStandardParts then return end

    local fromHead = fromModel:FindFirstChild("Head", true)
    local toHead = toCharacter:FindFirstChild("Head")
    if fromHead and toHead then
        for _, child in ipairs(toHead:GetChildren()) do
            if child:IsA("Decal") and child.Name == "face" then
                child:Destroy()
            end
        end
        for _, child in ipairs(fromHead:GetChildren()) do
            if child:IsA("Decal") then
                child:Clone().Parent = toHead
            end
        end
    end
end

function copyMorphAccessories(fromModel, character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, item in ipairs(fromModel:GetChildren()) do
        if item:IsA("Accessory") then
            local clone = item:Clone()
            clone:SetAttribute("ShawarmaMorph", true)
            pcall(function()
                hum:AddAccessory(clone)
            end)
        end
    end
end

function getMorphRigType(model)
    if model:FindFirstChild("UpperTorso", true) or model:FindFirstChild("LowerTorso", true) then
        return "R15"
    end
    return "R6"
end

function ensureMorphAnimator(model)
    local hum = model:FindFirstChildWhichIsA("Humanoid", true)
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator", hum)
        end
        return animator
    end
    local ac = model:FindFirstChildWhichIsA("AnimationController", true)
    if not ac then
        ac = Instance.new("AnimationController", model)
    end
    local animator = ac:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator", ac)
    end
    return animator
end

function clearMorphAnimations()
    if morphAnimStateConn then
        morphAnimStateConn:Disconnect()
        morphAnimStateConn = nil
    end
    morphIdleTrack = nil
    morphMoveTrack = nil
    for _, track in ipairs(morphAnimTracks) do
        pcall(function()
            track:Stop()
        end)
    end
    table.clear(morphAnimTracks)
end

function collectNpcAnimationIds(npcModel)
    local found = {idle = {}, walk = {}, run = {}, other = {}}

    local function addBucket(name, id)
        if not id or id == "" then return end
        local n = name:lower()
        local bucket
        if n:find("idle") then bucket = found.idle
        elseif n:find("run") then bucket = found.run
        elseif n:find("walk") or n:find("move") then bucket = found.walk
        else bucket = found.other
        end
        for _, existing in ipairs(bucket) do
            if existing == id then return end
        end
        table.insert(bucket, id)
    end

    for _, anim in ipairs(npcModel:GetDescendants()) do
        if anim:IsA("Animation") and anim.AnimationId ~= "" then
            addBucket(anim.Name, anim.AnimationId)
        end
    end

    local function scanAnimator(animator)
        if not animator then return end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId ~= "" then
                addBucket(track.Name, track.Animation.AnimationId)
            end
        end
    end

    for _, hum in ipairs(npcModel:GetDescendants()) do
        if hum:IsA("Humanoid") then
            scanAnimator(hum:FindFirstChildOfClass("Animator"))
        end
    end
    for _, ac in ipairs(npcModel:GetDescendants()) do
        if ac:IsA("AnimationController") then
            scanAnimator(ac:FindFirstChildOfClass("Animator"))
        end
    end

    local animate = npcModel:FindFirstChild("Animate", true)
    if animate then
        for _, child in ipairs(animate:GetDescendants()) do
            if child:IsA("Animation") and child.AnimationId ~= "" then
                addBucket(child.Name, child.AnimationId)
            end
        end
        if animate:IsA("LuaSourceContainer") then
            local ok, source = pcall(function()
                return animate.Source
            end)
            if ok and type(source) == "string" then
                for id in source:gmatch("rbxassetid://(%d+)") do
                    addBucket("parsed", "rbxassetid://" .. id)
                end
            end
        end
    end

    return found
end

function startMorphAnimLoop(playerHum)
    if morphAnimStateConn then morphAnimStateConn:Disconnect() end
    morphAnimStateConn = RunService.Heartbeat:Connect(function()
        if not isMorphed then return end
        local hum = (playerHum and playerHum.Parent) and playerHum or getHumanoid()
        if not hum then return end
        local moving = hum.MoveDirection.Magnitude > 0.05
        if moving and morphMoveTrack then
            if morphIdleTrack and morphIdleTrack.IsPlaying then
                morphIdleTrack:Stop(0.12)
            end
            if not morphMoveTrack.IsPlaying then
                morphMoveTrack:Play(0.12)
            end
            morphMoveTrack:AdjustSpeed(math.clamp(hum.WalkSpeed / 16, 0.35, 2.5))
        elseif morphIdleTrack then
            if morphMoveTrack and morphMoveTrack.IsPlaying then
                morphMoveTrack:Stop(0.12)
            end
            if not morphIdleTrack.IsPlaying then
                morphIdleTrack:Play(0.12)
            end
        end
    end)
end

function applyMorphNameHidden(character)
    if not character then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        if morphNameDisplay == nil then
            morphNameDisplay = {
                DisplayDistanceType = hum.DisplayDistanceType,
                HealthDisplayType = hum.HealthDisplayType,
                NameDisplayDistance = hum.NameDisplayDistance,
                HealthDisplayDistance = hum.HealthDisplayDistance,
            }
            pcall(function()
                morphNameDisplay.NameOcclusion = hum.NameOcclusion
            end)
        end
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        hum.NameDisplayDistance = 0
        hum.HealthDisplayDistance = 0
        pcall(function()
            hum.NameOcclusion = Enum.NameOcclusion.OccludeAll
        end)
    end
    for _, inst in ipairs(character:GetDescendants()) do
        if inst:IsA("BillboardGui") then
            if morphPartVisibility[inst] == nil then
                morphPartVisibility[inst] = inst.Enabled
            end
            inst.Enabled = false
        end
    end
end

function restoreMorphNameDisplay(character)
    if not character then
        morphNameDisplay = nil
        return
    end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum and morphNameDisplay then
        hum.DisplayDistanceType = morphNameDisplay.DisplayDistanceType
        hum.HealthDisplayType = morphNameDisplay.HealthDisplayType
        hum.NameDisplayDistance = morphNameDisplay.NameDisplayDistance
        hum.HealthDisplayDistance = morphNameDisplay.HealthDisplayDistance
        pcall(function()
            if morphNameDisplay.NameOcclusion then
                hum.NameOcclusion = morphNameDisplay.NameOcclusion
            end
        end)
    end
    morphNameDisplay = nil
end

function startMorphNameEnforce()
    if morphNameConn then morphNameConn:Disconnect() end
    morphNameConn = RunService.Heartbeat:Connect(function()
        if not isMorphed then return end
        applyMorphNameHidden(LocalPlayer.Character)
    end)
end

function stopMorphNameEnforce()
    if morphNameConn then
        morphNameConn:Disconnect()
        morphNameConn = nil
    end
end

function enforceCharacterHidden(character)
    if not character then return end
    applyMorphNameHidden(character)
    for _, inst in ipairs(character:GetDescendants()) do
        if inst:IsA("BasePart") then
            if morphPartVisibility[inst] == nil then
                morphPartVisibility[inst] = inst.LocalTransparencyModifier
            end
            inst.LocalTransparencyModifier = 1
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            if morphPartVisibility[inst] == nil then
                morphPartVisibility[inst] = inst.Transparency
            end
            inst.Transparency = 1
        end
    end
end

function resetCharacterVisibility(character)
    if not character then return end
    for _, inst in ipairs(character:GetDescendants()) do
        if inst:IsA("BasePart") then
            inst.LocalTransparencyModifier = 0
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            inst.Transparency = 0
        end
    end
end

function setCharacterVisible(character, visible)
    if not character then return end
    if visible then
        if morphHideConn then
            morphHideConn:Disconnect()
            morphHideConn = nil
        end
        for inst, mod in pairs(morphPartVisibility) do
            if inst.Parent then
                if inst:IsA("BasePart") then
                    inst.LocalTransparencyModifier = mod
                elseif inst:IsA("Decal") or inst:IsA("Texture") then
                    inst.Transparency = mod
                elseif inst:IsA("BillboardGui") then
                    inst.Enabled = mod
                end
            end
        end
        table.clear(morphPartVisibility)
        restoreMorphNameDisplay(character)
        resetCharacterVisibility(character)
    else
        enforceCharacterHidden(character)
        if morphHideConn then morphHideConn:Disconnect() end
        morphHideConn = character.DescendantAdded:Connect(function()
            if isMorphed and morphOverlay then
                enforceCharacterHidden(character)
            end
        end)
    end
end

clearMorphOverlay = function()
    if morphOverlayConn then
        morphOverlayConn:Disconnect()
        morphOverlayConn = nil
    end
    if morphOverlayRevealConn then
        morphOverlayRevealConn:Disconnect()
        morphOverlayRevealConn = nil
    end
    clearMorphExtras()
    if morphOverlay then
        morphOverlay:Destroy()
        morphOverlay = nil
    end
    morphHipOffset = 0
    morphPropRotation = nil
    morphAnchorPart = nil
    morphPivotFix = CFrame.new()
    morphUseFullPivotFollow = false
    morphPropGroundLift = 0
    morphHeightAdj = 0
    morphYawAdj = 0
    morphPitchAdj = 0
    morphRollAdj = 0
    morphScale = 1
    morphHudTick = 0
    morphKeysDown.E = false
    morphKeysDown.C = false
    morphKeysDown.Z = false
    morphKeysDown.X = false
    morphKeysDown.V = false
    morphKeysDown.B = false
    morphKeysDown.N = false
    morphKeysDown.M = false
    setCharacterVisible(LocalPlayer.Character, true)
end

setMorphAdjustKey = function(keyCode, down)
    if keyCode == Enum.KeyCode.E then morphKeysDown.E = down
    elseif keyCode == Enum.KeyCode.C then morphKeysDown.C = down
    elseif keyCode == Enum.KeyCode.Z then morphKeysDown.Z = down
    elseif keyCode == Enum.KeyCode.X then morphKeysDown.X = down
    elseif keyCode == Enum.KeyCode.V then morphKeysDown.V = down
    elseif keyCode == Enum.KeyCode.B then morphKeysDown.B = down
    elseif keyCode == Enum.KeyCode.N then morphKeysDown.N = down
    elseif keyCode == Enum.KeyCode.M then morphKeysDown.M = down
    end
end

function applyMorphScale()
    if morphOverlay then
        pcall(function()
            morphOverlay:ScaleTo(morphScale)
        end)
    end
    if morphExtras then
        pcall(function()
            morphExtras:ScaleTo(morphScale)
        end)
    end
end

function updateMorphAdjustHud()
    title.Text = string.format(
        "🎭 MORPH | высота %.1f | Z/X %d° | V/B %d° | N/M %d° | Ж/Э %.2fx",
        morphHeightAdj,
        math.floor(math.deg(morphYawAdj) + 0.5),
        math.floor(math.deg(morphRollAdj) + 0.5),
        math.floor(math.deg(morphPitchAdj) + 0.5),
        morphScale
    )
end

function getModelGroundLift(model)
    local pivotY = model:GetPivot().Position.Y
    local minBottom = math.huge
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            local bottom = part.Position.Y - part.Size.Y * 0.5
            minBottom = math.min(minBottom, bottom)
        end
    end
    if minBottom == math.huge then return 0 end
    return pivotY - minBottom
end

function findOverlayRoot(model)
    local hum = model:FindFirstChildWhichIsA("Humanoid", true)
    if hum then
        local hrp = model:FindFirstChild("HumanoidRootPart", true)
        if hrp and hrp:IsA("BasePart") then return hrp end
    else
        local hrp = model:FindFirstChild("HumanoidRootPart", true)
        if hrp and hrp:IsA("BasePart") and not isMorphUtilityPart(hrp) then
            return hrp
        end
    end

    local rootPart = model:FindFirstChild("RootPart", true)
    if rootPart and rootPart:IsA("BasePart") and not isMorphUtilityPart(rootPart) then
        return rootPart
    end

    if model.PrimaryPart and model.PrimaryPart:IsA("BasePart")
        and not isMorphUtilityPart(model.PrimaryPart) then
        return model.PrimaryPart
    end

    local best, bestScore = nil, -1
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and not isMorphUtilityPart(part) then
            local score = part.Size.X * part.Size.Y * part.Size.Z
            if partHasMorphVisualContent(part) then
                score *= 2
            end
            if score > bestScore then
                bestScore = score
                best = part
            end
        end
    end
    return best or model:FindFirstChildWhichIsA("BasePart", true)
end

function rigidifyMorphOverlay(model)
    local root = findOverlayRoot(model)
    if not root then return end
    model.PrimaryPart = root

    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Constraint")
            or d:IsA("WeldConstraint")
            or d:IsA("Weld")
            or d:IsA("Motor6D")
            or d:IsA("Snap") then
            d:Destroy()
        end
    end

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Massless = true
            part.Anchored = false
            if part ~= root then
                local weld = Instance.new("WeldConstraint")
                weld.Name = "ShawarmaMorphWeld"
                weld.Part0 = root
                weld.Part1 = part
                weld.Parent = root
            end
        end
    end
end

function stripExternalMorphConstraints(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("WeldConstraint") or d:IsA("Weld") or d:IsA("Snap") or d:IsA("Motor6D") then
            local p0, p1 = d.Part0, d.Part1
            if (p0 and not p0:IsDescendantOf(model)) or (p1 and not p1:IsDescendantOf(model)) then
                d:Destroy()
            end
        end
    end
end

function sanitizeMorphOverlay(model, rigid)
    local overlayHum = model:FindFirstChildWhichIsA("Humanoid", true)
    local compositeRig = not rigid and not overlayHum and hasMorphRig(model)
    local rigRoots = compositeRig and getMotor6DRigRoots(model) or {}

    stripExternalMorphConstraints(model)

    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ModuleScript") or d:IsA("Script") then
            d:Destroy()
        elseif d:IsA("LocalScript") then
            if rigid or d.Name ~= "Animate" then
                d:Destroy()
            end
        elseif d:IsA("Humanoid") then
            if rigid then
                d:Destroy()
            else
                d.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                d.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                d.PlatformStand = false
                d.AutoRotate = false
                d.WalkSpeed = 16
                d.JumpPower = 0
                pcall(function()
                    d.JumpHeight = 0
                end)
            end
        elseif d:IsA("BodyVelocity") or d:IsA("BodyGyro") or d:IsA("BodyPosition") then
            d:Destroy()
        elseif d:IsA("AlignPosition") or d:IsA("AlignOrientation") then
            d:Destroy()
        elseif d:IsA("BasePart") and not rigid then
            d.CanCollide = false
            d.CanQuery = false
            d.CanTouch = false
            d.Massless = true
            if compositeRig then
                d.Anchored = false
            elseif rigRoots[d] then
                d.Anchored = true
            elseif shouldUnanchorMorphPart(d, model, rigRoots) then
                d.Anchored = false
            end
        end
    end

    local root = findOverlayRoot(model)
    if root then
        model.PrimaryPart = root
    end

    if rigid then
        rigidifyMorphOverlay(model)
    else
        ensureMorphAnimator(model)
    end

    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then
            d.CastShadow = true
            d.LocalTransparencyModifier = 0
        end
    end

    stripMorphInteractObjects(model)
end

function syncMorphAnchorPivot()
    if morphOverlay and morphAnchorPart and morphAnchorPart.Parent then
        morphOverlay.PrimaryPart = morphAnchorPart
        morphOverlay.WorldPivot = morphAnchorPart.CFrame
    end
end

function placeMorphOverlayFollow(overlay, targetAnchorCF)
    local anchor = morphAnchorPart
    if morphUseFullPivotFollow or not (anchor and anchor:IsA("BasePart") and anchor.Parent) then
        if anchor and anchor.Parent then
            overlay.PrimaryPart = anchor
        end
        overlay:PivotTo(targetAnchorCF * morphPivotFix)
        return
    end
    anchor.CFrame = targetAnchorCF
end

function findMorphUpHint(model, anchor)
    local head = model:FindFirstChild("Head", true)
    if head and head:IsA("BasePart") and head ~= anchor then
        local dir = head.Position - anchor.Position
        if dir.Magnitude > 0.1 and dir.Unit:Dot(Vector3.yAxis) > 0.25 then
            return dir
        end
    end
    local torso = model:FindFirstChild("UpperTorso", true) or model:FindFirstChild("Torso", true)
    if torso and torso:IsA("BasePart") and torso ~= anchor then
        local dir = torso.Position - anchor.Position
        if dir.Magnitude > 0.1 and dir.Unit:Dot(Vector3.yAxis) > 0.25 then
            return dir
        end
    end

    local cf, size = model:GetBoundingBox()
    local tallestDir = cf.RightVector
    local tallestLen = size.X
    if size.Y > tallestLen then
        tallestLen = size.Y
        tallestDir = cf.UpVector
    end
    if size.Z > tallestLen then
        tallestLen = size.Z
        tallestDir = cf.LookVector
    end
    if tallestDir:Dot(Vector3.yAxis) < 0 then
        tallestDir = -tallestDir
    end
    return tallestDir
end

function rebaseMorphOverlayUpright(model, anchor)
    local upHint = findMorphUpHint(model, anchor)
    if upHint.Magnitude < 0.05 then return end
    local up = upHint.Unit
    if up:Dot(Vector3.yAxis) > 0.95 then return end

    local pivot = anchor.Position
    local axis = up:Cross(Vector3.yAxis)
    local fix
    if axis.Magnitude < 0.01 then
        local fwd = anchor.CFrame.LookVector
        fwd = Vector3.new(fwd.X, 0, fwd.Z)
        if fwd.Magnitude < 0.01 then
            fwd = Vector3.new(0, 0, -1)
        else
            fwd = fwd.Unit
        end
        fix = CFrame.fromAxisAngle(fwd, math.pi)
    else
        fix = CFrame.fromAxisAngle(axis.Unit, math.acos(math.clamp(up:Dot(Vector3.yAxis), -1, 1)))
    end

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CFrame = CFrame.new(pivot) * fix * CFrame.new(-pivot) * part.CFrame
        end
    end
end

function getMorphAnchorCFrame(charRoot, morphAdjust)
    local vertLift = morphHeightAdj + morphHipOffset * morphScale
    local pos = charRoot.Position + Vector3.new(0, vertLift, 0)
    local look = charRoot.CFrame.LookVector
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 0.01 then
        look = Vector3.new(0, 0, -1)
    else
        look = look.Unit
    end
    return CFrame.lookAt(pos, pos + look, Vector3.yAxis) * morphAdjust
end

function setupMorphAnchorFollow(overlay, charHum, npcHum)
    local anchor = findOverlayRoot(overlay)
    if not anchor then return false end

    rebaseMorphOverlayUpright(overlay, anchor)
    anchor = findOverlayRoot(overlay) or anchor

    if npcHum then
        morphHipOffset = charHum.HipHeight - npcHum.HipHeight - morphDropOffset
    else
        morphHipOffset = getModelGroundLift(overlay) - charHum.HipHeight - 0.12
    end

    morphAnchorPart = anchor
    overlay.PrimaryPart = anchor
    overlay.WorldPivot = anchor.CFrame
    morphPivotFix = anchor.CFrame:ToObjectSpace(overlay:GetPivot())
    morphUseFullPivotFollow = not overlay:FindFirstChildWhichIsA("Humanoid", true)
    return true
end

function attachMorphOverlay(npcModel, rigid)
    clearMorphOverlay()
    local character = LocalPlayer.Character
    if not character then return false end
    local charRoot = character:FindFirstChild("HumanoidRootPart")
    local charHum = character:FindFirstChildOfClass("Humanoid")
    if not charRoot or not charHum then return false end

    if npcModel:IsA("BasePart") then
        local wrapper = Instance.new("Model")
        wrapper.Name = "ShawarmaMorphOverlay"
        local partClone = npcModel:Clone()
        partClone.Parent = wrapper
        wrapper.PrimaryPart = partClone
        morphOverlay = wrapper
    else
        morphOverlay = npcModel:Clone()
        morphOverlay.Name = "ShawarmaMorphOverlay"
    end
    sanitizeMorphOverlay(morphOverlay, rigid)
    morphOverlay.Parent = Workspace

    local npcHum = npcModel:FindFirstChildWhichIsA("Humanoid", true)
    if rigid then
        local pivot = morphOverlay:GetPivot()
        morphPropRotation = pivot - pivot.Position
        morphPropGroundLift = getModelGroundLift(morphOverlay)
        morphHipOffset = 0
        morphAnchorPart = nil
    else
        if not setupMorphAnchorFollow(morphOverlay, charHum, npcHum) then
            morphAnchorPart = nil
            if npcHum then
                morphHipOffset = charHum.HipHeight - npcHum.HipHeight - morphDropOffset
            else
                morphHipOffset = getModelGroundLift(morphOverlay) - charHum.HipHeight - 0.12
            end
        end
    end

    if not rigid then
        placeMorphOverlayFollow(morphOverlay, getMorphAnchorCFrame(charRoot, CFrame.new()))
    end

    setCharacterVisible(character, false)

    morphOverlayConn = RunService.PreRender:Connect(function(dt)
        if not morphOverlay or not morphOverlay.Parent then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local charHum = char and char:FindFirstChildOfClass("Humanoid")
        if not root then return end
        enforceCharacterHidden(char)

        local rotSpeed = (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            or UserInputService:IsKeyDown(Enum.KeyCode.RightShift))
            and MORPH_FAST_MULT or 1

        if UserInputService:IsKeyDown(Enum.KeyCode.Z) then
            morphYawAdj -= MORPH_YAW_SPEED * rotSpeed * dt
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.X) then
            morphYawAdj += MORPH_YAW_SPEED * rotSpeed * dt
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.V) then
            morphRollAdj += MORPH_ROLL_SPEED * rotSpeed * dt
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.B) then
            morphRollAdj -= MORPH_ROLL_SPEED * rotSpeed * dt
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.N) then
            morphPitchAdj -= MORPH_PITCH_SPEED * rotSpeed * dt
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.M) then
            morphPitchAdj += MORPH_PITCH_SPEED * rotSpeed * dt
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) and not hasMorphInteractionPrompt() then
            morphHeightAdj += MORPH_HEIGHT_SPEED * rotSpeed * dt
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.C) then
            morphHeightAdj -= MORPH_HEIGHT_SPEED * rotSpeed * dt
        end
        local scaleChanged = false
        if UserInputService:IsKeyDown(Enum.KeyCode.Semicolon) then
            morphScale = math.min(MORPH_SCALE_MAX, morphScale + MORPH_SCALE_SPEED * rotSpeed * dt)
            scaleChanged = true
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Quote) then
            morphScale = math.max(MORPH_SCALE_MIN, morphScale - MORPH_SCALE_SPEED * rotSpeed * dt)
            scaleChanged = true
        end
        if scaleChanged then
            applyMorphScale()
            if morphAnchorPart and morphAnchorPart.Parent then
                morphPivotFix = morphAnchorPart.CFrame:ToObjectSpace(morphOverlay:GetPivot())
            end
        end

        local adjusting = UserInputService:IsKeyDown(Enum.KeyCode.E)
            or UserInputService:IsKeyDown(Enum.KeyCode.C)
            or UserInputService:IsKeyDown(Enum.KeyCode.Z)
            or UserInputService:IsKeyDown(Enum.KeyCode.X)
            or UserInputService:IsKeyDown(Enum.KeyCode.V)
            or UserInputService:IsKeyDown(Enum.KeyCode.B)
            or UserInputService:IsKeyDown(Enum.KeyCode.N)
            or UserInputService:IsKeyDown(Enum.KeyCode.M)
            or UserInputService:IsKeyDown(Enum.KeyCode.Semicolon)
            or UserInputService:IsKeyDown(Enum.KeyCode.Quote)
        if adjusting then
            morphYawAdj = morphYawAdj % (math.pi * 2)
            morphPitchAdj = morphPitchAdj % (math.pi * 2)
            morphRollAdj = morphRollAdj % (math.pi * 2)
            morphHudTick += dt
            if morphHudTick >= 0.12 then
                morphHudTick = 0
                updateMorphAdjustHud()
            end
        end

        local morphAdjust = CFrame.Angles(morphPitchAdj, morphYawAdj, morphRollAdj)
        local scaledGroundLift = morphPropGroundLift * morphScale

        if rigid and morphPropRotation then
            local feetY = root.Position.Y - (charHum and charHum.HipHeight or 2)
            local targetPos = Vector3.new(
                root.Position.X,
                feetY + scaledGroundLift - morphDropOffset + morphHeightAdj,
                root.Position.Z
            )
            morphOverlay:PivotTo(CFrame.new(targetPos) * morphAdjust * morphPropRotation)
            stabilizeMorphAssembly(morphOverlay)
        else
            placeMorphOverlayFollow(morphOverlay, getMorphAnchorCFrame(root, morphAdjust))
            stabilizeMorphAssembly(morphOverlay)
        end
    end)
    return true
end

function shouldUseMorphOverlay(npcModel, descriptionApplied)
    if isPlayerCharacterModel(npcModel) then
        return true
    end
    if not npcModel:FindFirstChildOfClass("Humanoid") then
        return true
    end
    for _, child in ipairs(npcModel:GetChildren()) do
        if child:IsA("MeshPart") and not STANDARD_BODY_NAMES[child.Name] then
            return true
        end
        if child:IsA("Model") then
            return true
        end
    end
    return false
end

function applyNpcAnimations(npcModel, playerHum, animTarget, collectedIds)
    clearMorphAnimations()
    animTarget = animTarget or playerHum.Parent
    if not animTarget then return end

    collectedIds = collectedIds or collectNpcAnimationIds(npcModel)

    if morphOverlay then
        local animate = morphOverlay:FindFirstChild("Animate", true)
        if animate then animate:Destroy() end
    end

    local animator = ensureMorphAnimator(animTarget)
    if not animator then return end

    local idleAnim, moveAnim = nil, nil
    for _, anim in ipairs(npcModel:GetDescendants()) do
        if anim:IsA("Animation") and anim.AnimationId ~= "" then
            local name = anim.Name:lower()
            if not idleAnim and name:find("idle") then
                idleAnim = anim
            elseif not moveAnim and (name:find("walk") or name:find("run") or name:find("move")) then
                moveAnim = anim
            end
        end
    end

    local std = STANDARD_MORPH_ANIMS[getMorphRigType(npcModel)]
    if not std and animTarget == morphOverlay then
        std = STANDARD_MORPH_ANIMS[getMorphRigType(animTarget)]
    end

    local function loadTrack(animId, priority)
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        local track = animator:LoadAnimation(anim)
        track.Priority = priority
        track.Looped = true
        table.insert(morphAnimTracks, track)
        return track
    end

    local function loadFrom(animObj, priority)
        return loadTrack(animObj.AnimationId, priority)
    end

    local function pickId(bucket, fallbackObj, stdId)
        if collectedIds[bucket] and collectedIds[bucket][1] then
            return collectedIds[bucket][1]
        end
        if bucket == "walk" and collectedIds.run and collectedIds.run[1] then
            return collectedIds.run[1]
        end
        if bucket == "walk" and collectedIds.other then
            for _, id in ipairs(collectedIds.other) do
                return id
            end
        end
        if fallbackObj then return fallbackObj.AnimationId end
        return stdId
    end

    local idleId = pickId("idle", idleAnim, std and std.idle)
    local moveId = pickId("walk", moveAnim, std and std.walk)

    if idleId then
        morphIdleTrack = loadTrack(idleId, Enum.AnimationPriority.Idle)
    end

    if moveId then
        morphMoveTrack = loadTrack(moveId, Enum.AnimationPriority.Movement)
    end

    if morphIdleTrack or morphMoveTrack then
        if morphIdleTrack then morphIdleTrack:Play() end
        startMorphAnimLoop(playerHum)
    end
end

function applyMorphWalkSpeed(npcHum)
    if npcHum.WalkSpeed > 0 then
        walkSpeed = math.clamp(npcHum.WalkSpeed, walkSpeedMin, walkSpeedMax)
        applyWalkSpeed()
    end
end

demorphCharacter = function()
    if not isMorphed then return end

    stopMorphNameEnforce()
    local wasOverlay = morphUsedOverlay
    clearMorphOverlay()
    clearMorphAnimations()

    local character = LocalPlayer.Character
    if character then
        removeMorphAccessories(character)
        restoreMorphNameDisplay(character)
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not wasOverlay and hum and savedDescription then
            pcall(function()
                hum:ApplyDescription(savedDescription, Enum.AssetTypeVerification.Always)
            end)
        else
            resetCharacterVisibility(character)
        end
        local backupStats = savedMorphStats
        restoreMorphStats(hum)
        if hum and backupStats then
            task.defer(function()
                local h = getHumanoid()
                if h and not isMorphed then
                    walkSpeed = backupStats.walkSpeed
                    h.HipHeight = backupStats.HipHeight
                    h.JumpPower = backupStats.JumpPower
                    pcall(function()
                        h.JumpHeight = backupStats.JumpHeight
                    end)
                    if not playerLocked then
                        h.WalkSpeed = walkSpeed
                    end
                    if h.Health > 0 then
                        h:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    if wasOverlay and LocalPlayer.Character then
                        resetCharacterVisibility(LocalPlayer.Character)
                    end
                end
            end)
        end
    end

    isMorphed = false
    morphSourceName = nil
    morphUsedOverlay = false
    savedDescription = nil
    applyWalkSpeed()
    title.Text = "🎮 YOU'RE PLAYING"
end

morphIntoNpc = function(npcModel)
    local character = LocalPlayer.Character
    if not character then
        title.Text = "⚠ No character"
        return false
    end

    local playerHum = character:FindFirstChildOfClass("Humanoid")
    local npcHum = npcModel:FindFirstChildOfClass("Humanoid")
    if not playerHum then
        title.Text = "⚠ No Humanoid"
        return false
    end

    saveOriginalAppearance(character)
    saveMorphStats(playerHum)
    removeMorphAccessories(character)
    clearMorphOverlay()
    clearMorphAnimations()
    morphUsedOverlay = false

    local npcAnimIds = collectNpcAnimationIds(npcModel)
    local useOverlay = shouldUseMorphOverlay(npcModel, false)
    local descriptionApplied = false
    local playerChars = getPlayerCharacters()
    local rigidProp = isInanimateTarget(npcModel, playerChars)
    local npcHasRig = hasMorphRig(npcModel)
    local useRigidOverlay = rigidProp and not npcHasRig

    if npcHum and not useOverlay then
        pcall(function()
            local desc = npcHum:GetAppliedDescription()
            playerHum:ApplyDescription(desc, Enum.AssetTypeVerification.Always)
            descriptionApplied = true
        end)
        copyBodyVisuals(npcModel, character, true)
        copyMorphAccessories(npcModel, character)
        applyMorphWalkSpeed(npcHum)
    elseif useOverlay then
        if not attachMorphOverlay(npcModel, useRigidOverlay) then
            restoreMorphStats(playerHum)
            title.Text = "⚠ Overlay failed"
            return false
        end
        morphUsedOverlay = true
        revealOverlayExtraParts(morphOverlay)
    else
        copyBodyVisuals(npcModel, character)
    end

    if not useRigidOverlay then
        local graftAnchor = character:FindFirstChild("HumanoidRootPart")
        if graftAnchor then
            pcall(function()
                attachMorphExtraParts(npcModel, graftAnchor, morphOverlay)
            end)
        end
        if not useRigidOverlay and morphUsedOverlay then
            applyNpcAnimations(npcModel, playerHum, morphOverlay, npcAnimIds)
        end
    end

    isMorphed = true
    morphSourceName = npcModel.Name
    startMorphNameEnforce()
    applyMorphNameHidden(character)
    if descriptionApplied and not morphUsedOverlay then
        pcall(function()
            applyNpcHeadToCharacter(npcModel, character)
        end)
    end
    title.Text = "🎭 MORPH: " .. npcModel.Name
    return true
end

end -- morph scope

local SPECTATOR_LOCK_ACTION = "ShawarmaSpectatorLock"
local playerLocked = false
local savedHumanoidState = nil
local playerFreezeConn = nil
local freezeCFrame = nil
local disabledHumanoidStates = {}
local didAnchorFreeze = false

function applyPlayerFreezeSnapshot()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = getHumanoid()

    if root then
        if not freezeCFrame then
            freezeCFrame = root.CFrame
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if not root.Anchored then
            root.Anchored = true
            didAnchorFreeze = true
        end
    end

    if not humanoid then return end

    if not savedHumanoidState then
        savedHumanoidState = {
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            JumpHeight = humanoid.JumpHeight,
            AutoRotate = humanoid.AutoRotate,
        }
        table.clear(disabledHumanoidStates)
        for _, state in ipairs({
            Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.Physics,
            Enum.HumanoidStateType.Freefall,
            Enum.HumanoidStateType.Jumping,
        }) do
            if humanoid:GetStateEnabled(state) then
                table.insert(disabledHumanoidStates, state)
                humanoid:SetStateEnabled(state, false)
            end
        end
    end

    humanoid.PlatformStand = true
    humanoid.Sit = false
    humanoid.AutoRotate = false
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    pcall(function()
        humanoid.JumpHeight = 0
    end)
end

function lockPlayerControl()
    if not playerLocked then
        playerLocked = true

        ContextActionService:BindAction(SPECTATOR_LOCK_ACTION, function()
            return Enum.ContextActionResult.Sink
        end, false,
            Enum.PlayerActions.CharacterForward,
            Enum.PlayerActions.CharacterBackward,
            Enum.PlayerActions.CharacterLeft,
            Enum.PlayerActions.CharacterRight,
            Enum.PlayerActions.CharacterJump
        )

        if playerFreezeConn then playerFreezeConn:Disconnect() end
        playerFreezeConn = RunService.Heartbeat:Connect(function()
            if not playerLocked then return end

            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if root and freezeCFrame then
                if not root.Anchored then
                    root.Anchored = true
                end
                root.CFrame = freezeCFrame
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end

            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.PlatformStand = true
                humanoid.JumpPower = 0
            end
        end)
    end

    applyPlayerFreezeSnapshot()
end

function unlockPlayerControl()
    if not playerLocked then return end
    playerLocked = false

    if playerFreezeConn then
        playerFreezeConn:Disconnect()
        playerFreezeConn = nil
    end

    ContextActionService:UnbindAction(SPECTATOR_LOCK_ACTION)

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and didAnchorFreeze then
        root.Anchored = false
        didAnchorFreeze = false
    end

    local humanoid = getHumanoid()
    if humanoid then
        for _, state in ipairs(disabledHumanoidStates) do
            humanoid:SetStateEnabled(state, true)
        end
        table.clear(disabledHumanoidStates)

        humanoid.PlatformStand = false
        humanoid.Sit = false
        humanoid.AutoRotate = savedHumanoidState and savedHumanoidState.AutoRotate ~= false
        humanoid.WalkSpeed = walkSpeed
        if savedHumanoidState and savedHumanoidState.JumpPower then
            humanoid.JumpPower = savedHumanoidState.JumpPower
        end
        if savedHumanoidState and savedHumanoidState.JumpHeight then
            pcall(function()
                humanoid.JumpHeight = savedHumanoidState.JumpHeight
            end)
        end

        task.defer(function()
            local hum = getHumanoid()
            if hum and hum.Parent and hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end

    savedHumanoidState = nil
    freezeCFrame = nil
    didAnchorFreeze = false
end

function startCamera(root, model)
    if not root or not root.Parent then
        handleTargetLost()
        return
    end
    if stopFreeCam then stopFreeCam(false) end
    currentRoot = root
    currentModel = model or getModelFromRoot(root)
    lastNPC = root
    isSpectating = true
    if spectatePlayerFrozen then
        lockPlayerControl()
    else
        unlockPlayerControl()
        applyWalkSpeed()
    end
    yaw = 0
    pitch = 0
    smoothYaw = 0
    smoothPitch = 0
    smoothDistance = distance
    Camera.CameraType = Enum.CameraType.Scriptable
    applyCameraMouseLock()
    if camConn then camConn:Disconnect() end
    camConn = RunService.RenderStepped:Connect(function(dt)
        if not currentRoot or not currentRoot.Parent then
            handleTargetLost()
            return
        end
        if currentModel and not currentModel.Parent then
            handleTargetLost()
            return
        end
        if not mouseVisible then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            UserInputService.MouseIconEnabled = false
            local delta = UserInputService:GetMouseDelta()
            yaw -= delta.X * sensitivity
            pitch -= delta.Y * sensitivity
            pitch = math.clamp(pitch, -1.2, 1.2)
        end
        local t = math.min(lerpSpeed * dt * 60, 1)
        smoothYaw = smoothYaw + (yaw - smoothYaw) * t
        smoothPitch = smoothPitch + (pitch - smoothPitch) * t
        smoothDistance = smoothDistance + (distance - smoothDistance) * t
        local rot = CFrame.Angles(0, smoothYaw, 0) * CFrame.Angles(smoothPitch, 0, 0)
        local offset = rot:VectorToWorldSpace(Vector3.new(0, height, smoothDistance))
        local camPos = currentRoot.Position + offset
        Camera.CFrame = CFrame.new(camPos, currentRoot.Position + Vector3.new(0, height, 0))
    end)
end

resetCamera = function()
    if stopFreeCam then stopFreeCam(false) end
    demorphCharacter()
    if camConn then camConn:Disconnect() camConn = nil end
    currentRoot = nil
    currentModel = nil
    isSpectating = false
    unlockPlayerControl()
    releaseCameraMouseLock()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    Camera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
    applyPlayZoomUnlock()
    title.Text = "🎮 YOU'RE PLAYING"
end

function leaveSpectateForMorph()
    if stopFreeCam then stopFreeCam(false) end
    if camConn then camConn:Disconnect() camConn = nil end
    currentRoot = nil
    currentModel = nil
    isSpectating = false
    unlockPlayerControl()
    releaseCameraMouseLock()
    Camera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end

function toggleMorph()
    if isMorphed then
        demorphCharacter()
        return
    end

    if not isSpectating or not currentModel then
        title.Text = "⚠ Select NPC first"
        return
    end

    local npc = currentModel
    if not npc.Parent then
        title.Text = "⚠ NPC gone"
        return
    end

    if not npc:FindFirstChildOfClass("Humanoid")
        and not npc:FindFirstChildOfClass("AnimationController")
        and not isMorphableTarget(npc) then
        title.Text = "⚠ Not morphable"
        return
    end

    leaveSpectateForMorph()
    local morphOk, morphResult = pcall(morphIntoNpc, npc)
    if not morphOk or not morphResult then
        demorphCharacter()
        title.Text = morphOk and "⚠ Morph failed" or "⚠ Morph error"
        return
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    setMouseVisible(false)
end

handleTargetLost = function()
    pruneDeadTargets()
    for _, entry in ipairs(targets) do
        if isTargetAlive(entry) then
            startCamera(entry.root, entry.model)
            title.Text = "⚠ Switched: " .. entry.model.Name
            return
        end
    end
    resetCamera()
    title.Text = "⚠ Target lost — press R"
end

function selectTarget(idx)
    pruneDeadTargets()
    local entry = targets[idx]
    if not isTargetAlive(entry) then
        refreshList()
        entry = targets[idx]
    end
    if not isTargetAlive(entry) then
        title.Text = "⚠ [" .. getKeyLabel(idx) .. "] empty"
        return
    end
    startCamera(entry.root, entry.model)
    title.Text = "👁 [" .. getKeyLabel(idx) .. "] " .. entry.model.Name
    applyCameraMouseLock()
end

function refreshList()
    targets = {}
    local seenModels = {}
    local playerChars = getPlayerCharacters()
    local charRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local spectateModel = resolveSpectateModel(obj, playerChars)
            if spectateModel and not seenModels[spectateModel] then
                local root = getRootPart(spectateModel)
                if root then
                    local dist = charRoot and (charRoot.Position - root.Position).Magnitude or 999999
                    if not includeInanimate or dist <= INANIMATE_SEARCH_DIST then
                        seenModels[spectateModel] = true
                        table.insert(targets, {
                            model = spectateModel,
                            root = root,
                            dist = dist,
                            inanimate = includeInanimate,
                        })
                    end
                end
            end
        elseif includeInanimate and isStandalonePropPart(obj) and isInanimateTarget(obj, playerChars) then
            if not seenModels[obj] then
                local dist = charRoot and (charRoot.Position - obj.Position).Magnitude or 999999
                if dist <= INANIMATE_SEARCH_DIST then
                    seenModels[obj] = true
                    table.insert(targets, {
                        model = obj,
                        root = obj,
                        dist = dist,
                        inanimate = true,
                    })
                end
            end
        end
    end

    table.sort(targets, function(a, b) return a.dist < b.dist end)

    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    for i, entry in ipairs(targets) do
        local npc = entry.model
        local root = entry.root
        local dist = math.floor(entry.dist)
        local tag = entry.inanimate and "📦 " or "👤 "
        local row = Instance.new("Frame", list)
        row.Size = UDim2.new(1,-6,0,32)
        row.BackgroundTransparency = 1
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundColor3 = entry.inanimate and Color3.fromRGB(45, 45, 70) or Color3.fromRGB(50,50,50)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = " [" .. getKeyLabel(i) .. "] " .. tag .. npc.Name .. "  [" .. dist .. "m]"
        btn.MouseButton1Click:Connect(function()
            if not isTargetAlive({model = npc, root = root}) then
                refreshList()
                title.Text = "⚠ Target gone — press R"
                return
            end
            startCamera(root, npc)
            title.Text = "👁 " .. npc.Name
            applyCameraMouseLock()
        end)
    end

    list.CanvasSize = UDim2.new(0,0,0,#targets * 36)
    if includeInanimate then
        title.Text = "Found: " .. #targets .. " (props " .. INANIMATE_SEARCH_DIST .. "m)"
    else
        title.Text = "Found: " .. #targets .. " (NPC)"
    end
end

function toggleSpectatePlayerFreeze()
    if not isSpectating or isFreeCam then
        title.Text = "⚠ Spectate NPC first"
        return
    end

    spectatePlayerFrozen = not spectatePlayerFrozen
    if spectatePlayerFrozen then
        lockPlayerControl()
        title.Text = "🔒 PLAYER LOCKED — Num2"
    else
        unlockPlayerControl()
        applyWalkSpeed()
        title.Text = "🏃 MOVE WHILE WATCH — Num2"
    end

    local npcName = currentModel and currentModel.Name or "SPECTATE"
    task.delay(1.5, function()
        if title.Text == "🔒 PLAYER LOCKED — Num2" or title.Text == "🏃 MOVE WHILE WATCH — Num2" then
            title.Text = "👁 " .. npcName
        end
    end)
end

function getSelectedPaintColor()
    local entry = PAINT_COLORS[paintColorIndex]
    return entry and entry.color or PAINT_COLORS[1].color
end

function getPaintStatusTitle()
    local entry = PAINT_COLORS[paintColorIndex] or PAINT_COLORS[1]
    return "🎨 [" .. getKeyLabel(paintColorIndex) .. "] " .. entry.name .. " | Alt+LMB"
end

function refreshPaintList()
    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("Frame") then
            c:Destroy()
        end
    end

    for i, entry in ipairs(PAINT_COLORS) do
        local selected = i == paintColorIndex
        local row = Instance.new("Frame", list)
        row.Size = UDim2.new(1, -6, 0, 32)
        row.BackgroundTransparency = 1

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = entry.color
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.BorderSizePixel = selected and 2 or 0
        btn.BorderColor3 = Color3.fromRGB(255, 230, 80)
        btn.Text = " [" .. getKeyLabel(i) .. "]  🎨 " .. entry.name
        btn.MouseButton1Click:Connect(function()
            selectPaintColor(i)
        end)
    end

    list.CanvasSize = UDim2.new(0, 0, 0, #PAINT_COLORS * 36)
    title.Text = getPaintStatusTitle()
end

function selectPaintColor(idx)
    if not paintMode or not PAINT_COLORS[idx] then
        return
    end
    paintColorIndex = idx
    refreshPaintList()
end

function validateSpectateForSearchMode()
    if not isSpectating or not currentModel then
        return
    end
    local playerChars = getPlayerCharacters()
    local stillValid = includeInanimate
        and isInanimateTarget(currentModel, playerChars)
        or (not includeInanimate and isLivingTarget(currentModel, playerChars))
    if not stillValid then
        resetCamera()
    end
end

function toggleNum1Mode()
    if paintMode then
        paintMode = false
        includeInanimate = false
        validateSpectateForSearchMode()
        refreshList()
        title.Text = "👤 NPC ONLY — Num1"
        task.delay(1.5, function()
            if title.Text == "👤 NPC ONLY — Num1" then
                title.Text = "🥙 NPC CAMERA"
            end
        end)
        return
    end

    if includeInanimate then
        paintMode = true
        paintColorIndex = 1
        refreshPaintList()
        task.delay(1.5, function()
            if paintMode and title.Text == getPaintStatusTitle() then
                title.Text = getPaintStatusTitle()
            end
        end)
        return
    end

    includeInanimate = true
    validateSpectateForSearchMode()
    refreshList()
    title.Text = "📦 PROPS ON — Num1"
    task.delay(1.5, function()
        if title.Text == "📦 PROPS ON — Num1" then
            title.Text = "Found: " .. #targets .. " (props " .. INANIMATE_SEARCH_DIST .. "m)"
        end
    end)
end

refresh.MouseButton1Click:Connect(function()
    if paintMode then
        refreshPaintList()
    else
        refreshList()
    end
end)
resetBtn.MouseButton1Click:Connect(resetCamera)
task.defer(function()
    pcall(refreshList)
end)

local baseFreeCamSpeed = 1.5
local freeCamPos = Vector3.new()
local freeCamConn = nil
local smoothFreeCamPos = Vector3.new()
local smoothFreeCamYaw = 0
local smoothFreeCamPitch = 0
local freeCamLerpSpeed = 0.13

applyWalkSpeed = function()
    if playerLocked then return end
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = walkSpeed
    end
end

function changeWalkSpeed(delta)
    walkSpeed = math.clamp(walkSpeed + delta, walkSpeedMin, walkSpeedMax)
    applyWalkSpeed()
    local prevTitle = title.Text
    local label = isFreeCam and "🎥 Cam speed: " or "🏃 Speed: "
    title.Text = label .. walkSpeed
    task.delay(1.5, function()
        if title.Text == label .. walkSpeed then
            title.Text = prevTitle
        end
    end)
end

do
    local humanoid = getHumanoid()
    if humanoid then
        walkSpeed = humanoid.WalkSpeed
    end
end

local isNoclip = false
local noclipConn = nil
local noclipSavedCollide = {}

function applyNoclipToCharacter(character, enabled)
    if not character then return end
    if enabled then
        for _, inst in ipairs(character:GetDescendants()) do
            if inst:IsA("BasePart") then
                if noclipSavedCollide[inst] == nil then
                    noclipSavedCollide[inst] = inst.CanCollide
                end
                inst.CanCollide = false
            end
        end
    else
        for inst, wasCollide in pairs(noclipSavedCollide) do
            if inst.Parent then
                inst.CanCollide = wasCollide
            end
        end
        table.clear(noclipSavedCollide)
    end
end

function setNoclip(enabled)
    if enabled == isNoclip then return end
    isNoclip = enabled

    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end

    applyNoclipToCharacter(LocalPlayer.Character, enabled)

    if enabled then
        noclipConn = RunService.Heartbeat:Connect(function()
            if not isNoclip or playerLocked then return end
            applyNoclipToCharacter(LocalPlayer.Character, true)
        end)
    end
end

function toggleNoclip()
    if playerLocked then
        title.Text = "⚠ Noclip blocked"
        return
    end
    local prevTitle = title.Text
    setNoclip(not isNoclip)
    title.Text = isNoclip and "👻 NOCLIP ON" or "👻 NOCLIP OFF"
    task.delay(1.5, function()
        if title.Text == "👻 NOCLIP ON" or title.Text == "👻 NOCLIP OFF" then
            title.Text = prevTitle
        end
    end)
end

local godModeConn = nil
local godModeHumConn = nil
local godModeStateConn = nil
local godModeDiedConn = nil
local godModeDescendantConn = nil
local godModeCharRemovingConn = nil
local godModeSaved = nil
local godModeHooksInstalled = false
local godMutedRemoteConns = {}
local godMutedDiedConns = {}
local godSavedCharacterAutoLoads = nil
local godLastSpyRemote = ""

local GOD_DAMAGE_REMOTE_HINTS = {
    "damage", "hurt", "hit", "attack", "kill", "death", "die",
    "lethal", "slay", "wound", "injure", "harm", "bite", "claw",
    "eliminate", "execute", "finisher", "ragdoll", "ko", "knock",
    "bleed", "burn", "poison", "stun", "downed", "lethal",
}

local function isLocalCharacter(inst)
    if typeof(inst) ~= "Instance" then return false end
    local character = LocalPlayer.Character
    if not character then return false end
    return inst == character or inst:IsDescendantOf(character)
end

local function isLocalHumanoid(inst)
    return typeof(inst) == "Instance" and inst:IsA("Humanoid") and inst.Parent == LocalPlayer.Character
end

function getRemoteFromSignal(sig)
    if typeof(sig) ~= "RBXScriptSignal" and typeof(sig) ~= "Instance" then return nil end
    local parent = sig.Parent
    if parent and (parent:IsA("RemoteEvent") or parent:IsA("UnreliableRemoteEvent")) then
        return parent
    end
    return nil
end

function looksLikeDamageRemote(inst)
    if typeof(inst) ~= "Instance" then return false end
    if not (inst:IsA("RemoteEvent") or inst:IsA("UnreliableRemoteEvent") or inst:IsA("RemoteFunction")) then
        return false
    end
    local name = string.lower(inst.Name)
    for _, hint in ipairs(GOD_DAMAGE_REMOTE_HINTS) do
        if string.find(name, hint, 1, true) then
            return true
        end
    end
    return false
end

function getInstancePath(inst)
    local parts = {}
    local current = inst
    while current and current ~= game do
        table.insert(parts, 1, current.Name)
        current = current.Parent
    end
    return table.concat(parts, ".")
end

function logGodRemote(direction, remote)
    if typeof(remote) ~= "Instance" then return end
    local path = getInstancePath(remote)
    godLastSpyRemote = direction .. " " .. path
    print("[ShawarmaSpectator GOD-SPY] " .. godLastSpyRemote)
    if godHpLabel.Visible then
        updateGodHpLabel(getHumanoid())
    end
end

function syncGodModeHealthGui()
    pcall(function()
        if godMode then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)
        elseif not gameUIHidden then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)
        else
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
        end
    end)
end

function updateGodHpLabel(hum)
    if not godHpLabel.Visible then return end
    local lines = {}
    if hum and hum.Parent then
        if hum.MaxHealth >= math.huge / 2 then
            table.insert(lines, "HP ∞ | GOD x5")
        else
            local hp = math.floor(hum.Health + 0.5)
            local maxHp = math.floor(hum.MaxHealth + 0.5)
            table.insert(lines, "HP " .. hp .. "/" .. maxHp .. " | GOD x5")
        end
    else
        table.insert(lines, "HP — | GOD x5")
    end
    if godLastSpyRemote ~= "" then
        local short = godLastSpyRemote
        if #short > 42 then
            short = "…" .. string.sub(short, -40)
        end
        table.insert(lines, short)
    end
    godHpLabel.Text = table.concat(lines, "\n")
    godHpLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
end

function clearGodModeBindings()
    if godModeHumConn then godModeHumConn:Disconnect() godModeHumConn = nil end
    if godModeStateConn then godModeStateConn:Disconnect() godModeStateConn = nil end
    if godModeDiedConn then godModeDiedConn:Disconnect() godModeDiedConn = nil end
    if godModeDescendantConn then godModeDescendantConn:Disconnect() godModeDescendantConn = nil end
    if godModeCharRemovingConn then godModeCharRemovingConn:Disconnect() godModeCharRemovingConn = nil end
end

function unmuteStoredConnections(bucket)
    for _, conn in ipairs(bucket) do
        pcall(function()
            if conn and conn.Enable then
                conn:Enable()
            end
        end)
    end
    table.clear(bucket)
end

function muteRemoteListeners(remote)
    if typeof(getconnections) ~= "function" then return end
    if not remote or not (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then return end
    pcall(function()
        local signal = remote.OnClientEvent
        if not signal then return end
        for _, conn in ipairs(getconnections(signal)) do
            table.insert(godMutedRemoteConns, conn)
            conn:Disable()
        end
    end)
end

function muteAllDamageRemoteListeners()
    if typeof(getconnections) ~= "function" then return end
    for _, inst in ipairs(game:GetDescendants()) do
        if looksLikeDamageRemote(inst) then
            muteRemoteListeners(inst)
        end
    end
end

function muteHumanoidDiedListeners(hum)
    if typeof(getconnections) ~= "function" or not hum then return end
    pcall(function()
        for _, conn in ipairs(getconnections(hum.Died)) do
            table.insert(godMutedDiedConns, conn)
            conn:Disable()
        end
    end)
end

function applyGodModePlayerGuards()
    pcall(function()
        godSavedCharacterAutoLoads = Players.CharacterAutoLoads
        Players.CharacterAutoLoads = false
    end)
    if godModeCharRemovingConn then godModeCharRemovingConn:Disconnect() end
    godModeCharRemovingConn = LocalPlayer.CharacterRemoving:Connect(function()
        if not godMode then return end
        local hum = getHumanoid()
        if hum then
            recoverFromDeath(hum)
        end
    end)
    if godModeDescendantConn then godModeDescendantConn:Disconnect() end
    godModeDescendantConn = game.DescendantAdded:Connect(function(inst)
        if not godMode then return end
        if looksLikeDamageRemote(inst) then
            task.defer(function()
                if godMode and inst.Parent then
                    muteRemoteListeners(inst)
                end
            end)
        end
    end)
end

function clearGodModePlayerGuards()
    unmuteStoredConnections(godMutedRemoteConns)
    unmuteStoredConnections(godMutedDiedConns)
    pcall(function()
        if godSavedCharacterAutoLoads ~= nil then
            Players.CharacterAutoLoads = godSavedCharacterAutoLoads
            godSavedCharacterAutoLoads = nil
        end
    end)
    godLastSpyRemote = ""
end

function healGodHumanoid(hum)
    if not godMode or not hum or not hum.Parent then return end
    hum.BreakJointsOnDeath = false
    hum.RequiresNeck = false
    if hum.MaxHealth < math.huge / 2 then
        hum.MaxHealth = math.huge
    end
    if hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
end

function recoverFromDeath(hum)
    if not godMode or not hum or not hum.Parent then return end
    healGodHumanoid(hum)
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    if hum:GetState() == Enum.HumanoidStateType.Dead then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
end

function restoreGodModeHumanoid(hum)
    clearGodModeBindings()
    if hum and godModeSaved then
        hum.MaxHealth = godModeSaved.MaxHealth
        hum.Health = math.clamp(hum.Health, 0, hum.MaxHealth)
        if hum.Health <= 0 then
            hum.Health = hum.MaxHealth
        end
        hum.BreakJointsOnDeath = godModeSaved.BreakJointsOnDeath
        hum.RequiresNeck = godModeSaved.RequiresNeck
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, godModeSaved.DeadStateEnabled)
        end)
        godModeSaved = nil
    end
end

function installGodModeHooks()
    if godModeHooksInstalled then return end
    pcall(function()
        if typeof(hookmetamethod) ~= "function" then return end
        local function wrap(fn)
            if typeof(newcclosure) == "function" then
                return newcclosure(fn)
            end
            return fn
        end
        local oldNamecall = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            local method = getnamecallmethod()
            if godMode then
                if method == "TakeDamage" and isLocalHumanoid(self) then
                    return
                end
                if method == "BreakJoints" and isLocalCharacter(self) then
                    return
                end
                if method == "ChangeState" and isLocalHumanoid(self) then
                    local state = select(1, ...)
                    if state == Enum.HumanoidStateType.Dead then
                        return oldNamecall(self, Enum.HumanoidStateType.GettingUp)
                    end
                end
                if method == "Kick" and self == LocalPlayer then
                    return
                end
                if method == "LoadCharacter" and self == LocalPlayer then
                    return
                end
                if method == "Connect" then
                    local remote = getRemoteFromSignal(self)
                    if remote and looksLikeDamageRemote(remote) then
                        local cb = select(1, ...)
                        if typeof(cb) == "function" then
                            local blocked = wrap(function() end)
                            return oldNamecall(self, blocked, select(2, ...))
                        end
                    end
                end
                if self:IsA("RemoteEvent") or self:IsA("UnreliableRemoteEvent") or self:IsA("RemoteFunction") then
                    if method == "FireServer" or method == "InvokeServer" then
                        logGodRemote("OUT", self)
                        if looksLikeDamageRemote(self) then
                            return
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end))
        local oldNewIndex = hookmetamethod(game, "__newindex", wrap(function(self, key, value)
            if godMode and isLocalHumanoid(self) then
                if key == "Health" and typeof(value) == "number" and value < self.MaxHealth then
                    return oldNewIndex(self, key, self.MaxHealth)
                end
                if key == "MaxHealth" and typeof(value) == "number" and value < math.huge / 2 then
                    return oldNewIndex(self, key, math.huge)
                end
                if key == "BreakJointsOnDeath" and value == true then
                    return oldNewIndex(self, key, false)
                end
                if key == "RequiresNeck" and value == true then
                    return oldNewIndex(self, key, false)
                end
            end
            return oldNewIndex(self, key, value)
        end))
        godModeHooksInstalled = true
    end)
end

function hookHumanoidTakeDamage(hum)
    pcall(function()
        if typeof(hookfunction) ~= "function" or not hum then return end
        local oldTakeDamage = hum.TakeDamage
        if typeof(oldTakeDamage) ~= "function" then return end
        local function wrap(fn)
            if typeof(newcclosure) == "function" then
                return newcclosure(fn)
            end
            return fn
        end
        hookfunction(oldTakeDamage, wrap(function(self, amount, ...)
            if godMode and self.Parent == LocalPlayer.Character then
                return
            end
            return oldTakeDamage(self, amount, ...)
        end))
    end)
end

function attachGodModeHumanoid(hum)
    if not hum or not godMode then return end
    clearGodModeBindings()
    if not godModeSaved then
        godModeSaved = {
            MaxHealth = hum.MaxHealth,
            BreakJointsOnDeath = hum.BreakJointsOnDeath,
            RequiresNeck = hum.RequiresNeck,
            DeadStateEnabled = hum:GetStateEnabled(Enum.HumanoidStateType.Dead),
        }
    end
    installGodModeHooks()
    hookHumanoidTakeDamage(hum)
    muteAllDamageRemoteListeners()
    muteHumanoidDiedListeners(hum)
    applyGodModePlayerGuards()
    hum.BreakJointsOnDeath = false
    hum.RequiresNeck = false
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    hum.MaxHealth = math.huge
    hum.Health = hum.MaxHealth
    godModeHumConn = hum.HealthChanged:Connect(function()
        if godMode and hum.Parent and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
        updateGodHpLabel(hum)
    end)
    godModeStateConn = hum.StateChanged:Connect(function(_, newState)
        if godMode and newState == Enum.HumanoidStateType.Dead then
            recoverFromDeath(hum)
        end
    end)
    godModeDiedConn = hum.Died:Connect(function()
        if godMode then
            recoverFromDeath(hum)
        end
    end)
    updateGodHpLabel(hum)
end

function applyGodModeHumanoid(hum)
    if not hum or not godMode then return end
    attachGodModeHumanoid(hum)
end

function setGodMode(enabled)
    if enabled == godMode then return end
    godMode = enabled

    if godModeConn then
        godModeConn:Disconnect()
        godModeConn = nil
    end

    godHpLabel.Visible = enabled
    syncGodModeHealthGui()

    local hum = getHumanoid()
    if enabled then
        applyGodModeHumanoid(hum)
        godModeConn = RunService.Heartbeat:Connect(function()
            local h = getHumanoid()
            if h then
                healGodHumanoid(h)
                if h:GetState() == Enum.HumanoidStateType.Dead then
                    recoverFromDeath(h)
                end
                updateGodHpLabel(h)
            end
        end)
    else
        restoreGodModeHumanoid(hum)
        clearGodModePlayerGuards()
        godHpLabel.Text = ""
    end
end

function toggleGodMode()
    local prevTitle = title.Text
    setGodMode(not godMode)
    title.Text = godMode and "🛡 GOD ON — <" or "🛡 GOD OFF — <"
    task.delay(1.5, function()
        if title.Text == "🛡 GOD ON — <" or title.Text == "🛡 GOD OFF — <" then
            title.Text = prevTitle
        end
    end)
end

local antiAfkEnabled = true
local ANTI_AFK_INTERVAL = 60 * 8

function antiAfkPulse()
    if not antiAfkEnabled or not modOn then return end
    pcall(function()
        local vu = game:GetService("VirtualUser")
        local cam = Workspace.CurrentCamera
        vu:CaptureController()
        vu:ClickButton2(Vector2.new(), cam and cam.CFrame or CFrame.new())
    end)
end

task.defer(function()
    pcall(function()
        LocalPlayer.Idled:Connect(antiAfkPulse)
    end)
    task.spawn(function()
        while true do
            task.wait(ANTI_AFK_INTERVAL)
            antiAfkPulse()
        end
    end)
end)

function isCtrlHeld()
    return UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
end

function isAltHeld()
    return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt)
        or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
end

function getDeleteRaycastFilter()
    local filter = {}
    if LocalPlayer.Character then
        table.insert(filter, LocalPlayer.Character)
    end
    if morphOverlay and morphOverlay.Parent then
        table.insert(filter, morphOverlay)
    end
    return filter
end

function isProtectedFromDelete(inst)
    if not inst then return true end
    if inst:IsA("Terrain") then return true end
    if inst:IsA("Camera") then return true end
    if inst:IsDescendantOf(gui) then return true end

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and inst:IsDescendantOf(character) then
            return true
        end
    end

    return false
end

function resolveDeleteTarget(inst)
    if isProtectedFromDelete(inst) then return nil end

    if inst:IsA("Accessory") then
        return inst
    end

    if inst:IsA("BasePart") then
        local accessory = inst:FindFirstAncestorOfClass("Accessory")
        if accessory then return accessory end

        local model = inst:FindFirstAncestorOfClass("Model")
        if model and not Players:GetPlayerFromCharacter(model) then
            local partCount = 0
            for _, d in ipairs(model:GetDescendants()) do
                if d:IsA("BasePart") then
                    partCount += 1
                end
            end
            if partCount <= 2 then
                return model
            end
        end
        return inst
    end

    if inst:IsA("Model") and not Players:GetPlayerFromCharacter(inst) then
        return inst
    end

    return nil
end

function isClickOnModGui()
    local pos = UserInputService:GetMouseLocation()
    for _, obj in ipairs(PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)) do
        if obj.Visible and obj:IsDescendantOf(gui) then
            return true
        end
    end
    return false
end

function destroyAtCursor()
    if isClickOnModGui() then return end

    local mouse = LocalPlayer:GetMouse()
    local hitInst = mouse.Target

    if not hitInst then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = getDeleteRaycastFilter()
        local result = Workspace:Raycast(
            mouse.UnitRay.Origin,
            mouse.UnitRay.Direction * 2000,
            params
        )
        hitInst = result and result.Instance
    end

    local target = resolveDeleteTarget(hitInst)
    if not target then
        title.Text = "⚠ Nothing to delete"
        task.delay(1, function()
            if title.Text == "⚠ Nothing to delete" then
                title.Text = "🥙 NPC CAMERA"
            end
        end)
        return
    end

    local targetName = target.Name
    local ok = pcall(function()
        target:Destroy()
    end)

    if ok then
        title.Text = "🗑️ Deleted: " .. targetName
        task.delay(1.5, function()
            if title.Text == "🗑️ Deleted: " .. targetName then
                title.Text = "🥙 NPC CAMERA"
            end
        end)
    else
        title.Text = "⚠ Delete failed"
        task.delay(1.5, function()
            if title.Text == "⚠ Delete failed" then
                title.Text = "🥙 NPC CAMERA"
            end
        end)
    end
end

function paintAtCursor()
    if not paintMode then return end
    if isClickOnModGui() then return end

    local mouse = LocalPlayer:GetMouse()
    local hitInst = mouse.Target

    if not hitInst then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = getDeleteRaycastFilter()
        local result = Workspace:Raycast(
            mouse.UnitRay.Origin,
            mouse.UnitRay.Direction * 2000,
            params
        )
        hitInst = result and result.Instance
    end

    local target = resolveDeleteTarget(hitInst)
    local statusTitle = getPaintStatusTitle()
    if not target then
        title.Text = "⚠ Nothing to paint"
        task.delay(1, function()
            if title.Text == "⚠ Nothing to paint" then
                title.Text = statusTitle
            end
        end)
        return
    end

    local paintColor = getSelectedPaintColor()
    local ok = pcall(function()
        if target:IsA("BasePart") then
            target.Color = paintColor
        elseif target:IsA("Model") then
            for _, inst in ipairs(target:GetDescendants()) do
                if inst:IsA("BasePart") then
                    inst.Color = paintColor
                end
            end
        end
    end)

    if ok then
        title.Text = "🎨 Painted: " .. target.Name
        task.delay(1, function()
            if title.Text == "🎨 Painted: " .. target.Name then
                title.Text = statusTitle
            end
        end)
    else
        title.Text = "⚠ Paint failed"
        task.delay(1, function()
            if title.Text == "⚠ Paint failed" then
                title.Text = statusTitle
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end
    demorphCharacter()
    if isSpectating or isFreeCam then
        freezeCFrame = nil
        savedHumanoidState = nil
        didAnchorFreeze = false
        if isFreeCam or spectatePlayerFrozen then
            lockPlayerControl()
        else
            applyWalkSpeed()
        end
    else
        applyWalkSpeed()
        playZoom = ZOOM_MIN
        applyPlayZoomUnlock()
        if isNoclip then
            table.clear(noclipSavedCollide)
            task.defer(function()
                if isNoclip and LocalPlayer.Character then
                    applyNoclipToCharacter(LocalPlayer.Character, true)
                end
            end)
        end
    end
    if godMode then
        godModeSaved = nil
        task.defer(function()
            applyGodModeHumanoid(getHumanoid())
        end)
    end
end)

pcall(applyPlayZoomUnlock)

function teleportToFreeCamPosition()
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local target = CFrame.new(smoothFreeCamPos) * CFrame.Angles(0, smoothFreeCamYaw, 0)
    if character.PrimaryPart then
        character:PivotTo(target)
    else
        root.CFrame = target
    end
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

stopFreeCam = function(doTeleport)
    if not isFreeCam and not freeCamConn then return end
    isFreeCam = false
    keysDown.W = false
    keysDown.A = false
    keysDown.S = false
    keysDown.D = false
    keysDown.E = false
    keysDown.C = false
    keysDown.Shift = false
    if freeCamConn then
        freeCamConn:Disconnect()
        freeCamConn = nil
    end
    if doTeleport then
        teleportToFreeCamPosition()
    end
    if savedGuiEnabled ~= nil then
        gui.Enabled = savedGuiEnabled
        savedGuiEnabled = nil
    end
    releaseCameraMouseLock()
    Camera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
    unlockPlayerControl()
end

startFreeCam = function()
    if isFreeCam then return end
    if isSpectating then resetCamera() end
    isFreeCam = true
    lockPlayerControl()
    savedGuiEnabled = gui.Enabled
    gui.Enabled = false
    applyCameraMouseLock()
    Camera.CameraType = Enum.CameraType.Scriptable
    freeCamPos = Camera.CFrame.Position
    smoothFreeCamPos = freeCamPos
    local rx, ry = Camera.CFrame:ToEulerAnglesYXZ()
    freeCamPitch = rx
    freeCamYaw = ry
    smoothFreeCamPitch = freeCamPitch
    smoothFreeCamYaw = freeCamYaw
    if freeCamConn then freeCamConn:Disconnect() end
    freeCamConn = RunService.RenderStepped:Connect(function(dt)
        if not isFreeCam then return end
        if not mouseVisible then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            UserInputService.MouseIconEnabled = false
            local delta = UserInputService:GetMouseDelta()
            freeCamYaw -= delta.X * sensitivity
            freeCamPitch -= delta.Y * sensitivity
            freeCamPitch = math.clamp(freeCamPitch, -1.55, 1.55)
        end
        local rotation = CFrame.Angles(0, freeCamYaw, 0) * CFrame.Angles(freeCamPitch, 0, 0)
        local moveVector = Vector3.new()
        if keysDown.W then moveVector += Vector3.new(0, 0, -1) end
        if keysDown.S then moveVector += Vector3.new(0, 0, 1) end
        if keysDown.A then moveVector += Vector3.new(-1, 0, 0) end
        if keysDown.D then moveVector += Vector3.new(1, 0, 0) end
        if keysDown.E then moveVector += Vector3.new(0, 1, 0) end
        if keysDown.C then moveVector += Vector3.new(0, -1, 0) end
        local speedScale = walkSpeed / 16
        local currentSpeed = baseFreeCamSpeed * speedScale * (keysDown.Shift and 3 or 1)
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * currentSpeed
        end
        freeCamPos = freeCamPos + rotation:VectorToWorldSpace(moveVector)
        local t = math.min(freeCamLerpSpeed * dt * 60, 1)
        smoothFreeCamPos = smoothFreeCamPos + (freeCamPos - smoothFreeCamPos) * t
        smoothFreeCamYaw = smoothFreeCamYaw + (freeCamYaw - smoothFreeCamYaw) * t
        smoothFreeCamPitch = smoothFreeCamPitch + (freeCamPitch - smoothFreeCamPitch) * t
        local smoothRotation = CFrame.Angles(0, smoothFreeCamYaw, 0) * CFrame.Angles(smoothFreeCamPitch, 0, 0)
        Camera.CFrame = CFrame.new(smoothFreeCamPos) * smoothRotation
    end)
    title.Text = "🎥 FREE CAMERA"
end

function applyModToggle()
    if modOn then
        modOn = false
        resetCamera()
        restoreLighting()
        setNoclip(false)
        setGodMode(false)
        paintMode = false
        includeInanimate = false
        keysDown.W = false
        keysDown.A = false
        keysDown.S = false
        keysDown.D = false
        keysDown.E = false
        keysDown.C = false
        keysDown.Shift = false
        mouseVisible = true
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        setModPanelInput(true)
        gui.Enabled = false
    else
        modOn = true
        gui.Enabled = true
        setModPanelInput(true)
        mouseVisible = true
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        applyPlayZoomUnlock()
        refreshList()
    end
end

function setMovementKey(keyCode, down)
    if keyCode == Enum.KeyCode.W then keysDown.W = down
    elseif keyCode == Enum.KeyCode.A then keysDown.A = down
    elseif keyCode == Enum.KeyCode.S then keysDown.S = down
    elseif keyCode == Enum.KeyCode.D then keysDown.D = down
    elseif keyCode == Enum.KeyCode.E then keysDown.E = down
    elseif keyCode == Enum.KeyCode.C then keysDown.C = down
    elseif keyCode == Enum.KeyCode.LeftShift then keysDown.Shift = down
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.KeypadZero then
        applyModToggle()
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 and modOn and isCtrlHeld() then
        destroyAtCursor()
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 and modOn and paintMode and isAltHeld() then
        paintAtCursor()
        return
    end

    if isFreeCam and modOn then
        setMovementKey(input.KeyCode, true)
        if input.KeyCode == Enum.KeyCode.LeftBracket then
            changeWalkSpeed(-walkSpeedStep)
            return
        end
        if input.KeyCode == Enum.KeyCode.RightBracket then
            changeWalkSpeed(walkSpeedStep)
            return
        end
        if input.KeyCode == Enum.KeyCode.KeypadEight then
            stopFreeCam(true)
            title.Text = "🎮 YOU'RE PLAYING"
            return
        end
    end

    if gp then return end
    if not modOn then return end

    if input.KeyCode == Enum.KeyCode.KeypadSix then
        setMouseVisible(not mouseVisible)
        local prevTitle = title.Text
        title.Text = mouseVisible and "🖱 Cursor ON — Num6" or "🖱 Cursor LOCKED — Num6"
        task.delay(1.2, function()
            if title.Text == "🖱 Cursor ON — Num6" or title.Text == "🖱 Cursor LOCKED — Num6" then
                title.Text = prevTitle
            end
        end)
        return
    end

    if input.KeyCode == Enum.KeyCode.KeypadSeven then
        applyGameUIHidden(not gameUIHidden)
        return
    end

    if input.KeyCode == Enum.KeyCode.KeypadOne then
        toggleNum1Mode()
        return
    end

    if input.KeyCode == Enum.KeyCode.KeypadTwo then
        toggleSpectatePlayerFreeze()
        return
    end

    if input.KeyCode == Enum.KeyCode.KeypadThree then
        toggleDayNight()
        return
    end

    if input.KeyCode == Enum.KeyCode.KeypadFour then
        toggleNoclip()
        return
    end

    if input.KeyCode == Enum.KeyCode.Comma then
        toggleGodMode()
        return
    end

    if input.KeyCode == Enum.KeyCode.KeypadNine then
        toggleMorph()
        return
    end

    if input.KeyCode == Enum.KeyCode.Q then
        gui.Enabled = not gui.Enabled
    end

    if input.KeyCode == Enum.KeyCode.R then
        if paintMode then
            refreshPaintList()
        else
            refreshList()
        end
    end

    if input.KeyCode == Enum.KeyCode.LeftBracket then
        changeWalkSpeed(-walkSpeedStep)
        return
    end

    if input.KeyCode == Enum.KeyCode.RightBracket then
      changeWalkSpeed(walkSpeedStep)
        return
    end

    if input.KeyCode == Enum.KeyCode.KeypadFive then
        if isFreeCam then
            stopFreeCam(false)
        end
        if isSpectating then
            resetCamera()
        else
            if lastNPC and lastNPC.Parent then
                startCamera(lastNPC, getModelFromRoot(lastNPC))
                title.Text = "👁 LAST TARGET"
            end
        end
    end

    if input.KeyCode == Enum.KeyCode.W then setMovementKey(input.KeyCode, true) end
    if input.KeyCode == Enum.KeyCode.A then setMovementKey(input.KeyCode, true) end
    if input.KeyCode == Enum.KeyCode.S then setMovementKey(input.KeyCode, true) end
    if input.KeyCode == Enum.KeyCode.D then setMovementKey(input.KeyCode, true) end
    if not isMorphed and input.KeyCode == Enum.KeyCode.E then setMovementKey(input.KeyCode, true) end
    if not isMorphed and input.KeyCode == Enum.KeyCode.C then setMovementKey(input.KeyCode, true) end
    if input.KeyCode == Enum.KeyCode.LeftShift then setMovementKey(input.KeyCode, true) end

    if input.KeyCode == Enum.KeyCode.KeypadEight then
        if isFreeCam then
            stopFreeCam(true)
            title.Text = "🎮 YOU'RE PLAYING"
        else
            startFreeCam()
        end
        return
    end

    local idx = getNumKeyIndex(input)
    if idx then
        if paintMode then
            selectPaintColor(idx)
        else
            selectTarget(idx)
        end
        return
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if isFreeCam then
        setMovementKey(input.KeyCode, false)
    end
    if input.KeyCode == Enum.KeyCode.E
        or input.KeyCode == Enum.KeyCode.C
        or input.KeyCode == Enum.KeyCode.Z
        or input.KeyCode == Enum.KeyCode.X
        or input.KeyCode == Enum.KeyCode.V
        or input.KeyCode == Enum.KeyCode.B
        or input.KeyCode == Enum.KeyCode.N
        or input.KeyCode == Enum.KeyCode.M then
        -- morph adjust handled via IsKeyDown in overlay loop
    end
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then setMovementKey(input.KeyCode, false) end
    if input.KeyCode == Enum.KeyCode.A then setMovementKey(input.KeyCode, false) end
    if input.KeyCode == Enum.KeyCode.S then setMovementKey(input.KeyCode, false) end
    if input.KeyCode == Enum.KeyCode.D then setMovementKey(input.KeyCode, false) end
    if not isMorphed and input.KeyCode == Enum.KeyCode.E then setMovementKey(input.KeyCode, false) end
    if not isMorphed and input.KeyCode == Enum.KeyCode.C then setMovementKey(input.KeyCode, false) end
    if input.KeyCode == Enum.KeyCode.LeftShift then setMovementKey(input.KeyCode, false) end
end)

print("[ShawarmaSpectator] ready")
