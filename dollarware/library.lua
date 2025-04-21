local inputService = game:GetService('UserInputService')
local renderService = game:GetService('RunService')
local tweenService = game:GetService('TweenService')
local guiService = game:GetService('GuiService')

-- Tween функция для анимаций
local tween
do
    local styleEnum, dirEnum = Enum.EasingStyle, Enum.EasingDirection
    local direction, styles = dirEnum.Out, {styleEnum.Exponential, styleEnum.Linear}
    function tween(object, props, duration, style)
        local tweenInfo = TweenInfo.new(duration, styles[style], direction)
        local t = tweenService:Create(object, tweenInfo, props)
        t:Play()
        return t
    end
end

-- Тема по умолчанию
local theme = {
    Primary = Color3.fromRGB(38, 233, 195); Secondary = Color3.fromRGB(233, 38, 115);
    Window1 = Color3.fromRGB(30, 30, 35); Window2 = Color3.fromRGB(20, 20, 25); Window3 = Color3.fromRGB(25, 25, 30);
    Button1 = Color3.fromRGB(35, 35, 40); Button2 = Color3.fromRGB(45, 45, 50); Button3 = Color3.fromRGB(65, 65, 70); Button4 = Color3.fromRGB(75, 75, 80);
    Stroke = Color3.fromRGB(50, 50, 55); StrokeHover = Color3.fromRGB(70, 70, 75);
    Inset1 = Color3.fromRGB(20, 20, 25); Inset2 = Color3.fromRGB(10, 10, 15); Inset3 = Color3.fromRGB(15, 15, 20);
    TextPrimary = Color3.fromRGB(255, 255, 255); TextStroke = Color3.fromRGB(0, 0, 0); TextDim = Color3.fromRGB(164, 164, 164);
    ControlGradient1 = Color3.fromRGB(255, 255, 255); ControlGradient2 = Color3.fromRGB(192, 192, 192);
}
local rounding, animSpeed = true, 1e-12

-- ScreenGui
local uiScreen = Instance.new('ScreenGui')
do
    uiScreen.OnTopOfCoreBlur = true
    uiScreen.DisplayOrder = 9e9
    uiScreen.ZIndexBehavior = 'Global'
    local str = ''
    for i = 1, 8 do str = str .. utf8.char(math.random(97, 2500)) end
    uiScreen.Name = str
    uiScreen.Parent = gethui and gethui() or game:GetService('CoreGui')

    local notifContainer = Instance.new('Frame')
    notifContainer.BackgroundTransparency = 1
    notifContainer.Name = '#notif-container'
    notifContainer.Position = UDim2.new(1, -250, 0, -50)
    notifContainer.Size = UDim2.new(0, 200, 1, 0)
    notifContainer.ZIndex = 0
    notifContainer.Parent = uiScreen
end

-- Базовый класс и остальные классы
local elemClasses = {}
local defaultWinPos = UDim2.fromScale(0.6, 0.6)
local ui = {__index = ui, windows = {}, pickerWindows = {}, notifs = {}, hotkeys = {}, scriptCns = {}, autoDisableToggles = true}

-- Базовый класс
do
    local baseElement = {__index = baseElement}
    baseElement.bindToEvent = function(self, event, callback) self.binds[event] = callback return self end
    baseElement.fireEvent = function(self, event, ...) local t = self.binds[event] if t then task.spawn(t, ...) end return self end
    baseElement.name = ''
    baseElement.tooltip = nil
    baseElement.setTooltip = function(self, tooltip) self.tooltip = tostring(tooltip) return self end
    elemClasses.baseElement = baseElement
end

-- Класс Window
do
    local window = {__index = window}
    setmetatable(window, elemClasses.baseElement)
    window.class = 'window'
    window.minimized = false
    window.size = UDim2.fromOffset(450, 350)
    window.minFocused = false

    local instances = {}
    do
        local mainFrame = Instance.new('Frame')
        mainFrame.BackgroundColor3 = theme.Window2
        mainFrame.Position = UDim2.fromScale(0.6, 0.6)
        mainFrame.Size = UDim2.fromOffset(500, 350)
        mainFrame.ZIndex = 5

        local stroke = Instance.new('UIStroke')
        stroke.ApplyStrokeMode = 'Border'
        stroke.Color = theme.Stroke
        stroke.LineJoinMode = 'Round'
        stroke.Thickness = 1
        stroke.Parent = mainFrame

        local shadow = Instance.new('ImageLabel')
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.BackgroundTransparency = 1
        shadow.Image = 'rbxassetid://7331400934'
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
        shadow.Position = UDim2.fromScale(0.5, 0.5)
        shadow.ScaleType = 'Slice'
        shadow.Size = UDim2.new(1, 50, 1, 50)
        shadow.SliceCenter = Rect.new(40, 40, 260, 260)
        shadow.ZIndex = 4
        shadow.Parent = mainFrame

        local trimLine = Instance.new('Frame')
        trimLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        trimLine.Position = UDim2.fromOffset(0, -1)
        trimLine.Size = UDim2.new(1, 0, 0, 1)
        trimLine.ZIndex = 64
        trimLine.Parent = mainFrame

        local gradient = Instance.new('UIGradient')
        gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
        gradient.Rotation = 0
        gradient.Parent = trimLine

        local titleBar = Instance.new('Frame')
        titleBar.Active = true
        titleBar.BackgroundColor3 = theme.Window1
        titleBar.BorderColor3 = theme.Inset1
        titleBar.BorderMode = 'Inset'
        titleBar.BorderSizePixel = 1
        titleBar.ClipsDescendants = true
        titleBar.Name = '#title-bar'
        titleBar.Selectable = true
        titleBar.Size = UDim2.new(1, 0, 0, 26)
        titleBar.ZIndex = 50
        titleBar.Parent = mainFrame

        local strokeTitle = Instance.new('UIStroke')
        strokeTitle.ApplyStrokeMode = 'Border'
        strokeTitle.Color = theme.Stroke
        strokeTitle.LineJoinMode = 'Round'
        strokeTitle.Thickness = 1
        strokeTitle.Parent = titleBar

        local buttonClose = Instance.new('TextButton')
        buttonClose.AnchorPoint = Vector2.new(1, 0)
        buttonClose.AutoButtonColor = false
        buttonClose.BackgroundColor3 = theme.Button1
        buttonClose.Position = UDim2.new(1, -3, 0, 2)
        buttonClose.Size = UDim2.fromOffset(20, 20)
        buttonClose.ZIndex = 52
        buttonClose.Text = ''
        buttonClose.Parent = titleBar

        local roundClose = Instance.new('UICorner')
        roundClose.CornerRadius = UDim.new(0, rounding and 2 or 0)
        roundClose.Parent = buttonClose

        local strokeClose = Instance.new('UIStroke')
        strokeClose.ApplyStrokeMode = 'Border'
        strokeClose.Color = theme.Stroke
        strokeClose.LineJoinMode = 'Round'
        strokeClose.Thickness = 1
        strokeClose.Parent = buttonClose

        local iconClose = Instance.new('ImageLabel')
        iconClose.BackgroundTransparency = 1
        iconClose.Image = 'rbxassetid://9801460300'
        iconClose.ImageColor3 = Color3.fromRGB(255, 255, 255)
        iconClose.Size = UDim2.fromScale(1, 1)
        iconClose.ZIndex = 52
        iconClose.Parent = buttonClose

        local gradientClose = Instance.new('UIGradient')
        gradientClose.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
        gradientClose.Rotation = 90
        gradientClose.Parent = iconClose

        local buttonMin = Instance.new('TextButton')
        buttonMin.AnchorPoint = Vector2.new(1, 0)
        buttonMin.AutoButtonColor = false
        buttonMin.BackgroundColor3 = theme.Button1
        buttonMin.Position = UDim2.new(1, -27, 0, 2)
        buttonMin.Size = UDim2.fromOffset(20, 20)
        buttonMin.ZIndex = 52
        buttonMin.Text = ''
        buttonMin.Parent = titleBar

        local roundMin = Instance.new('UICorner')
        roundMin.CornerRadius = UDim.new(0, rounding and 2 or 0)
        roundMin.Parent = buttonMin

        local strokeMin = Instance.new('UIStroke')
        strokeMin.ApplyStrokeMode = 'Border'
        strokeMin.Color = theme.Stroke
        strokeMin.LineJoinMode = 'Round'
        strokeMin.Thickness = 1
        strokeMin.Parent = buttonMin

        local iconMin = Instance.new('ImageLabel')
        iconMin.BackgroundTransparency = 1
        iconMin.Image = 'rbxassetid://9801458532'
        iconMin.ImageColor3 = Color3.fromRGB(255, 255, 255)
        iconMin.Size = UDim2.fromScale(1, 1)
        iconMin.ZIndex = 52
        iconMin.Parent = buttonMin

        local gradientMin = Instance.new('UIGradient')
        gradientMin.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
        gradientMin.Rotation = 90
        gradientMin.Parent = iconMin

        local title = Instance.new('TextLabel')
        title.BackgroundTransparency = 1
        title.Font = 'RobotoCondensed'
        title.Position = UDim2.fromOffset(24, 0)
        title.Size = UDim2.new(1, -74, 1, 0)
        title.Text = 'Window'
        title.TextColor3 = theme.TextPrimary
        title.TextSize = 17
        title.TextStrokeColor3 = theme.TextStroke
        title.TextStrokeTransparency = 0.8
        title.TextXAlignment = 'Left'
        title.TextYAlignment = 'Center'
        title.ZIndex = 52
        title.Parent = titleBar

        local paddingTitle = Instance.new('UIPadding')
        paddingTitle.PaddingLeft = UDim.new(0, 4)
        paddingTitle.Parent = title

        local pageRegion = Instance.new('Frame')
        pageRegion.BackgroundColor3 = theme.Window2
        pageRegion.BorderColor3 = theme.Inset2
        pageRegion.BorderMode = 'Inset'
        pageRegion.BorderSizePixel = 1
        pageRegion.ClipsDescendants = true
        pageRegion.Name = '#page-region'
        pageRegion.Position = UDim2.new(0, 126, 0, 27)
        pageRegion.Size = UDim2.new(1, -126, 1, -27)
        pageRegion.ZIndex = 30
        pageRegion.Parent = mainFrame

        local sideBar = Instance.new('Frame')
        sideBar.BackgroundColor3 = theme.Window3
        sideBar.BorderColor3 = theme.Inset3
        sideBar.BorderMode = 'Inset'
        sideBar.BorderSizePixel = 1
        sideBar.Name = '#sidebar'
        sideBar.Position = UDim2.fromOffset(0, 27)
        sideBar.Size = UDim2.new(0, 125, 1, -27)
        sideBar.ZIndex = 50
        sideBar.Parent = mainFrame

        local strokeSide = Instance.new('UIStroke')
        strokeSide.ApplyStrokeMode = 'Border'
        strokeSide.Color = theme.Stroke
        strokeSide.LineJoinMode = 'Round'
        strokeSide.Thickness = 1
        strokeSide.Parent = sideBar

        local menu = Instance.new('ScrollingFrame')
        menu.AutomaticCanvasSize = 'Y'
        menu.BackgroundTransparency = 1
        menu.Name = '#menu'
        menu.Position = UDim2.fromOffset(1, 1)
        menu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        menu.ScrollBarImageTransparency = 0.9
        menu.ScrollBarThickness = 1
        menu.Size = UDim2.new(1, -2, 1, -2)
        menu.ZIndex = 51
        menu.Parent = sideBar

        local layout = Instance.new('UIListLayout')
        layout.FillDirection = 'Vertical'
        layout.HorizontalAlignment = 'Center'
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = 'LayoutOrder'
        layout.VerticalAlignment = 'Top'
        layout.Parent = menu

        local paddingMenu = Instance.new('UIPadding')
        paddingMenu.PaddingTop = UDim.new(0, 5)
        paddingMenu.Parent = menu

        local resizeHandle = Instance.new('ImageLabel')
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.Image = 'rbxassetid://9995727737'
        resizeHandle.ImageColor3 = theme.Primary
        resizeHandle.Position = UDim2.new(1, -10, 1, -10)
        resizeHandle.Size = UDim2.fromOffset(10, 10)
        resizeHandle.ZIndex = 34
        resizeHandle.Parent = mainFrame

        instances.mainFrame = mainFrame
        instances.buttonClose = buttonClose
        instances.buttonMin = buttonMin
        instances.titleBar = titleBar
        instances.title = title
        instances.sideBar = sideBar
        instances.tabMenu = menu
        instances.pageRegion = pageRegion
        instances.resizeHandle = resizeHandle
    end
    window.instances = instances
    window.menus = {}

    window.signals = {
        buttonClose = {
            MouseEnter = function(self) tween(self, {BackgroundColor3 = theme.Button2}, 0.2, 1) tween(self['#stroke'], {Color = theme.StrokeHover}, 0.2, 1) end,
            MouseLeave = function(self) tween(self, {BackgroundColor3 = theme.Button1}, 0.2, 1) tween(self['#stroke'], {Color = theme.Stroke}, 0.2, 1) end,
            MouseButton1Click = function(_, self) self:destroy() end
        },
        buttonMin = {
            MouseEnter = function(self, w) w.minFocused = true if w.minimized then tween(self, {BackgroundColor3 = theme.Button4}, 0.2, 1) else tween(self, {BackgroundColor3 = theme.Button2}, 0.2, 1) end tween(self['#stroke'], {Color = theme.StrokeHover}, 0.2, 1) end,
            MouseLeave = function(self, w) w.minFocused = false if w.minimized then tween(self, {BackgroundColor3 = theme.Button3}, 0.2, 1) else tween(self, {BackgroundColor3 = theme.Button1}, 0.2, 1) end tween(self['#stroke'], {Color = theme.Stroke}, 0.2, 1) end,
            MouseButton1Click = function(_, self) self:minimize() end
        }
    }

    window.destroy = function(self)
        if ui.autoDisableToggles then
            for _, menu in ipairs(self.menus) do
                for _, section in ipairs(menu.sections) do
                    for _, control in ipairs(section.controls) do
                        if control.class == 'toggle' and control.toggled then control:disable() end
                    end
                end
            end
        end
        local mainFrame = self.instances.mainFrame
        task.spawn(function()
            local animCon
            task.spawn(function()
                local backgroundTransparency, imageTransparency, textTransparency, transparency = {}, {}, {}, {}
                local s = {Frame = {backgroundTransparency}, ImageLabel = {backgroundTransparency, imageTransparency}, TextButton = {backgroundTransparency, textTransparency}, TextLabel = {backgroundTransparency, textTransparency}, ScrollingFrame = {backgroundTransparency}, UIStroke = {transparency}}
                local d = mainFrame:GetDescendants()
                table.insert(d, mainFrame)
                for _, v in ipairs(d) do local a = s[v.ClassName] if a then for i = 1, #a do table.insert(a[i], v) end end end
                for _, v in ipairs(transparency) do v.Transparency = 1 end
                animCon = renderService.RenderStepped:Connect(function(dt)
                    dt *= 8
                    for _, v in ipairs(backgroundTransparency) do v.BackgroundTransparency += dt end
                    for _, v in ipairs(imageTransparency) do v.ImageTransparency += dt end
                    for _, v in ipairs(textTransparency) do v.TextTransparency += dt end
                end)
            end)
            tween(mainFrame, {Size = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 0)}, 0.5, 1).Completed:Wait()
            animCon:Disconnect()
            mainFrame:Destroy()
        end)
        table.remove(ui.windows, table.find(ui.windows, self))
        if #ui.windows == 0 then wait(0.3) ui.destroy(true) end
        self:fireEvent('destroyInternal')
        return self
    end

    window.setTitle = function(self, title) self.instances.title.Text = tostring(title) return self end
    window.setPosition = function(self, newPosition)
        if typeof(newPosition) == 'Vector2' then newPosition = UDim2.fromOffset(newPosition.X, newPosition.Y) end
        self.instances.mainFrame.Position = newPosition
        return self
    end
    window.setSize = function(self, size)
        if typeof(size) == 'Vector2' then size = UDim2.fromOffset(size.X, size.Y) end
        self.size = size
        self.instances.mainFrame.Size = size
        return self
    end

    window.new = function(self, resize)
        local new = setmetatable({}, self)
        new.menus = {}
        new.binds = {}
        table.insert(ui.windows, new)

        local instances = {}
        instances.mainFrame = self.instances.mainFrame:Clone()
        instances.buttonClose = instances.mainFrame['#title-bar']['#button-close']
        instances.buttonMin = instances.mainFrame['#title-bar']['#button-min']
        instances.titleBar = instances.mainFrame['#title-bar']
        instances.title = instances.titleBar['#title']
        instances.sideBar = instances.mainFrame['#sidebar']
        instances.tabMenu = instances.sideBar['#menu']
        instances.pageRegion = instances.mainFrame['#page-region']
        instances.resizeHandle = instances.mainFrame['#resize-handle']

        for i, signals in pairs(self.signals) do
            local inst = instances[i]
            for signal, func in pairs(signals) do
                inst[signal]:Connect(function() func(inst, new) end)
            end
        end

        do
            local mainFrame = instances.mainFrame
            local titleBar = instances.titleBar
            local targetPos
            titleBar.InputBegan:Connect(function(io)
                if io.UserInputType.Value == 0 then
                    local rootPos = mainFrame.AbsolutePosition
                    local startPos = Vector2.new(io.Position.X, io.Position.Y)
                    targetPos = UDim2.fromOffset(rootPos.X, rootPos.Y)
                    local aCon = renderService.RenderStepped:Connect(function(dt) mainFrame.Position = mainFrame.Position:Lerp(targetPos, 1 - animSpeed^dt) end)
                    local dCon = inputService.InputChanged:Connect(function(io)
                        if io.UserInputType.Value == 4 then
                            local curPos = Vector2.new(io.Position.X, io.Position.Y)
                            local dest = rootPos + (curPos - startPos)
                            targetPos = UDim2.fromOffset(dest.X, dest.Y)
                        end
                    end)
                    titleBar.InputEnded:Connect(function(io)
                        if io.UserInputType.Value == 0 then
                            dCon:Disconnect()
                            aCon:Disconnect()
                            tween(mainFrame, {Position = targetPos}, 0.2, 1)
                        end
                    end)
                end
            end)
        end

        if resize then
            local mainFrame = instances.mainFrame
            local resizeHandle = instances.resizeHandle
            local targetSize
            resizeHandle.InputBegan:Connect(function(io)
                if io.UserInputType.Value == 0 and not new.minimized then
                    local rootSize = mainFrame.AbsoluteSize
                    local startPos = Vector2.new(io.Position.X, io.Position.Y)
                    targetSize = UDim2.fromOffset(rootSize.X, rootSize.Y)
                    local aCon = renderService.RenderStepped:Connect(function(dt) mainFrame.Size = mainFrame.Size:Lerp(targetSize, 1 - animSpeed^dt) new.size = mainFrame.Size end)
                    local dCon = inputService.InputChanged:Connect(function(io)
                        if io.UserInputType.Value == 4 then
                            local curPos = Vector2.new(io.Position.X, io.Position.Y)
                            local dest = rootSize + (curPos - startPos)
                            targetSize = UDim2.fromOffset(math.clamp(dest.X, 400, 800), math.clamp(dest.Y, 300, 600))
                        end
                    end)
                    resizeHandle.InputEnded:Connect(function(io)
                        if io.UserInputType.Value == 0 and not new.minimized then
                            dCon:Disconnect()
                            aCon:Disconnect()
                            tween(mainFrame, {Size = targetSize}, 0.2, 1)
                            new.size = targetSize
                        end
                    end)
                end
            end)
        else
            instances.resizeHandle.Visible = false
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

        if newState then
            tween(mf, {Size = UDim2.fromOffset(self.size.X.Offset, 26)}, 0.3, 1)
            bminIcon.Image = 'rbxassetid://9642646619'
            tween(bminIcon, {Rotation = 45, ImageColor3 = theme.Primary}, 0.3, 1)
            if self.minFocused then tween(bmin, {BackgroundColor3 = theme.Button4}, 0.2, 1) else tween(bmin, {BackgroundColor3 = theme.Button3}, 0.2, 1) end
            mf['#page-region'].Visible = false
            mf['#sidebar'].Visible = false
        else
            tween(mf, {Size = self.size}, 0.3, 1)
            bminIcon.Image = 'rbxassetid://9642680675'
            tween(bminIcon, {Rotation = 0, ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.3, 1)
            if self.minFocused then tween(bmin, {BackgroundColor3 = theme.Button2}, 0.2, 1) else tween(bmin, {BackgroundColor3 = theme.Button1}, 0.2, 1) end
            mf['#page-region'].Visible = true
            mf['#sidebar'].Visible = true
        end
        self.minimized = newState
    end

    window.changeTab = function(self, newTab)
        if self.currentTab then
            self.currentTab.instances.page.Visible = false
            tween(self.currentTab.instances.tabButton, {BackgroundColor3 = theme.Button1}, 0.2, 1)
            tween(self.currentTab.instances.tabButton['#stroke'], {Color = theme.Stroke}, 0.2, 1)
        end
        newTab.instances.page.Visible = true
        tween(newTab.instances.tabButton, {BackgroundColor3 = theme.Button3}, 0.2, 1)
        tween(newTab.instances.tabButton['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
        self.currentTab = newTab
        return self
    end

    window.addMenu = function(self, settings)
        if not settings or type(settings) ~= 'table' then return error('expected type table for settings', 2) end
        local s_title = settings.text or 'nil'
        local new = elemClasses.menu:new()
        new.window = self
        new:setTitle(s_title)
        if #self.menus == 1 then new:show() end
        return new
    end

    elemClasses.window = window
end

-- Класс Menu
do
    local menu = {__index = menu}
    setmetatable(menu, elemClasses.baseElement)
    menu.class = 'menu'

    local instances = {}
    do
        local tabButton = Instance.new('TextButton')
        tabButton.AutoButtonColor = false
        tabButton.BackgroundColor3 = theme.Button1
        tabButton.Size = UDim2.new(1, -10, 0, 30)
        tabButton.Text = ''
        tabButton.ZIndex = 52

        local round = Instance.new('UICorner')
        round.CornerRadius = UDim.new(0, rounding and 4 or 0)
        round.Parent = tabButton

        local stroke = Instance.new('UIStroke')
        stroke.ApplyStrokeMode = 'Border'
        stroke.Color = theme.Stroke
        stroke.LineJoinMode = 'Round'
        stroke.Thickness = 1
        stroke.Parent = tabButton

        local label = Instance.new('TextLabel')
        label.BackgroundTransparency = 1
        label.Font = 'SourceSans'
        label.Size = UDim2.fromScale(1, 1)
        label.Text = 'Tab'
        label.TextColor3 = theme.TextPrimary
        label.TextSize = 14
        label.TextStrokeColor3 = theme.TextStroke
        label.TextStrokeTransparency = 0.8
        label.TextXAlignment = 'Left'
        label.TextYAlignment = 'Center'
        label.ZIndex = 53
        label.Parent = tabButton

        local padding = Instance.new('UIPadding')
        padding.PaddingLeft = UDim.new(0, 8)
        padding.Parent = label

        local page = Instance.new('Frame')
        page.BackgroundTransparency = 1
        page.Size = UDim2.fromScale(1, 1)
        page.Visible = false
        page.ZIndex = 31

        local layout = Instance.new('UIListLayout')
        layout.FillDirection = 'Vertical'
        layout.HorizontalAlignment = 'Center'
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = 'LayoutOrder'
        layout.VerticalAlignment = 'Top'
        layout.Parent = page

        local paddingPage = Instance.new('UIPadding')
        paddingPage.PaddingTop = UDim.new(0, 5)
        paddingPage.Parent = page

        instances.tabButton = tabButton
        instances.page = page
        instances.label = label
    end
    menu.instances = instances

    menu.sections = {}
    menu.focused = false

    menu.setTitle = function(self, title) self.instances.label.Text = tostring(title) return self end
    menu.show = function(self) self.window:changeTab(self) return self end

    menu.signals = {
        tabButton = {
            MouseEnter = function(inst, self) self.focused = true if not self.window.currentTab then tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1) tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1) end end,
            MouseLeave = function(inst, self) self.focused = false if self.window.currentTab ~= self then tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1) tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1) end end,
            MouseButton1Click = function(inst, self) self:show() end
        }
    }

    menu.new = function(self)
        local new = setmetatable({}, self)
        new.binds = {}
        new.sections = {}

        local instances = {}
        instances.tabButton = self.instances.tabButton:Clone()
        instances.page = self.instances.page:Clone()
        instances.label = instances.tabButton['#label']

        for i, signals in pairs(self.signals) do
            local inst = instances[i]
            for signal, func in pairs(signals) do
                inst[signal]:Connect(function() func(inst, new) end)
            end
        end

        instances.tabButton.Parent = self.window.instances.tabMenu
        instances.page.Parent = self.window.instances.pageRegion
        new.instances = instances
        new.window = self.window
        table.insert(self.window.menus, new)
        return new
    end

    menu.addSection = function(self, settings)
        if not settings or type(settings) ~= 'table' then return error('expected type table for settings', 2) end
        local s_title = settings.text or 'nil'
        local new = elemClasses.section:new()
        new.menu = self
        new:setTitle(s_title)
        return new
    end

    elemClasses.menu = menu
end

-- Класс Section
do
    local section = {__index = section}
    setmetatable(section, elemClasses.baseElement)
    section.class = 'section'

    local instances = {}
    do
        local sectionFrame = Instance.new('Frame')
        sectionFrame.BackgroundColor3 = theme.Window2
        sectionFrame.BorderColor3 = theme.Inset2
        sectionFrame.BorderMode = 'Inset'
        sectionFrame.BorderSizePixel = 1
        sectionFrame.Size = UDim2.new(1, -10, 0, 30)
        sectionFrame.ZIndex = 32

        local stroke = Instance.new('UIStroke')
        stroke.ApplyStrokeMode = 'Border'
        stroke.Color = theme.Stroke
        stroke.LineJoinMode = 'Round'
        stroke.Thickness = 1
        stroke.Parent = sectionFrame

        local header = Instance.new('Frame')
        header.BackgroundColor3 = theme.Window3
        header.BorderColor3 = theme.Inset3
        header.BorderMode = 'Inset'
        header.BorderSizePixel = 1
        header.Size = UDim2.new(1, 2, 0, 16)
        header.Position = UDim2.fromOffset(-1, 0)
        header.ZIndex = 33
        header.Parent = sectionFrame

        local strokeHeader = Instance.new('UIStroke')
        strokeHeader.ApplyStrokeMode = 'Border'
        strokeHeader.Color = theme.Stroke
        strokeHeader.LineJoinMode = 'Round'
        strokeHeader.Thickness = 1
        strokeHeader.Parent = header

        local trim = Instance.new('Frame')
        trim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        trim.Position = UDim2.fromOffset(0, -2)
        trim.Size = UDim2.new(1, 0, 0, 1)
        trim.ZIndex = 34
        trim.Parent = header

        local gradient = Instance.new('UIGradient')
        gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
        gradient.Rotation = 0
        gradient.Parent = trim

        local title = Instance.new('TextLabel')
        title.BackgroundTransparency = 1
        title.Font = 'SourceSans'
        title.Size = UDim2.fromScale(1, 1)
        title.Text = 'Section'
        title.TextColor3 = theme.TextPrimary
        title.TextSize = 14
        title.TextStrokeColor3 = theme.TextStroke
        title.TextStrokeTransparency = 0.8
        title.TextXAlignment = 'Left'
        title.TextYAlignment = 'Center'
        title.ZIndex = 34
        title.Parent = header

        local padding = Instance.new('UIPadding')
        padding.PaddingLeft = UDim.new(0, 4)
        padding.Parent = title

        local controlMenu = Instance.new('ScrollingFrame')
        controlMenu.AutomaticCanvasSize = 'Y'
        controlMenu.BackgroundTransparency = 1
        controlMenu.Position = UDim2.fromOffset(1, 17)
        controlMenu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        controlMenu.ScrollBarImageTransparency = 0.9
        controlMenu.ScrollBarThickness = 1
        controlMenu.Size = UDim2.new(1, -2, 1, -18)
        controlMenu.ZIndex = 33
        controlMenu.Parent = sectionFrame

        local layout = Instance.new('UIListLayout')
        layout.FillDirection = 'Vertical'
        layout.HorizontalAlignment = 'Left'
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = 'LayoutOrder'
        layout.VerticalAlignment = 'Top'
        layout.Parent = controlMenu

        local paddingMenu = Instance.new('UIPadding')
        paddingMenu.PaddingTop = UDim.new(0, 4)
        paddingMenu.Parent = controlMenu

        instances.sectionFrame = sectionFrame
        instances.header = header
        instances.title = title
        instances.controlMenu = controlMenu
    end
    section.instances = instances

    section.controls = {}
    section.minimized = false

    section.setTitle = function(self, title) self.instances.title.Text = tostring(title) return self end
    section.minimize = function(self)
        local newState = not self.minimized
        local sectionFrame = self.instances.sectionFrame
        local controlMenu = self.instances.controlMenu

        if newState then
            controlMenu.Visible = false
            tween(sectionFrame, {Size = UDim2.new(1, -10, 0, 16)}, 0.3, 1)
        else
            controlMenu.Visible = true
            local totalHeight = 16
            for _, control in ipairs(self.controls) do totalHeight += control.instances.controlFrame.Size.Y.Offset + 4 end
            tween(sectionFrame, {Size = UDim2.new(1, -10, 0, totalHeight)}, 0.3, 1)
        end
        self.minimized = newState
        return self
    end

    section.signals = {
        header = {
            MouseButton1Click = function(inst, self) self:minimize() end
        }
    }

    section.new = function(self)
        local new = setmetatable({}, self)
        new.binds = {}
        new.controls = {}

        local instances = {}
        instances.sectionFrame = self.instances.sectionFrame:Clone()
        instances.header = instances.sectionFrame['#header']
        instances.title = instances.header['#title']
        instances.controlMenu = instances.sectionFrame['#controls']
        instances.sectionFrame.ZIndex += (#self.menu.sections * 10)

        for i, signals in pairs(self.signals) do
            local inst = instances[i]
            for signal, func in pairs(signals) do
                inst[signal]:Connect(function() func(inst, new) end)
            end
        end

        instances.sectionFrame.Parent = self.menu.instances.page
        new.instances = instances
        new.menu = self.menu
        table.insert(self.menu.sections, new)
        return new
    end

    elemClasses.section = section
end

-- Класс Toggle
do
    local toggle = {__index = toggle}
    setmetatable(toggle, elemClasses.baseElement)
    toggle.class = 'toggle'

    local instances = {}
    do
        local controlFrame = Instance.new('Frame')
        controlFrame.BackgroundTransparency = 1
        controlFrame.Size = UDim2.new(1, 0, 0, 20)
        controlFrame.ZIndex = 34

        local clickRegion = Instance.new('TextButton')
        clickRegion.BackgroundTransparency = 1
        clickRegion.Size = UDim2.fromScale(1, 1)
        clickRegion.Text = ''
        clickRegion.ZIndex = 34
        clickRegion.Parent = controlFrame

        local label = Instance.new('TextLabel')
        label.BackgroundTransparency = 1
        label.Font = 'SourceSans'
        label.Size = UDim2.fromScale(1, 1)
        label.Text = 'Toggle'
        label.TextColor3 = theme.TextPrimary
        label.TextSize = 14
        label.TextStrokeColor3 = theme.TextStroke
        label.TextStrokeTransparency = 0.8
        label.TextXAlignment = 'Left'
        label.TextYAlignment = 'Center'
        label.ZIndex = 35
        label.Parent = clickRegion

        local padding = Instance.new('UIPadding')
        padding.PaddingLeft = UDim.new(0, 6)
        padding.Parent = label

        local toggleBtn = Instance.new('Frame')
        toggleBtn.AnchorPoint = Vector2.new(1, 0)
        toggleBtn.BackgroundColor3 = theme.Button1
        toggleBtn.Position = UDim2.new(1, -3, 0, 2)
        toggleBtn.Size = UDim2.fromOffset(16, 16)
        toggleBtn.ZIndex = 35
        toggleBtn.Parent = clickRegion

        local round = Instance.new('UICorner')
        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
        round.Parent = toggleBtn

        local stroke = Instance.new('UIStroke')
        stroke.ApplyStrokeMode = 'Border'
        stroke.Color = theme.Stroke
        stroke.LineJoinMode = 'Round'
        stroke.Thickness = 1
        stroke.Parent = toggleBtn

        local icon = Instance.new('ImageLabel')
        icon.BackgroundTransparency = 1
        icon.Image = 'rbxassetid://9801460300'
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        icon.Size = UDim2.fromScale(1, 1)
        icon.ZIndex = 35
        icon.Parent = toggleBtn

        local gradient = Instance.new('UIGradient')
        gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
        gradient.Rotation = 90
        gradient.Parent = icon

        instances.controlFrame = controlFrame
        instances.clickRegion = clickRegion
        instances.toggleBtn = toggleBtn
        instances.label = label
        instances.icon = icon
    end
    toggle.instances = instances

    toggle.toggled = false
    toggle.focused = false

    toggle.enable = function(self)
        self.toggled = true
        self.instances.icon.Image = 'rbxassetid://9642646619'
        tween(self.instances.icon, {ImageColor3 = theme.Primary, Rotation = 45}, 0.3, 1)
        if self.focused then tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button4}, 0.2, 1) else tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button3}, 0.2, 1) end
        self:fireEvent('onEnable')
        return self
    end

    toggle.disable = function(self)
        self.toggled = false
        self.instances.icon.Image = 'rbxassetid://9801460300'
        tween(self.instances.icon, {ImageColor3 = Color3.fromRGB(255, 255, 255), Rotation = 0}, 0.3, 1)
        if self.focused then tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button2}, 0.2, 1) else tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button1}, 0.2, 1) end
        self:fireEvent('onDisable')
        return self
    end

    toggle.click = function(self)
        if self.toggled then self:disable() else self:enable() end
        self:fireEvent('onToggle', self.toggled)
        return self
    end

    toggle.signals = {
        clickRegion = {
            MouseEnter = function(inst, self) self.focused = true if self.toggled then tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button4}, 0.2, 1) else tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button2}, 0.2, 1) end tween(self.instances.toggleBtn['#stroke'], {Color = theme.StrokeHover}, 0.2, 1) end,
            MouseLeave = function(inst, self) self.focused = false if self.toggled then tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button3}, 0.2, 1) else tween(self.instances.toggleBtn, {BackgroundColor3 = theme.Button1}, 0.2, 1) end tween(self.instances.toggleBtn['#stroke'], {Color = theme.Stroke}, 0.2, 1) end,
            MouseButton1Click = function(inst, self) self:click() end
        }
    }

    toggle.new = function(self)
        local new = setmetatable({}, self)
        new.binds = {}

        local instances = {}
        instances.controlFrame = self.instances.controlFrame:Clone()
        instances.clickRegion = instances.controlFrame['#click-region']
        instances.toggleBtn = instances.clickRegion['#toggle']
        instances.label = instances.clickRegion['#label']
        instances.icon = instances.toggleBtn['#icon']

        for i, signals in pairs(self.signals) do
            local inst = instances[i]
            for signal, func in pairs(signals) do
                inst[signal]:Connect(function() func(inst, new) end)
            end
        end

        new.instances = instances
        return new
    end

    elemClasses.section.addToggle = function(self, settings, callback)
        if not settings or type(settings) ~= 'table' then return error('expected type table for settings', 2) end
        local s_title = settings.text or 'nil'
        local s_enabled = settings.enabled or false

        local toggle = elemClasses.toggle:new()
        toggle.section = self
        toggle.name = s_title
        table.insert(self.controls, toggle)

        toggle.instances.label.Text = s_title
        if s_enabled then toggle:enable() end
        toggle.instances.controlFrame.Parent = self.instances.controlMenu

        if type(callback) == 'function' then toggle:bindToEvent('onToggle', callback) end
        return toggle
    end

    elemClasses.toggle = toggle
end

-- Класс Hotkey
do
    local hotkey = {__index = hotkey}
    setmetatable(hotkey, elemClasses.baseElement)
    hotkey.class = 'hotkey'

    local instances = {}
    do
        local controlFrame = Instance.new('Frame')
        controlFrame.BackgroundTransparency = 1
        controlFrame.Size = UDim2.new(1, 0, 0, 20)
        controlFrame.ZIndex = 34

        local back = Instance.new('TextButton')
        back.BackgroundTransparency = 1
        back.Size = UDim2.fromScale(1, 1)
        back.Text = ''
        back.ZIndex = 34
        back.Parent = controlFrame

        local label = Instance.new('TextLabel')
        label.BackgroundTransparency = 1
        label.Font = 'SourceSans'
        label.Size = UDim2.fromScale(1, 1)
        label.Text = 'Hotkey'
        label.TextColor3 = theme.TextPrimary
        label.TextSize = 14
        label.TextStrokeColor3 = theme.TextStroke
        label.TextStrokeTransparency = 0.8
        label.TextXAlignment = 'Left'
        label.TextYAlignment = 'Center'
        label.ZIndex = 35
        label.Parent = back

        local padding = Instance.new('UIPadding')
        padding.PaddingLeft = UDim.new(0, 6)
        padding.Parent = label

        local hotkeyLabel = Instance.new('TextLabel')
        hotkeyLabel.AnchorPoint = Vector2.new(1, 0)
        hotkeyLabel.BackgroundTransparency = 1
        hotkeyLabel.Font = 'SourceSans'
        hotkeyLabel.Position = UDim2.new(1, -3, 0, 2)
        hotkeyLabel.Size = UDim2.fromOffset(16, 16)
        hotkeyLabel.Text = '[None]'
        hotkeyLabel.TextColor3 = theme.TextDim
        hotkeyLabel.TextSize = 14
        hotkeyLabel.TextStrokeColor3 = theme.TextStroke
        hotkeyLabel.TextStrokeTransparency = 0.8
        hotkeyLabel.TextXAlignment = 'Right'
        hotkeyLabel.TextYAlignment = 'Center'
 PN       hotkeyLabel.ZIndex = 35
        hotkeyLabel.Parent = back

        instances.controlFrame = controlFrame
        instances.back = back
        instances.label = label
        instances.hotkey = hotkeyLabel
    end
    hotkey.instances = instances

    hotkey.set = nil
    hotkey.hotkey = nil
    hotkey.focused = false
    hotkey.inputCon = nil

    hotkey.click = function(self)
        if self.inputCon then return end
        local display = self.instances.hotkey
        tween(display, {TextColor3 = theme.Primary}, 0.3, 1)
        self.inputCon = inputService.InputBegan:Connect(function(io, gpe)
            local kc = io.KeyCode.Name
            if kc == 'Unknown' or kc == 'Escape' then
                self.hotkey = nil
                display.Text = '[None]'
                self.inputCon:Disconnect()
                self.inputCon = nil
                if self.focused then tween(display, {TextColor3 = theme.TextPrimary}, 0.3, 1) else tween(display, {TextColor3 = theme.TextDim}, 0.3, 1) end
            else
                self.hotkey = io.KeyCode
                self.set = time()
                display.Text = ('[%s]'):format(kc)
                self.inputCon:Disconnect()
                self.inputCon = nil
                if self.focused then tween(display, {TextColor3 = theme.TextPrimary}, 0.3, 1) else tween(display, {TextColor3 = theme.TextDim}, 0.3, 1) end
            end
        end)
        return self
    end

    hotkey.__hotkeyFunc = hotkey.click

    hotkey.signals = {
        back = {
            MouseEnter = function(inst, self) self.focused = true if self.inputCon then tween(self.instances.hotkey, {TextColor3 = theme.Primary}, 0.2, 1) else tween(self.instances.hotkey, {TextColor3 = theme.TextPrimary}, 0.2, 1) end end,
            MouseLeave = function(inst, self) self.focused = false if self.inputCon then tween(self.instances.hotkey, {TextColor3 = theme.Primary}, 0.2, 1) else tween(self.instances.hotkey, {TextColor3 = theme.TextDim}, 0.2, 1) end end,
            MouseButton1Click = function(inst, self) self:click() end
        }
    }

    hotkey.new = function(self)
        local new = setmetatable({}, self)
        new.binds = {}

        local instances = {}
        instances.controlFrame = self.instances.controlFrame:Clone()
        instances.back = instances.controlFrame['#back']
        instances.label = instances.back['#label']
        instances.hotkey = instances.back['#hotkey']

        for i, signals in pairs(self.signals) do
            local inst = instances[i]
            for signal, func in pairs(signals) do
                inst[signal]:Connect(function() func(inst, new) end)
            end
        end

        table.insert(ui.hotkeys, new)
        new.instances = instances
        return new
    end

    hotkey.linkToControl = function(self, control)
        if control and not control.__hotkeyFunc then return error('couldn\'t find control function', 2) end
        self.linkedControl = control
        return self
    end

    hotkey.setHotkey = function(self, hotkey)
        if hotkey then
            if typeof(hotkey) == 'EnumItem' and hotkey.EnumType == Enum.KeyCode then
                self.hotkey = hotkey
                self.instances.hotkey.Text = ('[%s]'):format(hotkey.Name)
            elseif Enum.KeyCode[hotkey] then
                self.hotkey = Enum.KeyCode[hotkey]
                self.instances.hotkey.Text = ('[%s]'):format(self.hotkey.Name)
            else
                return error('expected valid Enum.KeyCode Name, or Enum.KeyCode EnumItem', 2)
            end
        else
            self.hotkey = nil
            self.instances.hotkey.Text = '[None]'
        end
    end

    elemClasses.section.addHotkey = function(self, settings)
        if not settings or type(settings) ~= 'table' then return error('expected type table for settings', 2) end
        local s_title = settings.text or 'nil'
        local s_bind = settings.bind or nil

        if s_bind then
            if typeof(s_bind) == 'EnumItem' and s_bind.EnumType == Enum.KeyCode then
                s_bind = s_bind
            elseif Enum.KeyCode[s_bind] then
                s_bind = Enum.KeyCode[s_bind]
            else
                return error('expected valid Enum.KeyCode Name, or Enum.KeyCode EnumItem', 2)
            end
        end

        local hotkey = elemClasses.hotkey:new()
        hotkey.section = self
        hotkey.name = s_title
        table.insert(self.controls, hotkey)

        hotkey.instances.label.Text = s_title
        if s_bind then hotkey:setHotkey(s_bind) end
        hotkey.instances.controlFrame.Parent = self.instances.controlMenu
        return hotkey
    end

    elemClasses.hotkey = hotkey
end

-- Класс Notification
do
    local notif = {__index = notif}
    setmetatable(notif, elemClasses.baseElement)
    notif.class = 'notif'

    local instances = {}
    do
        local main = Instance.new('Frame')
        main.AnchorPoint = Vector2.new(1, 1)
        main.BackgroundColor3 = theme.Window2
        main.Size = UDim2.fromOffset(175, 100)
        main.ZIndex = 3000

        local stroke = Instance.new('UIStroke')
        stroke.ApplyStrokeMode = 'Border'
        stroke.Color = theme.Stroke
        stroke.LineJoinMode = 'Round'
        stroke.Thickness = 1
        stroke.Parent = main

        local shadow = Instance.new('ImageLabel')
        shadow AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.BackgroundTransparency = 1
        shadow.Image = 'rbxassetid://7331400934'
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
        shadow.Position = UDim2.fromScale(0.5, 0.5)
        shadow.ScaleType = 'Slice'
        shadow.Size = UDim2.new(1, 50, 1, 50)
        shadow.SliceCenter = Rect.new(40, 40, 260, 260)
        shadow.ZIndex = 2999
        shadow.Parent = main

        local trim = Instance.new('Frame')
        trim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        trim.Position = UDim2.fromOffset(0, -1)
        trim.Size = UDim2.new(1, 0, 0, 1)
        trim.ZIndex = 3005
        trim.Parent = main

        local gradient = Instance.new('UIGradient')
        gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
        gradient.Rotation = 0
        gradient.Parent = trim

        local titleBar = Instance.new('Frame')
        titleBar.BackgroundColor3 = theme.Window1
        titleBar.BorderColor3 = theme.Inset1
        titleBar.BorderMode = 'Inset'
        titleBar.BorderSizePixel = 1
        titleBar.Size = UDim2.new(1, 0, 0, 26)
        titleBar.ZIndex = 3001
        titleBar.Parent = main

        local strokeTitle = Instance.new('UIStroke')
        strokeTitle.ApplyStrokeMode = 'Border'
        strokeTitle.Color = theme.Stroke
        strokeTitle.LineJoinMode = 'Round'
        strokeTitle.Thickness = 1
        strokeTitle.Parent = titleBar

        local title = Instance.new('TextLabel')
        title.BackgroundTransparency = 1
        title.Font = 'SourceSans'
        title.Position = UDim2.fromOffset(24, 0)
        title.Size = UDim2.new(1, -22, 1, 0)
        title.Text = 'Notification'
        title.TextColor3 = theme.TextPrimary
        title.TextSize = 17
        title.TextStrokeColor3 = theme.TextStroke
        title.TextStrokeTransparency = 0.8
        title.TextXAlignment = 'Left'
        title.TextYAlignment = 'Center'
        title.ZIndex = 3002
        title.Parent = titleBar

        local padding = Instance.new('UIPadding')
        padding.PaddingLeft = UDim.new(0, 4)
        padding.Parent = title

        local region = Instance.new('Frame')
        region.BackgroundColor3 = theme.Window2
        region.BorderColor3 = theme.Inset2
        region.BorderMode = 'Inset'
        region.BorderSizePixel = 1
        region.Position = UDim2.fromOffset(0, 27)
        region.Size = UDim2.new(1, 0, 1, -27)
        region.ZIndex = 3001
        region.Parent = main

        local desc = Instance.new('TextLabel')
        desc.BackgroundTransparency = 1
        desc.Font = 'SourceSans'
        desc.Size = UDim2.fromScale(1, 1)
        desc.Text = 'Notification'
        desc.TextColor3 = theme.TextPrimary
        desc.TextSize = 14
        desc.TextStrokeColor3 = theme.TextStroke
        desc.TextStrokeTransparency = 0.8
        desc.TextWrapped = true
        desc.TextXAlignment = 'Left'
        desc.TextYAlignment = 'Top'
        desc.ZIndex = 3002
        desc.Parent = region

        local paddingDesc = Instance.new('UIPadding')
        paddingDesc.PaddingLeft = UDim.new(0, 6)
        paddingDesc.PaddingTop = UDim.new(0, 6)
        paddingDesc.Parent = desc

        instances.main = main
        instances.title = title
        instances.desc = desc
    end
    notif.instances = instances

    notif.destroy = function(self)
        local main = self.instances.main
        task.spawn(function()
            local animCon
            task.spawn(function()
                local backgroundTransparency, imageTransparency, textTransparency, transparency = {}, {}, {}, {}
                local s = {Frame = {backgroundTransparency}, ImageLabel = {backgroundTransparency, imageTransparency}, TextLabel = {backgroundTransparency, textTransparency}, UIStroke = {transparency}}
                local d = main:GetDescendants()
                table.insert(d, main)
                for _, v in ipairs(d) do local a = s[v.ClassName] if a then for i = 1, #a do table.insert(a[i], v) end end end
                for _, v in ipairs(transparency) do v.Transparency = 1 v:Destroy() end
                animCon = renderService.RenderStepped:Connect(function(dt)
                    dt *= 8
                    for _, v in ipairs(backgroundTransparency) do v.BackgroundTransparency += dt end
                    for _, v in ipairs(imageTransparency) do v.ImageTransparency += dt end
                    for _, v in ipairs(textTransparency) do v.TextTransparency += dt end
                end)
            end)
            tween(main, {Size = UDim2.fromOffset(main.AbsoluteSize.X, 0)}, 0.5, 1).Completed:Wait()
            animCon:Disconnect()
            main:Destroy()
        end)
        return self
    end

    notif.setTitle = function(self, title) self.instances.title.Text = tostring(title) return self end
    notif.setDesc = function(self, text)
        local desc = self.instances.desc
        local main = self.instances.main
        desc.Text = tostring(text)
        local c = 0
        while true do
            c += 1
            if c > 31 then break end
            local _ = desc.TextFits
            if desc.TextFits then break end
            main.Size += UDim2.fromOffset(0, 20)
        end
        return self
    end

    notif.new = function(self)
        local new = setmetatable({}, self)
        new.binds = {}

        local instances = {}
        instances.main = self.instances.main:Clone()
        instances.title = instances.main['#title-bar']['#title']
        instances.desc = instances.main['#region']['#desc']

        instances.main.Parent = uiScreen['#notif-container']
        new.instances = instances
        return new
    end

    elemClasses.notif = notif
end

-- UI методы
do
    setmetatable(ui, elemClasses.baseElement)
    ui.class = 'ui'
    ui.binds = {}

    ui.newWindow = function(settings)
        if not settings or type(settings) ~= 'table' then return error('expected type table for settings', 2) end
        local s_title = settings.text or 'nil'
        local s_resize = settings.resize or false
        local s_position = settings.position or defaultWinPos
        defaultWinPos += UDim2.fromScale(0.02, 0.02)

        local window = elemClasses.window:new(s_resize)
        local s_winSize = settings.size or window.size
        if typeof(s_winSize) == 'Vector2' then s_winSize = UDim2.fromOffset(s_winSize.X, s_winSize.Y) end

        window:setPosition(s_position)
        window:setTitle(s_title)
        window.size = s_winSize

        task.spawn(function()
            local mainFrame = window.instances.mainFrame
            mainFrame.Size = UDim2.fromOffset(s_winSize.X.Offset, 30)
            tween(mainFrame, {Size = s_winSize}, 0.5, 1)
        end)

        return window
    end

    ui.destroy = function(noWindows)
        ui:fireEvent('onPreDestroy')
        delay(0.4, function() uiScreen:Destroy() uiScreen = nil end)
        if not noWindows then for _, win in ipairs(ui.windows) do win:destroy() end end
        for _, v in pairs(elemClasses) do if v.instances then for _, inst in pairs(v.instances) do inst:Destroy() end end end
        ui.hkCon:Disconnect()
        for _, hotkey in ipairs(ui.hotkeys) do if hotkey.inputCon then hotkey.inputCon:Disconnect() end end
        ui:fireEvent('onDestroy')
        for _, v in pairs(ui.scriptCns) do v:Disconnect() end
    end

    ui.notify = function(settings)
        local s_title = settings.title or 'nil'
        local s_desc = settings.message or 'nil'
        local s_duration = settings.duration or 2
        if type(s_duration) ~= 'number' then return error('expected type \'number\' for setting \'duration\'', 2) end

        local startingOffset = 0
        for _, n in ipairs(ui.notifs) do startingOffset += n.size.Y.Offset + 20 end

        local notif = elemClasses.notif:new()
        local main = notif.instances.main
        main.Position = UDim2.new(4, 0, 1, -startingOffset)
        main.Parent = uiScreen['#notif-container']

        notif:setTitle(s_title)
        notif:setDesc(s_desc)

        notif.size = main.Size
        table.insert(ui.notifs, notif)

        tween(main, {Position = UDim2.new(1, 0, 1, -startingOffset)}, 0.3, 1)
        task.delay(s_duration, function()
            notif:destroy()
            table.remove(ui.notifs, table.find(ui.notifs, notif))
            local mainPos = main.AbsolutePosition.Y
            for _, n in ipairs(ui.notifs) do
                local nmain = n.instances.main
                if nmain.AbsolutePosition.Y > mainPos then continue end
                local p = UDim2.new(1, 0, 1, nmain.Position.Y.Offset + 20 + notif.size.Y.Offset)
                tween(nmain, {Position = p}, 0.3, 1)
            end
        end)
    end

    ui.hkCon = inputService.InputBegan:Connect(function(io, gpe)
        if not gpe and io.UserInputType.Name == 'Keyboard' then
            local kc = io.KeyCode
            for _, hotkey in ipairs(ui.hotkeys) do
                if hotkey.hotkey == kc and hotkey.set ~= time() then
                    local linkedControl = hotkey.linkedControl
                    if linkedControl then task.spawn(linkedControl.__hotkeyFunc, linkedControl) end
                end
            end
        end
    end)
end

return ui
