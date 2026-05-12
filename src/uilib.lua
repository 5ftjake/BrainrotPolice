-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local HiddenUI = gethui or get_hidden_gui or nil
local Plr = Players.LocalPlayer

-- Gui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
ScreenGui.DisplayOrder = 9999

if HiddenUI then
    ScreenGui.Parent = HiddenUI()
else
    ScreenGui.Parent = CoreGui
end

-- Loading UI
local LoaderLabel = Instance.new("TextLabel")
LoaderLabel.TextWrapped = true
LoaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LoaderLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
LoaderLabel.Text = "Brainrot Police"
LoaderLabel.Name = "LoaderLabel"
LoaderLabel.Size = UDim2.new(0.43699565529823303, 0, 0.10736579447984695, 0)
LoaderLabel.AnchorPoint = Vector2.new(0.5, 0.5)
LoaderLabel.BorderSizePixel = 0
LoaderLabel.BackgroundTransparency = 1
LoaderLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
LoaderLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
LoaderLabel.TextSize = 14
LoaderLabel.TextScaled = true
LoaderLabel.BackgroundColor3 = Color3.fromRGB(84, 224, 255)
LoaderLabel.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(38, 114, 255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(251, 1, 3)),
    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(251, 1, 3)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(251, 1, 3)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(38, 114, 255)),
}
UIGradient.Parent = LoaderLabel

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 0.05000000074505806
UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
UIStroke.Parent = LoaderLabel

local loaderLoop = RunService.Heartbeat:Connect(function()
    local t = tick()
    LoaderLabel.Position = UDim2.new(0.5, 0, 0.5 + math.sin(t * 0.25 * math.pi * 2) * 0.05, 0)
    UIGradient.Offset = Vector2.new((t * 0.5) % 2 - 1, 0)
end)

-- Executor Check
local isSkidded = false

if type(getfenv().identifyexecutor) == "function" then
    if identifyexecutor():lower() == "xeno" then
        isSkidded = true
    end
end

-- Folder
local FONT_FOLDER = "BrainrotPolice"

if not isfolder(FONT_FOLDER) then
    makefolder(FONT_FOLDER)
end

-- Font System
local Fonts = {}

local function registerFont(fontName, data)
    if type(getfenv().getcustomasset) ~= "function" or isSkidded then
        return nil
    end

    local jsonPath = FONT_FOLDER .. "/" .. fontName .. ".json"

    local faces = {}

    for _, faceData in ipairs(data.faces) do
        local localPath = FONT_FOLDER .. "/" .. faceData.file

        if not isfile(localPath) then
            writefile(localPath, game:HttpGet(faceData.url))
        end

        table.insert(faces, {
            name = faceData.name,
            weight = faceData.weight,
            style = faceData.style,
            assetId = getcustomasset(localPath)
        })
    end

    if not isfile(jsonPath) then
        writefile(jsonPath, HttpService:JSONEncode({
            name = fontName,
            faces = faces
        }))
    end

    Fonts[fontName] = getcustomasset(jsonPath)

    return Fonts[fontName]
end

-- Register Fonts
registerFont("georgia", {
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            file = "georgia.ttf",
            url = "https://github.com/IcantAffordSynapse/BrainrotPolice/raw/refs/heads/main/assets/georgia.ttf"
        },

        {
            name = "Bold",
            weight = 700,
            style = "normal",
            file = "georgiab.ttf",
            url = "https://github.com/IcantAffordSynapse/BrainrotPolice/raw/refs/heads/main/assets/georgiab.ttf"
        },

        {
            name = "Italic",
            weight = 400,
            style = "normal",
            file = "georgiai.ttf",
            url = "https://github.com/IcantAffordSynapse/BrainrotPolice/raw/refs/heads/main/assets/georgiai.ttf"
        }
    }
})

registerFont("bubblegum", {
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            file = "bubblegum.ttf",
            url = "https://github.com/IcantAffordSynapse/BrainrotPolice/raw/refs/heads/main/assets/Bubblegum.ttf"
        }
    }
})

-- Font Helper
local function applyFont(object, fontName, weight, style)
    if not Fonts[fontName] then
        return
    end

    object.FontFace = Font.new(
        Fonts[fontName],
        weight or Enum.FontWeight.Regular,
        style or Enum.FontStyle.Normal
    )
end

applyFont(LoaderLabel, "bubblegum", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

-- Main Frame
local Frame = Instance.new("CanvasGroup")
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Name = "Frame"
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0.36250776052474976, 0, 0.47191011905670166, 0)
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(17, 18, 24)
Frame.Parent = ScreenGui
Frame.Visible = false

local AspectRatio = Instance.new("UIAspectRatioConstraint")
AspectRatio.AspectRatio = 1.5449734926223755
AspectRatio.Name = "AspectRatio"
AspectRatio.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame

local TopBar = Instance.new("Frame")
TopBar.AnchorPoint = Vector2.new(0.5, 0)
TopBar.Name = "TopBar"
TopBar.Position = UDim2.new(0.5, 0, 0, 0)
TopBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
TopBar.Size = UDim2.new(1, 0, 0.10052909702062607, 0)
TopBar.BorderSizePixel = 0
TopBar.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
TopBar.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(130, 139, 185)
UIStroke.Parent = TopBar

local Header = Instance.new("TextLabel")
Header.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Header.AnchorPoint = Vector2.new(0.5, 0.5)
Header.TextSize = 14
Header.Size = UDim2.new(0.4897260367870331, 0, 0.6842105388641357, 0)
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header.Text = "Brainrot Police"
Header.Name = "Header"
Header.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Header.TextWrapped = true
Header.BackgroundTransparency = 1
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Position = UDim2.new(0.2688356041908264, 0, 0.5, 0)
Header.BorderSizePixel = 0
Header.TextScaled = true
Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Header.Parent = TopBar

applyFont(
    Header,
    "georgia",
    Enum.FontWeight.Regular,
    Enum.FontStyle.Normal
)

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = Color3.fromRGB(130, 139, 185)
UIStroke2.Parent = Frame

-- Intro Frame
local IntroFrame = Instance.new("CanvasGroup")
IntroFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
IntroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
IntroFrame.BackgroundTransparency = 1
IntroFrame.Position = UDim2.new(0.5, 0, 0.5529100298881531, 0)
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(0.9537671208381653, 0, 0.817460298538208, 0)
IntroFrame.BorderSizePixel = 0
IntroFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IntroFrame.Parent = Frame

local TopQuote = Instance.new("TextLabel")
TopQuote.TextWrapped = true
TopQuote.Name = "TopQuote"
TopQuote.TextColor3 = Color3.fromRGB(255, 255, 255)
TopQuote.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
TopQuote.Text = '"Fuck Brainrot" - esore'
TopQuote.Size = UDim2.new(0.5960502624511719, 0, 0.08414239436388016, 0)
TopQuote.BorderColor3 = Color3.fromRGB(0, 0, 0)
TopQuote.AnchorPoint = Vector2.new(0.5, 0.5)
TopQuote.BorderSizePixel = 0
TopQuote.BackgroundTransparency = 1
TopQuote.Position = UDim2.new(0.5, 0, 0.1080000028014183, 0)
TopQuote.TextScaled = true
TopQuote.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TopQuote.TextSize = 14
TopQuote.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopQuote.Parent = IntroFrame
applyFont(
    TopQuote,
    "georgia",
    Enum.FontWeight.Regular,
    Enum.FontStyle.Italic
)

local SupportLabel = Instance.new("TextLabel")
SupportLabel.TextWrapped = true
SupportLabel.Name = "SupportLabel"
SupportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SupportLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
SupportLabel.Text = [[If you'd like to support my work,
Check out Vaehz on YouTube
Join the Discord - discord.gg/vaehz]]
SupportLabel.Size = UDim2.new(0.6983842253684998, 0, 0.269, 0)
SupportLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
SupportLabel.AnchorPoint = Vector2.new(0.5, 0.5)
SupportLabel.BorderSizePixel = 0
SupportLabel.BackgroundTransparency = 1
SupportLabel.Position = UDim2.new(0.5, 0, 0.382, 0)
SupportLabel.TextScaled = true
SupportLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SupportLabel.TextSize = 14
SupportLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SupportLabel.Parent = IntroFrame
applyFont(
    SupportLabel,
    "georgia",
    Enum.FontWeight.Regular,
    Enum.FontStyle.Normal
)

local DismissBtn = Instance.new("ImageButton")
DismissBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
DismissBtn.AnchorPoint = Vector2.new(0.5, 0)
DismissBtn.Name = "DismissBtn"
DismissBtn.Position = UDim2.new(0.5, 0, 0.7149999737739563, 0)
DismissBtn.Size = UDim2.new(0.30161580443382263, 0, 0.15210355818271637, 0)
DismissBtn.Selectable = false
DismissBtn.BorderSizePixel = 0
DismissBtn.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
DismissBtn.Parent = IntroFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(130, 139, 185)
UIStroke.Parent = DismissBtn

local btnlbl = Instance.new("TextLabel")
btnlbl.TextWrapped = true
btnlbl.Name = "btnlbl"
btnlbl.TextColor3 = Color3.fromRGB(255, 255, 255)
btnlbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
btnlbl.Text = "Lets go"
btnlbl.Size = UDim2.new(0.7678571343421936, 0, 0.5531914830207825, 0)
btnlbl.BorderColor3 = Color3.fromRGB(0, 0, 0)
btnlbl.AnchorPoint = Vector2.new(0.5, 0.5)
btnlbl.BorderSizePixel = 0
btnlbl.BackgroundTransparency = 1
btnlbl.Position = UDim2.new(0.5, 0, 0.5, 0)
btnlbl.TextScaled = true
btnlbl.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
btnlbl.TextSize = 14
btnlbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btnlbl.Parent = DismissBtn
applyFont(
    btnlbl,
    "georgia",
    Enum.FontWeight.Regular,
    Enum.FontStyle.Normal
)

local UICorner = Instance.new("UICorner")
UICorner.Parent = DismissBtn

-- Main Sect
local MainContent = Instance.new("CanvasGroup")
MainContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainContent.AnchorPoint = Vector2.new(0.5, 0.5)
MainContent.BackgroundTransparency = 1
MainContent.Position = UDim2.new(0.5, 0, 0.5529100298881531, 0)
MainContent.Name = "MainContent"
MainContent.Size = UDim2.new(0.9537671208381653, 0, 0.817460298538208, 0)
MainContent.BorderSizePixel = 0
MainContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainContent.Parent = Frame
MainContent.Interactable = false
MainContent.GroupTransparency = 1

local TabsContainer = Instance.new("Frame")
TabsContainer.BackgroundTransparency = 1
TabsContainer.Name = "TabsContainer"
TabsContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabsContainer.Size = UDim2.new(0.2590000033378601, 0, 1, 0)
TabsContainer.BorderSizePixel = 0
TabsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabsContainer.Parent = MainContent

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0.019999999552965164, 0)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = TabsContainer

local SectionDock = Instance.new("Frame")
SectionDock.Name = "SectionDock"
SectionDock.BackgroundTransparency = 1
SectionDock.Position = UDim2.new(0.28007158637046814, 0, 0, 0)
SectionDock.BorderColor3 = Color3.fromRGB(0, 0, 0)
SectionDock.Size = UDim2.new(0.7239908576011658, 0, 1, 0)
SectionDock.BorderSizePixel = 0
SectionDock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SectionDock.Parent = MainContent

DismissBtn.MouseButton1Click:Connect(function()
    TweenService:Create(
        IntroFrame,
        TweenInfo.new(
            0.5
        ),
        {
            GroupTransparency = 1
        }
    ):Play()
    TweenService:Create(
        MainContent,
        TweenInfo.new(
            0.5
        ),
        {
            GroupTransparency = 0
        }
    ):Play()

    IntroFrame.Interactable = false
    MainContent.Interactable = true
end)

-- Loader Txt
local uilib = {}
local currentOpen = nil
local switchin = false

function uilib:EndLoad()
    loaderLoop:Disconnect()
    LoaderLabel:Destroy()
    Frame.Visible = true
end

function uilib:Tab(tabName, tabIco)
    local TabBtn = Instance.new("ImageButton")
    TabBtn.Name = tabName
    TabBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabBtn.Size = UDim2.new(1, 0, 0.13600000739097595, 0)
    TabBtn.BorderSizePixel = 0
    TabBtn.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
    TabBtn.Parent = TabsContainer

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(130, 139, 185)
    UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    UIStroke.Parent = TabBtn

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = TabBtn

    local TabIco = Instance.new("ImageLabel")
    TabIco.ScaleType = Enum.ScaleType.Fit
    TabIco.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabIco.Name = "TabIco"
    TabIco.AnchorPoint = Vector2.new(0.5, 0.5)
    TabIco.Image = tabIco
    TabIco.BackgroundTransparency = 1
    TabIco.Position = UDim2.new(0.1340000033378601, 0, 0.5, 0)
    TabIco.Size = UDim2.new(0.1458333283662796, 0, 0.5, 0)
    TabIco.BorderSizePixel = 0
    TabIco.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabIco.Parent = TabBtn

    local TabTitle = Instance.new("TextLabel")
    TabTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    TabTitle.AnchorPoint = Vector2.new(0.5, 0.5)
    TabTitle.TextSize = 14
    TabTitle.Size = UDim2.new(0.6875, 0, 0.4523809552192688, 0)
    TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabTitle.Text = tabName
    TabTitle.Name = "TabTitle"
    TabTitle.TextWrapped = true
    TabTitle.BackgroundTransparency = 1
    TabTitle.TextXAlignment = Enum.TextXAlignment.Left
    TabTitle.Position = UDim2.new(0.5990554094314575, 0, 0.5, 0)
    TabTitle.BorderSizePixel = 0
    TabTitle.TextScaled = true
    
    TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabTitle.Parent = TabBtn
    applyFont(
        TabTitle,
        "georgia",
        Enum.FontWeight.Regular,
        Enum.FontStyle.Normal
    )

    local SectionCanvas = Instance.new("CanvasGroup")
    SectionCanvas.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionCanvas.AnchorPoint = Vector2.new(0.5, 0.5)
    SectionCanvas.BackgroundTransparency = 1
    SectionCanvas.Position = UDim2.new(0.5, 0, 0.5, 0)
    SectionCanvas.Name = tabName
    SectionCanvas.Size = UDim2.new(1, 0, 1, 0)
    SectionCanvas.BorderSizePixel = 0
    SectionCanvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionCanvas.Parent = SectionDock
    SectionCanvas.Interactable = false
    SectionCanvas.GroupTransparency = 1

    local SectionContainer = Instance.new("ScrollingFrame")
    SectionContainer.Active = true
    SectionContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SectionContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    SectionContainer.BorderSizePixel = 0
    SectionContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    SectionContainer.ScrollBarImageColor3 = Color3.fromRGB(130, 139, 185)
    SectionContainer.MidImage = "rbxassetid://127122516187967"
    SectionContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionContainer.ScrollBarThickness = 3
    SectionContainer.Name = "SectionContainer"
    SectionContainer.Size = UDim2.new(1, 0, 1, 0)
    SectionContainer.TopImage = "rbxassetid://95393284273131"
    SectionContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    SectionContainer.BottomImage = "rbxassetid://130372495606057"
    SectionContainer.BackgroundTransparency = 1
    SectionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionContainer.Parent = SectionCanvas

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = SectionContainer

    TabBtn.MouseButton1Click:Connect(function()
        if switchin then return end
        if currentOpen == tabName then return end

        switchin = true

        if currentOpen then
            TweenService:Create(
                SectionDock[currentOpen],
                TweenInfo.new(
                    0.5
                ),
                {
                    GroupTransparency = 1
                }
            ):Play()
        end

        TweenService:Create(
            SectionCanvas,
            TweenInfo.new(
                0.5
            ),
            {
                GroupTransparency = 0
            }
        ):Play()

        task.wait(0.5)

        SectionCanvas.Interactable = true
        if currentOpen then
            SectionDock[currentOpen].Interactable = false
        end

        currentOpen = tabName

        switchin = false
    end)

    local elements = {}

    function elements:Unsupported()
        local NotSupportedMain = Instance.new("Frame")
        NotSupportedMain.BackgroundTransparency = 1
        NotSupportedMain.Name = "NotSupportedMain"
        NotSupportedMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotSupportedMain.Size = UDim2.new(0.972, 0, 0.718, 0)
        NotSupportedMain.BorderSizePixel = 0
        NotSupportedMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotSupportedMain.Parent = SectionContainer

        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "ContentFrame"
        ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.Size = UDim2.new(1, 0, 0.9459459185600281, 0)
        ContentFrame.BorderSizePixel = 0
        ContentFrame.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
        ContentFrame.Parent = NotSupportedMain

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = ContentFrame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(130, 139, 185)
        UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
        UIStroke.Parent = ContentFrame

        local TabTitle = Instance.new("TextLabel")
        TabTitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        TabTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.AnchorPoint = Vector2.new(0.5, 0.5)
        TabTitle.TextSize = 14
        TabTitle.Size = UDim2.new(0.8721153736114502, 0, 0.14532120525836945, 0)
        TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabTitle.Text = "This game isn't supported!"
        TabTitle.Name = "TabTitle"
        TabTitle.TextWrapped = true
        TabTitle.BackgroundTransparency = 1
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        TabTitle.Position = UDim2.new(0.48110663890838623, 0, 0.12745361030101776, 0)
        TabTitle.BorderSizePixel = 0
        TabTitle.TextScaled = true
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.Parent = ContentFrame
        applyFont(
            TabTitle,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        )

        local TabTitle = Instance.new("TextLabel")
        TabTitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        TabTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.AnchorPoint = Vector2.new(0.5, 0.5)
        TabTitle.TextSize = 14
        TabTitle.Size = UDim2.new(0.8721153736114502, 0, 0.11674977093935013, 0)
        TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabTitle.Text = "You can either:"
        TabTitle.Name = "TabTitle"
        TabTitle.TextWrapped = true
        TabTitle.BackgroundTransparency = 1
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        TabTitle.Position = UDim2.new(0.48110663890838623, 0, 0.3036440908908844, 0)
        TabTitle.BorderSizePixel = 0
        TabTitle.TextScaled = true
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.Parent = ContentFrame
        applyFont(
            TabTitle,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        )

        local CloseBPButton = Instance.new("TextButton")
        CloseBPButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        CloseBPButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        CloseBPButton.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseBPButton.TextSize = 14
        CloseBPButton.Size = UDim2.new(0.8721153736114502, 0, 0.09770215302705765, 0)
        CloseBPButton.TextColor3 = Color3.fromRGB(89, 205, 255)
        CloseBPButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CloseBPButton.Text = "Close Brainrot Police"
        CloseBPButton.Name = "CloseBPButton"
        CloseBPButton.TextWrapped = true
        CloseBPButton.Selectable = false
        CloseBPButton.BackgroundTransparency = 1
        CloseBPButton.TextXAlignment = Enum.TextXAlignment.Left
        CloseBPButton.Position = UDim2.new(0.48110663890838623, 0, 0.6369774341583252, 0)
        CloseBPButton.BorderSizePixel = 0
        CloseBPButton.TextScaled = true
        CloseBPButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CloseBPButton.Parent = ContentFrame
        applyFont(
            CloseBPButton,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        )

        local GameslistButton = Instance.new("TextButton")
        GameslistButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        GameslistButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        GameslistButton.AnchorPoint = Vector2.new(0.5, 0.5)
        GameslistButton.TextSize = 14
        GameslistButton.Size = UDim2.new(0.8721153736114502, 0, 0.09770215302705765, 0)
        GameslistButton.TextColor3 = Color3.fromRGB(89, 205, 255)
        GameslistButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        GameslistButton.Text = "Check out our supported games list"
        GameslistButton.Name = "GameslistButton"
        GameslistButton.TextWrapped = true
        GameslistButton.Selectable = false
        GameslistButton.BackgroundTransparency = 1
        GameslistButton.TextXAlignment = Enum.TextXAlignment.Left
        GameslistButton.Position = UDim2.new(0.48110663890838623, 0, 0.5369774103164673, 0)
        GameslistButton.BorderSizePixel = 0
        GameslistButton.TextScaled = true
        GameslistButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        GameslistButton.Parent = ContentFrame
        applyFont(
            GameslistButton,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        )

        local SuggestButton = Instance.new("TextButton")
        SuggestButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        SuggestButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        SuggestButton.AnchorPoint = Vector2.new(0.5, 0.5)
        SuggestButton.TextSize = 14
        SuggestButton.Size = UDim2.new(0.8721153736114502, 0, 0.09770215302705765, 0)
        SuggestButton.TextColor3 = Color3.fromRGB(89, 205, 255)
        SuggestButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SuggestButton.Text = "Suggest for this game to be added"
        SuggestButton.Name = "SuggestButton"
        SuggestButton.TextWrapped = true
        SuggestButton.Selectable = false
        SuggestButton.BackgroundTransparency = 1
        SuggestButton.TextXAlignment = Enum.TextXAlignment.Left
        SuggestButton.Position = UDim2.new(0.48110663890838623, 0, 0.43697741627693176, 0)
        SuggestButton.BorderSizePixel = 0
        SuggestButton.TextScaled = true
        SuggestButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SuggestButton.Parent = ContentFrame
        applyFont(
            SuggestButton,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        )

        local BottomTing = Instance.new("TextLabel")
        BottomTing.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        BottomTing.Active = true
        BottomTing.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        BottomTing.AnchorPoint = Vector2.new(0.5, 0.5)
        BottomTing.TextSize = 14
        BottomTing.Size = UDim2.new(0.8721153736114502, 0, 0.09770215302705765, 0)
        BottomTing.TextColor3 = Color3.fromRGB(255, 255, 255)
        BottomTing.BorderColor3 = Color3.fromRGB(0, 0, 0)
        BottomTing.Text = "Click your desired option."
        BottomTing.Name = "BottomTing"
        BottomTing.TextWrapped = true
        BottomTing.BackgroundTransparency = 1
        BottomTing.TextXAlignment = Enum.TextXAlignment.Left
        BottomTing.Position = UDim2.new(0.48110663890838623, 0, 0.9036440849304199, 0)
        BottomTing.BorderSizePixel = 0
        BottomTing.TextScaled = true
        BottomTing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BottomTing.Parent = ContentFrame
        applyFont(
            BottomTing,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Italic
        )

        SuggestButton.MouseButton1Click:Connect(function()
            setclipboard("https://discord.gg/vaehz")
            SuggestButton.Text = "Copied to Clipboard!"
            task.wait(2)
            SuggestButton.Text = "Suggest for this game to be added"
        end)

        CloseBPButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)

        GameslistButton.MouseButton1Click:Connect(function()
            if switchin then return end

            switchin = true

            TweenService:Create(
                SectionCanvas,
                TweenInfo.new(
                    0.5
                ),
                {
                    GroupTransparency = 1
                }
            ):Play()

            TweenService:Create(
                SectionDock["Games List"],
                TweenInfo.new(
                    0.5
                ),
                {
                    GroupTransparency = 0
                }
            ):Play()

            task.wait(0.5)

            SectionCanvas.Interactable = false
            SectionDock["Games List"].Interactable = true

            currentOpen = "Games List"

            switchin = false
        end)
    end

    function elements:Button(elementName, cb)
        local ButtonMain = Instance.new("Frame")
        ButtonMain.BackgroundTransparency = 1
        ButtonMain.Name = "ButtonMain"
        ButtonMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ButtonMain.Size = UDim2.new(0.972000002861023, 0, 0.18777988851070404, 0)
        ButtonMain.BorderSizePixel = 0
        ButtonMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ButtonMain.Parent = SectionContainer

        local ContentFrame = Instance.new("ImageButton")
        ContentFrame.Size = UDim2.new(1, 0, 0.9111184477806091, 0)
        ContentFrame.Name = "ContentFrame"
        ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.Selectable = false
        ContentFrame.BorderSizePixel = 0
        ContentFrame.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
        ContentFrame.Parent = ButtonMain

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = ContentFrame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(130, 139, 185)
        UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
        UIStroke.Parent = ContentFrame

        local elementtitle = Instance.new("TextLabel")
        elementtitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        elementtitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.AnchorPoint = Vector2.new(0.5, 0.5)
        elementtitle.TextSize = 14
        elementtitle.Size = UDim2.new(0.8721153736114502, 0, 0.445485919713974, 0)
        elementtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        elementtitle.Text = elementName
        elementtitle.Name = "elementtitle"
        elementtitle.TextWrapped = true
        elementtitle.BackgroundTransparency = 1
        elementtitle.TextXAlignment = Enum.TextXAlignment.Left
        elementtitle.Position = UDim2.new(0.5, 0, 0.5, 0)
        elementtitle.BorderSizePixel = 0
        elementtitle.TextScaled = true
        elementtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.Parent = ContentFrame
        applyFont(
            elementtitle,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Italic
        )

        ContentFrame.MouseButton1Click:Connect(function()
            cb()
        end)
    end

    function elements:Toggle(elementName, defState, cb)
        local isToggled = defState

        local ToggleMain = Instance.new("Frame")
        ToggleMain.BackgroundTransparency = 1
        ToggleMain.Name = "ToggleMain"
        ToggleMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ToggleMain.Size = UDim2.new(0.972000002861023, 0, 0.18777988851070404, 0)
        ToggleMain.BorderSizePixel = 0
        ToggleMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleMain.Parent = SectionContainer

        local ContentFrame = Instance.new("ImageButton")
        ContentFrame.Size = UDim2.new(1, 0, 0.9111184477806091, 0)
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Active = false
        ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.Selectable = false
        ContentFrame.BorderSizePixel = 0
        ContentFrame.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
        ContentFrame.Parent = ToggleMain

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = ContentFrame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(130, 139, 185)
        UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
        UIStroke.Parent = ContentFrame

        local elementtitle = Instance.new("TextLabel")
        elementtitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        elementtitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.AnchorPoint = Vector2.new(0.5, 0.5)
        elementtitle.TextSize = 14
        elementtitle.Size = UDim2.new(0.7875059247016907, 0, 0.4454859495162964, 0)
        elementtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        elementtitle.Text = elementName
        elementtitle.Name = "elementtitle"
        elementtitle.TextWrapped = true
        elementtitle.BackgroundTransparency = 1
        elementtitle.TextXAlignment = Enum.TextXAlignment.Left
        elementtitle.Position = UDim2.new(0.4576953053474426, 0, 0.49999967217445374, 0)
        elementtitle.BorderSizePixel = 0
        elementtitle.TextScaled = true
        elementtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.Parent = ContentFrame
        applyFont(
            elementtitle,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Italic
        )

        local toggledindicator = Instance.new("TextLabel")
        toggledindicator.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        toggledindicator.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        toggledindicator.AnchorPoint = Vector2.new(0.5, 0.5)
        toggledindicator.TextSize = 14
        toggledindicator.Size = UDim2.new(0.05935234576463699, 0, 0.4454859495162964, 0)
        toggledindicator.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggledindicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
        toggledindicator.Text = isToggled and "🟢" or "🔴"
        toggledindicator.Name = "toggledindicator"
        toggledindicator.TextWrapped = true
        toggledindicator.BackgroundTransparency = 1
        toggledindicator.TextXAlignment = Enum.TextXAlignment.Right
        toggledindicator.Position = UDim2.new(0.9063810110092163, 0, 0.49999967217445374, 0)
        toggledindicator.BorderSizePixel = 0
        toggledindicator.TextScaled = true
        toggledindicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggledindicator.Parent = ContentFrame

        ContentFrame.MouseButton1Click:Connect(function()
            if isToggled then
                isToggled = false
                toggledindicator.Text = "🔴"
            else
                isToggled = true
                toggledindicator.Text = "🟢"
            end

            cb(isToggled)
        end)
    end

    function elements:Textbox(elementName, def, cb)
        local TextboxMain = Instance.new("Frame")
        TextboxMain.BackgroundTransparency = 1
        TextboxMain.Name = "TextboxMain"
        TextboxMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextboxMain.Size = UDim2.new(0.972000002861023, 0, 0.18777988851070404, 0)
        TextboxMain.BorderSizePixel = 0
        TextboxMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextboxMain.Parent = SectionContainer

        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "ContentFrame"
        ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.Size = UDim2.new(1, 0, 0.9111184477806091, 0)
        ContentFrame.BorderSizePixel = 0
        ContentFrame.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
        ContentFrame.Parent = TextboxMain

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = ContentFrame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(130, 139, 185)
        UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
        UIStroke.Parent = ContentFrame

        local elementtitle = Instance.new("TextLabel")
        elementtitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        elementtitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.AnchorPoint = Vector2.new(0.5, 0.5)
        elementtitle.TextSize = 14
        elementtitle.Size = UDim2.new(0.5464974641799927, 0, 0.4454859495162964, 0)
        elementtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        elementtitle.Text = elementName
        elementtitle.Name = "elementtitle"
        elementtitle.TextWrapped = true
        elementtitle.BackgroundTransparency = 1
        elementtitle.TextXAlignment = Enum.TextXAlignment.Left
        elementtitle.Position = UDim2.new(0.33719107508659363, 0, 0.49999967217445374, 0)
        elementtitle.BorderSizePixel = 0
        elementtitle.TextScaled = true
        elementtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        elementtitle.Parent = ContentFrame
        applyFont(
            elementtitle,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Italic
        )

        local Frame = Instance.new("Frame")
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.new(0.796999990940094, 0, 0.5, 0)
        Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Frame.Size = UDim2.new(0.27433955669403076, 0, 0.5296337008476257, 0)
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = Color3.fromRGB(57, 61, 81)
        Frame.Parent = ContentFrame

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Frame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(130, 139, 185)
        UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
        UIStroke.Parent = Frame

        local tbinp = Instance.new("TextBox")
        tbinp.TextWrapped = true
        tbinp.Active = false
        tbinp.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        tbinp.AnchorPoint = Vector2.new(0.5, 0.5)
        tbinp.PlaceholderText = "Type here"
        tbinp.TextSize = 14
        tbinp.Size = UDim2.new(0.8736003041267395, 0, 0.6433030962944031, 0)
        tbinp.TextColor3 = Color3.fromRGB(255, 255, 255)
        tbinp.BorderColor3 = Color3.fromRGB(0, 0, 0)
        tbinp.Text = def
        tbinp.Name = "tbinp"
        tbinp.Selectable = false
        tbinp.BackgroundTransparency = 1
        tbinp.Position = UDim2.new(0.5, 0, 0.5, 0)
        tbinp.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        tbinp.BorderSizePixel = 0
        tbinp.TextScaled = true
        tbinp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tbinp.Parent = Frame
        applyFont(
            tbinp,
            "georgia",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Italic
        )

        tbinp.FocusLost:Connect(function(ep)
            if ep then
                cb(tbinp.Text)
            end
        end)
    end

    return elements
end

local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

return uilib
