-- Street Life Remastered - Pro Edition V3.1 (Fixed & Safe)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local GUI_Parent = gethui and gethui() or CoreGui
if GUI_Parent:FindFirstChild("StreetLifeProV3") then GUI_Parent.StreetLifeProV3:Destroy() end

-- ==========================================
-- 1. دوائر الـ FOV (الرسم بشكل آمن)
-- ==========================================
local SilentFOV_Radius = 120
local AimbotFOV_Radius = 150

local silentFovCircle, aimbotFovCircle
pcall(function()
    silentFovCircle = Drawing.new("Circle")
    silentFovCircle.Visible = false
    silentFovCircle.Radius = SilentFOV_Radius
    silentFovCircle.Filled = false
    silentFovCircle.Color = Color3.fromRGB(0, 255, 100)
    silentFovCircle.Thickness = 2
    silentFovCircle.Transparency = 0.8

    aimbotFovCircle = Drawing.new("Circle")
    aimbotFovCircle.Visible = false
    aimbotFovCircle.Radius = AimbotFOV_Radius
    aimbotFovCircle.Filled = false
    aimbotFovCircle.Color = Color3.fromRGB(255, 50, 50)
    aimbotFovCircle.Thickness = 2
    aimbotFovCircle.Transparency = 0.8
end)

-- ==========================================
-- 2. بناء الواجهة (UI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "StreetLifeProV3"; ScreenGui.Parent = GUI_Parent; ScreenGui.ResetOnSpawn = false
local FloatingIcon = Instance.new("TextButton"); FloatingIcon.Parent = ScreenGui; FloatingIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25); FloatingIcon.Position = UDim2.new(0, 35, 0, 150); FloatingIcon.Size = UDim2.new(0, 55, 0, 55); FloatingIcon.Font = Enum.Font.SourceSansBold; FloatingIcon.Text = "🔥"; FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 100); FloatingIcon.TextSize = 28
local IconCorner = Instance.new("UICorner"); IconCorner.CornerRadius = UDim.new(1, 0); IconCorner.Parent = FloatingIcon
local IconStroke = Instance.new("UIStroke"); IconStroke.Color = Color3.fromRGB(0, 255, 100); IconStroke.Thickness = 2.5; IconStroke.Parent = FloatingIcon

local MainFrame = Instance.new("Frame"); MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.Position = UDim2.new(0.5, -210, 0.5, -230); MainFrame.Size = UDim2.new(0, 420, 0, 460); MainFrame.Visible = false
local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 16); MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke"); MainStroke.Color = Color3.fromRGB(0, 255, 100); MainStroke.Thickness = 2; MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame"); TopBar.Parent = MainFrame; TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30); TopBar.Size = UDim2.new(1, 0, 0, 50)
local TopCorner = Instance.new("UICorner"); TopCorner.CornerRadius = UDim.new(0, 16); TopCorner.Parent = TopBar
local Title = Instance.new("TextLabel"); Title.Parent = TopBar; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 20, 0, 0); Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Font = Enum.Font.SourceSansBold; Title.Text = "STREET LIFE | Pro V3.1"; Title.TextColor3 = Color3.fromRGB(0, 255, 100); Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left
local CloseXBtn = Instance.new("TextButton"); CloseXBtn.Parent = TopBar; CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50); CloseXBtn.Position = UDim2.new(1, -40, 0.5, -14); CloseXBtn.Size = UDim2.new(0, 28, 0, 28); CloseXBtn.Font = Enum.Font.SourceSansBold; CloseXBtn.Text = "X"; CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseXBtn.TextSize = 14; CloseXBtn.AutoButtonColor = false
local XCorner = Instance.new("UICorner"); XCorner.CornerRadius = UDim.new(1, 0); XCorner.Parent = CloseXBtn

local TabsBar = Instance.new("Frame"); TabsBar.Parent = MainFrame; TabsBar.BackgroundTransparency = 1; TabsBar.Position = UDim2.new(0, 10, 0, 60); TabsBar.Size = UDim2.new(1, -20, 0, 35)
local TabsLayout = Instance.new("UIListLayout"); TabsLayout.Parent = TabsBar; TabsLayout.FillDirection = Enum.FillDirection.Horizontal; TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabsLayout.Padding = UDim.new(0, 8)
local ContentContainer = Instance.new("Frame"); ContentContainer.Parent = MainFrame; ContentContainer.BackgroundTransparency = 1; ContentContainer.Position = UDim2.new(0, 10, 0, 100); ContentContainer.Size = UDim2.new(1, -20, 1, -110)

local tabs = {}
local function createTabContent(name)
    local scrolling = Instance.new("ScrollingFrame"); scrolling.Name = name .. "Content"; scrolling.Parent = ContentContainer; scrolling.BackgroundTransparency = 1; scrolling.Size = UDim2.new(1, 0, 1, 0); scrolling.CanvasSize = UDim2.new(0, 0, 0, 0); scrolling.ScrollBarThickness = 4; scrolling.Visible = false
    local list = Instance.new("UIListLayout"); list.Parent = scrolling; list.HorizontalAlignment = Enum.HorizontalAlignment.Center; list.SortOrder = Enum.SortOrder.LayoutOrder; list.Padding = UDim.new(0, 10)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scrolling.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15) end)
    return scrolling
end

local function createTabButton(name, iconText)
    local btn = Instance.new("TextButton"); btn.Parent = TabsBar; btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); btn.Size = UDim2.new(0, 90, 1, 0); btn.Font = Enum.Font.SourceSansBold; btn.Text = iconText .. " " .. name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.TextSize = 13; btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1; stroke.Parent = btn
    local content = createTabContent(name)
    btn.Activated:Connect(function()
        for _, t in pairs(tabs) do t.content.Visible = false; t.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35); t.btn.TextColor3 = Color3.fromRGB(150, 150, 150); t.stroke.Color = Color3.fromRGB(45, 45, 60) end
        content.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); btn.TextColor3 = Color3.fromRGB(0, 255, 100); stroke.Color = Color3.fromRGB(0, 255, 100)
    end)
    tabs[name] = {btn = btn, content = content, stroke = stroke}
    return content
end

local combatTab = createTabButton("Combat", "🎯")
local visualsTab = createTabButton("Visuals", "👁️")
local utilityTab = createTabButton("Utility", "📦")
tabs["Combat"].content.Visible = true; tabs["Combat"].btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); tabs["Combat"].btn.TextColor3 = Color3.fromRGB(0, 255, 100); tabs["Combat"].stroke.Color = Color3.fromRGB(0, 255, 100)

local function createFeatureToggle(parentTab, name, desc, callback)
    local btn = Instance.new("TextButton"); btn.Parent = parentTab; btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30); btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = ""; btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 10); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1.2; stroke.Parent = btn
    local nameLabel = Instance.new("TextLabel"); nameLabel.Parent = btn; nameLabel.BackgroundTransparency = 1; nameLabel.Position = UDim2.new(0, 15, 0, 8); nameLabel.Size = UDim2.new(0.7, 0, 0, 16); nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.Text = name; nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240); nameLabel.TextSize = 14; nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    local descLabel = Instance.new("TextLabel"); descLabel.Parent = btn; descLabel.BackgroundTransparency = 1; descLabel.Position = UDim2.new(0, 15, 0, 26); descLabel.Size = UDim2.new(0.7, 0, 0, 16); descLabel.Font = Enum.Font.SourceSans; descLabel.Text = desc; descLabel.TextColor3 = Color3.fromRGB(120, 120, 120); descLabel.TextSize = 11; descLabel.TextXAlignment = Enum.TextXAlignment.Left
    local statusBox = Instance.new("Frame"); statusBox.Parent = btn; statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65); statusBox.Position = UDim2.new(1, -40, 0.5, -12); statusBox.Size = UDim2.new(0, 24, 0, 24)
    local boxCorner = Instance.new("UICorner"); boxCorner.CornerRadius = UDim.new(0, 6); boxCorner.Parent = statusBox
    local state = false
    btn.Activated:Connect(function()
        state = not state
        if state then statusBox.BackgroundColor3 = Color3.fromRGB(0, 255, 100); stroke.Color = Color3.fromRGB(0, 255, 100) else statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65); stroke.Color = Color3.fromRGB(45, 45, 60) end
        callback(state)
    end)
    return btn
end

local silentEnabled, aimbotEnabled, espEnabled, autoFarmEnabled = false, false, false, false

createFeatureToggle(combatTab, "Silent Aim", "تصويب صامت ذكي", function(enabled) silentEnabled = enabled; if silentFovCircle then silentFovCircle.Visible = enabled end end)
createFeatureToggle(combatTab, "Aimbot", "قفل الكاميرا نحو الهدف", function(enabled) aimbotEnabled = enabled; if aimbotFovCircle then aimbotFovCircle.Visible = enabled end end)
createFeatureToggle(visualsTab, "Pro ESP", "مربعات وأسماء اللاعبين", function(enabled) espEnabled = enabled end)
createFeatureToggle(utilityTab, "Auto Farm", "جمع الأغراض تلقائياً", function(enabled) autoFarmEnabled = enabled end)

-- تحديث الـ FOV والـ Render
RunService.RenderStepped:Connect(function()
    local camCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if silentFovCircle then silentFovCircle.Position = camCenter end
    if aimbotFovCircle then aimbotFovCircle.Position = camCenter end
end)

-- حركة الأيقونة
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = FloatingIcon.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
local function toggleMenu() MainFrame.Visible = not MainFrame.Visible end
FloatingIcon.Activated:Connect(toggleMenu)
CloseXBtn.Activated:Connect(toggleMenu)

print("Street Life Pro V3.1 - Loaded Successfully!")
