
-- Check if the GUI is already loaded to prevent multiple instances
if getgenv().ImJustJowHubLoaded then return end
getgenv().ImJustJowHubLoaded = true

-- Wait for the game to be fully loaded before creating the GUI
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Data for featured scripts, populated by the web app
local featuredScripts = {
    {
        name = [[GONER SCRIPT!]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpTbwgPlxYIyGZId_oAwPjNCDywv4Jh_dckljjZN_0eZXVBA2SY4Ie5hU&s=10]],
        script = [[require(4513235536).G("Carl_TheNPCOG")]]
    },
    {
        name = [[EYO-ZEN SCRIPT!]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJjJpZrIgB_0gCnWBE9r3XWkKZDpeFMsmCew&s]],
        script = [[loadstring(game:HttpGet("https://pastebin.com/raw/VmQXnzZs", true))()]]
    },
    {
        name = [[NEKO ARC]],
        thumbnail = [[https://i.ytimg.com/vi/oSBPFrNpei0/maxresdefault.jpg]],
        script = [[require(134825709410639).Burenyuu("UsernameHere")]]
    },
    {
        name = [[MINOS PRIME]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNkTV7bEMhvxlAfLk9FbCra-xLiROuvM6PdWPMVymOozOAc6xl6NJwNM8&s=10]],
        script = [[require(0x3603754d7)("YourNameHere", "minos2")]]
    },
    {
        name = [[GOJO TSB]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvfjUD4Vae5MBGGz0EkPcfi4zf-sbdItX20w&s]],
        script = [[require(14499140823)("YourNameHere", "sorcerer")]]
    },
    {
        name = [[GAROU TSB SCRIPT!]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQf1V5B-3IcbhdI2muSYVnd0R45xMqUKSxZos_ldK1ImV2oo_ToYoL-DcE6&s=10]],
        script = [[require(14499140823)("YourNameHere", "garou2")]]
    },
    {
        name = [[SUKUNA SCRIPT]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcH-SKId4LS1z6hzrVJIjk5mWomU7SCLl7__8h-Zb7E1cLm8LuWZUFONm1&s=10]],
        script = [[require(89529616632600)("YourNameHere", "Sukuna")]]
    },
    {
        name = [[SHRIKE SCRIPT]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMTrFt8n4slL5nvNHdJn-G2_9k1z0DN-gSMHIPeYpX3G9m_8QAwz0ChoeQ&s=10]],
        script = [[require(2101877169).shr("Username")]]
    },
    {
        name = [[EERIN SCRIPT]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhoUHb4Qug0FiTxS2pYFTTquhKOjuE62Vro_18PtsKcqzZG-ARJARmsRc&s=10]],
        script = [[require(4382452670).load("YourNameHere")]]
    },
    {
        name = [[LAST STAR: GALAXIA EDIT]],
        thumbnail = [[https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3joW2toW4CoTyIrBbIuhRCDsOCLNJRMI11l_9AoV7rXwZBv02UCgYVxQ&s=10]],
        script = [[require(7693373349).load("nam")]]
    }
}

-- Main GUI Setup
local HubGui = Instance.new("ScreenGui")
HubGui.Name = "ImJustJowHub"
HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
HubGui.ResetOnSpawn = false

-- The main draggable frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = HubGui
MainFrame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
MainFrame.BorderColor3 = Color3.fromRGB(56, 189, 248)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.ClipsDescendants = true
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header for title and dragging
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(31, 41, 55)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.fromScale(0.02, 0)
Title.Font = Enum.Font.Code
Title.Text = "ImJustJow's Featured Scripts"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -30, 0.5, 0)
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
local cbCorner = UICorner:Clone()
cbCorner.Parent = CloseButton

-- Scrolling frame for script list
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(56, 189, 248)
ScrollingFrame.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = ScrollingFrame
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)

-- Template for each script card
local ScriptCardTemplate = Instance.new("Frame")
ScriptCardTemplate.Name = "ScriptCard"
ScriptCardTemplate.BackgroundColor3 = Color3.fromRGB(31, 41, 55)
ScriptCardTemplate.BorderSizePixel = 1
ScriptCardTemplate.BorderColor3 = Color3.fromRGB(75, 85, 99)
ScriptCardTemplate.Size = UDim2.new(0.95, 0, 0, 80)
local cardCorner = UICorner:Clone()
cardCorner.Parent = ScriptCardTemplate

local Thumbnail = Instance.new("ImageLabel")
Thumbnail.Name = "Thumbnail"
Thumbnail.Parent = ScriptCardTemplate
Thumbnail.BackgroundColor3 = Color3.fromRGB(55, 65, 81)
Thumbnail.Size = UDim2.new(0, 60, 0, 60)
Thumbnail.Position = UDim2.new(0, 10, 0.5, 0)
Thumbnail.AnchorPoint = Vector2.new(0, 0.5)
local thumbCorner = UICorner:Clone()
thumbCorner.Parent = Thumbnail

local ScriptName = Instance.new("TextLabel")
ScriptName.Name = "ScriptName"
ScriptName.Parent = ScriptCardTemplate
ScriptName.BackgroundTransparency = 1
ScriptName.Size = UDim2.new(1, -170, 1, 0)
ScriptName.Position = UDim2.fromScale(0, 0)
ScriptName.Font = Enum.Font.SourceSansSemibold
ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptName.TextSize = 16
ScriptName.TextXAlignment = Enum.TextXAlignment.Left
ScriptName.TextWrapped = true
local namePadding = Instance.new("UIPadding")
namePadding.Parent = ScriptName
namePadding.PaddingLeft = UDim.new(0, 80)

local GetScriptButton = Instance.new("TextButton")
GetScriptButton.Name = "GetScriptButton"
GetScriptButton.Parent = ScriptCardTemplate
GetScriptButton.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
GetScriptButton.Size = UDim2.new(0, 80, 0, 30)
GetScriptButton.Position = UDim2.new(1, -10, 0.5, 0)
GetScriptButton.AnchorPoint = Vector2.new(1, 0.5)
GetScriptButton.Font = Enum.Font.SourceSansBold
GetScriptButton.Text = "Get Script"
GetScriptButton.TextColor3 = Color3.fromRGB(17, 24, 39)
GetScriptButton.TextSize = 14
local btnCorner = UICorner:Clone()
btnCorner.Parent = GetScriptButton

-- Modal for viewing and copying script content
local ModalBackdrop = Instance.new("Frame")
ModalBackdrop.Name = "ModalBackdrop"
ModalBackdrop.Parent = HubGui
ModalBackdrop.BackgroundColor3 = Color3.new(0, 0, 0)
ModalBackdrop.BackgroundTransparency = 0.5
ModalBackdrop.Size = UDim2.fromScale(1, 1)
ModalBackdrop.Visible = false
ModalBackdrop.ZIndex = 2

local ModalFrame = Instance.new("Frame")
ModalFrame.Name = "ModalFrame"
ModalFrame.Parent = ModalBackdrop
ModalFrame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
ModalFrame.BorderColor3 = Color3.fromRGB(250, 204, 21) -- yellow-400
ModalFrame.BorderSizePixel = 2
ModalFrame.Position = UDim2.fromScale(0.5, 0.5)
ModalFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ModalFrame.Size = UDim2.new(0, 500, 0, 300)
local modalCorner = UICorner:Clone()
modalCorner.Parent = ModalFrame

local ModalTitle = Instance.new("TextLabel")
ModalTitle.Parent = ModalFrame
ModalTitle.BackgroundTransparency = 1
ModalTitle.Size = UDim2.new(1, -50, 0, 30)
ModalTitle.Position = UDim2.fromScale(0.02, 0)
ModalTitle.Font = Enum.Font.Code
ModalTitle.TextColor3 = Color3.fromRGB(250, 204, 21)
ModalTitle.TextSize = 18
ModalTitle.TextXAlignment = Enum.TextXAlignment.Left

local ScriptContent = Instance.new("TextBox")
ScriptContent.Parent = ModalFrame
ScriptContent.MultiLine = true
ScriptContent.ReadOnly = true
ScriptContent.TextWrapped = true
ScriptContent.ClearTextOnFocus = false
ScriptContent.Font = Enum.Font.Code
ScriptContent.TextXAlignment = Enum.TextXAlignment.Left
ScriptContent.TextYAlignment = Enum.TextYAlignment.Top
ScriptContent.BackgroundColor3 = Color3.fromRGB(31, 41, 55)
ScriptContent.TextColor3 = Color3.fromRGB(229, 231, 235)
ScriptContent.Size = UDim2.new(1, -20, 1, -80)
ScriptContent.Position = UDim2.new(0.5, 0, 0, 35)
ScriptContent.AnchorPoint = Vector2.new(0.5, 0)
local scriptContentCorner = UICorner:Clone()
scriptContentCorner.Parent = ScriptContent

local CopyButton = Instance.new("TextButton")
CopyButton.Parent = ModalFrame
CopyButton.BackgroundColor3 = Color3.fromRGB(250, 204, 21)
CopyButton.Size = UDim2.new(0.4, 0, 0, 35)
CopyButton.Position = UDim2.new(0.25, 0, 1, -10)
CopyButton.AnchorPoint = Vector2.new(0.5, 1)
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.Text = "Copy Script"
CopyButton.TextColor3 = Color3.fromRGB(17, 24, 39)
CopyButton.TextSize = 14
local copyBtnCorner = UICorner:Clone()
copyBtnCorner.Parent = CopyButton

local ModalCloseButton = Instance.new("TextButton")
ModalCloseButton.Parent = ModalFrame
ModalCloseButton.BackgroundColor3 = Color3.fromRGB(75, 85, 99)
ModalCloseButton.Size = UDim2.new(0.4, 0, 0, 35)
ModalCloseButton.Position = UDim2.new(0.75, 0, 1, -10)
ModalCloseButton.AnchorPoint = Vector2.new(0.5, 1)
ModalCloseButton.Font = Enum.Font.SourceSansBold
ModalCloseButton.Text = "Close"
ModalCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ModalCloseButton.TextSize = 14
local modalCloseBtnCorner = UICorner:Clone()
modalCloseBtnCorner.Parent = ModalCloseButton


-- Function to populate the scrolling list with script cards
local function populateScripts()
    local canvasY = #featuredScripts * (ScriptCardTemplate.Size.Y.Offset + UIListLayout.Padding.Offset)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, canvasY)
    for i, scriptData in ipairs(featuredScripts) do
        local card = ScriptCardTemplate:Clone()
        card.Parent = ScrollingFrame
        card.LayoutOrder = i
        card.Name = scriptData.name
        card.ScriptName.Text = scriptData.name
        card.Thumbnail.Image = scriptData.thumbnail
        card.GetScriptButton.MouseButton1Click:Connect(function()
            ModalTitle.Text = scriptData.name
            ScriptContent.Text = scriptData.script
            ModalBackdrop.Visible = true
        end)
    end
    ScriptCardTemplate:Destroy() -- Clean up the template
end

-- Function to make the main frame draggable
local function makeDraggable(guiObject)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
        end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Connect button events
CloseButton.MouseButton1Click:Connect(function()
    HubGui:Destroy()
    getgenv().ImJustJowHubLoaded = nil -- Allow re-execution after closing
end)

ModalCloseButton.MouseButton1Click:Connect(function()
    ModalBackdrop.Visible = false
end)

CopyButton.MouseButton1Click:Connect(function()
    -- Check for executor-specific clipboard function
    if setclipboard then
        setclipboard(ScriptContent.Text)
        CopyButton.Text = "Copied!"
        task.wait(2)
        CopyButton.Text = "Copy Script"
    else
        CopyButton.Text = "Error!"
        task.wait(2)
        CopyButton.Text = "Copy Script"
    end
end)

-- Initialize the GUI
makeDraggable(Header)
populateScripts()

-- Parent the GUI to CoreGui if available, otherwise PlayerGui
HubGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
