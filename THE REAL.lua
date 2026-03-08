--[[ BIZARRE LINEAGE LITE INTERNAL V43 | REFACTORED UPDATE | REGISTER SAFE | SOLID 0 ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local getgenv = getgenv or function() return _G end
if getgenv().LiteExtremeLoaded then return end
getgenv().LiteExtremeLoaded = true

local Players = game:GetService('Players')
local Http = game:GetService('HttpService')
local Tween = game:GetService('TweenService')
local UIS = game:GetService('UserInputService')
local RS = game:GetService('RunService')
local TS = game:GetService('TeleportService')
local VU = game:GetService('VirtualUser')
local VIM = game:GetService('VirtualInputManager')
local CS = game:GetService('CollectionService')
local Lighting = game:GetService('Lighting')
local Stats = game:GetService('Stats')
local Client = Players.LocalPlayer
local CoreGui = game:GetService('CoreGui')

local Vector3now, Vector2now, CFramenow = Vector3.new, Vector2.new, CFrame.new
local UDim2now, Color3now = UDim2.new, Color3.fromRGB
local math_floor, math_clamp, math_rad = math.floor, math.clamp, math.rad

local State = {
    TrueInstinct = false,
    GodModeActive = false,
    CurrentFarmTarget = nil,
    QueueLoader = nil,
}

local Settings = {
    MenuKey='Insert', MasterKey='K', AutoFarm=false, TargetRange=500, SafeTP=true, GodModeActive=false,
    NPC_ESP=true, Boss_ESP=true, Player_ESP=true, Item_ESP=true,
    NPC_ESPColor=Color3now(255,230,0), Boss_ESPColor=Color3now(255,60,60),
    Player_ESPColor=Color3now(0,255,100), Item_ESPColor=Color3now(150,255,120),
    ItemESPRange=1000, AutoItemFarm=false, ShowMapItems=false,
    FarmAngle='Below (Default)', FarmDist=7, FarmOnlyBoss=true,
    AutoM1=false, AutoSkillE=false, AutoSkillR=false, AutoSkillZ=false, AutoSkillX=false, AutoSkillC=false, AutoSkillV=false,
    AutoRaid=false, RaidAutoEnter=true, RaidAutoRetry=true, RaidDelay=0.5,
    WalkSpeed=16, JumpPower=50, UITransparency=0, ConfigName='LiteExtreme_V43', FarmTargetName='',
    AutoRoka=false, EngineActive=true, AdvancedScan=false, ScanInterval=1.5,
    AutoPlayAgain=true, ClickSpeed=0.015, MacroInterval=0.02, AutoRejoin=true,
    AutoDialog=true, StealthMode=false, AntiAFK=true
}

local function LoadConfig()
    local s, err = pcall(function()
        if isfile(Settings.ConfigName .. ".json") then
            local contents = readfile(Settings.ConfigName .. ".json")
            if contents then
                local d = Http:JSONDecode(contents)
                for k,v in pairs(d) do Settings[k] = v end
            end
        end
    end)
    if not s then warn("[LiteExtreme] Load config failed:", err) end
end
LoadConfig()

local function SaveConfig()
    local s, err = pcall(function()
        writefile(Settings.ConfigName .. ".json", Http:JSONEncode(Settings))
    end)
    if not s then warn("[LiteExtreme] Save config failed:", err) end
end

local AccentColor = Color3now(0, 255, 100)
local SecondaryGreen = Color3now(20, 60, 30)
local DarkBg = Color3now(5, 12, 8)

local WikiData = {
    {Name='TIME STOP DOMINATOR', Stand='The World', SubAbility='Hamon', Style='Boxing', Desc='High DPS build for time stops.', Img='rbxassetid://13110298083'},
    {Name='SPEED DEMON', Stand='Made In Heaven', SubAbility='Cyborg', Style='Karate', Desc='Hit-and-run battle style.', Img='rbxassetid://13110298083'},
    {Name='VAMPIRE TANK', Stand='Stone Free', SubAbility='Vampire', Style='Kendo', Desc='High survivability.', Img='rbxassetid://13110298083'},
    {Name='RANGED POKER', Stand='Weather Report', SubAbility='Spin', Style='Kendo', Desc='Area control build.', Img='rbxassetid://13110298083'},
    {Name='Common Chest', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Low level materials.', Img='rbxassetid://13110298083'},
    {Name='Rare Chest', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Reliable Yen source.', Img='rbxassetid://13110298083'},
    {Name='Legendary Chest', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Guaranteed rare items.', Img='rbxassetid://13110298083'},
    {Name='Stat Reset Essence', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Resets stat points.', Img='rbxassetid://7335967073'},
    {Name='Personality Reroll', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Rerolls stand personality.', Img='rbxassetid://7335967073'},
    {Name='Vampire Mask', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Become a vampire.', Img='rbxassetid://13110298083'},
    {Name='Stand Arrow', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Awaken a Stand.', Img='rbxassetid://13110298083'},
    {Name='Lucky Arrow', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Guarantees a Skin.', Img='rbxassetid://13110298083'},
    {Name='Rokakaka Fruit', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Resets Stand.', Img='rbxassetid://13110298083'},
    {Name='Red Stone of Aja', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Evolve abilities.', Img='rbxassetid://13110298083'}
}

local UI_Master = {Pages = {}, Buttons = {}, Elements = {}}
function UI_Master:Init()
    local SG = Instance.new('ScreenGui', CoreGui); SG.Name = 'BizarreLiteExtreme_V43'; SG.IgnoreGuiInset = true; SG.ResetOnSpawn = false
    local Main = Instance.new('Frame', SG); Main.Size = UDim2now(0, 960, 0, 680); Main.Position = UDim2now(0.5, -480, 0.5, -340); Main.BackgroundColor3 = DarkBg; Main.BackgroundTransparency = 0.15; Main.BorderSizePixel = 0; Instance.new('UICorner', Main).CornerRadius = UDim.new(0, 8)
    local Sidebar = Instance.new('Frame', Main); Sidebar.Size = UDim2now(0, 200, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(8, 20, 10); Sidebar.BackgroundTransparency = 0.2; Sidebar.BorderSizePixel = 1; Sidebar.BorderColor3 = AccentColor
    
    local Branding = Instance.new('TextLabel', Sidebar); Branding.Size = UDim2now(1, 0, 0, 80); Branding.Text = 'LITE EXTREME'; Branding.TextColor3 = Color3.new(1,1,1); Branding.Font = Enum.Font.GothamBold; Branding.TextSize = 22; Branding.BackgroundTransparency = 1
    
    local IdentityPanel = Instance.new('Frame', Sidebar); IdentityPanel.Size = UDim2now(1, -16, 0, 130); IdentityPanel.Position = UDim2now(0, 8, 1, -140); IdentityPanel.BackgroundColor3 = Color3.new(0,0,0); IdentityPanel.BackgroundTransparency = 0; Instance.new('UICorner', IdentityPanel)
    local alb = Instance.new('ImageLabel', IdentityPanel); alb.Size = UDim2now(0, 46, 0, 46); alb.Position = UDim2now(0, 8, 0, 8); alb.Image = 'rbxthumb://type=AvatarHeadShot&id='..Client.UserId..'&w=150&h=150'; alb.BackgroundTransparency = 1; Instance.new('UICorner', alb).CornerRadius = UDim.new(1, 0)
    local sng = Instance.new('TextLabel', IdentityPanel); sng.Size = UDim2now(1, -60, 0, 18); sng.Position = UDim2now(0, 60, 0, 8); sng.Text = Client.DisplayName or Client.Name; sng.TextColor3 = Color3.new(1,1,1); sng.Font = Enum.Font.GothamBold; sng.TextSize = 13; sng.TextXAlignment = 0; sng.BackgroundTransparency = 1; sng.ClipsDescendants = true
    local playT = Instance.new('TextLabel', IdentityPanel); playT.Name = "PT"; playT.Size = UDim2now(1, -16, 0, 14); playT.Position = UDim2now(0, 8, 0, 60); playT.Text = 'Playtime: 0h 0m'; playT.TextColor3 = Color3.fromRGB(200, 200, 200); playT.Font = Enum.Font.Gotham; playT.TextSize = 13; playT.TextXAlignment = 0; playT.BackgroundTransparency = 1
    local yenT = Instance.new('TextLabel', IdentityPanel); yenT.Name = "YT"; yenT.Size = UDim2now(1, -16, 0, 14); yenT.Position = UDim2now(0, 8, 0, 80); yenT.Text = 'Yen: 0'; yenT.TextColor3 = Color3.fromRGB(240, 215, 0); yenT.Font = Enum.Font.Gotham; yenT.TextSize = 13; yenT.TextXAlignment = 0; yenT.BackgroundTransparency = 1
    local totalYen = Instance.new('TextLabel', IdentityPanel); totalYen.Name = "TY"; totalYen.Size = UDim2now(1, -16, 0, 14); totalYen.Position = UDim2now(0, 8, 0, 100); totalYen.Text = 'Total Yen: 0'; totalYen.TextColor3 = Color3.fromRGB(255, 190, 0); totalYen.Font = Enum.Font.GothamBold; totalYen.TextSize = 13; totalYen.TextXAlignment = 0; totalYen.BackgroundTransparency = 1
    
    local Content = Instance.new('Frame', Main); Content.Size = UDim2now(1, -220, 1, -80); Content.Position = UDim2now(0, 210, 0, 65); Content.BackgroundTransparency = 1
    local TopBar = Instance.new('Frame', Main); TopBar.Size = UDim2now(1, -200, 0, 65); TopBar.Position = UDim2now(0, 200, 0, 0); TopBar.BackgroundColor3 = Color3.fromRGB(8, 20, 10); TopBar.BorderSizePixel = 1; TopBar.BorderColor3 = AccentColor
    
    local Title = Instance.new('TextLabel', TopBar); Title.Size = UDim2now(0, 250, 1, 0); Title.Position = UDim2now(0, 20, 0, 0); Title.Text = 'BIZARRE LINEAGE'; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0
    
    local StatusBox = Instance.new('Frame', TopBar); StatusBox.Size = UDim2now(0, 140, 0, 45); StatusBox.Position = UDim2now(1, -160, 0, 10); StatusBox.BackgroundColor3 = Color3.fromRGB(10, 30, 15); StatusBox.BackgroundTransparency = 0.2; Instance.new('UICorner', StatusBox)
    local fpsL = Instance.new('TextLabel', StatusBox); fpsL.Size = UDim2now(1, 0, 1, 0); fpsL.Text = 'FPS: 0'; fpsL.TextColor3 = AccentColor; fpsL.Font = Enum.Font.GothamBold; fpsL.TextSize = 14; fpsL.BackgroundTransparency = 1
    
    local ItemPanel = Instance.new('Frame', Main); ItemPanel.Size = UDim2now(0, 200, 1, 0); ItemPanel.Position = UDim2now(1, 15, 0, 0); ItemPanel.BackgroundColor3 = DarkBg; ItemPanel.BackgroundTransparency = 0.15; ItemPanel.BorderSizePixel = 1; ItemPanel.BorderColor3 = AccentColor
    local iT = Instance.new('TextLabel', ItemPanel); iT.Size = UDim2now(1, 0, 0, 40); iT.Text = 'MAP ITEMS'; iT.TextColor3 = AccentColor; iT.Font = Enum.Font.GothamBold; iT.TextSize = 16; iT.BackgroundTransparency = 1
    local iList = Instance.new('ScrollingFrame', ItemPanel); iList.Name = "List"; iList.Size = UDim2now(1, -10, 1, -50); iList.Position = UDim2now(0, 5, 0, 40); iList.BackgroundTransparency = 1; iList.BorderSizePixel = 0; iList.ScrollBarThickness = 2; iList.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UIListLayout", iList).Padding = UDim.new(0, 2)

    -- DETAILS POPUP OVERLAY
    local PopupOverlay = Instance.new("Frame", Main); PopupOverlay.Size = UDim2now(1, -200, 1, 0); PopupOverlay.Position = UDim2now(0, 200, 0, 0); PopupOverlay.BackgroundColor3 = Color3.new(0,0,0); PopupOverlay.BackgroundTransparency = 0; PopupOverlay.ZIndex = 50; PopupOverlay.Visible = false
    local PopImg = Instance.new("ImageLabel", PopupOverlay); PopImg.Size = UDim2now(0, 300, 0, 300); PopImg.Position = UDim2now(0.5, -150, 0.1, 0); PopImg.BackgroundTransparency = 1; PopImg.ZIndex = 51
    local PopTitle = Instance.new("TextLabel", PopupOverlay); PopTitle.Size = UDim2now(1, 0, 0, 40); PopTitle.Position = UDim2now(0, 0, 0.2, 310); PopTitle.TextColor3 = Color3.new(1,1,1); PopTitle.Font = Enum.Font.GothamBold; PopTitle.TextSize = 28; PopTitle.BackgroundTransparency = 1; PopTitle.ZIndex = 51
    local PopDesc = Instance.new("TextLabel", PopupOverlay); PopDesc.Size = UDim2now(0.8, 0, 0, 200); PopDesc.Position = UDim2now(0.1, 0, 0.2, 360); PopDesc.TextColor3 = Color3.new(1,1,1); PopDesc.Font = Enum.Font.Gotham; PopDesc.TextSize = 16; PopDesc.TextWrapped = true; PopDesc.TextYAlignment = Enum.TextYAlignment.Top; PopDesc.BackgroundTransparency = 1; PopDesc.ZIndex = 51
    local PopBack = Instance.new("TextButton", PopupOverlay); PopBack.Size = UDim2now(0, 150, 0, 40); PopBack.Position = UDim2now(0.5, -75, 0.9, -20); PopBack.BackgroundColor3 = Color3.new(0,0,0); PopBack.TextColor3 = Color3.new(1,1,1); PopBack.Font = Enum.Font.GothamBold; PopBack.TextSize = 14; PopBack.Text = "BACK TO LIST"; PopBack.ZIndex = 51; Instance.new("UIStroke", PopBack).Color = Color3.new(1,1,1); Instance.new("UICorner", PopBack).CornerRadius = UDim.new(0, 4)
    PopBack.MouseButton1Click:Connect(function() PopupOverlay.Visible = false end)

    local GuardLabel = Instance.new("TextLabel", SG); GuardLabel.Size = UDim2now(0, 100, 0, 20); GuardLabel.Position = UDim2now(1, -210, 0, 10); GuardLabel.BackgroundTransparency = 1; GuardLabel.TextColor3 = Color3.new(1,1,1); GuardLabel.Font = Enum.Font.GothamBold; GuardLabel.TextSize = 14; GuardLabel.Text = "ENGINE: [LOCK]"; GuardLabel.TextXAlignment = Enum.TextXAlignment.Right; GuardLabel.Visible = true; GuardLabel.ZIndex = 100
    local GuardStroke = Instance.new("UIStroke", GuardLabel); GuardStroke.Color = Color3.new(0,0,0); GuardStroke.Thickness = 2

    local GuardZone = Instance.new("Frame", SG); GuardZone.Size = UDim2now(0, 250, 0, 80); GuardZone.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4); GuardZone.BackgroundTransparency = 0.92; GuardZone.BorderSizePixel = 0; GuardZone.Visible = false; GuardZone.ZIndex = 0
    local GZStroke = Instance.new("UIStroke", GuardZone); GZStroke.Color = Color3.new(0.4, 0.4, 0.4); GZStroke.Thickness = 1; GZStroke.Transparency = 0.8

    self.Elements = {Main=Main, Sidebar=Sidebar, Content=Content, FPS=fpsL, ItemList=iList, ItemPanel=ItemPanel, Popup=PopupOverlay, PopImg=PopImg, PopTitle=PopTitle, PopDesc=PopDesc, PT=playT, YT=yenT, TY=totalYen, Guard=GuardLabel, GuardZone=GuardZone}
    ItemPanel.Visible = Settings.ShowMapItems
end

function UI_Master:AddTab(name, index, icon)
    local b = Instance.new('TextButton', self.Elements.Sidebar); b.Size = UDim2now(1, -20, 0, 46); b.Position = UDim2now(0, 10, 0, 90 + (index-1)*54); b.BackgroundColor3 = Color3.fromRGB(15, 30, 20); b.BackgroundTransparency = 0.5; b.Text = '   ' .. name; b.TextColor3 = Color3.fromRGB(180, 220, 180); b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.TextXAlignment = 0; b.AutoButtonColor = false; Instance.new('UICorner', b)
    local im = Instance.new('ImageLabel', b); im.Size = UDim2now(0, 18, 0, 18); im.Position = UDim2now(0, 12, 0.5, -9); im.Image = icon or 'rbxassetid://6031230111'; im.BackgroundTransparency = 1; im.ImageColor3 = Color3.fromRGB(180, 220, 180)
    self.Buttons[name] = b; b.MouseButton1Click:Connect(function() self:Switch(name) end)
    local p = Instance.new('ScrollingFrame', self.Elements.Content); p.Size = UDim2now(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0; p.AutomaticCanvasSize = Enum.AutomaticSize.Y; local llo = Instance.new('UIListLayout', p); llo.Padding = UDim.new(0, 8); llo.SortOrder = Enum.SortOrder.LayoutOrder; self.Pages[name] = p
end

function UI_Master:Switch(name)
    for k, v in pairs(self.Pages) do v.Visible = (k == name) end
    for k, v in pairs(self.Buttons) do
        local act = (k == name)
        Tween:Create(v, TweenInfo.new(0.3), {
            BackgroundColor3 = act and SecondaryGreen or Color3now(15, 30, 20),
            BackgroundTransparency = act and 0.2 or 0.5,
            TextColor3 = act and AccentColor or Color3now(180, 220, 180)
        }):Play()
        local ic = v:FindFirstChildOfClass('ImageLabel')
        if ic then Tween:Create(ic, TweenInfo.new(0.3), {ImageColor3 = act and AccentColor or Color3now(180, 220, 180)}):Play() end
    end
    self.Elements.Popup.Visible = false
end

function UI_Master:AddToggle(page, label, key, tooltip)
    local state = Settings[key] or false
    local f = Instance.new("Frame", page); f.Size = UDim2now(1, -10, 0, 45); f.BackgroundColor3 = Color3now(15, 20, 15); f.BackgroundTransparency = 0.6; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3now(30, 40, 30)
    local t = Instance.new("TextLabel", f); t.Size = UDim2now(1, -60, 1, 0); t.Position = UDim2now(0, 60, 0, 0); t.Text = label; t.TextColor3 = Color3.new(0.9,0.9,0.9); t.Font = Enum.Font.GothamBold; t.TextSize = 14; t.TextXAlignment = 0; t.BackgroundTransparency = 1
    
    if tooltip then
        -- Add tooltip functionality
        local hoverEvent = Instance.new("TextLabel", f)
        hoverEvent.Size = UDim2now(0, 200, 0, 30)
        hoverEvent.Position = UDim2now(0, 60, 1, 5)
        hoverEvent.Text = tooltip
        hoverEvent.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        hoverEvent.BackgroundColor3 = Color3.new(0, 0, 0)
        hoverEvent.Font = Enum.Font.Gotham
        hoverEvent.TextSize = 12
        hoverEvent.Visible = false
        hoverEvent.ZIndex = 10
        Instance.new("UICorner", hoverEvent).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", hoverEvent).Color = AccentColor
        
        f.MouseEnter:Connect(function() hoverEvent.Visible = true end)
        f.MouseLeave:Connect(function() hoverEvent.Visible = false end)
    end

    local b = Instance.new("TextButton", f); b.Size = UDim2now(0, 40, 0, 20); b.Position = UDim2now(0, 10, 0.5, -10); b.BackgroundColor3 = state and AccentColor or Color3now(30, 35, 30); b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local i = Instance.new("Frame", b); i.Size = UDim2now(0, 16, 0, 16); i.Position = UDim2now(state and 1 or 0, state and -18 or 2, 0.5, -8); i.BackgroundColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", i).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function() 
        Settings[key] = not Settings[key]
        local s = Settings[key]
        Tween:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = s and AccentColor or Color3now(30, 35, 30)}):Play()
        Tween:Create(i, TweenInfo.new(0.2), {Position = UDim2now(s and 1 or 0, s and -18 or 2, 0.5, -8)}):Play() 
    end)
end

function UI_Master:AddSlider(page, label, key, min, max, sfx)
    local val = Settings[key] or min
    local f = Instance.new("Frame", page); f.Size = UDim2now(1, -10, 0, 55); f.BackgroundColor3 = Color3now(15, 20, 15); f.BackgroundTransparency = 0.6; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3now(30, 40, 30)
    local t = Instance.new("TextLabel", f); t.Size = UDim2now(1, -20, 0, 20); t.Position = UDim2now(0, 10, 0, 5); t.Text = label .. ": " .. tostring(val) .. (sfx or ""); t.TextColor3 = Color3.new(0.9,0.9,0.9); t.Font = Enum.Font.GothamBold; t.TextSize = 13; t.TextXAlignment = 0; t.BackgroundTransparency = 1
    local bg = Instance.new("Frame", f); bg.Size = UDim2now(1, -20, 0, 6); bg.Position = UDim2now(0, 10, 0, 35); bg.BackgroundColor3 = Color3now(30, 35, 30); Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    local pctI = math_clamp((val-min)/(max-min), 0, 1)
    local fl = Instance.new("Frame", bg); fl.Size = UDim2now(pctI, 0, 1, 0); fl.BackgroundColor3 = AccentColor; Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", fl); knob.Size = UDim2now(0, 14, 0, 14); knob.Position = UDim2now(1, -7, 0.5, -7); knob.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local kb = Instance.new("TextButton", f); kb.Size = UDim2now(1, -20, 0, 30); kb.Position = UDim2now(0, 10, 0, 20); kb.BackgroundTransparency = 1; kb.Text = ""
    local md = false
    kb.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then md = true; Tween:Create(knob, TweenInfo.new(0.1), {Size=UDim2now(0,18,0,18), Position=UDim2now(1,-9,0.5,-9)}):Play() end end)
    UIS.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then md = false; Tween:Create(knob, TweenInfo.new(0.1), {Size=UDim2now(0,14,0,14), Position=UDim2now(1,-7,0.5,-7)}):Play() end end)
    UIS.InputChanged:Connect(function(io) if md and io.UserInputType == Enum.UserInputType.MouseMovement then local pct = math_clamp((io.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1); Settings[key] = math_floor(min + ((max - min) * pct)); t.Text = label .. ": " .. Settings[key] .. (sfx or ""); fl.Size = UDim2now(pct, 0, 1, 0) end end)
end

function UI_Master:AddDropdown(page, label, key, options)
    local f = Instance.new("Frame", page); f.Size = UDim2now(1, -10, 0, 45); f.BackgroundColor3 = Color3now(15, 20, 15); f.BackgroundTransparency = 0.6; f.ZIndex = 2; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3now(30, 40, 30)
    local t = Instance.new("TextLabel", f); t.Size = UDim2now(0.5, 0, 1, 0); t.Position = UDim2now(0, 10, 0, 0); t.Text = label; t.TextColor3 = Color3.new(0.9,0.9,0.9); t.Font = Enum.Font.GothamBold; t.TextSize = 13; t.TextXAlignment = 0; t.BackgroundTransparency = 1; t.ZIndex = 2
    local b = Instance.new("TextButton", f); b.Size = UDim2now(0.45, 0, 0, 25); b.Position = UDim2now(0.55, -10, 0.5, -12); b.BackgroundColor3 = Color3now(8, 18, 10); b.Text = tostring(Settings[key]); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 12; b.ZIndex = 2; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", b).Color = AccentColor
    local drop = Instance.new("ScrollingFrame", f); drop.Size = UDim2now(0.45, 0, 0, math.min(#options * 25, 150)); drop.Position = UDim2now(0.55, -10, 1, 2); drop.BackgroundColor3 = Color3now(8, 18, 10); drop.Visible = false; drop.ScrollBarThickness = 2; drop.ZIndex = 10; Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", drop).Color = AccentColor
    local ll = Instance.new("UIListLayout", drop); ll.SortOrder = Enum.SortOrder.LayoutOrder
    b.MouseButton1Click:Connect(function() drop.Visible = not drop.Visible; f.ZIndex = drop.Visible and 10 or 2 end)
    for i, opt in ipairs(options) do
        local ob = Instance.new("TextButton", drop); ob.Size = UDim2now(1, 0, 0, 25); ob.BackgroundTransparency = 1; ob.Text = opt; ob.TextColor3 = Color3.new(0.8,0.8,0.8); ob.Font = Enum.Font.Gotham; ob.TextSize = 11; ob.ZIndex = 11
        ob.MouseButton1Click:Connect(function() Settings[key] = opt; b.Text = tostring(opt); drop.Visible = false; f.ZIndex = 2 end)
    end
end
function UI_Master:AddWikiSearch(page)
local f = Instance.new("Frame", page); f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundColor3 = DarkBg; f.BackgroundTransparency = 0; Instance.new("UIStroke", f).Color = AccentColor
local tb = Instance.new("TextBox", f); tb.Size = UDim2.new(1, -20, 1, 0); tb.Position = UDim2.new(0, 10, 0, 0); tb.BackgroundTransparency = 1; tb.Text = ""; tb.PlaceholderText = "Search item or build..."; tb.TextColor3 = Color3.new(1,1,1); tb.Font = Enum.Font.GothamBold; tb.TextSize = 14; tb.TextXAlignment = 0; tb.ClearTextOnFocus = false

local HeaderList = {"NAME", "STAND", "SUB-ABILITY", "FIGHTING STYLE", "ACTION"}
local hF = Instance.new("Frame", page); hF.Size = UDim2.new(1, -10, 0, 30); hF.BackgroundTransparency = 1
for i, txt in ipairs(HeaderList) do
    local l = Instance.new("TextLabel", hF); l.Size = UDim2.new(0.2, 0, 1, 0); l.Position = UDim2.new(0.2*(i-1), 0, 0, 0); l.BackgroundTransparency = 1
    l.Text = txt; l.TextColor3 = Color3.fromRGB(150, 180, 150); l.Font = Enum.Font.GothamBold; l.TextSize = 10; l.TextXAlignment = (i==1 and 0 or 1)
end

local function UpdateSearch()
    local q = tb.Text:lower()
    for _, child in ipairs(page:GetChildren()) do
        if child:IsA("Frame") and child.Name == "WikiEntry" then
            local nm = child:FindFirstChild("Col1") and child.Col1.Text:lower() or ""
            local match = (q == "") or string.find(nm, q)
            child.Visible = match
        end
    end
end
tb:GetPropertyChangedSignal("Text"):Connect(UpdateSearch)
end

function UI_Master:AddWikiEntry(page, data)
local f = Instance.new("Frame", page); f.Size = UDim2.new(1, -10, 0, 50); f.BackgroundColor3 = Color3.fromRGB(5, 12, 10); f.BackgroundTransparency = 0.1; f.Name = "WikiEntry"
local divider = Instance.new("Frame", f); divider.Size = UDim2.new(1, 0, 0, 1); divider.Position = UDim2.new(0, 0, 1, 0); divider.BackgroundColor3 = Color3.fromRGB(20, 40, 20); divider.BorderSizePixel = 0

local col1 = Instance.new("TextLabel", f); col1.Name = "Col1"; col1.Size = UDim2.new(0.2, 0, 1, 0); col1.Position = UDim2.new(0, 0, 0, 0); col1.Text = data.Name; col1.TextColor3 = Color3.new(1,1,1); col1.Font = Enum.Font.GothamBold; col1.TextSize = 10; col1.TextXAlignment = 0; col1.BackgroundTransparency = 1; col1.TextWrapped = true
local col2 = Instance.new("TextLabel", f); col2.Size = UDim2.new(0.2, 0, 1, 0); col2.Position = UDim2.new(0.2, 0, 0, 0); col2.Text = data.Stand; col2.TextColor3 = Color3.new(1,1,1); col2.Font = Enum.Font.Gotham; col2.TextSize = 11; col2.TextXAlignment = 1; col2.BackgroundTransparency = 1
local col3 = Instance.new("TextLabel", f); col3.Size = UDim2.new(0.2, 0, 1, 0); col3.Position = UDim2.new(0.4, 0, 0, 0); col3.Text = data.SubAbility; col3.TextColor3 = Color3.new(1,1,1); col3.Font = Enum.Font.Gotham; col3.TextSize = 11; col3.TextXAlignment = 1; col3.BackgroundTransparency = 1
local col4 = Instance.new("TextLabel", f); col4.Size = UDim2.new(0.2, 0, 1, 0); col4.Position = UDim2.new(0.6, 0, 0, 0); col4.Text = data.Style; col4.TextColor3 = Color3.new(1,1,1); col4.Font = Enum.Font.Gotham; col4.TextSize = 11; col4.TextXAlignment = 1; col4.BackgroundTransparency = 1

local btnFrame = Instance.new("Frame", f); btnFrame.Size = UDim2.new(0.2, 0, 1, 0); btnFrame.Position = UDim2.new(0.8, 0, 0, 0); btnFrame.BackgroundTransparency = 1
local detBtn = Instance.new("TextButton", btnFrame); detBtn.Size = UDim2.new(0, 80, 0, 28); detBtn.Position = UDim2.new(1, -80, 0.5, -14); detBtn.BackgroundColor3 = Color3.new(0,0,0); detBtn.TextColor3 = Color3.new(1,1,1); detBtn.Font = Enum.Font.Gotham; detBtn.TextSize = 12; detBtn.Text = "DETAIL"
Instance.new("UICorner", detBtn).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", detBtn).Color = Color3.new(0.7,0.7,0.7)

detBtn.MouseButton1Click:Connect(function()
    UI_Master.Elements.PopTitle.Text = data.Name
    UI_Master.Elements.PopDesc.Text = "\nSTAND: " .. data.Stand .. "\nSUB: " .. data.SubAbility .. "\nSTYLE: " .. data.Style .. "\n\n" .. data.Desc
    UI_Master.Elements.PopImg.Image = data.Img
    UI_Master.Elements.Popup.Visible = true
end)
end

UI_Master:Init()
local Tabs = {'Dashboard', 'Combat', 'Skills', 'ESP', 'Farming', 'Raid', 'Tools', 'Teleport', 'Misc', 'Wiki', 'Settings'}
for i, t in ipairs(Tabs) do UI_Master:AddTab(t, i) end
UI_Master:Switch('Dashboard')

-- COMMAND CONSOLE
local function CreateConsole()
    local cF = Instance.new("Frame", UI_Master.Elements.Main.Parent)
    cF.Name = "CommandConsole"
    cF.Size = UDim2now(0, 400, 0, 40)
    cF.Position = UDim2now(0.5, -200, 1, -100)
    cF.BackgroundColor3 = Color3now(10, 10, 10)
    cF.BackgroundTransparency = 0.2
    cF.Visible = false
    Instance.new("UICorner", cF)
    Instance.new("UIStroke", cF).Color = AccentColor
    
    local tb = Instance.new("TextBox", cF)
    tb.Size = UDim2now(1, -20, 1, 0)
    tb.Position = UDim2now(0, 10, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.PlaceholderText = ";commands (e.g. ;speed 50)"
    tb.TextColor3 = Color3now(255, 255, 255)
    tb.Font = Enum.Font.Code
    tb.TextSize = 16
    tb.TextXAlignment = 0
    
    tb.FocusLost:Connect(function(enter)
        if enter then
            local cmd = tb.Text:lower()
            if cmd:sub(1,1) == ";" then cmd = cmd:sub(2) end
            local args = cmd:split(" ")
            local action = args[1]
            
            if action == "speed" then Settings.WalkSpeed = tonumber(args[2]) or 16
            elseif action == "jump" then Settings.JumpPower = tonumber(args[2]) or 50
            elseif action == "rejoin" then TS:Teleport(game.PlaceId, Client)
            elseif action == "serverhop" then UI_Master:ServerHop()
            elseif action == "toggle" then
                local what = args[2]
                if what == "m1" then Settings.AutoM1 = not Settings.AutoM1
                elseif what == "farm" then Settings.AutoFarm = not Settings.AutoFarm
                elseif what == "stealth" then Settings.StealthMode = not Settings.StealthMode
                end
            end
            tb.Text = ""
            cF.Visible = false
        end
    end)
    return cF
end
local CommandConsole = CreateConsole()

function UI_Master:ServerHop()
    local Http = game:GetService("HttpService")
    -- sortOrder=Asc returns the lowest player count servers first
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, res = pcall(function() return game:HttpGet(Api) end)
    if success then
        local data = Http:JSONDecode(res)
        if data and data.data then
            local bestServer = nil
            for _, server in ipairs(data.data) do
                -- Look for servers with low ping and low players (but at least 1 player usually ensures it's a valid alive server)
                if server.playing > 0 and server.playing < (server.maxPlayers - 2) and server.id ~= game.JobId then
                    if server.ping and server.ping < 100 then
                        -- Found a potentially low ping / Germany or EU server
                        bestServer = server
                        break
                    elseif bestServer == nil then
                        bestServer = server
                    end
                end
            end
            
            if bestServer then
                TS:TeleportToPlaceInstance(game.PlaceId, bestServer.id, Client)
            end
        end
    end
end

-- Dashboard
local pgD = UI_Master.Pages.Dashboard
UI_Master:AddToggle(pgD, "True Instinct", "AutoRoka", "Automatically uses Rokakaka if stand is not desired.")
local logF = Instance.new("ScrollingFrame", pgD); logF.Size = UDim2.new(1, -10, 0, 200); logF.BackgroundColor3 = Color3.fromRGB(15, 20, 15); logF.BackgroundTransparency = 0.5; logF.BorderSizePixel = 0; logF.ScrollBarThickness = 2; logF.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UICorner", logF).CornerRadius = UDim.new(0, 4); local lt = Instance.new("Frame", logF); lt.Size = UDim2.new(1, -20, 1, -20); lt.Position = UDim2.new(0, 10, 0, 10); lt.BackgroundTransparency = 1; Instance.new("UIListLayout", lt).Padding = UDim.new(0, 4)
local function Line(t, c) local l = Instance.new("TextLabel", lt); l.Size = UDim2.new(1, 0, 0, 18); l.Text = t; l.TextColor3 = c or Color3.fromRGB(200, 200, 200); l.Font = Enum.Font.Code; l.TextSize = 11; l.TextXAlignment = 0; l.BackgroundTransparency = 1 end
Line("Lite Extreme v43 Loaded.", AccentColor)
Line("Features Cleaned & Re-Organized.", Color3.new(0.5, 1, 0.5))

-- Combat
local pgC = UI_Master.Pages.Combat
UI_Master:AddToggle(pgC, "Auto M1", "AutoM1", "Auto Left Click continuously")
UI_Master:AddToggle(pgC, "God Mode", "GodModeActive", "Attempts to loop dodge I-frames")
UI_Master:AddSlider(pgC, "Click Speed (Hold)", "ClickSpeed", 0.005, 0.1, "s")
UI_Master:AddSlider(pgC, "Attack Interval", "MacroInterval", 0.01, 1, "s")

-- Skills (New Tab to decrease clutter)
local pgSkills = UI_Master.Pages.Skills
UI_Master:AddToggle(pgSkills, "Auto E (Barrage)", "AutoSkillE")
UI_Master:AddToggle(pgSkills, "Auto R (Heavy)", "AutoSkillR")
UI_Master:AddToggle(pgSkills, "Auto Z", "AutoSkillZ")
UI_Master:AddToggle(pgSkills, "Auto X", "AutoSkillX")
UI_Master:AddToggle(pgSkills, "Auto C", "AutoSkillC")
UI_Master:AddToggle(pgSkills, "Auto V", "AutoSkillV")

-- ESP (New Tab)
local pgESP = UI_Master.Pages.ESP
UI_Master:AddToggle(pgESP, "NPC ESP (Yellow)", "NPC_ESP")
UI_Master:AddToggle(pgESP, "Boss ESP (Red)", "Boss_ESP")
UI_Master:AddToggle(pgESP, "Player ESP (Green)", "Player_ESP")
UI_Master:AddToggle(pgESP, "Item ESP (Light Green)", "Item_ESP")
UI_Master:AddToggle(pgESP, "Show Items on Dashboard", "ShowMapItems", "Displays nearby items in the right panel")

-- Farming
local pgF = UI_Master.Pages.Farming
UI_Master:AddToggle(pgF, "Auto Farm", "AutoFarm", "Farm NPCs/Bosses around you")
UI_Master:AddToggle(pgF, "Attack Bosses Only", "FarmOnlyBoss")
UI_Master:AddDropdown(pgF, "Attack Angle", "FarmAngle", {"Below (Default)", "Above", "Behind", "Front", "Right", "Left"})
UI_Master:AddSlider(pgF, "Attack Distance", "FarmDist", 0, 15)
UI_Master:AddSlider(pgF, "Max Scan Range", "TargetRange", 10, 500)
local function MakeRangeSlider(page, label, key, minV, maxV)
    local row = Instance.new("Frame", page); row.Size = UDim2.new(1,-10,0,50); row.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(1,0,0,20); lbl.TextColor3 = Color3.new(0.9,0.9,0.9); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1
    local bg = Instance.new("Frame", row); bg.Size = UDim2.new(1,-20,0,6); bg.Position = UDim2.new(0,10,0,30); bg.BackgroundColor3 = Color3.fromRGB(30,35,30); Instance.new("UICorner",bg).CornerRadius = UDim.new(1,0)
    local fl = Instance.new("Frame", bg); fl.Size = UDim2.new(math.clamp((Settings[key]-minV)/(maxV-minV),0,1),0,1,0); fl.BackgroundColor3 = AccentColor; Instance.new("UICorner",fl).CornerRadius = UDim.new(1,0)
    local kb = Instance.new("TextButton", row); kb.Size = UDim2.new(1,-20,0,30); kb.Position = UDim2.new(0,10,0,20); kb.BackgroundTransparency = 1; kb.Text = ""
    local knob = Instance.new("Frame", fl); knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(1,-7,0.5,-7); knob.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)
    local md = false
    local function Upd() lbl.Text = label .. ": " .. ((Settings[key] >= maxV) and "∞" or tostring(Settings[key])) end
    Upd()
    kb.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then md = true end end)
    UIS.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then md = false end end)
    UIS.InputChanged:Connect(function(io)
        if md and io.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = math.clamp((io.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            Settings[key] = math.floor(minV + (maxV-minV)*pct); fl.Size = UDim2.new(pct,0,1,0); Upd()
        end
    end)
end
MakeRangeSlider(pgF, "Item ESP Range", "ItemESPRange", 30, 2000)
-- Raid
local pgR = UI_Master.Pages.Raid
UI_Master:AddToggle(pgR, "Auto Raid", "AutoRaid")
UI_Master:AddToggle(pgR, "Auto Enter", "RaidAutoEnter")
UI_Master:AddToggle(pgR, "Auto Retry", "RaidAutoRetry")
UI_Master:AddSlider(pgR, "Raid Retry Delay", "RaidDelay", 0, 5, "s")

-- Tools
local pgTools = UI_Master.Pages.Tools
UI_Master:AddToggle(pgTools, "Auto Dialog (Skip NPCs)", "AutoDialog")
UI_Master:AddToggle(pgTools, "Stealth Mode", "StealthMode", "Makes your character transparent locally")

local shBtn = Instance.new("TextButton", pgTools); shBtn.Size = UDim2now(1, -10, 0, 40); shBtn.BackgroundColor3 = SecondaryGreen; shBtn.Text = "SERVER HOP (Random)"; shBtn.TextColor3 = Color3now(255,255,255); shBtn.Font = Enum.Font.GothamBold; shBtn.TextSize = 14; Instance.new("UICorner", shBtn)
shBtn.MouseButton1Click:Connect(function() 
    if _G.QueueLoader then _G.QueueLoader() end
    task.wait(0.2)
    UI_Master:ServerHop() 
end)

local rjBtn = Instance.new("TextButton", pgTools); rjBtn.Size = UDim2now(1, -10, 0, 40); rjBtn.BackgroundColor3 = Color3now(60, 20, 20); rjBtn.Text = "REJOIN SERVER"; rjBtn.TextColor3 = Color3now(255,255,255); rjBtn.Font = Enum.Font.GothamBold; rjBtn.TextSize = 14; Instance.new("UICorner", rjBtn)
rjBtn.MouseButton1Click:Connect(function() 
    if _G.QueueLoader then _G.QueueLoader() end
    rjBtn.Text = "WAITING 2S..."
    task.wait(2)
    TS:Teleport(game.PlaceId, Client) 
end)

local conBtn = Instance.new("TextButton", pgTools); conBtn.Size = UDim2now(1, -10, 0, 40); conBtn.BackgroundColor3 = Color3now(20, 20, 60); conBtn.Text = "OPEN CONSOLE [ ; ]"; conBtn.TextColor3 = Color3now(255,255,255); conBtn.Font = Enum.Font.GothamBold; conBtn.TextSize = 14; Instance.new("UICorner", conBtn)
conBtn.MouseButton1Click:Connect(function() CommandConsole.Visible = true; CommandConsole:FindFirstChildOfClass("TextBox"):CaptureFocus() end)

local customHopBtn = Instance.new("TextButton", pgTools); customHopBtn.Size = UDim2now(1, -10, 0, 40); customHopBtn.BackgroundColor3 = Color3now(60, 40, 60); customHopBtn.Text = "CUSTOM SERVER HOP"; customHopBtn.TextColor3 = Color3now(255,255,255); customHopBtn.Font = Enum.Font.GothamBold; customHopBtn.TextSize = 14; Instance.new("UICorner", customHopBtn)
do
    local script = {Parent = customHopBtn}

    local targetPlaceId = 123456789

    local function handleServerHop()
    local ts = game:GetService("TeleportService")
    local lp = game.Players.LocalPlayer

    if game.PlaceId == targetPlaceId then

    local scriptToLoad = [[
    repeat task.wait() until game:IsLoaded()
    print("Script reloaded successfully!")
    -- Put your main loadstring or script here
    ]]

    if queue_on_teleport then
    queue_on_teleport(scriptToLoad)
    elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(scriptToLoad)
    else
    warn("Your executor doesn't support queue_on_teleport :/")
    end

    ts:Teleport(game.PlaceId, lp)
    else
    print("Wrong game ID, skipping teleport.")
    end
    end

    script.Parent.MouseButton1Click:Connect(handleServerHop)
end

-- Teleport
local pgT = UI_Master.Pages.Teleport
UI_Master:AddToggle(pgT, "Safe TP", "SafeTP", "Tweens character to destination safely")
UI_Master:AddSlider(pgT, "TP Speed", "WalkSpeed", 16, 500)

for i=1, 20 do
    local b = Instance.new("TextButton", pgT); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 30, 20); b.Text = "Teleport: Stop " .. i; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 12; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() 
        pcall(function() 
            local hum, hrp
            if Client.Character then hum = Client.Character:FindFirstChildOfClass("Humanoid"); hrp = Client.Character:FindFirstChild("HumanoidRootPart") end
            if hrp then
                local wp = workspace:FindFirstChild("Durak " .. i) or workspace:FindFirstChild("Durak"..i) or workspace:FindFirstChild("Stop " .. i)
                if not wp then
                    for _, child in ipairs(workspace:GetDescendants()) do
                        if child:IsA("BasePart") and (child.Name == "Durak " .. i or child.Name == "Durak"..i or child.Name == "Stop " .. i) then wp = child break end
                    end
                end
                
                if wp then
                    if Settings.SafeTP then Tween:Create(hrp, TweenInfo.new((hrp.Position - wp.Position).Magnitude / Settings.WalkSpeed, Enum.EasingStyle.Linear), {CFrame = wp.CFrame + Vector3.new(0,5,0)}):Play()
                    else hrp.CFrame = wp.CFrame + Vector3.new(0,5,0) end
                end
            end
        end) 
    end)
end

-- Misc
local pgM = UI_Master.Pages.Misc
local function AddSpeedControl(page, label, key, default, minV, maxV)
    local row = Instance.new("Frame", page); row.Size = UDim2.new(1,-10,0,60); row.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(1,0,0,18); lbl.Text = label; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1
    local bg = Instance.new("Frame", row); bg.Size = UDim2.new(0.7,0,0,6); bg.Position = UDim2.new(0,0,0,30); bg.BackgroundColor3 = Color3.fromRGB(30,35,30); Instance.new("UICorner",bg).CornerRadius = UDim.new(1,0)
    local fl = Instance.new("Frame", bg); fl.Size = UDim2.new((Settings[key]-minV)/(maxV-minV),0,1,0); fl.BackgroundColor3 = AccentColor; Instance.new("UICorner",fl).CornerRadius = UDim.new(1,0)
    local knob = Instance.new("Frame", fl); knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(1,-7,0.5,-7); knob.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)
    local box = Instance.new("TextBox", row); box.Size = UDim2.new(0.25,0,0,26); box.Position = UDim2.new(0.73,0,0,20); box.BackgroundColor3 = Color3.fromRGB(15,20,15); box.TextColor3 = Color3.new(1,1,1); box.Font = Enum.Font.GothamBold; box.TextSize = 13; box.Text = tostring(Settings[key]); box.ClearTextOnFocus = false; Instance.new("UICorner",box).CornerRadius = UDim.new(0,4); Instance.new("UIStroke",box).Color = AccentColor
    local kb = Instance.new("TextButton", row); kb.Size = UDim2.new(0.7,0,0,30); kb.Position = UDim2.new(0,0,0,18); kb.BackgroundTransparency = 1; kb.Text = ""
    local md = false
    kb.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then md = true; Tween:Create(knob,TweenInfo.new(0.1),{Size=UDim2.new(0,18,0,18),Position=UDim2.new(1,-9,0.5,-9)}):Play() end end)
    UIS.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then md = false; Tween:Create(knob,TweenInfo.new(0.1),{Size=UDim2.new(0,14,0,14),Position=UDim2.new(1,-7,0.5,-7)}):Play() end end)
    UIS.InputChanged:Connect(function(io)
        if md and io.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = math.clamp((io.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            local val = math.floor(minV + (maxV-minV)*pct)
            Settings[key] = val; fl.Size = UDim2.new(pct,0,1,0); box.Text = tostring(val)
        end
    end)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            if n < minV then n = minV elseif n > maxV then n = maxV end
            Settings[key] = n; fl.Size = UDim2.new((n-minV)/(maxV-minV),0,1,0); box.Text = tostring(n)
        else
            box.Text = tostring(default); Settings[key] = default
        end
    end)
end

AddSpeedControl(pgM, "Walk Speed (16 = default)", "WalkSpeed", 16, 8, 500)
AddSpeedControl(pgM, "Jump Power (50 = default)", "JumpPower", 50, 20, 500)

local mapHdr = Instance.new("TextLabel", pgM); mapHdr.Size = UDim2.new(1,-10,0,25); mapHdr.Text = "-- Farm Extras --"; mapHdr.TextColor3 = AccentColor; mapHdr.Font = Enum.Font.GothamBold; mapHdr.TextSize = 12; mapHdr.TextXAlignment = 0; mapHdr.BackgroundTransparency = 1
UI_Master:AddToggle(pgM, "Auto Farm Items", "AutoItemFarm")
UI_Master:AddToggle(pgM, "Master Toggle (Key: K)", "EngineActive", "Main switch for all combat and farm hooks")

local perfHdr = Instance.new("TextLabel", pgM); perfHdr.Size = UDim2.new(1,-10,0,25); perfHdr.Text = "-- Performance Tweaks --"; perfHdr.TextColor3 = AccentColor; perfHdr.Font = Enum.Font.GothamBold; perfHdr.TextSize = 12; perfHdr.TextXAlignment = 0; perfHdr.BackgroundTransparency = 1
UI_Master:AddToggle(pgM, "Advanced Scan (Deeper, Slower)", "AdvancedScan")
UI_Master:AddSlider(pgM, "Scan Interval (Seconds)", "ScanInterval", 1, 5)

local function UpdateGuardUI()
    if UI_Master.Elements.Guard then
        UI_Master.Elements.Guard.Text = "ENGINE: [" .. (Settings.EngineActive and "LOCK" or "UNLOCK") .. "]"
        UI_Master.Elements.Guard.TextColor3 = Settings.EngineActive and Color3.new(0.2,1,0.2) or Color3.new(1,0.2,0.2)
    end
    if UI_Master.Elements.GuardZone then UI_Master.Elements.GuardZone.Visible = Settings.EngineActive end
end
UpdateGuardUI()

task.spawn(function()
    while task.wait(0.2) do
        if UI_Master.Elements.ItemPanel then UI_Master.Elements.ItemPanel.Visible = Settings.ShowMapItems end
        UpdateGuardUI()
    end
end)

-- Wiki
local pgW = UI_Master.Pages.Wiki; UI_Master:AddWikiSearch(pgW); for _, item in ipairs(WikiData) do UI_Master:AddWikiEntry(pgW, item) end

-- Settings
local pgS = UI_Master.Pages.Settings
local function Snd() pcall(function() local s = Instance.new("Sound", game.SoundService); s.SoundId = "rbxassetid://6518811702"; s.Volume = 0.9; s.RollOffMaxDistance = 100; s:Play(); game:GetService("Debris"):AddItem(s, 2) end) end
local function MakeSect(parent, title) local hdr = Instance.new("TextLabel", parent); hdr.Size = UDim2.new(1,-10,0,20); hdr.Text = title; hdr.TextColor3 = AccentColor; hdr.Font = Enum.Font.GothamBold; hdr.TextSize = 12; hdr.TextXAlignment = 0; hdr.BackgroundTransparency = 1; return hdr end
local function MakeInput(parent, label, defaultVal, onChange)
    local wrap = Instance.new("Frame", parent); wrap.Size = UDim2.new(1,-10,0,60); wrap.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", wrap); lbl.Size = UDim2.new(1,0,0,20); lbl.Text = label; lbl.TextColor3 = AccentColor; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1
    local box = Instance.new("TextBox", wrap); box.Size = UDim2.new(1,0,0,32); box.Position = UDim2.new(0,0,0,22); box.BackgroundColor3 = Color3.fromRGB(8,18,10); box.TextColor3 = Color3.new(1,1,1); box.Font = Enum.Font.GothamBold; box.TextSize = 13; box.Text = tostring(defaultVal); box.ClearTextOnFocus = false; Instance.new("UICorner",box).CornerRadius = UDim.new(0,4); Instance.new("UIStroke",box).Color = AccentColor
    box.Focused:Connect(function() Snd() end)
    box:GetPropertyChangedSignal("Text"):Connect(function() pcall(function() onChange(box.Text) end) end)
    return box
end

MakeInput(pgS, "Config File Name:", Settings.ConfigName, function(v) Settings.ConfigName = v end)

local saveBtn = Instance.new("TextButton", pgS); saveBtn.Size = UDim2.new(1,-10,0,38); saveBtn.BackgroundColor3 = Color3.fromRGB(0,80,30); saveBtn.TextColor3 = Color3.new(1,1,1); saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 14; saveBtn.Text = "SAVE CONFIG"; Instance.new("UICorner",saveBtn).CornerRadius = UDim.new(0,4)
saveBtn.MouseButton1Click:Connect(function() Snd(); SaveConfig(); saveBtn.Text = "CONFIG SAVED"; saveBtn.BackgroundColor3 = AccentColor; task.delay(2, function() saveBtn.Text = "SAVE CONFIG"; saveBtn.BackgroundColor3 = Color3.fromRGB(0,80,30) end) end)

local loadBtn = Instance.new("TextButton", pgS); loadBtn.Size = UDim2.new(1,-10,0,38); loadBtn.BackgroundColor3 = Color3.fromRGB(0,40,80); loadBtn.TextColor3 = Color3.new(1,1,1); loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 14; loadBtn.Text = "LOAD CONFIG"; Instance.new("UICorner",loadBtn).CornerRadius = UDim.new(0,4)
loadBtn.MouseButton1Click:Connect(function() Snd(); LoadConfig(); loadBtn.Text = "LOADED!"; loadBtn.BackgroundColor3 = AccentColor; task.delay(2, function() loadBtn.Text = "LOAD CONFIG"; loadBtn.BackgroundColor3 = Color3.fromRGB(0,40,80) end) end)

MakeSect(pgS, "Menu UI Keybind:")
local bindBtn = Instance.new("TextButton", pgS); bindBtn.Size = UDim2.new(1,-10,0,38); bindBtn.BackgroundColor3 = Color3.fromRGB(30,30,60); bindBtn.TextColor3 = Color3.new(1,1,1); bindBtn.Font = Enum.Font.GothamBold; bindBtn.TextSize = 13; bindBtn.Text = "Press to bind: [" .. Settings.MenuKey .. "]"; Instance.new("UICorner",bindBtn).CornerRadius = UDim.new(0,4); Instance.new("UIStroke",bindBtn).Color = AccentColor
local waitingBind = false
bindBtn.MouseButton1Click:Connect(function()
    if waitingBind then return end; waitingBind = true; bindBtn.Text = "Press any key..."; bindBtn.BackgroundColor3 = Color3.fromRGB(60,60,0)
    local conn; conn = UIS.InputBegan:Connect(function(inp, gp)
        if gp then return end
        local n = inp.KeyCode.Name ~= "Unknown" and inp.KeyCode.Name or inp.UserInputType.Name
        Settings.MenuKey = n; bindBtn.Text = "Bound: [" .. n .. "]"; bindBtn.BackgroundColor3 = Color3.fromRGB(0,60,20)
        Snd(); conn:Disconnect(); waitingBind = false
    end)
end)

MakeSect(pgS, "Master Toggle Keybind:")
local masterBindBtn = Instance.new("TextButton", pgS); masterBindBtn.Size = UDim2.new(1,-10,0,38); masterBindBtn.BackgroundColor3 = Color3.fromRGB(30,30,60); masterBindBtn.TextColor3 = Color3.new(1,1,1); masterBindBtn.Font = Enum.Font.GothamBold; masterBindBtn.TextSize = 13; masterBindBtn.Text = "Press to bind Master Toggle: [" .. Settings.MasterKey .. "]"; Instance.new("UICorner",masterBindBtn).CornerRadius = UDim.new(0,4); Instance.new("UIStroke",masterBindBtn).Color = AccentColor
local mWaitingBind = false
masterBindBtn.MouseButton1Click:Connect(function()
    if mWaitingBind then return end; mWaitingBind = true; masterBindBtn.Text = "Press any key..."; masterBindBtn.BackgroundColor3 = Color3.fromRGB(60,60,0)
    local conn; conn = UIS.InputBegan:Connect(function(inp, gp)
        if gp then return end
        local n = inp.KeyCode.Name ~= "Unknown" and inp.KeyCode.Name or inp.UserInputType.Name
        Settings.MasterKey = n; masterBindBtn.Text = "Bound: [" .. n .. "]"; masterBindBtn.BackgroundColor3 = Color3.fromRGB(0,60,20)
        Snd(); conn:Disconnect(); mWaitingBind = false
    end)
end)

UI_Master:AddSlider(pgS, "UI Transparency", "UITransparency", 0, 80, "%")

-- Dragging system
local MainFrame = UI_Master.Elements.Main
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
MainFrame.InputBegan:Connect(function(io)
    if io.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = io.Position; startPos = MainFrame.Position
        io.Changed:Connect(function() if io.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseMovement then dragInput = io end end)
UIS.InputChanged:Connect(function(io)
    if io == dragInput and dragging then
        local delta = io.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then
        if inp.KeyCode == Enum.KeyCode.Semicolon then
            CommandConsole.Visible = true; CommandConsole:FindFirstChildOfClass("TextBox"):CaptureFocus()
        end
        return
    end
    if Settings.MenuKey then
        local keyName = inp.KeyCode.Name
        if keyName == "Unknown" then keyName = inp.UserInputType.Name end
        if keyName == Settings.MenuKey then
            MainFrame.Visible = not MainFrame.Visible
        elseif keyName == Settings.MasterKey then
            Settings.EngineActive = not Settings.EngineActive
            UpdateGuardUI()
            Snd()
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Settings.StealthMode then
            pcall(function()
                if MainFrame.Visible then MainFrame.Visible = false end
                local char = Client.Character
                if char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.Transparency = 0.7; v.CanCollide = false
                        elseif v:IsA("Decal") then v.Transparency = 0.7 end
                    end
                end
            end)
        end
    end
end)

local TargetNPCNames = {"Boss", "Lieutenant", "Captain", "Warden", "Champion", "Overlord", "Miniboss", "Titan", "Colossus", "Ravager", "Butcher"}
local BadPrompts = {"talk", "speak", "sit", "claim", "meditat", "gang"}
local TargetBlacklist = {"Quest", "Vendor", "Shop", "Banker", "Giorno", "Bucciarati"}

local function IsTarget(obj)
    local hum = obj:FindFirstChildOfClass("Humanoid")
    if hum and hum.MaxHealth >= 3000 then return true end
    local l = string.lower(obj.Name)
    for _, t in ipairs(TargetNPCNames) do if l:find(string.lower(t)) then return true end end
    return false
end

local function IsBlacklisted(name)
    local l = string.lower(name)
    for _, t in ipairs(TargetBlacklist) do if l:find(string.lower(t)) then return true end end
    return false
end

local EntityCache = {}
local ESP_Pool = {Highlights = {}, Labels = {}}
local DetectedItems = {}

local function GetFromPool(pType, parent)
    local itm = table.remove(ESP_Pool[pType])
    if itm then itm.Parent = parent; itm.Enabled = true; return itm end
    if pType == "Highlights" then
        local hl = Instance.new("Highlight", parent); hl.FillTransparency = 0.8; hl.OutlineTransparency = 0.2; return hl
    else
        local bg = Instance.new("BillboardGui", parent); bg.AlwaysOnTop = true; bg.Size = UDim2now(0, 120, 0, 30); bg.StudsOffset = Vector3now(0, 3.5, 0)
        local l = Instance.new("TextLabel", bg); l.Size = UDim2now(1,0,1,0); l.BackgroundTransparency = 1; l.TextStrokeTransparency = 0; l.Font = Enum.Font.GothamBold; l.TextSize = 11; return bg
    end
end

local function RecycleESP(data)
    if data.HL then data.HL.Enabled = false; data.HL.Parent = nil; table.insert(ESP_Pool.Highlights, data.HL); data.HL = nil end
    if data.BB then data.BB.Enabled = false; data.BB.Parent = nil; table.insert(ESP_Pool.Labels, data.BB); data.BB = nil end
end

local function UnifiedScan()
    local CurrentTick = {}
    local hrp = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local function Process(obj)
        local id = obj:GetDebugId()
        local isNpc = obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Client.Character
        local isItem = not isNpc and obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent:IsA("BasePart")
        
        if isNpc or isItem then
            local root = isNpc and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("BasePart")) or obj.Parent
            if root then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < 1000 then 
                    CurrentTick[id] = true
                    if not EntityCache[id] then
                        local meta = {Obj = obj, Root = root, IsNpc = isNpc}
                        if isNpc then
                            meta.IsBoss = IsTarget(obj)
                            meta.IsPlayer = Players:GetPlayerFromCharacter(obj) ~= nil
                            meta.IsTalk = IsBlacklisted(obj.Name) or (obj:FindFirstChildOfClass("ProximityPrompt") ~= nil and not meta.IsBoss)
                        else
                            meta.Obj = root; meta.Prompt = obj
                            local act = string.lower(obj.ActionText or ""); local objT = string.lower(obj.ObjectText or "")
                            meta.IsBad = false
                            for _, p in ipairs(BadPrompts) do 
                                if act:find(p) or objT:find(p) or root.Name:lower():find(p) then meta.IsBad = true break end 
                            end
                        end
                        EntityCache[id] = meta
                    end
                end
            end
        end
    end

    if Settings.AdvancedScan then
        for _, obj in ipairs(workspace:GetDescendants()) do Process(obj) end
    else
        local Folders = {"NPCs", "Entities", "Living", "Drops", "Items", "Debris", "Objects", "World"}
        for _, n in ipairs(Folders) do
            local f = workspace:FindFirstChild(n)
            if f then for _, c in ipairs(f:GetChildren()) do Process(c) end end
        end
        for _, c in ipairs(workspace:GetChildren()) do
            if c:IsA("Model") or c:IsA("BasePart") then Process(c) end
            for _, gc in ipairs(c:GetChildren()) do if gc:IsA("ProximityPrompt") then Process(gc) end end
        end
        if not next(CurrentTick) then
            for _, c in ipairs(workspace:GetChildren()) do for _, gc in ipairs(c:GetChildren()) do Process(gc) end end
        end
    end

    for id, data in pairs(EntityCache) do
        if not CurrentTick[id] then RecycleESP(data); if data.UI then data.UI:Destroy() end; EntityCache[id] = nil end
    end
    table.clear(DetectedItems)
    for _, data in pairs(EntityCache) do
        if data.IsNpc and not data.IsTalk and not data.IsPlayer then 
            table.insert(DetectedItems, {Obj=data.Obj, Part=data.Root, Name=data.Obj.Name, IsBoss=data.IsBoss})
        elseif not data.IsNpc and not data.IsBad then 
            table.insert(DetectedItems, {Obj=data.Prompt, Part=data.Root, Name=data.Root.Name, IsItem=true}) 
        end
    end
end

RS.Heartbeat:Connect(function()
    if not (Settings.NPC_ESP or Settings.Boss_ESP or Settings.Player_ESP or Settings.Item_ESP or Settings.ShowMapItems) then 
        for _, data in pairs(EntityCache) do RecycleESP(data) end; return 
    end
    local hrp = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, data in pairs(EntityCache) do
        local dist = (data.Root.Position - hrp.Position).Magnitude
        local showESP, color = false, AccentColor
        
        if data.IsNpc then
            if data.IsPlayer then showESP = Settings.Player_ESP; color = Settings.Player_ESPColor
            elseif data.IsBoss then showESP = Settings.Boss_ESP; color = Settings.Boss_ESPColor
            else showESP = Settings.NPC_ESP; color = Settings.NPC_ESPColor end
        else showESP = Settings.Item_ESP; color = Settings.Item_ESPColor end
        
        if showESP and dist < (Settings.ItemESPRange or 2000) then
            if not data.HL then data.HL = GetFromPool("Highlights", data.Obj) end
            if not data.BB then data.BB = GetFromPool("Labels", CoreGui); data.BB.Adornee = data.Root end
            data.HL.FillColor = color; data.HL.OutlineColor = color
            data.BB.TextLabel.TextColor3 = color; data.BB.TextLabel.Text = data.Obj.Name .. " [" .. math_floor(dist) .. "m]"
        else RecycleESP(data) end
        
        if Settings.ShowMapItems then
            if not data.UI then
                local l = Instance.new("TextLabel", UI_Master.Elements.ItemList)
                l.Size = UDim2now(1,0,0,18); l.BackgroundTransparency = 1; l.Font = Enum.Font.Gotham; l.TextSize = 10; l.TextXAlignment = 0; data.UI = l
            end
            data.UI.Text = (data.IsBoss and "[B] " or "") .. data.Obj.Name .. " (" .. math_floor(dist) .. "m)"
            data.UI.TextColor3 = color; data.UI.Visible = true
        elseif data.UI then data.UI.Visible = false end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        local hum = Client.Character and Client.Character:FindFirstChild("Humanoid")
        local hrp = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) then continue end
        
        if Settings.WalkSpeed ~= 16 then hum.WalkSpeed = Settings.WalkSpeed end
        if Settings.JumpPower ~= 50 then hum.JumpPower = Settings.JumpPower end
        
        if Settings.AutoFarm and Settings.EngineActive then
            local closest, minDist = nil, Settings.TargetRange
            for _, item in ipairs(DetectedItems) do
                if not item.IsItem then
                    local th = item.Obj:FindFirstChild("Humanoid")
                    if th and th.Health > 0 then
                        local isRequested = not Settings.FarmOnlyBoss or item.IsBoss
                        local isSpecific = (Settings.FarmTargetName == "" or item.Name == Settings.FarmTargetName)
                        if isRequested and isSpecific then
                            local d = (hrp.Position - item.Part.Position).Magnitude
                            if d < minDist then minDist = d; closest = item end
                        end
                    end
                end
            end
            State.CurrentFarmTarget = closest
        else State.CurrentFarmTarget = nil end
        
        if Settings.AutoItemFarm and Settings.EngineActive then
            local closest, minDist = nil, 400
            for _, item in ipairs(DetectedItems) do
                if item.IsItem then
                    local d = (hrp.Position - item.Part.Position).Magnitude
                    if d < minDist then minDist = d; closest = item end
                end
            end
            if closest then
                pcall(function()
                    hrp.CFrame = closest.Part.CFrame; task.wait(0.3)
                    local old = closest.Obj.HoldDuration; closest.Obj.HoldDuration = 0
                    fireproximityprompt(closest.Obj); closest.Obj.HoldDuration = old; task.wait(0.5)
                end)
            end
        end
    end
end)

RS.Stepped:Connect(function()
    if Settings.AutoFarm and Client.Character then
        for _, v in ipairs(Client.Character:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end
    end
end)

RS.Heartbeat:Connect(function()
    pcall(function()
        if Settings.AutoFarm and State.CurrentFarmTarget then
            local hum = Client.Character and Client.Character:FindFirstChildOfClass("Humanoid")
            local hrp = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and State.CurrentFarmTarget.Part and State.CurrentFarmTarget.Part:IsDescendantOf(workspace) then
                local dist = Settings.FarmDist or 7
                local targetPos = State.CurrentFarmTarget.Part.Position + Vector3now(0, -dist, 0)
                hrp.CFrame = CFramenow(targetPos) * CFrame.Angles(math_rad(90), 0, 0)
                hrp.Velocity = Vector3now(0,0,0)
                hum.PlatformStand = true
            end
        else
            local hum = Client.Character and Client.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.PlatformStand then hum.PlatformStand = false end
        end
    end)
end)

task.spawn(function() while true do pcall(UnifiedScan); task.wait(Settings.ScanInterval or 1.5) end end)

task.spawn(function()
    while true do
        if Settings.AutoFarm then Settings.AutoM1 = true end
        local isTyping = UIS:GetFocusedTextBox() ~= nil
        local isPaused = not Settings.EngineActive
        local mousePos = UIS:GetMouseLocation()
        local inGuardZone = mousePos.X < 250 and mousePos.Y < 80
        
        if (Settings.AutoM1 or Settings.AutoFarm) and not (isTyping or isPaused or inGuardZone) then
            pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0); task.wait(Settings.ClickSpeed or 0.015); VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                local skills = {{Key = Enum.KeyCode.E, Active = Settings.AutoSkillE},{Key = Enum.KeyCode.R, Active = Settings.AutoSkillR},{Key = Enum.KeyCode.Z, Active = Settings.AutoSkillZ},{Key = Enum.KeyCode.X, Active = Settings.AutoSkillX},{Key = Enum.KeyCode.C, Active = Settings.AutoSkillC},{Key = Enum.KeyCode.V, Active = Settings.AutoSkillV}}
                for _, skill in ipairs(skills) do
                    if skill.Active then
                        VIM:SendKeyEvent(true, skill.Key, false, game); task.wait(0.01); VIM:SendKeyEvent(false, skill.Key, false, game)
                    end
                end
            end)
            task.wait(Settings.MacroInterval or 0.02)
        else task.wait(0.05) end
    end
end)

task.spawn(function()
    local function InitGodMode(char)
        local remote = char:WaitForChild("client_character_controller", 5)
        if remote then remote = remote:WaitForChild("Dodge", 5) end
        if not remote then return end
        char:GetAttributeChangedSignal("Dodging"):Connect(function()
            if Settings.GodModeActive and not char:GetAttribute("Dodging") then
                repeat 
                    remote:FireServer(); task.wait(0.1)
                until char:GetAttribute("Dodging") or not Settings.GodModeActive or char.Parent == nil
            end
        end)
    end
    Client.CharacterAdded:Connect(InitGodMode)
    if Client.Character then InitGodMode(Client.Character) end
end)

task.spawn(function()
    local startT = tick()
    local fC, lastT = 0, tick()
    RS.RenderStepped:Connect(function()
        fC = fC + 1
        if tick() - lastT >= 1 then UI_Master.Elements.FPS.Text = fC .. " FPS"; fC = 0; lastT = tick() end
        local pt = math_floor((tick() - startT)/60)
        UI_Master.Elements.PT.Text = "Playtime: " .. math_floor(pt/60) .. "h " .. (pt%60) .. "m"
    end)
    repeat task.wait(1) until Client:FindFirstChild("leaderstats")
    local function UpdYen()
        local ls = Client.leaderstats
        local y = ls:FindFirstChild("Yen") or ls:FindFirstChild("Cash") or ls:GetChildren()[1]
        if y then
            UI_Master.Elements.YT.Text = "Yen: " .. y.Value; UI_Master.Elements.TY.Text = "Total Yen: " .. y.Value
            y.Changed:Connect(function(v) UI_Master.Elements.YT.Text = "Yen: " .. v; UI_Master.Elements.TY.Text = "Total Yen: " .. v end)
        end
    end
    UpdYen()
end)

task.spawn(function()
    while task.wait(1) do
        if not Settings.AutoRaid then continue end
        pcall(function()
            local chumbo = workspace:FindFirstChild("Chumbo") or workspace:FindFirstChild("Raid NPC")
            if chumbo and chumbo:FindFirstChild("HumanoidRootPart") then
                local hrp = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - chumbo.HumanoidRootPart.Position).Magnitude < 20 then
                    local prompt = chumbo:FindFirstChildOfClass("ProximityPrompt") or chumbo:FindFirstChild("Prompt", true)
                    if prompt then fireproximityprompt(prompt) end
                end
            end
            
            local dialog = Client.PlayerGui:FindFirstChild("Dialogue") or Client.PlayerGui:FindFirstChild("NPC_Dialogue")
            if dialog and dialog.Enabled then
                local option1 = dialog:FindFirstChild("Option1", true) or dialog:FindFirstChild("1", true)
                if option1 and option1:IsA("TextButton") then
                    VIM:SendMouseButtonEvent(option1.AbsolutePosition.X + option1.AbsoluteSize.X/2, option1.AbsolutePosition.Y + option1.AbsoluteSize.Y/2 + 36, 0, true, game, 1); task.wait(0.05)
                    VIM:SendMouseButtonEvent(option1.AbsolutePosition.X + option1.AbsoluteSize.X/2, option1.AbsolutePosition.Y + option1.AbsoluteSize.Y/2 + 36, 0, false, game, 1)
                end
            end
            
            if Settings.RaidAutoEnter or Settings.AutoPlayAgain then
                local pGui = Client.PlayerGui
                local playBtn = pGui:FindFirstChild("PlayAgain", true) or pGui:FindFirstChild("Play Again", true) or pGui:FindFirstChild("Start", true)
                if not playBtn then
                    for _, v in ipairs(pGui:GetDescendants()) do
                        if v:IsA("TextButton") and v.Visible and (v.Text:upper():find("PLAY AGAIN") or v.Text:upper() == "PLAY") then playBtn = v break end
                    end
                end
                if playBtn then
                    task.wait(Settings.RaidDelay or 0.5) -- User requested manual delay logic
                    VIM:SendMouseButtonEvent(playBtn.AbsolutePosition.X + playBtn.AbsoluteSize.X/2, playBtn.AbsolutePosition.Y + playBtn.AbsoluteSize.Y/2 + 36, 0, true, game, 1); task.wait(0.05)
                    VIM:SendMouseButtonEvent(playBtn.AbsolutePosition.X + playBtn.AbsoluteSize.X/2, playBtn.AbsolutePosition.Y + playBtn.AbsoluteSize.Y/2 + 36, 0, false, game, 1)
                end
            end
            
            if Settings.AutoDialog then
                local d = Client.PlayerGui:FindFirstChild("Dialogue") or Client.PlayerGui:FindFirstChild("NPC_Dialogue")
                if d and d.Enabled then
                    local container = d:FindFirstChild("Options") or d:FindFirstChild("Frame") or d
                    local firstOpt = container:FindFirstChild("Option1", true) or container:FindFirstChild("1", true) or container:FindFirstChildOfClass("TextButton")
                    if firstOpt and firstOpt:IsA("TextButton") and firstOpt.Visible then
                        VIM:SendMouseButtonEvent(firstOpt.AbsolutePosition.X + firstOpt.AbsoluteSize.X/2, firstOpt.AbsolutePosition.Y + firstOpt.AbsoluteSize.Y/2 + 36, 0, true, game, 1); task.wait(0.1)
                        VIM:SendMouseButtonEvent(firstOpt.AbsolutePosition.X + firstOpt.AbsoluteSize.X/2, firstOpt.AbsolutePosition.Y + firstOpt.AbsoluteSize.Y/2 + 36, 0, false, game, 1)
                    end
                end
            end
        end)
    end
end)

Client.Idled:Connect(function()
    if not Settings.AntiAFK then return end
    pcall(function()
        VU:Button2Down(Vector2now(0,0), workspace.CurrentCamera.CFrame); task.wait(0.5); VU:Button2Up(Vector2now(0,0), workspace.CurrentCamera.CFrame)
        VIM:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game); task.wait(0.1); VIM:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end)
end)

local function SuperPersistence()
    local loader = [[
        if not game:IsLoaded() then game.Loaded:Wait() end
        task.wait(1)
        print("[LiteExtreme] Auto-Reloading Engine...")
        pcall(function() 
            local src = readfile("LiteExtreme.lua") or readfile("message (22).txt")
            if src then 
                loadstring(src)() 
                print("[LiteExtreme] Reload Complete!")
            else warn("[LiteExtreme] Backup file not found!") end
        end)
    ]]
    
    State.QueueLoader = function()
        pcall(function() writefile(Settings.ConfigName .. ".json", Http:JSONEncode(Settings)) end)
        local qot = (queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or (getfenv and getfenv().queue_on_teleport))
        if qot then pcall(function() qot(loader) end) end
    end

    local TS = game:GetService("TeleportService")
    pcall(function()
        local rawT = TS.Teleport
        if typeof(rawT) == "function" then TS.Teleport = function(self, ...) State.QueueLoader(); task.wait(0.5); return rawT(self, ...) end end
    end)
    
    pcall(function()
        local rawTPI = TS.TeleportToPlaceInstance
        if typeof(rawTPI) == "function" then TS.TeleportToPlaceInstance = function(self, ...) State.QueueLoader(); task.wait(0.5); return rawTPI(self, ...) end end
    end)

    if hookmetamethod then
        local oldNm
        oldNm = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if self == TS and (method == "Teleport" or method == "TeleportToPlaceInstance" or method == "teleport" or method:find("Teleport")) then
                State.QueueLoader()
            end
            return oldNm(self, ...)
        end)
    end

    Client.OnTeleport:Connect(function() State.QueueLoader() end)
end
SuperPersistence()
