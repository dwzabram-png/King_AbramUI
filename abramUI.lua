-- ===============================================
-- 👑 KING LEGACY - ABRAM UI (PART 1: UI LIBRARY)
-- UI Source: gui.txt (Modified to Red Theme)
-- ===============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

if not player then return end

-- Обертка для библиотеки, чтобы не засорять глобальную область
local Library = (function()
    local CFAHub = {}
    
    -- Ждем загрузку игры
    if not game:IsLoaded() then game.Loaded:Wait() end

    local Tween = game:GetService("TweenService")
    local Tweeninfo = TweenInfo.new
    local Input = game:GetService("UserInputService")
    local Run = game:GetService("RunService")
    local Utility = {}
    local Animate = {}

    -- Вспомогательные функции UI
    function Utility:TweenObject(obj, properties, duration, ...)
        Tween:Create(obj, Tweeninfo(duration, ...), properties):Play()
    end

    function Utility:Pop(object, shrink)
        local clone = object:Clone()
        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        clone.Size = clone.Size - UDim2.new(0, shrink, 0, shrink)
        clone.Position = UDim2.new(0.5, 0, 0.5, 0)
        clone.Parent = object
        object.BackgroundTransparency = 1
        Utility:TweenObject(clone, {Size = object.Size}, 0.2)
        spawn(function()
            wait(0.2)
            object.BackgroundTransparency = 0
            clone:Destroy()
        end)
        return clone
    end

    function Utility:TweenTransparency(obj, style, value)
        if string.lower(style) == 'bg' then
            Tween:Create(obj, TweenInfo.new(.25), {BackgroundTransparency = value}):Play()
        elseif string.lower(style) == 'img' then 
            Tween:Create(obj, TweenInfo.new(.25), {ImageTransparency = value}):Play()
        elseif string.lower(style) == 'text' then 
            Tween:Create(obj, TweenInfo.new(.25), {TextTransparency = value}):Play()
        end
    end

    function Animate:CreateGradient(object)
        local UIGradient = Instance.new("UIGradient")
        UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 200))}
        UIGradient.Rotation = 25
        UIGradient.Parent = object
    end

    function CFAHub:DraggingEnabled(frame, parent)
        parent = parent or frame
        local dragging = false
        local dragInput, mousePos, framePos

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                mousePos = input.Position
                framePos = parent.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)

        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)

        Input.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - mousePos
                Utility:TweenObject(parent, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.25)
            end
        end)
    end

    local GuiName = "abramUI_Red_v1"

    function CFAHub:CreateWindow(title, gameName)
        -- УДАЛЯЕМ СТАРЫЙ GUI
        for _, v in pairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and v.Name == GuiName then v:Destroy() end
        end

        -- 🔴 КРАСНАЯ ТЕМА (RED THEME)
        local themes = {
            SchemaColor = Color3.fromRGB(255, 0, 0), -- Ярко-красный
            TextColor = Color3.fromRGB(255, 255, 255),
            Header = Color3.fromRGB(20, 20, 20),
            Container = Color3.fromRGB(30, 30, 30),
            Background = Color3.fromRGB(25, 25, 25),
            Slider = Color3.fromRGB(40, 40, 40),
            Drop = Color3.fromRGB(35, 35, 35),
            ScrollBar = Color3.fromRGB(255, 0, 0),
            NotiBackground = Color3.fromRGB(10, 10, 10),
            Glow = Color3.fromRGB(255, 0, 0),
            Logo = "rbxassetid://8964489645" -- Твой логотип
        }

        local CFAHubGui = Instance.new("ScreenGui")
        CFAHubGui.Name = GuiName
        CFAHubGui.Parent = CoreGui
        CFAHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local Container = Instance.new("Frame")
        local UIScale = Instance.new("UIScale")
        local ContainerCorner = Instance.new("UICorner")
        local ElementContainer = Instance.new("Frame")
        local Elements = Instance.new("Frame")
        local ElementCorner = Instance.new("UICorner")
        local Header = Instance.new("Frame")
        local HeaderCorner = Instance.new("UICorner")
        local logo = Instance.new("ImageLabel")
        local Title = Instance.new("TextLabel")
        local TabFrame = Instance.new("Frame")
        local TabCorner = Instance.new("UICorner")
        local TabScroll = Instance.new("ScrollingFrame")
        local TabGridLayout = Instance.new("UIGridLayout")
        local ShadowBlue = Instance.new("ImageLabel")
        local UIPageLayout = Instance.new("UIPageLayout")

        -- NOTIFICATION SYSTEM
        local CurrentAlert = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = CurrentAlert
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        UIListLayout.Padding = UDim.new(0, 8)
        CurrentAlert.Name = "NotiContainer"
        CurrentAlert.Parent = CFAHubGui
        CurrentAlert.AnchorPoint = Vector2.new(1, 1)
        CurrentAlert.BackgroundTransparency = 1
        CurrentAlert.Position = UDim2.new(1, -10, 1, -10)
        CurrentAlert.Size = UDim2.new(1, -10, 1, -10)
        CurrentAlert.ZIndex = 9

        function CFAHub:AddNoti(header, message, duration)
            duration = duration or 3
            local Template = Instance.new("Frame")
            local HeaderLbl = Instance.new("TextLabel")
            local MessageLbl = Instance.new("TextLabel")
            local UICorner = Instance.new("UICorner")
            local BarFrame = Instance.new("Frame")
            local Bar = Instance.new("Frame")
            
            Template.Parent = CurrentAlert
            Template.BackgroundColor3 = themes.NotiBackground
            Template.BackgroundTransparency = 0.1
            Template.Size = UDim2.new(0, 250, 0, 70)
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = Template
            
            HeaderLbl.Parent = Template
            HeaderLbl.BackgroundTransparency = 1
            HeaderLbl.Position = UDim2.new(0.05, 0, 0.1, 0)
            HeaderLbl.Size = UDim2.new(0.9, 0, 0, 20)
            HeaderLbl.Font = Enum.Font.GothamBold
            HeaderLbl.Text = header
            HeaderLbl.TextColor3 = themes.SchemaColor
            HeaderLbl.TextSize = 16
            HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
            
            MessageLbl.Parent = Template
            MessageLbl.BackgroundTransparency = 1
            MessageLbl.Position = UDim2.new(0.05, 0, 0.4, 0)
            MessageLbl.Size = UDim2.new(0.9, 0, 0.5, 0)
            MessageLbl.Font = Enum.Font.GothamSemibold
            MessageLbl.Text = message
            MessageLbl.TextColor3 = themes.TextColor
            MessageLbl.TextSize = 14
            MessageLbl.TextWrapped = true
            MessageLbl.TextXAlignment = Enum.TextXAlignment.Left
            
            BarFrame.Parent = Template
            BarFrame.BackgroundColor3 = themes.NotiBackground
            BarFrame.Position = UDim2.new(0, 0, 1, -4)
            BarFrame.Size = UDim2.new(1, 0, 0, 4)
            
            Bar.Parent = BarFrame
            Bar.BackgroundColor3 = themes.SchemaColor
            Bar.Size = UDim2.new(1, 0, 1, 0)
            
            Tween:Create(Bar, TweenInfo.new(duration), {Size = UDim2.new(0, 0, 1, 0)}):Play()
            spawn(function() wait(duration) Template:Destroy() end)
        end

        CFAHub:DraggingEnabled(Header, Container)

        Container.Parent = CFAHubGui
        Container.AnchorPoint = Vector2.new(0.5, 0.5)
        Container.BackgroundColor3 = themes.Container
        Container.Position = UDim2.new(0.5, 0, 0.5, 0)
        Container.Size = UDim2.new(0, 673, 0, 402)
        UIScale.Parent = Container
        ContainerCorner.CornerRadius = UDim.new(0, 4)
        ContainerCorner.Parent = Container

        ElementContainer.Parent = Container
        ElementContainer.BackgroundColor3 = themes.Background
        ElementContainer.Position = UDim2.new(0.2715, 0, 0.4975, 15)
        ElementContainer.Size = UDim2.new(0.716, 0, 0.029, 348)
        ElementContainer.ClipsDescendants = true
        ElementCorner.CornerRadius = UDim.new(0, 4)
        ElementCorner.Parent = ElementContainer

        Elements.Parent = ElementContainer
        Elements.BackgroundTransparency = 1
        Elements.Size = UDim2.new(1, 0, 1, 0)
        UIPageLayout.Parent = Elements
        UIPageLayout.FillDirection = Enum.FillDirection.Vertical
        UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
        UIPageLayout.TweenTime = 0.5

        Header.Parent = Container
        Header.BackgroundColor3 = themes.Header
        Header.Size = UDim2.new(0, 673, 0, 29)
        HeaderCorner.CornerRadius = UDim.new(0, 4)
        HeaderCorner.Parent = Header

        logo.Parent = Header
        logo.AnchorPoint = Vector2.new(0.5, 0.5)
        logo.BackgroundTransparency = 1
        logo.Position = UDim2.new(0.03, 0, 0.5, 0)
        logo.Size = UDim2.new(0, 25, 0, 25)
        logo.Image = themes.Logo

        Title.Parent = Header
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0.058, 0, 0, 0)
        Title.Size = UDim2.new(0, 625, 0, 29)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = title
        Title.RichText = true
        Title.TextColor3 = themes.TextColor
        Title.TextSize = 22
        Title.TextXAlignment = Enum.TextXAlignment.Left

        TabFrame.Parent = Container
        TabFrame.BackgroundColor3 = themes.Background
        TabFrame.Position = UDim2.new(0.01, 0, 0.4975, 15)
        TabFrame.Size = UDim2.new(0.25, 0, 0.029, 348)
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabFrame

        TabScroll.Parent = TabFrame
        TabScroll.BackgroundTransparency = 1
        TabScroll.Size = UDim2.new(1, 0, 1, 0)
        TabScroll.ScrollBarThickness = 0
        TabGridLayout.Parent = TabScroll
        TabGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabGridLayout.CellSize = UDim2.new(0, 150, 0, 35)

        ShadowBlue.Parent = Container
        ShadowBlue.AnchorPoint = Vector2.new(0.5, 0.5)
        ShadowBlue.BackgroundTransparency = 1
        ShadowBlue.Position = UDim2.new(0.5, 0, 0.5, 0)
        ShadowBlue.Size = UDim2.new(1, 74, 1, 45)
        ShadowBlue.ZIndex = 0
        ShadowBlue.Image = "http://www.roblox.com/asset/?id=7495863394"
        ShadowBlue.ImageColor3 = themes.Glow

        local Tabs = {}
        local LayoutOrder = -1
        local first = true

        function Tabs:CreatePage(tabTitle)
            LayoutOrder = LayoutOrder + 1
            local TabButton = Instance.new("TextButton")
            local TabButtonCorner = Instance.new("UICorner")
            local slice = Instance.new("Frame")
            local sliceCorner = Instance.new("UICorner")
            local PageContainer = Instance.new("Frame")
            local SectionScroll = Instance.new("ScrollingFrame")
            local SectionScrollListLayout = Instance.new("UIListLayout")

            PageContainer.Name = tabTitle.."_Page"
            PageContainer.Parent = Elements
            PageContainer.BackgroundTransparency = 1
            PageContainer.Size = UDim2.new(1, 0, 1, 0)
            PageContainer.LayoutOrder = LayoutOrder

            SectionScroll.Parent = PageContainer
            SectionScroll.BackgroundTransparency = 1
            SectionScroll.Size = UDim2.new(1, 0, 1, 0)
            SectionScroll.ScrollBarThickness = 4
            SectionScroll.ScrollBarImageColor3 = themes.ScrollBar

            SectionScrollListLayout.Parent = SectionScroll
            SectionScrollListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionScrollListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionScrollListLayout.Padding = UDim.new(0, 6)

            SectionScrollListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionScroll.CanvasSize = UDim2.new(0, 0, 0, SectionScrollListLayout.AbsoluteContentSize.Y + 10)
            end)

            TabButton.Parent = TabScroll
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.BackgroundTransparency = 1
            TabButton.Size = UDim2.new(0, 141, 0, 43)
            TabButton.Font = Enum.Font.SourceSansSemibold
            TabButton.Text = tabTitle
            TabButton.TextColor3 = themes.TextColor
            TabButton.TextSize = 23
            TabButtonCorner.CornerRadius = UDim.new(0, 4)
            TabButtonCorner.Parent = TabButton

            slice.Parent = TabButton
            slice.AnchorPoint = Vector2.new(0.5, 1)
            slice.BackgroundColor3 = themes.SchemaColor
            slice.Position = UDim2.new(0.5, 0, 1, 0)
            slice.Size = UDim2.new(0, 20, 0, 4)
            sliceCorner.CornerRadius = UDim.new(0, 4)
            sliceCorner.Parent = slice

            if first then
                first = false
                slice.Size = UDim2.new(0, 50, 0, 4)
                slice.BackgroundTransparency = 0
                TabButton.TextTransparency = 0
            else
                slice.Size = UDim2.new(0, 20, 0, 4)
                slice.BackgroundTransparency = 1
                TabButton.TextTransparency = 0.5
            end

            TabButton.MouseButton1Click:Connect(function()
                UIPageLayout:JumpToIndex(PageContainer.LayoutOrder)
                for _, v in pairs(TabScroll:GetChildren()) do
                    if v:IsA("TextButton") then
                        Utility:TweenObject(v, {TextTransparency = .5}, 0.1)
                        Tween:Create(v.slice, Tweeninfo(0.2), {Size = UDim2.new(0, 15, 0, 4), BackgroundTransparency = 1}):Play()
                    end
                end
                Utility:TweenObject(TabButton, {TextTransparency = 0}, 0.1)
                Tween:Create(slice, Tweeninfo(0.2), {Size = UDim2.new(0, 50, 0, 4), BackgroundTransparency = 0}):Play()
            end)

            local Sections = {}
            function Sections:CreateSection(secName)
                local SectionFrame = Instance.new("Frame")
                local SectionFrameCorner = Instance.new("UICorner")
                local SectionText = Instance.new("TextLabel")
                local SectionFrameListLayout = Instance.new("UIListLayout")

                SectionFrame.Parent = SectionScroll
                SectionFrame.BackgroundColor3 = themes.Container
                SectionFrame.Size = UDim2.new(0, 470, 0, 100)
                SectionFrame.ClipsDescendants = true
                SectionFrameCorner.CornerRadius = UDim.new(0, 4)
                SectionFrameCorner.Parent = SectionFrame

                SectionText.Parent = SectionFrame
                SectionText.BackgroundTransparency = 1
                SectionText.Size = UDim2.new(1, 0, 0, 26)
                SectionText.Font = Enum.Font.SourceSansSemibold
                SectionText.Text = secName
                SectionText.TextColor3 = themes.SchemaColor
                SectionText.TextSize = 21

                SectionFrameListLayout.Parent = SectionFrame
                SectionFrameListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                SectionFrameListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                SectionFrameListLayout.Padding = UDim.new(0, 6)

                SectionFrameListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    SectionFrame.Size = UDim2.new(0, 470, 0, SectionFrameListLayout.AbsoluteContentSize.Y + 6)
                end)

                local Elements = {}

                function Elements:CreateButton(btitle, callback)
                    callback = callback or function() end
                    local Button = Instance.new("TextButton")
                    local ButtonCorner = Instance.new("UICorner")
                    Button.Parent = SectionFrame
                    Button.BackgroundColor3 = themes.Background
                    Button.Size = UDim2.new(0, 440, 0, 34)
                    Button.Font = Enum.Font.SourceSansSemibold
                    Button.Text = " " .. btitle
                    Button.TextColor3 = themes.TextColor
                    Button.TextSize = 22
                    Button.TextXAlignment = Enum.TextXAlignment.Left
                    Button.AutoButtonColor = false
                    ButtonCorner.CornerRadius = UDim.new(0, 4)
                    ButtonCorner.Parent = Button
                    Button.MouseButton1Click:Connect(function()
                        Utility:Pop(Button, 10)
                        pcall(callback)
                    end)
                end

                function Elements:CreateToggle(togtitle, setting, callback)
                    callback = callback or function() end
                    local tog = setting.Toggled or false
                    local ToggleButton = Instance.new("TextButton")
                    local ToggleCorner = Instance.new("UICorner")
                    local IconEnable = Instance.new("ImageLabel")
                    local ToggleText = Instance.new("TextLabel")

                    ToggleButton.Parent = SectionFrame
                    ToggleButton.BackgroundColor3 = themes.Background
                    ToggleButton.Size = UDim2.new(0, 440, 0, 34)
                    ToggleButton.AutoButtonColor = false
                    ToggleButton.Text = ""
                    ToggleCorner.CornerRadius = UDim.new(0, 4)
                    ToggleCorner.Parent = ToggleButton

                    IconEnable.Parent = ToggleButton
                    IconEnable.AnchorPoint = Vector2.new(0.5, 0.5)
                    IconEnable.BackgroundTransparency = 1
                    IconEnable.Position = UDim2.new(0.95, 0, 0.5, 0)
                    IconEnable.Size = UDim2.new(0, 23, 0, 23)
                    IconEnable.Image = "rbxassetid://3926309567"
                    IconEnable.ImageRectOffset = Vector2.new(784, 420)
                    IconEnable.ImageRectSize = Vector2.new(48, 48)
                    IconEnable.ImageTransparency = tog and 0 or 1
                    IconEnable.ImageColor3 = themes.TextColor

                    ToggleText.Parent = ToggleButton
                    ToggleText.BackgroundTransparency = 1
                    ToggleText.Size = UDim2.new(0, 396, 0, 34)
                    ToggleText.Font = Enum.Font.SourceSansSemibold
                    ToggleText.Text = " " .. togtitle
                    ToggleText.TextColor3 = themes.TextColor
                    ToggleText.TextSize = 22
                    ToggleText.TextXAlignment = Enum.TextXAlignment.Left

                    local isToggle = tog
                    local function update()
                        Tween:Create(IconEnable, TweenInfo.new(0.1), {ImageTransparency = isToggle and 0 or 1}):Play()
                        pcall(callback, isToggle)
                    end
                    ToggleButton.MouseButton1Click:Connect(function()
                        isToggle = not isToggle
                        update()
                    end)
                    if isToggle then pcall(callback, isToggle) end
                end

                function Elements:CreateTextbox(boxtitle, desc, callback, def)
                    callback = callback or function() end
                    local TextBoxFrame = Instance.new("Frame")
                    local TextBoxText = Instance.new("TextLabel")
                    local TextBoxCorner = Instance.new("UICorner")
                    local Box = Instance.new("TextBox")
                    local BoxCorner = Instance.new("UICorner")

                    TextBoxFrame.Parent = SectionFrame
                    TextBoxFrame.BackgroundColor3 = themes.Background
                    TextBoxFrame.Size = UDim2.new(0, 440, 0, 65)
                    TextBoxText.Parent = TextBoxFrame
                    TextBoxText.BackgroundTransparency = 1
                    TextBoxText.Size = UDim2.new(0, 396, 0, 34)
                    TextBoxText.Font = Enum.Font.SourceSansSemibold
                    TextBoxText.Text = " " .. boxtitle
                    TextBoxText.TextColor3 = themes.TextColor
                    TextBoxText.TextSize = 22
                    TextBoxText.TextXAlignment = Enum.TextXAlignment.Left
                    TextBoxCorner.CornerRadius = UDim.new(0, 4)
                    TextBoxCorner.Parent = TextBoxFrame

                    Box.Parent = TextBoxFrame
                    Box.AnchorPoint = Vector2.new(0.5, 0.5)
                    Box.BackgroundColor3 = themes.Container
                    Box.Position = UDim2.new(0.5, 0, 0.715, 0)
                    Box.Size = UDim2.new(0, 426, 0, 25)
                    Box.Font = Enum.Font.SourceSansSemibold
                    Box.PlaceholderText = desc
                    Box.Text = def or ""
                    Box.TextColor3 = themes.TextColor
                    Box.TextSize = 18
                    BoxCorner.CornerRadius = UDim.new(0, 4)
                    BoxCorner.Parent = Box

                    Box.FocusLost:Connect(function(enterPressed)
                        callback(Box.Text)
                    end)
                end

                function Elements:CreateDropdown(droptitle, setting, callback)
                    local list = setting.List or {}
                    local default = setting.Default
                    callback = callback or function() end
                    local opened = false

                    local Dropdown = Instance.new("Frame")
                    local DropdownCorner = Instance.new("UICorner")
                    local TopFrame = Instance.new("Frame")
                    local TextLabel = Instance.new("TextLabel")
                    local ArrowIcon = Instance.new("ImageLabel")
                    local DropButton = Instance.new("TextButton")
                    local DropItemHolder = Instance.new("ScrollingFrame")
                    local DropItemListLayout = Instance.new("UIListLayout")

                    Dropdown.Parent = SectionFrame
                    Dropdown.BackgroundColor3 = themes.Drop
                    Dropdown.ClipsDescendants = true
                    Dropdown.Size = UDim2.new(0, 440, 0, 34)
                    DropdownCorner.CornerRadius = UDim.new(0, 4)
                    DropdownCorner.Parent = Dropdown

                    TopFrame.Parent = Dropdown
                    TopFrame.BackgroundColor3 = themes.Background
                    TopFrame.Size = UDim2.new(0, 440, 0, 34)
                    
                    TextLabel.Parent = TopFrame
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.Position = UDim2.new(0.03, 0, 0, 0)
                    TextLabel.Size = UDim2.new(0.8, 0, 1, 0)
                    TextLabel.Font = Enum.Font.SourceSansSemibold
                    TextLabel.Text = droptitle .. ": " .. (default or "")
                    TextLabel.TextColor3 = themes.TextColor
                    TextLabel.TextSize = 22
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

                    ArrowIcon.Parent = TopFrame
                    ArrowIcon.BackgroundTransparency = 1
                    ArrowIcon.Position = UDim2.new(0.9, 0, 0.2, 0)
                    ArrowIcon.Size = UDim2.new(0, 20, 0, 20)
                    ArrowIcon.Image = "rbxassetid://7072706663"
                    ArrowIcon.ImageColor3 = themes.TextColor

                    DropButton.Parent = TopFrame
                    DropButton.BackgroundTransparency = 1
                    DropButton.Size = UDim2.new(1, 0, 1, 0)
                    DropButton.Text = ""

                    DropItemHolder.Parent = Dropdown
                    DropItemHolder.BackgroundTransparency = 1
                    DropItemHolder.Position = UDim2.new(0, 0, 0, 34)
                    DropItemHolder.Size = UDim2.new(1, 0, 0, 100)
                    DropItemHolder.ScrollBarThickness = 4
                    DropItemHolder.ScrollBarImageColor3 = themes.ScrollBar

                    DropItemListLayout.Parent = DropItemHolder
                    DropItemListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    DropItemListLayout.Padding = UDim.new(0, 2)

                    DropItemListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropItemListLayout.AbsoluteContentSize.Y)
                    end)

                    local function ToggleDrop()
                        opened = not opened
                        if opened then
                            Dropdown:TweenSize(UDim2.new(0, 440, 0, 134), "Out", "Quad", 0.3, true)
                            Tween:Create(ArrowIcon, TweenInfo.new(0.3), {Rotation = 180}):Play()
                        else
                            Dropdown:TweenSize(UDim2.new(0, 440, 0, 34), "Out", "Quad", 0.3, true)
                            Tween:Create(ArrowIcon, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        end
                    end

                    DropButton.MouseButton1Click:Connect(ToggleDrop)

                    for _, item in ipairs(list) do
                        local ItemBtn = Instance.new("TextButton")
                        ItemBtn.Parent = DropItemHolder
                        ItemBtn.BackgroundColor3 = themes.Background
                        ItemBtn.Size = UDim2.new(1, 0, 0, 30)
                        ItemBtn.Font = Enum.Font.SourceSansSemibold
                        ItemBtn.Text = "  " .. item
                        ItemBtn.TextColor3 = themes.TextColor
                        ItemBtn.TextSize = 20
                        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                        ItemBtn.AutoButtonColor = false

                        ItemBtn.MouseButton1Click:Connect(function()
                            ToggleDrop()
                            TextLabel.Text = droptitle .. ": " .. item
                            callback(item)
                        end)
                    end
                end

                function Elements:CreateLabel(text)
                    local Label = Instance.new("TextLabel")
                    Label.Parent = SectionFrame
                    Label.BackgroundColor3 = themes.Background
                    Label.BackgroundTransparency = 1
                    Label.Size = UDim2.new(0, 440, 0, 30)
                    Label.Font = Enum.Font.SourceSansSemibold
                    Label.Text = " " .. text
                    Label.TextColor3 = themes.TextColor
                    Label.TextSize = 20
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    return Label
                end

                return Elements
            end
            return Sections
        end
        return Tabs
    end
    return CFAHub
end)()-- ===============================================
-- 👑 KING LEGACY AUTO FARM (ABRAM UI RED - PART 2)
-- PASTE THIS BELOW PART 1
-- ===============================================

-- ===============================================
-- 🚀 АВТОМАТИЧЕСКИЙ ЗАПУСК ИГРЫ
-- ===============================================

local args = {
    [1] = "EnterTheGame",
    [2] = {}
}

pcall(function()
    ReplicatedStorage.Chest.Remotes.Functions.EtcFunction:InvokeServer(unpack(args))
end)

task.wait(1)

-- ===============================================
-- 🔐 ENCRYPTION (ORIGINAL ABRAM LOGIC)
-- ===============================================

local function XOREncrypt(str, key)
    local result = {}
    for i = 1, #str do
        local charCode = string.byte(str, i)
        local keyCode = string.byte(key, ((i - 1) % #key) + 1)
        local encrypted = (charCode + keyCode) % 256
        table.insert(result, string.char(encrypted))
    end
    return table.concat(result)
end

local function XORDecrypt(str, key)
    local result = {}
    for i = 1, #str do
        local charCode = string.byte(str, i)
        local keyCode = string.byte(key, ((i - 1) % #key) + 1)
        local decrypted = (charCode - keyCode + 256) % 256
        table.insert(result, string.char(decrypted))
    end
    return table.concat(result)
end

-- ===============================================
-- 💾 CONFIG SYSTEM
-- ===============================================

local Config = {
    AccountName = player.Name,
    TelegramToken = "",
    TelegramChatID = "",
    Enabled = false,
    AutoFarm = false,
    AutoStats = false,
    Stat1 = "Melee",
    Stat2 = "Defense",
    AutoHaki = false
}

local function GetConfigFilename()
    return "AbramCFG_" .. player.Name .. "_v10_RedFinal.json"
end

local function SaveConfig()
    if not writefile then return end
    local encryptedToken = XOREncrypt(Config.TelegramToken or "", "KL_SECURE_KEY")
    local encryptedChatID = XOREncrypt(Config.TelegramChatID or "", "KL_SECURE_KEY")
    
    local dataToSave = {
        AccountName = Config.AccountName,
        TelegramToken = HttpService:Base64Encode(encryptedToken),
        TelegramChatID = HttpService:Base64Encode(encryptedChatID),
        Enabled = Config.Enabled,
        AutoFarm = Config.AutoFarm,
        AutoStats = Config.AutoStats,
        Stat1 = Config.Stat1,
        Stat2 = Config.Stat2,
        AutoHaki = Config.AutoHaki
    }
    writefile(GetConfigFilename(), HttpService:JSONEncode(dataToSave))
end

local function LoadConfig()
    if not readfile or not isfile(GetConfigFilename()) then return end
    local success, result = pcall(function()
        local jsonData = readfile(GetConfigFilename())
        local savedData = HttpService:JSONDecode(jsonData)
        
        local encryptedToken = HttpService:Base64Decode(savedData.TelegramToken or "")
        local encryptedChatID = HttpService:Base64Decode(savedData.TelegramChatID or "")
        
        Config.TelegramToken = XORDecrypt(encryptedToken, "KL_SECURE_KEY")
        Config.TelegramChatID = XORDecrypt(encryptedChatID, "KL_SECURE_KEY")
        Config.Enabled = savedData.Enabled
        Config.AutoFarm = savedData.AutoFarm
        Config.AutoStats = savedData.AutoStats
        Config.Stat1 = savedData.Stat1 or "Melee"
        Config.Stat2 = savedData.Stat2 or "Defense"
        Config.AutoHaki = savedData.AutoHaki
    end)
end

LoadConfig()

-- ===============================================
-- 🎮 GAME DATA
-- ===============================================

local PlaStat = player:WaitForChild("PlayerStats", 10)
local PlaLevel = PlaStat:WaitForChild("lvl", 10)
local Points = PlaStat:WaitForChild("Points", 10)
local DefenseStat = PlaStat:WaitForChild("Defense", 10)
local MeleeStat = PlaStat:WaitForChild("Melee", 10)
local SwordStat = PlaStat:WaitForChild("sword", 10)
local Backpack = player:WaitForChild("Backpack")

local RemoteQuest, RemoteSkill, RemoteArmament, RemoteMoveCooldown

pcall(function()
    RemoteQuest = ReplicatedStorage:WaitForChild("Chest", 5):WaitForChild("Remotes", 5):WaitForChild("Functions", 5):WaitForChild("Quest", 5)
    RemoteSkill = ReplicatedStorage:WaitForChild("Chest", 5):WaitForChild("Remotes", 5):WaitForChild("Functions", 5):WaitForChild("SkillAction", 5)
    RemoteArmament = ReplicatedStorage:WaitForChild("Chest", 5):WaitForChild("Remotes", 5):WaitForChild("Events", 5):WaitForChild("Armament", 5)
    RemoteMoveCooldown = ReplicatedStorage:WaitForChild("Chest", 5):WaitForChild("Remotes", 5):WaitForChild("Bindables", 5):WaitForChild("MoveCooldown", 5)
end)

-- ===============================================
-- 🔧 VARIABLES
-- ===============================================

local farmStartTime = tick()
local lastNotifiedQuest = ""
local lastMilestoneLevel = 0
local currentStats = {melee = 0, sword = 0, defense = 0}
local lastMessageTime = 0
local MESSAGE_COOLDOWN = 3
local teleportConnection
local currentTarget = nil
local currentQuest = nil
local lastQuestCheck = 0
local lastMobSearch = 0
local lastAttack = 0
local hasTelepotedToIsland = false
local currentSword = nil
local lastWeaponCheck = 0
local WEAPON_CHECK_INTERVAL = 2
local isArmamentActive = false
local lastSkillZ = 0
local lastSkillX = 0
local SKILL_COOLDOWNS = {Z = 2, X = 4}
local QUEST_CHECK_INTERVAL = 3
local MOB_SEARCH_INTERVAL = 0.1
local ATTACK_INTERVAL = 0.01
local char = player.Character or player.CharacterAdded:Wait()

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ===============================================
-- 🗺️ QUESTS (FULL LIST - NO CUTS)
-- ===============================================

local QuestConfig = {
    [1] = {minLevel = 1, maxLevel = 9, questName = "Kill 4 Soldiers", mobName = "Soldier [Lv. 1]", mobFolder = workspace.Monster.Mon, islandPosition = CFrame.new(-2111, 49, -4561), displayName = "Soldiers (1-9)"},
    [2] = {minLevel = 10, maxLevel = 19, questName = "Kill 5 Clown Pirates", mobName = "Clown Pirate [Lv. 10]", mobFolder = workspace.Monster.Mon, islandPosition = CFrame.new(-2111, 49, -4561), displayName = "Clown Pirates (10-19)"},
    [3] = {minLevel = 20, maxLevel = 29, questName = "Kill 1 Smoky", mobName = "Smoky [Lv. 20]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2111, 49, -4561), displayName = "Smoky Boss (20-29)"},
    [4] = {minLevel = 30, maxLevel = 49, questName = "Kill 1 Tashi", mobName = "Tashi [Lv. 30]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2111, 49, -4561), displayName = "Tashi Boss (30-49)"},
    [5] = {minLevel = 50, maxLevel = 74, questName = "Kill 6 Clown Swordman", mobName = "Clown Swordman [Lv. 50]", mobFolder = workspace.Monster.Mon, islandPosition = CFrame.new(-714, 88, -3505), displayName = "Clown Swordman (50-74)"},
    [6] = {minLevel = 75, maxLevel = 99, questName = "Kill 1 The Clown", mobName = "The Clown [Lv. 75]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-714, 88, -3505), displayName = "The Clown (75-99)"},
    [7] = {minLevel = 100, maxLevel = 119, questName = "Kill 4 Commander", mobName = "Commander [Lv. 100]", mobFolder = workspace.Monster.Mon, islandPosition = CFrame.new(-2283, 95, -2560), displayName = "Commander (100-119)"},
    [8] = {minLevel = 120, maxLevel = 144, questName = "Kill 1 Captain", mobName = "Captain [Lv. 120]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2283, 95, -2560), displayName = "Captain (120-144)"},
    [9] = {minLevel = 145, maxLevel = 179, questName = "Kill 1 The Barbaric", mobName = "The Barbaric [Lv. 145]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2283, 95, -2560), displayName = "The Barbaric (145-179)"},
    [10] = {minLevel = 180, maxLevel = 199, questName = "Kill 4 Fighter Fishmans", mobName = "Fighter Fishman [Lv. 180]", mobFolder = workspace.Monster.Mon, islandPosition = CFrame.new(-745, 52, -1494), displayName = "Fighter Fishman (180-199)"},
    [11] = {minLevel = 200, maxLevel = 229, questName = "Kill 1 Karate Fishman", mobName = "Karate Fishman [Lv. 200]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-745, 52, -1494), displayName = "Karate Fishman (200-229)"},
    [12] = {minLevel = 230, maxLevel = 249, questName = "Kill 1 Shark Man", mobName = "Shark Man [Lv. 230]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-745, 52, -1494), displayName = "Shark Man (230-249)"},
    [13] = {minLevel = 250, maxLevel = 299, questName = "Kill 4 Trainer Chef", mobName = "Trainer Chef [Lv. 250]", mobFolder = workspace.Monster.Mon, islandPosition = CFrame.new(-4137, 70, -3048), displayName = "Trainer Chef (250-299)"},
    [14] = {minLevel = 300, maxLevel = 349, questName = "Kill 1 Dark Leg", mobName = "Dark Leg [Lv. 300]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-4137, 70, -3048), displayName = "Dark Leg (300-349)"},
    [15] = {minLevel = 350, maxLevel = 399, questName = "Kill 1 Dory", mobName = "Dory [Lv. 350]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-4308, 70, -2732), displayName = "Dory (350-399)"},
    [16] = {minLevel = 400, maxLevel = 449, questName = "Kill 5 Snow Soldier", mobName = "Snow Soldier [Lv. 400]", mobFolder = workspace.Monster.Mon, islandPosition = CFrame.new(-5442, 63, -1275), displayName = "Snow Soldier (400-449)"},
    [17] = {minLevel = 450, maxLevel = 524, questName = "Kill 1 King Snow", mobName = "King Snow [Lv. 450]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-5442, 63, -1275), displayName = "King Snow (450-524)"},
    [18] = {minLevel = 525, maxLevel = 624, questName = "Kill 1 Candle Man", mobName = "Candle Man [Lv. 525]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2923, 97, -631), displayName = "Candle Man (525-624)"},
    [19] = {minLevel = 625, maxLevel = 724, questName = "Kill 1 Bomb Man", mobName = "Bomb Man [Lv. 625]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2923, 97, -631), displayName = "Bomb Man (625-724)"},
    [20] = {minLevel = 725, maxLevel = 849, questName = "Kill 1 King of Sand", mobName = "King of Sand [Lv. 725]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2923, 97, -631), displayName = "King of Sand (725-849)"},
    [21] = {minLevel = 850, maxLevel = 949, questName = "Kill 1 Ball Man", mobName = "Ball Man [Lv. 850]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-4596, 504, 1444), displayName = "Ball Man (850)"},
    [22] = {minLevel = 950, maxLevel = 1099, questName = "Kill 1 Rumble Man", mobName = "Rumble Man [Lv. 950]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-4596, 504, 1444), displayName = "Rumble Man (950-1099)"},
    [23] = {minLevel = 1100, maxLevel = 1149, questName = "Kill 1 Leader", mobName = "Leader [Lv. 1100]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(1803, 51, 761), displayName = "Leader (1100-1149)"},
    [24] = {minLevel = 1150, maxLevel = 1249, questName = "Kill 1 Pasta", mobName = "Pasta [Lv. 1150]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(1803, 51, 761), displayName = "Pasta (1150-1249)"},
    [25] = {minLevel = 1250, maxLevel = 1299, questName = "Kill 1 Wolf", mobName = "Wolf [Lv. 1250]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-1301, 69, 2068), displayName = "Wolf (1250)"},
    [26] = {minLevel = 1300, maxLevel = 1449, questName = "Kill 1 Giraffe", mobName = "Giraffe [Lv. 1300]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-1185, 69, 2055), displayName = "Giraffe (1300)"},
    [27] = {minLevel = 1450, maxLevel = 1649, questName = "Kill 1 Leo", mobName = "Leo [Lv. 1450]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-1074, 22, 2563), displayName = "Leo (1450)"},
    [28] = {minLevel = 1650, maxLevel = 1849, questName = "Kill 1 Shadow Master", mobName = "Shadow Master [Lv. 1650]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2774, 33, 4439), displayName = "Shadow Master (1650)"},
    [29] = {minLevel = 1850, maxLevel = 1924, questName = "Kill 1 True Karate Fishman", mobName = "True Karate Fishman [Lv. 1850]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(2408, 71, -1936), displayName = "True Karate Fishman (1850)"},
    [30] = {minLevel = 1925, maxLevel = 2049, questName = "Kill 1 Quake Woman", mobName = "Quake Woman [Lv. 1925]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-2016, 79, 6098), displayName = "Quake Woman (1925)"},
    [31] = {minLevel = 2050, maxLevel = 2099, questName = "Kill 1 Combat Fishman", mobName = "Combat Fishman [Lv. 2050]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-1456, 74, 6804), displayName = "Combat Fishman (2050)"},
    [32] = {minLevel = 2100, maxLevel = 2199, questName = "Kill 1 Sword Fishman", mobName = "Sword Fishman [Lv. 2100]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-1806, 109, 6560), displayName = "Sword Fishman (2100)"},
    [33] = {minLevel = 2200, maxLevel = 9999, questName = "Kill 1 Seasoned Fishman", mobName = "Seasoned Fishman [Lv. 2200]", mobFolder = workspace.Monster.Boss, islandPosition = CFrame.new(-1806, 109, 6560), displayName = "Seasoned Fishman (2200+)"}
}

-- ===============================================
-- 📱 TELEGRAM
-- ===============================================

local function SendTelegramNotification(message)
    if not Config.Enabled or Config.TelegramToken == "" or Config.TelegramChatID == "" then
        return false
    end
    
    local currentTime = tick()
    if currentTime - lastMessageTime < MESSAGE_COOLDOWN then
        return false
    end
    lastMessageTime = currentTime
    
    local url = string.format("https://api.telegram.org/bot%s/sendMessage", Config.TelegramToken)
    local data = {chat_id = Config.TelegramChatID, text = message, parse_mode = "Markdown"}
    
    pcall(function()
        if request then
            request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
        elseif http_request then
            http_request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
        elseif syn and syn.request then
            syn.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
        end
    end)
    
    return true
end

-- ===============================================
-- ⚔️ WEAPON
-- ===============================================

local function IsSword(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return tool:FindFirstChild("EquipServer") ~= nil
end

local function FindSwordInInventory()
    local character = player.Character
    if not character then return nil end
    
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") and item.Name ~= "None" and IsSword(item) then
            return item.Name
        end
    end
    
    for _, item in pairs(Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name ~= "None" and IsSword(item) then
            return item.Name
        end
    end
    
    return nil
end

local function EquipSword()
    if not currentSword then return false end
    
    local character = player.Character
    if not character then return false end
    
    if character:FindFirstChild(currentSword) then return true end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") and not IsSword(tool) then
            pcall(function() tool.Parent = Backpack end)
        end
    end
    
    local sword = Backpack:FindFirstChild(currentSword)
    if sword and IsSword(sword) then
        pcall(function() humanoid:EquipTool(sword) end)
        return true
    end
    
    return false
end

local function UpdateCurrentSword()
    local currentTime = tick()
    if currentTime - lastWeaponCheck < WEAPON_CHECK_INTERVAL then return end
    
    lastWeaponCheck = currentTime
    
    local foundSword = FindSwordInInventory()
    
    if foundSword and foundSword ~= currentSword then
        currentSword = foundSword
        EquipSword()
    elseif not foundSword and currentSword then
        currentSword = nil
    end
end

-- ===============================================
-- 🎯 QUEST FUNCTIONS
-- ===============================================

local function GetQuestByLevel(level)
    for _, questData in pairs(QuestConfig) do
        if level >= questData.minLevel and level <= questData.maxLevel then
            return questData
        end
    end
    return QuestConfig[#QuestConfig]
end

local function TeleportToIsland(questData)
    if not questData or not questData.islandPosition then return false end
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    pcall(function()
        char.HumanoidRootPart.CFrame = questData.islandPosition
    end)
    
    task.wait(1)
    return true
end

local function TakeQuest(questData)
    if not questData then return false end
    
    local success = pcall(function()
        RemoteQuest:InvokeServer("take", questData.questName)
    end)
    
    if success then
        if not currentQuest or currentQuest.questName ~= questData.questName then
            currentQuest = questData
        else
            currentQuest = questData
        end
        return true
    end
    
    return false
end

local function FindNearestMob(mobFolder, mobName)
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local nearestMob = nil
    local shortestDistance = math.huge
    local playerPos = char.HumanoidRootPart.Position
    
    for _, mob in pairs(mobFolder:GetChildren()) do
        if mob.Name == mobName then
            local mobHumanoid = mob:FindFirstChild("Humanoid")
            local mobHead = mob:FindFirstChild("Head")
            
            if mobHumanoid and mobHead and mobHumanoid.Health > 0 then
                local distance = (mobHead.Position - playerPos).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestMob = mob
                end
            end
        end
    end
    
    return nearestMob
end

-- ===============================================
-- 💥 COMBAT
-- ===============================================

local function UseArmament()
    if isArmamentActive then return end
    
    pcall(function()
        RemoteArmament:FireServer()
    end)
    
    isArmamentActive = true
end

local function AttackTarget()
    local currentTime = tick()
    if currentTime - lastAttack < ATTACK_INTERVAL then return end
    
    lastAttack = currentTime
    
    if not currentTarget or not currentTarget.Parent then return end
    
    local targetHRP = currentTarget:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    local targetPosition = targetHRP.CFrame
    
    task.spawn(function()
        pcall(function()
            RemoteSkill:InvokeServer("FS_None_M1")
        end)
    end)
    
    if currentSword then
        local character = player.Character
        if character and character:FindFirstChild(currentSword) then
            task.spawn(function()
                pcall(function()
                    RemoteSkill:InvokeServer("SW_" .. currentSword .. "_M1")
                end)
            end)
            
            if currentTime - lastSkillZ >= SKILL_COOLDOWNS.Z then
                lastSkillZ = currentTime
                
                task.spawn(function()
                    pcall(function()
                        RemoteSkill:InvokeServer("SW_" .. currentSword .. "_Z", {Type = "Down", MouseHit = targetPosition})
                        RemoteSkill:InvokeServer("SW_" .. currentSword .. "_Z", {Type = "Up", MouseHit = targetPosition})
                        RemoteMoveCooldown:Fire("SW", "Z", SKILL_COOLDOWNS.Z)
                    end)
                end)
            end
            
            if currentTime - lastSkillX >= SKILL_COOLDOWNS.X then
                lastSkillX = currentTime
                
                task.spawn(function()
                    pcall(function()
                        RemoteSkill:InvokeServer("SW_" .. currentSword .. "_X", {Type = "Down", MouseHit = targetPosition})
                        RemoteSkill:InvokeServer("SW_" .. currentSword .. "_X", {Type = "Up", MouseHit = targetPosition})
                        RemoteMoveCooldown:Fire("SW", "X", SKILL_COOLDOWNS.X)
                    end)
                end)
            end
        else
            EquipSword()
        end
    end
end

-- ===============================================
-- 🔄 MAIN LOOP (EXACT COPY FROM ABRAM.TXT)
-- ===============================================

local function StartTeleportLoop()
    if teleportConnection then
        teleportConnection:Disconnect()
    end
    
    teleportConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoFarm then return end
        
        if not currentTarget or not currentTarget.Parent then return end
        
        local mobHead = currentTarget:FindFirstChild("Head")
        if not mobHead then
            currentTarget = nil
            return
        end
        
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local mobHumanoid = currentTarget:FindFirstChild("Humanoid")
        if not mobHumanoid or mobHumanoid.Health <= 0 then
            currentTarget = nil
            return
        end
        
        pcall(function()
            local abovePosition = mobHead.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(270), 0, 0)
            char.HumanoidRootPart.CFrame = abovePosition
        end)
    end)
end

local function MainFarmLoop()
    while true do
        if Config.AutoFarm then
            local currentTime = tick()
            
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                task.wait(1)
            else
                UpdateCurrentSword()
                
                -- Auto Haki Logic
                if Config.AutoHaki and not isArmamentActive then
                    UseArmament()
                end
                
                if not hasTelepotedToIsland and currentQuest then
                    TeleportToIsland(currentQuest)
                    hasTelepotedToIsland = true
                end
                
                if currentTime - lastQuestCheck >= QUEST_CHECK_INTERVAL then
                    lastQuestCheck = currentTime
                    
                    local questData = GetQuestByLevel(PlaLevel.Value)
                    if questData then
                        if currentQuest and questData.questName ~= currentQuest.questName then
                            hasTelepotedToIsland = false
                            currentTarget = nil
                        end
                        
                        TakeQuest(questData)
                    end
                end
                
                if currentTarget then
                    local mobHumanoid = currentTarget:FindFirstChild("Humanoid")
                    
                    if not mobHumanoid or mobHumanoid.Health <= 0 or not currentTarget.Parent then
                        currentTarget = nil
                    end
                end
                
                if not currentTarget and currentQuest and currentTime - lastMobSearch >= MOB_SEARCH_INTERVAL then
                    lastMobSearch = currentTime
                    currentTarget = FindNearestMob(currentQuest.mobFolder, currentQuest.mobName)
                end
                
                if currentTarget then
                    AttackTarget()
                else
                    if currentQuest and currentQuest.islandPosition and char and char:FindFirstChild("HumanoidRootPart") then
                        pcall(function()
                            char.HumanoidRootPart.CFrame = currentQuest.islandPosition
                        end)
                    end
                end
            end
        end
        task.wait(0.01)
    end
end

-- ===============================================
-- 📊 AUTO STATS (SPLIT LOGIC)
-- ===============================================

task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.AutoStats and Points.Value > 0 then
            local stat1 = Config.Stat1
            local stat2 = Config.Stat2
            local pts = Points.Value
            local remote = player.PlayerGui.MainGui.StarterFrame.StatsFrame.RemoteEvent

            pcall(function()
                if stat1 == stat2 then
                    -- 100% to one stat
                    remote:FireServer(stat1, pts)
                else
                    -- 50/50 split
                    local half = math.floor(pts / 2)
                    if half > 0 then
                        remote:FireServer(stat1, half)
                        remote:FireServer(stat2, pts - half)
                    end
                end
            end)
        end
    end
end)

-- ===============================================
-- 🖥️ UI SETUP
-- ===============================================

local Window = Library:CreateWindow("<font color=\"#FF0000\">abramUI</font>", "King Legacy")
local MainTab = Window:CreatePage("Main")
local StatsTab = Window:CreatePage("Auto Stats")
local TelegramTab = Window:CreatePage("Telegram")

-- Main Tab
local MainSection = MainTab:CreateSection("Farming")

MainSection:CreateToggle("Auto Farm", {Toggled = Config.AutoFarm, Description = "Starts farming quests"}, function(val)
    Config.AutoFarm = val
    if val then
        SendTelegramNotification("👑 *FARM STARTED* 👑\nPlayer: " .. player.Name)
    else
        currentTarget = nil
    end
end)

MainSection:CreateToggle("Auto Haki", {Toggled = Config.AutoHaki, Description = "Automatically enables Haki"}, function(val)
    Config.AutoHaki = val
end)

local QuestLabel = MainSection:CreateLabel("Quest: None")

-- Auto Stats Tab
local StatsSection = StatsTab:CreateSection("Upgrade Settings")

StatsSection:CreateDropdown("Stat Priority 1", {List = {"Melee", "Defense", "Sword", "Fruit"}, Default = Config.Stat1}, function(val)
    Config.Stat1 = val
end)

StatsSection:CreateDropdown("Stat Priority 2", {List = {"Melee", "Defense", "Sword", "Fruit"}, Default = Config.Stat2}, function(val)
    Config.Stat2 = val
end)

StatsSection:CreateToggle("Enable Auto Stats", {Toggled = Config.AutoStats, Description = "Splits points between selected stats"}, function(val)
    Config.AutoStats = val
end)

-- Telegram Tab
local TelegramSection = TelegramTab:CreateSection("Telegram Setup")

TelegramSection:CreateTextbox("Bot Token", "Enter Bot Token", function(val)
    Config.TelegramToken = val
    SaveConfig()
end, Config.TelegramToken)

TelegramSection:CreateTextbox("Chat ID", "Enter Chat ID", function(val)
    Config.TelegramChatID = val
    SaveConfig()
end, Config.TelegramChatID)

TelegramSection:CreateToggle("Enable Notifications", {Toggled = Config.Enabled, Description = "Send messages to Telegram"}, function(val)
    Config.Enabled = val
    SaveConfig()
end)

TelegramSection:CreateButton("Test Notification", function()
    local res = SendTelegramNotification("✅ Test Message from abramUI!")
    if res then
        Library:AddNoti("Success", "Message Sent!", 3, true)
    else
        Library:AddNoti("Error", "Check Token/ID!", 3, true)
    end
end)

TelegramSection:CreateButton("Save Config", function()
    SaveConfig()
    Library:AddNoti("Config", "Saved Successfully!", 3, true)
end)

-- UI Updater
task.spawn(function()
    while true do
        task.wait(1)
        if currentQuest then
            QuestLabel.Text = " Quest: " .. currentQuest.questName .. " (Lvl: " .. PlaLevel.Value .. ")"
        else
            QuestLabel.Text = " Quest: Searching... (Lvl: " .. PlaLevel.Value .. ")"
        end
    end
end)

-- Start
StartTeleportLoop()
task.spawn(MainFarmLoop)
