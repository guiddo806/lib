local inputService = game:GetService('UserInputService')
local renderService = game:GetService('RunService')
local tweenService = game:GetService('TweenService')
local guiService = game:GetService('GuiService')

local tween
do
    local styleEnum = Enum.EasingStyle
    local dirEnum = Enum.EasingDirection
    
    local direction = dirEnum.Out
    local styles = {styleEnum.Exponential, styleEnum.Linear}
    
    function tween(object, shit, duration, style) 
        local tweenInfo = TweenInfo.new(duration, styles[style], direction)
        local tween = tweenService:Create(object, tweenInfo, shit)
        tween:Play()
        return tween 
    end
end

local args = {...}
local theme
local rounding
local animSpeed = 1e-12

-- theme 
do
    if (#args > 0 and typeof(args[1]) == 'table') then
        local settings = args[1]
        theme = settings.theme
        rounding = settings.rounding
        if (settings.smoothDragging == nil) then 
            settings.smoothDragging = true 
        end
        animSpeed = settings.smoothDragging and 1e-12 or 0
        if (typeof(theme) == 'string') then
            if (theme == 'cherry') then          -- red
                theme = {
                    Primary = Color3.fromRGB(249, 22, 52);
                    Secondary = Color3.fromRGB(247, 22, 149);
                    
                    Window1 = Color3.fromRGB(11, 11, 11);
                    Window2 = Color3.fromRGB(5, 5, 5);
                    Window3 = Color3.fromRGB(8, 8, 8);
                    
                    Button1 = Color3.fromRGB(12, 12, 12);
                    Button2 = Color3.fromRGB(15, 15, 15);
                    Button3 = Color3.fromRGB(21, 21, 21);
                    Button4 = Color3.fromRGB(24, 24, 24);
                    
                    Stroke = Color3.fromRGB(30, 30, 30);
                    StrokeHover = Color3.fromRGB(83, 23, 31);
                    
                    Inset1 = Color3.fromRGB(3, 3, 3);
                    Inset2 = Color3.fromRGB(1, 1, 1);
                    Inset3 = Color3.fromRGB(2, 2, 2);
                    
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(164, 164, 164);
                    
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(200, 200, 200);
                }
            elseif (theme == 'orange') then      -- orange
                theme = {
                    Primary = Color3.fromRGB(244, 148, 22);
                    Secondary = Color3.fromRGB(247, 37, 22);
                    
                    Window1 = Color3.fromRGB(20, 20, 22);
                    Window2 = Color3.fromRGB(10, 10, 12);
                    Window3 = Color3.fromRGB(15, 15, 17);
                    
                    Button1 = Color3.fromRGB(18, 18, 20);
                    Button2 = Color3.fromRGB(20, 20, 22);
                    Button3 = Color3.fromRGB(28, 28, 30);
                    Button4 = Color3.fromRGB(30, 30, 32);
                    
                    Stroke = Color3.fromRGB(60, 60, 60);
                    StrokeHover = Color3.fromRGB(110, 110, 110);
                    
                    Inset1 = Color3.fromRGB(10, 10, 12);
                    Inset2 = Color3.fromRGB(0, 0, 2);
                    Inset3 = Color3.fromRGB(5, 5, 7);
                    
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'lemon') then       -- yellow
                theme = {
                    Primary = Color3.fromRGB(220, 255, 66);
                    Secondary = Color3.fromRGB(232, 173, 25);
                    
                    Window1 = Color3.fromRGB(30, 30, 30);
                    Window2 = Color3.fromRGB(20, 20, 20);
                    Window3 = Color3.fromRGB(25, 25, 25);
                    
                    Button1 = Color3.fromRGB(35, 35, 35);
                    Button2 = Color3.fromRGB(40, 40, 40);
                    Button3 = Color3.fromRGB(50, 50, 50);
                    Button4 = Color3.fromRGB(55, 55, 55);
                    
                    Stroke = Color3.fromRGB(55, 55, 55);
                    StrokeHover = Color3.fromRGB(80, 80, 80);
                    
                    Inset1 = Color3.fromRGB(18, 18, 18);
                    Inset2 = Color3.fromRGB(8, 8, 8);
                    Inset3 = Color3.fromRGB(13, 13, 13);
                    
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'lime') then        -- green
                theme = {
                    Primary = Color3.fromRGB(33, 255, 120);
                    Secondary = Color3.fromRGB(120, 255, 33);
                    
                    Window1 = Color3.fromRGB(30, 30, 32);
                    Window2 = Color3.fromRGB(24, 24, 26);
                    Window3 = Color3.fromRGB(28, 28, 30);
                    
                    Button1 = Color3.fromRGB(36, 36, 38);
                    Button2 = Color3.fromRGB(40, 40, 42);
                    Button3 = Color3.fromRGB(46, 46, 48);
                    Button4 = Color3.fromRGB(50, 50, 52);
                    
                    Stroke = Color3.fromRGB(60, 60, 60);
                    StrokeHover = Color3.fromRGB(110, 110, 110);
                    
                    Inset1 = Color3.fromRGB(20, 20, 22);
                    Inset2 = Color3.fromRGB(14, 14, 16);
                    Inset3 = Color3.fromRGB(18, 18, 20);
                    
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'raspberry') then   -- cyan
                theme = {
                    Primary = Color3.fromRGB(0, 190, 255);
                    Secondary = Color3.fromRGB(0, 255, 190);
                    
                    Window1 = Color3.fromRGB(25, 25, 27);
                    Window2 = Color3.fromRGB(19, 19, 21);
                    Window3 = Color3.fromRGB(23, 23, 25);
                    
                    Button1 = Color3.fromRGB(24, 24, 26);
                    Button2 = Color3.fromRGB(28, 28, 30);
                    Button3 = Color3.fromRGB(34, 40, 42);
                    Button4 = Color3.fromRGB(38, 44, 46);
                    
                    Stroke = Color3.fromRGB(60, 60, 60);
                    StrokeHover = Color3.fromRGB(110, 110, 110);
                    
                    Inset1 = Color3.fromRGB(20, 20, 22);
                    Inset2 = Color3.fromRGB(14, 14, 16);
                    Inset3 = Color3.fromRGB(18, 18, 20);
                    
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'blueberry') then   -- blue
                theme = {
                    Primary = Color3.fromRGB(91, 77, 249);
                    Secondary = Color3.fromRGB(130, 76, 247);
                    
                    Window1 = Color3.fromRGB(20, 20, 23);
                    Window2 = Color3.fromRGB(12, 12, 15);
                    Window3 = Color3.fromRGB(15, 15, 18);
                    
                    Button1 = Color3.fromRGB(18, 18, 21);
                    Button2 = Color3.fromRGB(21, 21, 24);
                    Button3 = Color3.fromRGB(38, 38, 41);
                    Button4 = Color3.fromRGB(41, 41, 44);
                    
                    Stroke = Color3.fromRGB(50, 50, 53);
                    StrokeHover = Color3.fromRGB(60, 60, 63);
                    
                    Inset1 = Color3.fromRGB(15, 15, 18);
                    Inset2 = Color3.fromRGB(7, 7, 10);
                    Inset3 = Color3.fromRGB(13, 13, 16);
                    
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(168, 168, 168);
                    
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'grape') then       -- purple
                theme = {
                    Primary = Color3.fromRGB(134, 53, 255);
                    Secondary = Color3.fromRGB(211, 53, 255);
                    
                    Window1 = Color3.fromRGB(20, 20, 20);
                    Window2 = Color3.fromRGB(10, 10, 10);
                    Window3 = Color3.fromRGB(15, 15, 15);
                    
                    Button1 = Color3.fromRGB(15, 15, 15);
                    Button2 = Color3.fromRGB(20, 20, 20);
                    Button3 = Color3.fromRGB(35, 35, 35);
                    Button4 = Color3.fromRGB(40, 40, 40);
                    
                    Stroke = Color3.fromRGB(34, 34, 34);
                    StrokeHover = Color3.fromRGB(89, 49, 150);
                    
                    Inset1 = Color3.fromRGB(5, 5, 5);
                    Inset2 = Color3.fromRGB(0, 0, 0);
                    Inset3 = Color3.fromRGB(3, 3, 3);
                    
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(74, 42, 122);
                    
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'watermelon') then  -- legacy red-aqua
                theme = nil
            end
        end
    end
    
    if (rounding == nil) then
        rounding = true 
    end
    if (typeof(theme) ~= 'table') then
        theme = {
            Primary = Color3.fromRGB(38, 233, 195); -- primary accent
            Secondary = Color3.fromRGB(233, 38, 115); -- secondary accent
            
            Window1 = Color3.fromRGB(30, 30, 35); -- window headers (the tool bar w/ title and min/max buttons)
            Window2 = Color3.fromRGB(20, 20, 25); -- window background
            Window3 = Color3.fromRGB(25, 25, 30); -- sidebar, section header, tooltip header
            
            Button1 = Color3.fromRGB(35, 35, 40); -- idle disabled button
            Button2 = Color3.fromRGB(45, 45, 50); -- disabled button focused
            Button3 = Color3.fromRGB(65, 65, 70); -- idle enabled button
            Button4 = Color3.fromRGB(75, 75, 80); -- enabled button focused
            
            Stroke = Color3.fromRGB(50, 50, 55); -- stroke for everything
            StrokeHover = Color3.fromRGB(70, 70, 75); -- stroke for everything
            
            Inset1 = Color3.fromRGB(20, 20, 25); -- inner stroke of Window1
            Inset2 = Color3.fromRGB(10, 10, 15); -- inner stroke of Window2
            Inset3 = Color3.fromRGB(15, 15, 20); -- inner stroke of Window3
            
            TextPrimary = Color3.fromRGB(255, 255, 255); -- primary text color
            TextStroke = Color3.fromRGB(0, 0, 0); -- text stroke
            TextDim = Color3.fromRGB(164, 164, 164); -- dim text color
            
            ControlGradient1 = Color3.fromRGB(255, 255, 255); -- top color for extra gradient effects
            ControlGradient2 = Color3.fromRGB(192, 192, 192); -- bottom color for extra gradient effects
        }
    end
end

-- screen gui 
local uiScreen = Instance.new('ScreenGui') do 
    uiScreen.OnTopOfCoreBlur = true
    uiScreen.DisplayOrder = 9e9
    uiScreen.ZIndexBehavior = 'Global'
    
    local str = ''
    for i = 1, 8 do
        str = str .. utf8.char(math.random(97, 2500))
    end
    uiScreen.Name = str
    str = nil 
    
    if (typeof(syn) == 'table' and typeof(syn.protect_gui) == 'function') then
        --syn.protect_gui(uiScreen)
    end
    if (gethui) then
        uiScreen.Parent = gethui()
    else
        uiScreen.Parent = game:GetService('CoreGui')
    end
end

local defaultWinPos = UDim2.fromScale(0.6, 0.6)

local ui = {}

-- classes
local elemClasses = {} 
do 
    -- GLOBAL
    do 
        local baseElement = {} do 
            baseElement.__index = baseElement
            baseElement.bindToEvent = function(self, event, callback) 
                self.binds[event] = callback
                return self
            end
            baseElement.fireEvent = function(self, event, ...) 
                local t = self.binds[event]
                if (t) then task.spawn(t, ...) end
                return self
            end
            
            baseElement.name = '' 
        end
        elemClasses.baseElement = baseElement
    end
    -- WINDOW
    do
        local window = {} do 
            window.__index = window
            setmetatable(window, elemClasses.baseElement)
            
            window.class = 'window'
            
            window.minimized = false
            window.size = UDim2.fromOffset(450, 350)
            window.minFocused = false
            
            local instances = {} do 
                local mainFrame = Instance.new('Frame') do 
                    mainFrame.BackgroundColor3 = theme.Window2
                    mainFrame.BackgroundTransparency = 0
                    mainFrame.BorderSizePixel = 0
                    mainFrame.Name = '#main_frame'
                    mainFrame.Position = UDim2.fromScale(0.6, 0.6)
                    mainFrame.Size = UDim2.fromOffset(500, 350)
                    mainFrame.Visible = true
                    mainFrame.ZIndex = 5 
                end
                
                local scale = Instance.new('UIScale') do 
                    scale.Scale = 1 
                    scale.Name = '#scale'
                    scale.Parent = mainFrame
                end
                
                local stroke = Instance.new('UIStroke') do 
                    stroke.ApplyStrokeMode = 'Border'
                    stroke.Color = theme.Stroke
                    stroke.LineJoinMode = 'Round'
                    stroke.Thickness = 1 
                    stroke.Name = '#stroke'
                    stroke.Parent = mainFrame
                end
                local shadow = Instance.new('ImageLabel') do 
                    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
                    shadow.BackgroundTransparency = 1
                    shadow.BorderSizePixel = 0 
                    shadow.Image = 'rbxassetid://7331400934'
                    shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
                    shadow.Name = '#shadow'
                    shadow.Position = UDim2.fromScale(0.5, 0.5)
                    shadow.ScaleType = 'Slice'
                    shadow.Size = UDim2.new(1, 50, 1, 50)
                    shadow.SliceCenter = Rect.new(40, 40, 260, 260)
                    shadow.SliceScale = 1
                    shadow.ZIndex = 4
                    shadow.Parent = mainFrame
                end
                local trimLine = Instance.new('Frame') do 
                    trimLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    trimLine.BackgroundTransparency = 0
                    trimLine.BorderSizePixel = 0 
                    trimLine.Name = '#trim'
                    trimLine.Position = UDim2.fromOffset(0, -1)
                    trimLine.Size = UDim2.new(1, 0, 0, 1)
                    trimLine.ZIndex = 64
                    trimLine.Parent = mainFrame
                    
                    local gradient = Instance.new('UIGradient') do 
                        gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
                        gradient.Enabled = true
                        gradient.Name = '#gradient'
                        gradient.Rotation = 0
                        gradient.Parent = trimLine
                    end
                end
                local titleBar = Instance.new('Frame') do 
                    titleBar.Active = true
                    titleBar.BackgroundColor3 = theme.Window1
                    titleBar.BackgroundTransparency = 0
                    titleBar.BorderColor3 = theme.Inset1
                    titleBar.BorderMode = 'Inset'
                    titleBar.BorderSizePixel = 1
                    titleBar.ClipsDescendants = true
                    titleBar.Name = '#title-bar'
                    titleBar.Selectable = true
                    titleBar.Size = UDim2.new(1, 0, 0, 26)
                    titleBar.ZIndex = 50
                    titleBar.Parent = mainFrame 
                    
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Thickness = 1 
                        stroke.Name = '#stroke'
                        stroke.Parent = titleBar
                    end
                    
                    local fade = Instance.new('Frame') do 
                        fade.BackgroundColor3 = theme.Window1
                        fade.BackgroundTransparency = 1
                        fade.BorderColor3 = theme.Inset1
                        fade.BorderMode = 'Inset'
                        fade.BorderSizePixel = 1
                        fade.Name = '#fade'
                        fade.Size = UDim2.new(1, 4, 1, 4)
                        fade.Position = UDim2.fromOffset(-2, -2)
                        fade.Visible = false
                        fade.ZIndex = 60
                        fade.Parent = titleBar
                    end
                    
                    local buttonClose = Instance.new('TextButton') do 
                        buttonClose.AnchorPoint = Vector2.new(1, 0)
                        buttonClose.AutoButtonColor = false
                        buttonClose.BackgroundColor3 = theme.Button1
                        buttonClose.BorderSizePixel = 0
                        buttonClose.Name = '#button-close'
                        buttonClose.Position = UDim2.new(1, -3, 0, 2)
                        buttonClose.Size = UDim2.fromOffset(20, 20)
                        buttonClose.Visible = true
                        buttonClose.ZIndex = 52 
                        buttonClose.Text = ''
                        buttonClose.Parent = titleBar
                        
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = buttonClose
                        end
                        
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = buttonClose
                        end
                        
                        local icon = Instance.new('ImageLabel') do 
                            icon.Active = false
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Image = 'rbxassetid://9801460300'
                            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(0, 0)
                            icon.Size = UDim2.fromScale(1, 1)
                            icon.Visible = true
                            icon.ZIndex = 52 
                            icon.Parent = buttonClose
                            
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = icon
                            end
                        end
                    end
                    
                    local buttonMin = Instance.new('TextButton') do 
                        buttonMin.AnchorPoint = Vector2.new(1, 0)
                        buttonMin.AutoButtonColor = false
                        buttonMin.BackgroundColor3 = theme.Button1
                        buttonMin.BorderSizePixel = 0
                        buttonMin.Name = '#button-min'
                        buttonMin.Position = UDim2.new(1, -27, 0, 2)
                        buttonMin.Size = UDim2.fromOffset(20, 20)
                        buttonMin.Visible = true
                        buttonMin.ZIndex = 52 
                        buttonMin.Text = ''
                        buttonMin.Parent = titleBar
                        
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = buttonMin
                        end
                        
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = buttonMin
                        end
                        
                        local icon = Instance.new('ImageLabel') do 
                            icon.Active = false
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Image = 'rbxassetid://9801458532'
                            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(0, 0)
                            icon.Size = UDim2.fromScale(1, 1)
                            icon.Visible = true
                            icon.ZIndex = 52 
                            icon.Parent = buttonMin
                            
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = icon
                            end
                        end
                    end
                    
                    local title = Instance.new('TextLabel') do 
                        title.BackgroundTransparency = 1
                        title.BorderSizePixel = 0
                        title.Font = 'RobotoCondensed'
                        title.Name = '#title'
                        title.Position = UDim2.fromOffset(24, 0)
                        title.RichText = true
                        title.Size = UDim2.new(1, -74, 1, 0)
                        title.Text = 'j'
                        title.TextColor3 = theme.TextPrimary
                        title.TextScaled = false
                        title.TextSize = 17
                        title.TextStrokeColor3 = theme.TextStroke
                        title.TextStrokeTransparency = 0.8
                        title.TextTransparency = 0
                        title.TextXAlignment = 'Left'
                        title.TextYAlignment = 'Center'
                        title.Visible = true
                        title.ZIndex = 52 
                        title.Parent = titleBar
                        
                        local padding = Instance.new('UIPadding') do 
                            padding.PaddingLeft = UDim.new(0, 4)
                            padding.Name = '#padding'
                            padding.Parent = title
                        end
                    end
                end
                local pageRegion = Instance.new('Frame') do 
                    pageRegion.BackgroundColor3 = theme.Window2
                    pageRegion.BackgroundTransparency = 0
                    pageRegion.BorderColor3 = theme.Inset2
                    pageRegion.BorderMode = 'Inset'
                    pageRegion.BorderSizePixel = 1
                    pageRegion.ClipsDescendants = true 
                    pageRegion.Name = '#page-region'
                    pageRegion.Position = UDim2.new(0, 126, 0, 27)
                    pageRegion.Size = UDim2.new(1, -126, 1, -27)
                    pageRegion.Visible = true
                    pageRegion.ZIndex = 30
                    pageRegion.Parent = mainFrame
                end
                local sideBar = Instance.new('Frame') do 
                    sideBar.BackgroundColor3 = theme.Window3
                    sideBar.BackgroundTransparency = 0 
                    sideBar.BorderColor3 = theme.Inset3
                    sideBar.BorderMode = 'Inset'
                    sideBar.BorderSizePixel = 1
                    sideBar.Name = '#sidebar'
                    sideBar.Position = UDim2.fromOffset(0, 27)
                    sideBar.Size = UDim2.new(0, 125, 1, -27)
                    sideBar.Visible = true
                    sideBar.ZIndex = 50
                    sideBar.Parent = mainFrame
                    
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Name = '#stroke'
                        stroke.Thickness = 1 
                        stroke.Parent = sideBar
                    end
                    
                    local menu = Instance.new('ScrollingFrame') do 
                        menu.AutomaticCanvasSize = 'Y'
                        menu.BackgroundTransparency = 1
                        menu.BorderSizePixel = 0
                        menu.BottomImage = 'rbxassetid://9416839567'
                        menu.CanvasSize = UDim2.fromOffset(0, 0)
                        menu.MidImage = 'rbxassetid://9416839567'
                        menu.Name = '#menu'
                        menu.Position = UDim2.fromOffset(1, 1)
                        menu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
                        menu.ScrollBarImageTransparency = 0.9
                        menu.ScrollBarThickness = 1
                        menu.ScrollingDirection = 'Y'
                        menu.ScrollingEnabled = true
                        menu.Size = UDim2.new(1, -2, 1, -2)
                        menu.TopImage = 'rbxassetid://9416839567'
                        menu.Visible = true
                        menu.ZIndex = 51
                        menu.Parent = sideBar
                        
                        local layout = Instance.new('UIListLayout') do 
                            layout.FillDirection = 'Vertical'
                            layout.HorizontalAlignment = 'Center'
                            layout.Name = '#layout'
                            layout.Padding = UDim.new(0, 6)
                            layout.SortOrder = 'LayoutOrder'
                            layout.VerticalAlignment = 'Top'
                            layout.Parent = menu
                        end
                        
                        local padding = Instance.new('UIPadding') do 
                            padding.Name = '#padding'
                            padding.PaddingTop = UDim.new(0, 5)
                            padding.Parent = menu
                        end
                    end
                end
                
                instances.mainFrame = mainFrame
            end
            window.instances = instances 
            window.signals = {
                buttonClose = {
                    MouseEnter = function(self) 
                        tween(self, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(self['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(self) 
                        tween(self, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(self['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(_, self) 
                        self:destroy()
                    end
                },
                buttonMin = {
                    MouseEnter = function(self, w) 
                        w.minFocused = true
                        if (w.minimized) then
                            tween(self, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(self, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(self['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(self, w) 
                        w.minFocused = false
                        if (w.minimized) then
                            tween(self, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(self, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(self['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(_, self) 
                        self:minimize()
                    end
                }
            }
            
            window.destroy = function(self) 
                local mainFrame = self.instances.mainFrame
                task.spawn(function()
                    local animCon
                    task.spawn(function() 
                        local backgroundTransparency = {}
                        local scrollBarImageTransparency = {}
                        local imageTransparency = {}
                        local transparency = {}
                        local textTransparency = {}
                        
                        local s = {
                            Frame = {backgroundTransparency}, 
                            ImageButton = {backgroundTransparency, imageTransparency},
                            ImageLabel = {backgroundTransparency, imageTransparency},
                            TextButton = {backgroundTransparency, textTransparency},
                            TextLabel = {backgroundTransparency, textTransparency},
                            TextBox = {backgroundTransparency, textTransparency},
                            ScrollingFrame = {backgroundTransparency, scrollBarImageTransparency},
                            UIStroke = {transparency},
                        }
                        local d = mainFrame:GetDescendants()
                        table.insert(d, mainFrame)
                        
                        for i, v in ipairs(d) do 
                            local a = s[v.ClassName]
                            if (a) then
                                for i = 1, #a do 
                                    table.insert(a[i], v)
                                end
                            end
                        end
                        
                        for i,v in ipairs(transparency) do
                            v.Transparency = 1
                        end
                        for i,v in ipairs(scrollBarImageTransparency) do 
                            v.ScrollBarImageTransparency = 1 
                        end
                        
                        transparency = nil
                        scrollBarImageTransparency = nil
                        animCon = renderService.RenderStepped:Connect(function(dt) 
                            dt *= 8
                            for i= 1, #backgroundTransparency do 
                                backgroundTransparency[i].BackgroundTransparency += dt
                            end
                            for i= 1, #imageTransparency do 
                                imageTransparency[i].ImageTransparency += dt
                            end
                            for i= 1, #textTransparency do 
                                textTransparency[i].TextTransparency += dt
                            end
                        end)
                    end)
                    tween(mainFrame['#scale'], {Scale = 0.6}, 0.5, 1).Completed:Wait()
                    animCon:Disconnect()
                    mainFrame:Destroy()
                end)
                
                table.remove(ui.windows, table.find(ui.windows, self))
                if (#ui.windows == 0) then
                    wait(0.3)
                    ui.destroy(true) 
                end
                
                self:fireEvent('destroyInternal')
                return self 
            end
            window.setTitle = function(self, title) 
                self.instances.title.Text = tostring(title)
                return self 
            end
            window.setPosition = function(self, newPosition)
                if (typeof(newPosition) == 'Vector2') then
                    newPosition = UDim2.fromOffset(newPosition.X, newPosition.Y)
                elseif (typeof(newPosition) ~= 'UDim2') then
                    return error('expected type UDim2 or Vector2', 2)
                end
                self.instances.mainFrame.Position = newPosition
                return self 
            end
            window.setSize = function(self, size)
                if (typeof(size) == 'Vector2') then
                    size = UDim2.fromOffset(size.X, size.Y)
                elseif (typeof(size) ~= 'UDim2') then
                    return error('expected type UDim2 or Vector2', 2)
                end
                self.size = size
                self.instances.mainFrame.Size = size
                return self 
            end
            
            window.getPosition = function(self) 
                return self.instances.mainFrame.Position
            end
            window.getSize = function(self, targetSize) 
                return targetSize and self.size or self.instances.mainFrame.Size
            end
            
            window.new = function(self, resize) 
                local new = setmetatable({}, self)
                new.menus = {}
                new.binds = {}
                table.insert(ui.windows, new)
                
                local instances = {}
                instances.mainFrame = self.instances.mainFrame:Clone()
                
                local titleBar = instances.mainFrame['#title-bar']
                
                instances.buttonClose = titleBar['#button-close']
                instances.buttonMin = titleBar['#button-min']
                instances.titleBar = titleBar
                instances.title = titleBar['#title']
                instances.gradient = instances.mainFrame['#trim']['#gradient']
                instances.sideBar = instances.mainFrame['#sidebar']
                instances.tabMenu = instances.sideBar['#menu']
                instances.pageRegion = instances.mainFrame['#page-region']
                
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                
                do 
                    local dCon
                    local aCon
                    local mainFrame = instances.mainFrame
                    local targetPos
                    
                    titleBar.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Value == 0) then
                            local rootPos = mainFrame.AbsolutePosition
                            local startPos = io.Position
                            startPos = Vector2.new(startPos.X, startPos.Y)
                            targetPos = UDim2.fromOffset(rootPos.X, rootPos.Y)
                            aCon = renderService.RenderStepped:Connect(function(dt) 
                                mainFrame.Position = mainFrame.Position:lerp(targetPos, 1 - animSpeed^dt)
                            end)
                            dCon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Value == 4) then
                                    local curPos = io.Position
                                    curPos = Vector2.new(curPos.X, curPos.Y) 
                                    local dest = rootPos + (curPos - startPos)
                                    targetPos = UDim2.fromOffset(dest.X, dest.Y)
                                end
                            end)
                        end
                    end)
                    titleBar.InputEnded:Connect(function(io)
                        if (io.UserInputType.Value == 0) then
                            dCon:Disconnect()
                            aCon:Disconnect()
                            tween(mainFrame, {Position = targetPos}, 0.2, 1)
                        end
                    end)
                end
                
                instances.mainFrame.Parent = uiScreen
                new.instances = instances
                return new
            end
            window.minimize = function(self) 
                local newState = not self.minimized
                local mf = self.instances.mainFrame
                local bmin = mf['#title-bar']['#button-min']
                local bminIcon = bmin['#icon']
                
                if (newState) then
                    tween(mf, {Size = UDim2.fromOffset(self.size.X.Offset, 26)}, 0.3, 1)
                    bminIcon.Image = 'rbxassetid://9642646619'
                    tween(bminIcon, {Rotation = 45, ImageColor3 = theme.Primary}, 0.3, 1)
                    if (self.minFocused) then
                        tween(bmin, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                    else
                        tween(bmin, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                    end
                    mf['#page-region'].Visible = false
                    mf['#sidebar'].Visible = false
                else
                    tween(mf, {Size = self.size}, 0.3, 1)
                    bminIcon.Image = 'rbxassetid://9642680675'
                    tween(bminIcon, {Rotation = 0, ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.3, 1)
                    if (self.minFocused) then
                        tween(bmin, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    else
                        tween(bmin, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end
                    mf['#page-region'].Visible = true
                    mf['#sidebar'].Visible = true
                end
                self.minimized = newState
            end            
        end
        elemClasses.window = window
    end
    -- MENU
    do 
        local menu = {} do 
            menu.__index = menu
            setmetatable(menu, elemClasses.baseElement)
            
            menu.class = 'menu'
            
            do 
                local instances = {} do 
                    local tabButton = Instance.new('TextButton') do 
                        tabButton.AutoButtonColor = false
                        tabButton.BackgroundColor3 = theme.Button1
                        tabButton.BackgroundTransparency = 0
                        tabButton.BorderSizePixel = 0
                        tabButton.Name = '#tab-button'
                        tabButton.Size = UDim2.new(1, -12, 0, 26)
                        tabButton.Text = ''
                        tabButton.ZIndex = 52
                        
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = tabButton
                        end
                        
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = tabButton
                        end
                        
                        local label = Instance.new('TextLabel') do 
                            label.BackgroundTransparency = 1
                            label.Font = 'SourceSans'
                            label.Name = '#label'
                            label.RichText = true
                            label.Size = UDim2.fromScale(1, 1)
                            label.Text = 'tab'
                            label.TextColor3 = theme.TextPrimary
                            label.TextSize = 14
                            label.TextStrokeColor3 = theme.TextStroke
                            label.TextStrokeTransparency = 0.8
                            label.TextTransparency = 0
                            label.TextWrapped = false
                            label.TextXAlignment = 'Center'
                            label.TextYAlignment = 'Center'
                            label.Visible = true
                            label.ZIndex = 52
                            label.Parent = tabButton
                        end
                    end
                    
                    local tabFrame = Instance.new('Frame') do 
                        tabFrame.BackgroundTransparency = 1
                        tabFrame.ClipsDescendants = true
                        tabFrame.Name = '#tab-frame'
                        tabFrame.Size = UDim2.fromScale(1, 1)
                        tabFrame.Visible = false
                        tabFrame.ZIndex = 31
                        
                        local layout = Instance.new('UIListLayout') do 
                            layout.FillDirection = 'Horizontal'
                            layout.HorizontalAlignment = 'Left'
                            layout.Name = '#layout'
                            layout.Padding = UDim.new(0, 5)
                            layout.SortOrder = 'LayoutOrder'
                            layout.VerticalAlignment = 'Top'
                            layout.Parent = tabFrame
                        end
                        
                        local padding = Instance.new('UIPadding') do 
                            padding.Name = '#padding'
                            padding.PaddingLeft = UDim.new(0, 5)
                            padding.PaddingTop = UDim.new(0, 5)
                            padding.Parent = tabFrame
                        end
                    end
                    
                    instances.tabButton = tabButton
                    instances.tabFrame = tabFrame
                end
                menu.instances = instances
            end
            
            menu.focused = false
            menu.active = false
            
            menu.sections = {}
            
            menu.signals = {
                tabButton = {
                    MouseEnter = function(self, menu) 
                        menu.focused = true
                        if (menu.active) then
                            tween(self, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(self, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(self['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(self, menu) 
                        menu.focused = false
                        if (menu.active) then
                            tween(self, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(self, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(self['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(self, menu) 
                        menu:select()
                    end
                }
            }
            
            menu.select = function(self) 
                local window = self.window 
                local tabButton = self.instances.tabButton
                
                for _, menu in ipairs(window.menus) do 
                    local otherTabButton = menu.instances.tabButton
                    menu.active = false
                    menu.instances.tabFrame.Visible = false
                    
                    if (menu.focused) then
                        tween(otherTabButton, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    else
                        tween(otherTabButton, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end
                end
                
                self.active = true
                self.instances.tabFrame.Visible = true
                
                if (self.focused) then
                    tween(tabButton, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                else
                    tween(tabButton, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                end
            end
            
            menu.new = function(self) 
                local new = setmetatable({}, self)
                new.sections = {}
                new.binds = {}
                
                local instances = {}
                instances.tabButton = self.instances.tabButton:Clone()
                instances.tabFrame = self.instances.tabFrame:Clone()
                instances.label = instances.tabButton['#label']
                
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                
                new.instances = instances
                return new
            end
            
            elemClasses.window.addTab = function(self, name) 
                local menu = elemClasses.menu:new()
                menu.name = tostring(name)
                menu.window = self 
                table.insert(self.menus, menu)
                
                menu.instances.label.Text = name
                menu.instances.tabButton.Parent = self.instances.tabMenu
                menu.instances.tabFrame.Parent = self.instances.pageRegion
                
                if (#self.menus == 1) then
                    menu:select()
                end
                
                return menu
            end
        end
        elemClasses.menu = menu
    end
    -- SECTION
    do 
        local section = {} do 
            section.__index = section
            setmetatable(section, elemClasses.baseElement)
            
            section.class = 'section'
            
            do 
                local instances = {} do 
                    local main = Instance.new('Frame') do 
                        main.BackgroundColor3 = theme.Window3
                        main.BackgroundTransparency = 0
                        main.BorderColor3 = theme.Inset3
                        main.BorderMode = 'Inset'
                        main.BorderSizePixel = 1
                        main.Name = '#section'
                        main.Size = UDim2.new(0.495, -5, 0, 50)
                        main.Visible = true
                        main.ZIndex = 32
                        
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = main
                        end
                        
                        local titleBar = Instance.new('Frame') do 
                            titleBar.BackgroundColor3 = theme.Window3
                            titleBar.BackgroundTransparency = 0
                            titleBar.BorderColor3 = theme.Inset3
                            titleBar.BorderMode = 'Inset'
                            titleBar.BorderSizePixel = 1
                            titleBar.Name = '#title-bar'
                            titleBar.Size = UDim2.new(1, 2, 0, 16)
                            titleBar.Position = UDim2.fromOffset(-1, 0)
                            titleBar.Visible = true
                            titleBar.ZIndex = 33
                            titleBar.Parent = main
                            
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = titleBar
                            end
                            
                            local label = Instance.new('TextLabel') do 
                                label.BackgroundTransparency = 1
                                label.Font = 'SourceSans'
                                label.Name = '#label'
                                label.RichText = true
                                label.Size = UDim2.fromScale(1, 1)
                                label.Text = 'section'
                                label.TextColor3 = theme.TextPrimary
                                label.TextSize = 14
                                label.TextStrokeColor3 = theme.TextStroke
                                label.TextStrokeTransparency = 0.8
                                label.TextTransparency = 0
                                label.TextWrapped = false
                                label.TextXAlignment = 'Left'
                                label.TextYAlignment = 'Center'
                                label.Visible = true
                                label.ZIndex = 33
                                label.Parent = titleBar
                                
                                local padding = Instance.new('UIPadding') do 
                                    padding.Name = '#padding'
                                    padding.PaddingLeft = UDim.new(0, 4)
                                    padding.Parent = label
                                end
                            end
                        end
                        
                        local controlMenu = Instance.new('ScrollingFrame') do 
                            controlMenu.AutomaticCanvasSize = 'Y'
                            controlMenu.BackgroundTransparency = 1
                            controlMenu.BorderSizePixel = 0
                            controlMenu.Name = '#control-menu'
                            controlMenu.Position = UDim2.fromOffset(0, 18)
                            controlMenu.ScrollBarImageTransparency = 1
                            controlMenu.ScrollingEnabled = false
                            controlMenu.Size = UDim2.new(1, 0, 1, -18)
                            controlMenu.Visible = true
                            controlMenu.ZIndex = 33
                            controlMenu.Parent = main
                            
                            local layout = Instance.new('UIListLayout') do 
                                layout.FillDirection = 'Vertical'
                                layout.HorizontalAlignment = 'Left'
                                layout.Name = '#layout'
                                layout.Padding = UDim.new(0, 5)
                                layout.SortOrder = 'LayoutOrder'
                                layout.VerticalAlignment = 'Top'
                                layout.Parent = controlMenu
                            end
                            
                            local padding = Instance.new('UIPadding') do 
                                padding.Name = '#padding'
                                padding.PaddingLeft = UDim.new(0, 5)
                                padding.PaddingTop = UDim.new(0, 5)
                                padding.Parent = controlMenu
                            end
                        end
                    end
                    
                    instances.main = main
                end
                section.instances = instances
            end
            
            section.controls = {}
            
            section.new = function(self) 
                local new = setmetatable({}, self)
                new.controls = {}
                new.binds = {}
                
                local instances = {}
                instances.main = self.instances.main:Clone()
                instances.label = instances.main['#title-bar']['#label']
                instances.controlMenu = instances.main['#control-menu']
                
                new.instances = instances
                return new
            end
            
            elemClasses.menu.addSection = function(self, name) 
                local section = elemClasses.section:new()
                section.name = tostring(name)
                section.menu = self 
                table.insert(self.sections, section)
                
                section.instances.label.Text = name
                section.instances.main.Parent = self.instances.tabFrame
                
                return section
            end
        end
        elemClasses.section = section
    end
end

do
    ui.__index = ui 
    setmetatable(ui, elemClasses.baseElement)
    ui.class = 'ui'
    
    ui.binds = {}
    ui.windows = {}
    ui.scriptCns = {}
    
    local windows = ui.windows
    
    ui.newWindow = function(settings) 
        if (typeof(settings) ~= 'table') then
            return error('expected type table for settings', 2)
        end
        
        local s_title = settings.text or 'nil'
        local s_resize = settings.resize or false
        local s_position = settings.position
        if (not s_position) then
            s_position = defaultWinPos
            defaultWinPos += UDim2.fromScale(0.02, 0.02)
        end
        
        local window = elemClasses.window:new(s_resize)
        
        local s_winSize = settings.size or window.size
        if (typeof(s_winSize) == 'Vector2') then
            s_winSize = UDim2.fromOffset(s_winSize.X, s_winSize.Y) 
        end
        
        window:setPosition(s_position)
        window:setTitle(s_title)
        window.size = s_winSize
        
        task.spawn(function()
            local instances = window.instances 
            local mainFrame = instances.mainFrame 
            local titleBar = instances.titleBar
            
            mainFrame.Size = UDim2.fromOffset(s_winSize.X.Offset, 30)
            tween(mainFrame, {Size = s_winSize}, 0.5, 1)
            
            task.spawn(function() 
                local bClose = titleBar['#button-close']
                local bMin = titleBar['#button-min']
                local title = titleBar['#title']
                
                local offset = UDim2.fromOffset(50, 0) 
                bClose.Position += offset
                bMin.Position += offset
                title.Position -= offset
                tween(bClose, {Position = bClose.Position - offset}, 1, 1)
                tween(bMin, {Position = bMin.Position - offset}, 1, 1)
                tween(title, {Position = title.Position + offset}, 1, 1)
            end)
            
            task.spawn(function()
                local fade = titleBar['#fade']
                fade.BackgroundTransparency = 0
                fade.Visible = true
                tween(fade, {BackgroundTransparency = 1}, 2, 1).Completed:Wait()
                fade.Visible = false 
            end)
        end)
        
        return window
    end
    ui.destroy = function(noWindows)
        ui:fireEvent('onPreDestroy')
        delay(0.4, function() 
            uiScreen:Destroy()
            uiScreen = nil
        end)
        
        if (noWindows ~= true) then  
            for _, win in ipairs(windows) do 
                win:destroy()
            end
        end
        
        for i,v in pairs(elemClasses) do 
            if not (v.instances) then continue end 
            for i,v in pairs(v.instances) do 
                v:Destroy() 
            end
        end
        
        ui:fireEvent('onDestroy')
        for _, v in pairs(ui.scriptCns) do v:Disconnect() end
    end
end

return ui
