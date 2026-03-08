--[[ BIZARRE LINEAGE LITE INTERNAL V43 | REFACTORED UPDATE | REGISTER SAFE | SOLID 0 ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local getgenv = getgenv or function() return _G end
local SG_NAME = 'BizarreLiteExtreme_V43'
if game:GetService('CoreGui'):FindFirstChild(SG_NAME) then game:GetService('CoreGui')[SG_NAME]:Destroy() end
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
local bc = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function base64_encode(data) return ((data:gsub('.', function(x) local r,b='',x:byte() for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end return r; end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x) if (#x < 6) then return '' end local c=0 for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end return bc:sub(c+1,c+1) end)..({ '', '==', '=' })[#data%3+1]) end
local function base64_decode(data) data = string.gsub(data, '[^'..bc..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',bc:find(x)-1 for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x < 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end
local function setClipboard(txt)
    local func = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if func then pcall(function() func(txt) end) end
end


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
    ItemESPRange=1000, AutoItemFarm=false, ShowMapItems=false, ShowItemPanel=true,
    FarmAngle='Below (Default)', FarmDist=7, FarmOnlyBoss=true,
    AutoM1=false, AutoSkillE=false, AutoSkillR=false, AutoSkillZ=false, AutoSkillX=false, AutoSkillC=false, AutoSkillV=false,
    AutoRaid=false, RaidAutoEnter=true, RaidAutoRetry=true, RaidDelay=0.5,
    WalkSpeed=16, JumpPower=50, UITransparency=0, ConfigName='LiteExtreme_V43', FarmTargetName='',
    AutoRoka=false, EngineActive=true, AdvancedScan=false, ScanInterval=1.5,
    AutoPlayAgain=true, ClickSpeed=0.015, MacroInterval=0.02, AutoRejoin=true,
    AutoDialog=true, StealthMode=false, AntiAFK=true, AutoStand=false, VisualizerActive=false
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

local AccentColor = Color3now(255, 120, 0)
local SecondaryGreen = Color3now(40, 40, 45)
local DarkBg = Color3now(10, 10, 12)



local WikiData = {
    {Name='Stand Arrow', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Gains access to a Stand.', Img='rbxassetid://13110298083'},
    {Name='Stone Mask', Stand='-ITEM-', SubAbility='Vampire', Style='-', Desc='Gives the Vampire Sub Ability.', Img='rbxassetid://13110298083'},
    {Name='Luky Arrow', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Guarantees a random Skin for a Stand.', Img='rbxassetid://13110298083'},
    {Name='Common Chest', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Gives various items.', Img='rbxassetid://13110298083'},
    {Name='Rare Chest', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Gives various rare items.', Img='rbxassetid://13110298083'},
    {Name='Legendary Chest', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Gives various legendary items.', Img='rbxassetid://13110298083'},
    {Name='Dio\'s Diary', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Quest item for Pucci\'s quest.', Img='rbxassetid://13110298083'},
    {Name='Red Stone of Aja', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Doubles Legendary Skin chance, 2x Conjuration, +1% Lucky Arrow spawn.', Img='rbxassetid://13110298083'},
    {Name='Fabric', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Bronze Fragments', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Acid', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Leather', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Maigot Recipe', Stand='-ITEM-', SubAbility='-', Style='-', Desc='Tonio Trussardi Quest item.', Img='rbxassetid://13110298083'},
    {Name='Sapphire', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Ruby', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Bones', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Opal', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Silver Fragments', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Gold Fragments', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Gold Coins', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Burner Phone', Stand='-QUEST-', SubAbility='-', Style='-', Desc='NPC Questline item.', Img='rbxassetid://13110298083'},
    {Name='Manga Manuscripts', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Lost Spirit', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Vampire Fang', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='DIO\'s Bone', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Cosmic Radiation', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Meteor Fragments', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Imperfect Aja', Stand='-CRAFT-', SubAbility='-', Style='-', Desc='Crafting material.', Img='rbxassetid://13110298083'},
    {Name='Stop Sign', Stand='-WEAPON-', SubAbility='-', Style='-', Desc='Weapon.', Img='rbxassetid://13110298083'},
    {Name='Shadow Axe', Stand='-WEAPON-', SubAbility='-', Style='-', Desc='Weapon.', Img='rbxassetid://13110298083'},
    {Name='Odachi', Stand='-WEAPON-', SubAbility='-', Style='-', Desc='Weapon.', Img='rbxassetid://13110298083'},
    {Name='Katana', Stand='-WEAPON-', SubAbility='-', Style='-', Desc='Weapon.', Img='rbxassetid://13110298083'},
    {Name='Hammer', Stand='-WEAPON-', SubAbility='-', Style='-', Desc='Weapon.', Img='rbxassetid://13110298083'},
    {Name='Shovel', Stand='-WEAPON-', SubAbility='-', Style='-', Desc='Weapon.', Img='rbxassetid://13110298083'},
    {Name='Luck & Pluck', Stand='-WEAPON-', SubAbility='-', Style='-', Desc='Weapon.', Img='rbxassetid://13110298083'},
    {Name='Stat Point Essence', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Resets Stat Points.', Img='rbxassetid://7335967073'},
    {Name='Stand Skin Essence', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Gives Stand a skin.', Img='rbxassetid://7335967073'},
    {Name='Stand Stat Essence', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Rerolls Stand stat grades.', Img='rbxassetid://7335967073'},
    {Name='Stand Personality Essence', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Rerolls Stand personality.', Img='rbxassetid://7335967073'},
    {Name='Stand Conjuration Essence', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Maxes out Stand Conjuration.', Img='rbxassetid://7335967073'},
    {Name='Custom Clothing Essence', Stand='-ESSENCE-', SubAbility='-', Style='-', Desc='Use Roblox avatar appearance.', Img='rbxassetid://7335967073'}
}

local UI_Master = {Pages = {}, Buttons = {}, Elements = {}}
function UI_Master:Init()
    local SG = Instance.new('ScreenGui', CoreGui); SG.Name = 'BizarreLiteExtreme_V43'; SG.IgnoreGuiInset = true; SG.ResetOnSpawn = false
    local Main = Instance.new('CanvasGroup', SG)
    Main.Size = UDim2now(0, 980, 0, 680)
    Main.Position = UDim2now(0.5, -490, 0.5, -300) -- Slightly lower for reveal
    Main.BackgroundColor3 = DarkBg; Main.BackgroundTransparency = 0.05; Main.BorderSizePixel = 0
    Main.GroupTransparency = 1
    Instance.new('UICorner', Main).CornerRadius = UDim.new(0, 10)
    Instance.new('UIStroke', Main).Color = AccentColor


    -- Sidebar (fixed width, uses UIListLayout so tabs never overlap)
    local Sidebar = Instance.new('Frame', Main)
    Sidebar.Size = UDim2now(0, 210, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(6, 16, 8); Sidebar.BackgroundTransparency = 0.1; Sidebar.BorderSizePixel = 0
    Instance.new('UICorner', Sidebar).CornerRadius = UDim.new(0, 10)

    -- Sidebar accent divider
    local SideDiv = Instance.new('Frame', Sidebar); SideDiv.Size = UDim2now(0, 2, 1, 0); SideDiv.Position = UDim2now(1, -2, 0, 0); SideDiv.BackgroundColor3 = AccentColor; SideDiv.BorderSizePixel = 0

    local Branding = Instance.new('Frame', Sidebar); Branding.Size = UDim2now(1, 0, 0, 72); Branding.BackgroundTransparency = 1
    local BrandTitle = Instance.new('TextLabel', Branding); BrandTitle.Size = UDim2now(1, -20, 0, 28); BrandTitle.Position = UDim2now(0, 10, 0, 10); BrandTitle.Text = 'THE REAL'; BrandTitle.TextColor3 = Color3.new(1, 1, 1); BrandTitle.Font = Enum.Font.GothamBold; BrandTitle.TextSize = 25; BrandTitle.TextXAlignment = 0; BrandTitle.BackgroundTransparency = 1

    local BrandLink = Instance.new('TextButton', Branding); BrandLink.Size = UDim2now(1, -20, 0, 18); BrandLink.Position = UDim2now(0, 10, 0, 40); BrandLink.Text = 'discord.gg/6AE5zUQB'; BrandLink.TextColor3 = Color3.fromRGB(150, 255, 150); BrandLink.Font = Enum.Font.GothamBold; BrandLink.TextSize = 11; BrandLink.TextXAlignment = 0; BrandLink.BackgroundTransparency = 0.8; BrandLink.BackgroundColor3 = Color3.fromRGB(20, 40, 20); BrandLink.TextWrapped = true
    Instance.new("UICorner", BrandLink).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", BrandLink).Color = Color3.fromRGB(40, 80, 40)

    -- Subtle Branding Animation (Shine)
    local Shine = Instance.new("Frame", Branding); Shine.Size = UDim2now(0, 50, 1, 0); Shine.Position = UDim2now(-0.5, 0, 0, 0); Shine.BackgroundColor3 = Color3.new(1,1,1); Shine.BackgroundTransparency = 0.9; Shine.Rotation = 15; Shine.BorderSizePixel = 0
    task.spawn(function()
        while task.wait(5) do
            Shine.Position = UDim2now(-0.5, 0, 0, 0)
            Tween:Create(Shine, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Position = UDim2now(1.5, 0, 0, 0)}):Play()
        end
    end)

    BrandLink.MouseButton1Click:Connect(function()
        setClipboard('https://discord.gg/6AE5zUQB')
        BrandLink.Text = "COPIED!"
        BrandLink.TextColor3 = Color3.new(1,1,1)
        task.wait(1.5)
        BrandLink.Text = 'discord.gg/6AE5zUQB'
        BrandLink.TextColor3 = Color3.fromRGB(240, 200, 150)
    end)


    -- Tab scroll container (so tabs never get cut off)
    local TabScroll = Instance.new('ScrollingFrame', Sidebar)
    TabScroll.Name = 'TabScroll'
    TabScroll.Size = UDim2now(1, -4, 1, -210)
    TabScroll.Position = UDim2now(0, 2, 0, 75)
    TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0; TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; TabScroll.BorderSizePixel = 0
    local TabLayout = Instance.new('UIListLayout', TabScroll); TabLayout.Padding = UDim.new(0, 4); TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local TabPad = Instance.new('UIPadding', TabScroll); TabPad.PaddingLeft = UDim.new(0, 8); TabPad.PaddingRight = UDim.new(0, 8); TabPad.PaddingTop = UDim.new(0, 4)
    self.TabScroll = TabScroll

    -- Identity panel at the bottom of the sidebar
    local IdentityPanel = Instance.new('Frame', Sidebar)
    IdentityPanel.Size = UDim2now(1, -16, 0, 120)
    IdentityPanel.Position = UDim2now(0, 8, 1, -128)
    IdentityPanel.BackgroundColor3 = Color3.fromRGB(8, 20, 10); IdentityPanel.BackgroundTransparency = 0.2; IdentityPanel.BorderSizePixel = 0
    Instance.new('UICorner', IdentityPanel).CornerRadius = UDim.new(0, 8)
    Instance.new('UIStroke', IdentityPanel).Color = Color3.fromRGB(30, 60, 35)

    local alb = Instance.new('ImageLabel', IdentityPanel); alb.Size = UDim2now(0, 48, 0, 48); alb.Position = UDim2now(0, 10, 0, 8); alb.Image = 'rbxthumb://type=AvatarHeadShot&id='..Client.UserId..'&w=150&h=150'; alb.BackgroundTransparency = 1; Instance.new('UICorner', alb).CornerRadius = UDim.new(1, 0)
    local sng = Instance.new('TextLabel', IdentityPanel); sng.Size = UDim2now(1, -70, 0, 18); sng.Position = UDim2now(0, 66, 0, 8); sng.Text = Client.DisplayName or Client.Name; sng.TextColor3 = Color3.new(1,1,1); sng.Font = Enum.Font.GothamBold; sng.TextSize = 13; sng.TextXAlignment = 0; sng.BackgroundTransparency = 1; sng.ClipsDescendants = true
    local nameSub = Instance.new('TextLabel', IdentityPanel); nameSub.Size = UDim2now(1,-70,0,14); nameSub.Position = UDim2now(0,66,0,28); nameSub.Text = '@'..Client.Name; nameSub.TextColor3 = Color3.fromRGB(150, 180, 150); nameSub.Font = Enum.Font.Gotham; nameSub.TextSize = 11; nameSub.TextXAlignment = 0; nameSub.BackgroundTransparency = 1

    local playT = Instance.new('TextLabel', IdentityPanel); playT.Name = "PT"; playT.Size = UDim2now(1, -16, 0, 14); playT.Position = UDim2now(0, 10, 0, 62); playT.Text = 'Playtime: 0h 0m'; playT.TextColor3 = Color3.fromRGB(180, 180, 180); playT.Font = Enum.Font.Gotham; playT.TextSize = 11; playT.TextXAlignment = 0; playT.BackgroundTransparency = 1
    local yenT = Instance.new('TextLabel', IdentityPanel); yenT.Name = "YT"; yenT.Size = UDim2now(1, -16, 0, 14); yenT.Position = UDim2now(0, 10, 0, 78); yenT.Text = 'Yen: 0'; yenT.TextColor3 = Color3.fromRGB(255, 230, 0); yenT.Font = Enum.Font.Gotham; yenT.TextSize = 11; yenT.TextXAlignment = 0; yenT.BackgroundTransparency = 1
    local totalYen = Instance.new('TextLabel', IdentityPanel); totalYen.Name = "TY"; totalYen.Size = UDim2now(1, -16, 0, 14); totalYen.Position = UDim2now(0, 10, 0, 96); totalYen.Text = 'Total: 0'; totalYen.TextColor3 = AccentColor; totalYen.Font = Enum.Font.GothamBold; totalYen.TextSize = 11; totalYen.TextXAlignment = 0; totalYen.BackgroundTransparency = 1


    -- Top bar
    local Title = Instance.new('TextLabel', TopBar); Title.Size = UDim2now(0, 500, 1, 0); Title.Position = UDim2now(0, 20, 0, 0); Title.Text = 'BIZARRE LINEAGE'; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 32; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0



    local StatusBox = Instance.new('Frame', TopBar); StatusBox.Size = UDim2now(0, 120, 0, 38); StatusBox.Position = UDim2now(1, -140, 0.5, -19); StatusBox.BackgroundColor3 = Color3.fromRGB(10, 30, 15); StatusBox.BackgroundTransparency = 0.3; Instance.new('UICorner', StatusBox).CornerRadius = UDim.new(0, 6)
    local fpsL = Instance.new('TextLabel', StatusBox); fpsL.Size = UDim2now(1, 0, 1, 0); fpsL.Text = 'FPS: 0'; fpsL.TextColor3 = AccentColor; fpsL.Font = Enum.Font.GothamBold; fpsL.TextSize = 18; fpsL.BackgroundTransparency = 1


    -- Content area (adjusted for right-docked panel)
    local Content = Instance.new('Frame', Main)
    Content.Size = UDim2now(1, -440, 1, -68)
    Content.Position = UDim2now(0, 215, 0, 60)
    Content.BackgroundTransparency = 1

    -- Map Items side panel (DOCKER INSIDE MAIN)
    local ItemPanel = Instance.new('Frame', Main)
    ItemPanel.Name = "ItemPanel"
    ItemPanel.Size = UDim2now(0, 210, 1, -68)
    ItemPanel.Position = UDim2now(1, -215, 0, 60)
    ItemPanel.BackgroundColor3 = Color3.fromRGB(5, 14, 8); ItemPanel.BackgroundTransparency = 0.15; ItemPanel.BorderSizePixel = 0
    Instance.new('UICorner', ItemPanel).CornerRadius = UDim.new(0, 8)
    Instance.new('UIStroke', ItemPanel).Color = Color3.fromRGB(20, 60, 30)

    local iT = Instance.new('TextLabel', ItemPanel); iT.Size = UDim2now(1, 0, 0, 30); iT.Position = UDim2now(0,0,0,6); iT.Text = '  MAP ITEMS'; iT.TextColor3 = AccentColor; iT.Font = Enum.Font.GothamBold; iT.TextSize = 14; iT.BackgroundTransparency = 1; iT.TextXAlignment = 0

    -- Search box for Map Items
    local iSearch = Instance.new('TextBox', ItemPanel); iSearch.Name = 'Search'; iSearch.Size = UDim2now(1, -14, 0, 28); iSearch.Position = UDim2now(0, 7, 0, 36); iSearch.BackgroundColor3 = Color3.fromRGB(8, 20, 10); iSearch.TextColor3 = Color3.new(1,1,1); iSearch.Font = Enum.Font.Gotham; iSearch.TextSize = 12; iSearch.PlaceholderText = 'Search items...'; iSearch.PlaceholderColor3 = Color3.fromRGB(80,120,80); iSearch.Text = ''; iSearch.ClearTextOnFocus = false; iSearch.BorderSizePixel = 0
    Instance.new('UICorner', iSearch).CornerRadius = UDim.new(0, 4)
    Instance.new('UIStroke', iSearch).Color = Color3.fromRGB(40, 80, 50)

    local iList = Instance.new('ScrollingFrame', ItemPanel); iList.Name = "List"; iList.Size = UDim2now(1, -10, 1, -78); iList.Position = UDim2now(0, 5, 0, 72); iList.BackgroundTransparency = 1; iList.BorderSizePixel = 0; iList.ScrollBarThickness = 2; iList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", iList).Padding = UDim.new(0, 2)

    -- Fixed Search logic
    iSearch:GetPropertyChangedSignal('Text'):Connect(function()
        local q = iSearch.Text:lower()
        for _, child in ipairs(iList:GetChildren()) do
            if child:IsA('TextLabel') then
                child.Visible = (q == '' or child.Text:lower():find(q, 1, true) ~= nil)
            end
        end
    end)

    -- DETAILS POPUP OVERLAY
    local PopupOverlay = Instance.new("Frame", Main); PopupOverlay.Size = UDim2now(1, -210, 1, -60); PopupOverlay.Position = UDim2now(0, 215, 0, 60); PopupOverlay.BackgroundColor3 = Color3.fromRGB(5,12,8); PopupOverlay.BackgroundTransparency = 0.05; PopupOverlay.ZIndex = 50; PopupOverlay.Visible = false
    Instance.new('UICorner', PopupOverlay).CornerRadius = UDim.new(0, 8)
    local PopImg = Instance.new("ImageLabel", PopupOverlay); PopImg.Size = UDim2now(0, 260, 0, 260); PopImg.Position = UDim2now(0.5, -130, 0, 30); PopImg.BackgroundTransparency = 1; PopImg.ZIndex = 51
    local PopTitle = Instance.new("TextLabel", PopupOverlay); PopTitle.Size = UDim2now(1, -40, 0, 36); PopTitle.Position = UDim2now(0, 20, 0, 300); PopTitle.TextColor3 = Color3.new(1,1,1); PopTitle.Font = Enum.Font.GothamBold; PopTitle.TextSize = 24; PopTitle.BackgroundTransparency = 1; PopTitle.TextXAlignment = 0; PopTitle.ZIndex = 51
    local PopDesc = Instance.new("TextLabel", PopupOverlay); PopDesc.Size = UDim2now(1, -40, 0, 160); PopDesc.Position = UDim2now(0, 20, 0, 340); PopDesc.TextColor3 = Color3.fromRGB(200,200,200); PopDesc.Font = Enum.Font.Gotham; PopDesc.TextSize = 14; PopDesc.TextWrapped = true; PopDesc.TextYAlignment = Enum.TextYAlignment.Top; PopDesc.BackgroundTransparency = 1; PopDesc.ZIndex = 51; PopDesc.TextXAlignment = 0
    local PopBack = Instance.new("TextButton", PopupOverlay); PopBack.Size = UDim2now(0, 140, 0, 38); PopBack.Position = UDim2now(0, 20, 1, -58); PopBack.BackgroundColor3 = Color3.fromRGB(10,30,15); PopBack.TextColor3 = AccentColor; PopBack.Font = Enum.Font.GothamBold; PopBack.TextSize = 13; PopBack.Text = "← BACK"; PopBack.ZIndex = 51; Instance.new("UIStroke", PopBack).Color = AccentColor; Instance.new("UICorner", PopBack).CornerRadius = UDim.new(0, 6)
    PopBack.MouseButton1Click:Connect(function() PopupOverlay.Visible = false end)

    -- ENGINE Guard label
    local GuardLabel = Instance.new("TextLabel", SG); GuardLabel.Size = UDim2now(0, 140, 0, 22); GuardLabel.Position = UDim2now(1, -155, 0, 8); GuardLabel.BackgroundTransparency = 1; GuardLabel.TextColor3 = Color3.new(1,1,1); GuardLabel.Font = Enum.Font.GothamBold; GuardLabel.TextSize = 13; GuardLabel.Text = "ENGINE: [LOCK]"; GuardLabel.TextXAlignment = Enum.TextXAlignment.Right; GuardLabel.Visible = true; GuardLabel.ZIndex = 100
    local GuardStroke = Instance.new("UIStroke", GuardLabel); GuardStroke.Color = Color3.new(0,0,0); GuardStroke.Thickness = 2
    local GuardZone = Instance.new("Frame", SG); GuardZone.Size = UDim2now(0, 220, 0, 60); GuardZone.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3); GuardZone.BackgroundTransparency = 0.92; GuardZone.BorderSizePixel = 0; GuardZone.Visible = false; GuardZone.ZIndex = 0

    -- Boss HP Bar (custom, always-on-top UI element)
    local BossBar = Instance.new('Frame', SG); BossBar.Name = 'BossHPBar'; BossBar.Size = UDim2now(0, 500, 0, 52); BossBar.Position = UDim2now(0.5, -250, 0, 8); BossBar.BackgroundColor3 = Color3.fromRGB(8, 20, 12); BossBar.BackgroundTransparency = 0.15; BossBar.Visible = false; BossBar.ZIndex = 200; BossBar.BorderSizePixel = 0
    Instance.new('UICorner', BossBar).CornerRadius = UDim.new(0, 8)
    Instance.new('UIStroke', BossBar).Color = Color3.fromRGB(200, 60, 60)
    local BBName = Instance.new('TextLabel', BossBar); BBName.Size = UDim2now(1, -20, 0, 18); BBName.Position = UDim2now(0, 10, 0, 4); BBName.Text = 'Boss Name'; BBName.TextColor3 = Color3.new(1,1,1); BBName.Font = Enum.Font.GothamBold; BBName.TextSize = 13; BBName.TextXAlignment = 0; BBName.BackgroundTransparency = 1; BBName.ZIndex = 201
    local BBBg = Instance.new('Frame', BossBar); BBBg.Size = UDim2now(1, -20, 0, 16); BBBg.Position = UDim2now(0, 10, 0, 26); BBBg.BackgroundColor3 = Color3.fromRGB(30, 15, 15); BBBg.BorderSizePixel = 0; BBBg.ZIndex = 201; Instance.new('UICorner', BBBg).CornerRadius = UDim.new(1, 0)
    local BBFill = Instance.new('Frame', BBBg); BBFill.Name = 'Fill'; BBFill.Size = UDim2now(1, 0, 1, 0); BBFill.BackgroundColor3 = Color3.fromRGB(200, 50, 50); BBFill.BorderSizePixel = 0; BBFill.ZIndex = 202; Instance.new('UICorner', BBFill).CornerRadius = UDim.new(1, 0)
    local BBText = Instance.new('TextLabel', BBBg); BBText.Name = 'HPText'; BBText.Size = UDim2now(1, 0, 1, 0); BBText.Text = '0/0'; BBText.TextColor3 = Color3.new(1,1,1); BBText.Font = Enum.Font.GothamBold; BBText.TextSize = 11; BBText.BackgroundTransparency = 1; BBText.ZIndex = 203

    -- Play Again notification banner (styled like Boss HP Bar)
    local PlayAgainBanner = Instance.new('Frame', SG); PlayAgainBanner.Name = 'PlayAgainBanner'; PlayAgainBanner.Size = UDim2now(0, 500, 0, 52); PlayAgainBanner.Position = UDim2now(0.5, -250, 0, 8); PlayAgainBanner.BackgroundColor3 = Color3.fromRGB(8, 20, 12); PlayAgainBanner.BackgroundTransparency = 0.15; PlayAgainBanner.Visible = false; PlayAgainBanner.ZIndex = 200; PlayAgainBanner.BorderSizePixel = 0
    Instance.new('UICorner', PlayAgainBanner).CornerRadius = UDim.new(0, 8)
    Instance.new('UIStroke', PlayAgainBanner).Color = AccentColor
    local PALabel = Instance.new('TextLabel', PlayAgainBanner); PALabel.Size = UDim2now(1, 0, 1, 0); PALabel.Text = 'BOSS DEFEATED! | CLICKING PLAY AGAIN...'; PALabel.TextColor3 = AccentColor; PALabel.Font = Enum.Font.GothamBold; PALabel.TextSize = 16; PALabel.BackgroundTransparency = 1; PALabel.ZIndex = 201


    -- Correctly populate self.Elements without overwriting existing data
    local e = self.Elements
    e.Main=Main; e.Sidebar=Sidebar; e.Content=Content; e.FPS=fpsL; e.ItemList=iList; e.ItemPanel=ItemPanel; e.Popup=PopupOverlay; e.PopImg=PopImg; e.PopTitle=PopTitle; e.PopDesc=PopDesc; e.PT=playT; e.YT=yenT; e.TY=totalYen; e.Guard=GuardLabel; e.GuardZone=GuardZone; e.BossBar=BossBar; e.BBName=BBName; e.BBFill=BBFill; e.BBText=BBText; e.PlayAgainBanner=PlayAgainBanner
    
    ItemPanel.Visible = Settings.ShowItemPanel or false

    -- STARTUP ANIMATION
    task.spawn(function()
        Tween:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Back), {Position = UDim2now(0.5, -490, 0.5, -340), GroupTransparency = (Settings.UITransparency or 0)/100}):Play()
    end)

    
    UIS.InputBegan:Connect(function(io, busy)
        if busy then return end
        if io.KeyCode == Enum.KeyCode[Settings.MenuKey] then
            Main.Visible = not Main.Visible
        elseif io.KeyCode == Enum.KeyCode[Settings.MasterKey] then
            Settings.EngineActive = not Settings.EngineActive
            local active = Settings.EngineActive
            Tween:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                GroupTransparency = active and (Settings.UITransparency/100) or 1
            }):Play()
            local vis = workspace:FindFirstChild("LiteExtreme_Visualizer")
            if vis then vis.Transparency = active and 0.8 or 1 end
        end
    end)
end

function UI_Master:AddTab(name, index, icon)
    -- Tabs now go into the scrollable TabScroll container, layout is handled by UIListLayout
    local b = Instance.new('TextButton', self.TabScroll)
    b.Size = UDim2now(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(12, 28, 16); b.BackgroundTransparency = 0.4; b.Text = '  ' .. name; b.TextColor3 = Color3.fromRGB(160, 210, 160); b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.TextXAlignment = 0; b.AutoButtonColor = false; b.BorderSizePixel = 0
    Instance.new('UICorner', b).CornerRadius = UDim.new(0, 6)
    local im = Instance.new('ImageLabel', b); im.Size = UDim2now(0, 16, 0, 16); im.Position = UDim2now(1, -28, 0.5, -8); im.Image = icon or 'rbxassetid://6031230111'; im.BackgroundTransparency = 1; im.ImageColor3 = Color3.fromRGB(160, 210, 160)
    b.MouseEnter:Connect(function() 
        if self.Pages[name] and self.Pages[name].Visible then return end
        Tween:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(20, 40, 30), BackgroundTransparency = 0.4}):Play() 
    end)
    b.MouseLeave:Connect(function() 
        if self.Pages[name] and self.Pages[name].Visible then return end
        Tween:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(12, 28, 16), BackgroundTransparency = 0.4}):Play() 
    end)
    
    b.MouseButton1Down:Connect(function() Tween:Create(b, TweenInfo.new(0.1), {Size = UDim2now(1, -10, 0, 34)}):Play() end)
    b.MouseButton1Up:Connect(function() Tween:Create(b, TweenInfo.new(0.1), {Size = UDim2now(1, 0, 0, 38)}):Play() end)

    b.MouseButton1Click:Connect(function() self:Switch(name) end)
    self.Buttons[name] = b
    
    local p = Instance.new('Frame', self.Elements.Content)
    p.Name = name .. '_Page'
    p.Size = UDim2now(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false;
    
    local scroll = Instance.new('ScrollingFrame', p)
    scroll.Size = UDim2now(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 2; scroll.ScrollBarImageColor3 = AccentColor; scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.BorderSizePixel = 0
    
    local llo = Instance.new('UIListLayout', scroll); llo.Padding = UDim.new(0, 6); llo.SortOrder = Enum.SortOrder.LayoutOrder
    local ppad = Instance.new('UIPadding', scroll); ppad.PaddingLeft = UDim.new(0, 4); ppad.PaddingRight = UDim.new(0, 4); ppad.PaddingTop = UDim.new(0, 6)
    self.Pages[name] = p
    self.Elements[name .. '_Scroll'] = scroll
end



function UI_Master:Switch(name)
    for k, v in pairs(self.Pages) do
        if k == name then
            v.Visible = true
            -- Subtle pop animation for the page
            v.Size = UDim2now(1, 10, 1, 10)
            v.Position = UDim2now(0, -5, 0, -5)
            Tween:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2now(1,0,1,0), Position = UDim2now(0,0,0,0)}):Play()
        else
            v.Visible = false
        end
    end
    for k, v in pairs(self.Buttons) do
        local act = (k == name)
        Tween:Create(v, TweenInfo.new(0.3), {
            BackgroundColor3 = act and AccentColor or Color3now(15, 30, 20),
            BackgroundTransparency = act and 0.1 or 0.6,
            TextColor3 = act and Color3now(255, 255, 255) or Color3now(150, 150, 150)
        }):Play()
    end
    self.Elements.Popup.Visible = false
end



function UI_Master:AddToggle(page, label, key, tooltip, callback)
    local state = Settings[key] or false
    local f = Instance.new("Frame", page); f.Size = UDim2now(1, -10, 0, 45); f.BackgroundColor3 = Color3now(15, 20, 15); f.BackgroundTransparency = 0.6; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3now(30, 40, 30)
    local t = Instance.new("TextLabel", f); t.Size = UDim2now(1, -60, 1, 0); t.Position = UDim2now(0, 60, 0, 0); t.Text = label; t.TextColor3 = Color3.new(0.9,0.9,0.9); t.Font = Enum.Font.GothamBold; t.TextSize = 14; t.TextXAlignment = 0; t.BackgroundTransparency = 1
    
    if tooltip then
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
    local str = Instance.new("UIStroke", b); str.Color = AccentColor; str.Transparency = 1; str.Thickness = 2
    b.MouseButton1Click:Connect(function() 
        Settings[key] = not Settings[key]
        local s = Settings[key]
        local info = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Tween:Create(b, info, {BackgroundColor3 = s and AccentColor or Color3now(30, 35, 30)}):Play()
        Tween:Create(i, info, {Position = UDim2now(s and 1 or 0, s and -18 or 2, 0.5, -8)}):Play()
        Tween:Create(str, info, {Transparency = s and 0.5 or 1}):Play()
        if callback then callback(s) end
    end)
    
    f.MouseEnter:Connect(function() 
        Tween:Create(f, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(25, 25, 28), BackgroundTransparency = 0.4}):Play() 
        if Settings[key] then Tween:Create(str, TweenInfo.new(0.3), {Transparency = 0}):Play() end
    end)
    f.MouseLeave:Connect(function() 
        Tween:Create(f, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(10, 10, 12), BackgroundTransparency = 0.6}):Play() 
        if Settings[key] then Tween:Create(str, TweenInfo.new(0.3), {Transparency = 0.5}):Play() end
    end)
end



function UI_Master:AddSlider(page, label, key, min, max, sfx, prec)
    local val = Settings[key] or min
    local f = Instance.new("Frame", page); f.Size = UDim2now(1, -10, 0, 55); f.BackgroundColor3 = Color3now(15, 20, 15); f.BackgroundTransparency = 0.6; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3now(30, 40, 30)
    local t = Instance.new("TextLabel", f); t.Size = UDim2now(1, -20, 0, 20); t.Position = UDim2now(0, 10, 0, 5); t.Text = label .. ": " .. string.format("%."..(prec or 0).."f", val) .. (sfx or ""); t.TextColor3 = Color3.new(0.9,0.9,0.9); t.Font = Enum.Font.GothamBold; t.TextSize = 13; t.TextXAlignment = 0; t.BackgroundTransparency = 1
    local bg = Instance.new("Frame", f); bg.Size = UDim2now(1, -20, 0, 6); bg.Position = UDim2now(0,10, 0, 35); bg.BackgroundColor3 = Color3now(30, 35, 30); Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    local pctI = math_clamp((val-min)/(max-min), 0, 1)
    local fl = Instance.new("Frame", bg); fl.Size = UDim2now(pctI, 0, 1, 0); fl.BackgroundColor3 = AccentColor; Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", fl); knob.Size = UDim2now(0, 14, 0, 14); knob.Position = UDim2now(1, -7, 0.5, -7); knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200); Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob); knobStroke.Color = AccentColor; knobStroke.Transparency = 1; knobStroke.Thickness = 2
    local kb = Instance.new("TextButton", f); kb.Size = UDim2now(1, -20, 0, 30); kb.Position = UDim2now(0, 10, 0, 20); kb.BackgroundTransparency = 1; kb.Text = ""
    local md = false
    kb.InputBegan:Connect(function(io) 
        if io.UserInputType == Enum.UserInputType.MouseButton1 then 
            md = true
            Tween:Create(knob, TweenInfo.new(0.1), {Size = UDim2now(0, 18, 0, 18), Position = UDim2now(1, -9, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            Tween:Create(knobStroke, TweenInfo.new(0.1), {Transparency = 0.5}):Play()
        end 
    end)
    UIS.InputEnded:Connect(function(io) 
        if io.UserInputType == Enum.UserInputType.MouseButton1 then 
            md = false
            Tween:Create(knob, TweenInfo.new(0.2), {Size = UDim2now(0, 14, 0, 14), Position = UDim2now(1, -7, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            Tween:Create(knobStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        end 
    end)
    UIS.InputChanged:Connect(function(io) 
        if md and io.UserInputType == Enum.UserInputType.MouseMovement then 
            local pct = math_clamp((io.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            local rawVal = min + ((max - min) * pct)
            if prec and prec > 0 then
                Settings[key] = tonumber(string.format("%."..prec.."f", rawVal))
            else
                Settings[key] = math_floor(rawVal)
            end
            t.Text = label .. ": " .. string.format("%."..(prec or 0).."f", Settings[key]) .. (sfx or "")
            fl.Size = UDim2now(pct, 0, 1, 0)
            if key == "UITransparency" and self.Elements.Main then
                self.Elements.Main.GroupTransparency = Settings[key] / 100
            end
        end 
    end)
    
    f.MouseEnter:Connect(function() Tween:Create(f, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(25, 35, 30), BackgroundTransparency = 0.4}):Play() end)
    f.MouseLeave:Connect(function() Tween:Create(f, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(15, 20, 15), BackgroundTransparency = 0.7}):Play() end)
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
                local match = (q == "") or (string.find(nm, q, 1, true) ~= nil)
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
CreateConsole()

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
local scD = UI_Master.Elements.Dashboard_Scroll
UI_Master:AddToggle(scD, "True Instinct", "AutoRoka", "Automatically uses Rokakaka if stand is not desired.")
local logF = Instance.new("ScrollingFrame", scD); logF.Size = UDim2.new(1, -10, 0, 180); logF.BackgroundColor3 = Color3.fromRGB(15, 20, 15); logF.BackgroundTransparency = 0.5; logF.BorderSizePixel = 0; logF.ScrollBarThickness = 2; logF.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UICorner", logF).CornerRadius = UDim.new(0, 4); local lt = Instance.new("Frame", logF); lt.Size = UDim2.new(1, -20, 1, -20); lt.Position = UDim2.new(0, 10, 0, 10); lt.BackgroundTransparency = 1; Instance.new("UIListLayout", lt).Padding = UDim.new(0, 4)
local function Line(t, c) local l = Instance.new("TextLabel", lt); l.Size = UDim2.new(1, 0, 0, 18); l.Text = t; l.TextColor3 = c or Color3.fromRGB(150, 180, 150); l.Font = Enum.Font.Code; l.TextSize = 11; l.TextXAlignment = 0; l.BackgroundTransparency = 1 end
Line("THE REAL v43 Loaded.", AccentColor)
Line("Visual Overhaul Applied.", Color3.new(0.5, 0.8, 1))

-- Combat
local scC = UI_Master.Elements.Combat_Scroll
UI_Master:AddToggle(scC, "Auto M1", "AutoM1", "Auto Left Click continuously")
UI_Master:AddToggle(scC, "God Mode", "GodModeActive", "Attempts to loop dodge I-frames")
UI_Master:AddSlider(scC, "Click Speed (Hold)", "ClickSpeed", 0.001, 0.05, "s", 3)
UI_Master:AddSlider(scC, "Attack Interval", "MacroInterval", 0.001, 0.5, "s", 3)

-- Skills
local scSkills = UI_Master.Elements.Skills_Scroll
UI_Master:AddToggle(scSkills, "Auto E (Barrage)", "AutoSkillE")
UI_Master:AddToggle(scSkills, "Auto R (Heavy)", "AutoSkillR")
UI_Master:AddToggle(scSkills, "Auto Z", "AutoSkillZ")
UI_Master:AddToggle(scSkills, "Auto X", "AutoSkillX")
UI_Master:AddToggle(scSkills, "Auto C", "AutoSkillC")
UI_Master:AddToggle(scSkills, "Auto V", "AutoSkillV")


-- ESP
local scESP = UI_Master.Elements.ESP_Scroll
UI_Master:AddToggle(scESP, "NPC ESP (Yellow)", "NPC_ESP")
UI_Master:AddToggle(scESP, "Boss ESP (Red)", "Boss_ESP")
UI_Master:AddToggle(scESP, "Player ESP (Ice Cyan)", "Player_ESP")
UI_Master:AddToggle(scESP, "Item ESP (Light Green)", "Item_ESP")
UI_Master:AddToggle(scESP, "Map Items Panel", "ShowItemPanel", "Toggle visibility of the right side panel", function(s)
    UI_Master.Elements.ItemPanel.Visible = s
end)
UI_Master:AddToggle(scESP, "Hitbox Visualizer", "VisualizerActive", "Shows the scanning range sphere")

-- Farming
local scF = UI_Master.Elements.Farming_Scroll
UI_Master:AddToggle(scF, "Auto Farm", "AutoFarm", "Farm NPCs/Bosses around you", function(s)
    Settings.AutoM1 = s
end)
UI_Master:AddToggle(scF, "Attack Bosses Only", "FarmOnlyBoss")
UI_Master:AddToggle(scF, "Advanced Scan (Deeper)", "AdvancedScan", "Scans more objects (May cause FPS drops!)")
local fWarn = Instance.new("TextLabel", scF); fWarn.Size = UDim2now(1, -10, 0, 30); fWarn.Text = "⚠️ ADVANCED SCAN: RECOMMENDED FOR BEST ITEM DETECTION"; fWarn.TextColor3 = Color3.fromRGB(255, 100, 100); fWarn.Font = Enum.Font.GothamBold; fWarn.TextSize = 10; fWarn.BackgroundTransparency = 1; fWarn.TextWrapped = true
UI_Master:AddSlider(scF, "Scan Interval", "ScanInterval", 0.1, 5, "s", 1)
UI_Master:AddDropdown(scF, "Attack Angle", "FarmAngle", {"Below (Default)", "Above", "Behind", "Front", "Right", "Left"})
UI_Master:AddSlider(scF, "Attack Distance", "FarmDist", 0, 15)
UI_Master:AddSlider(scF, "Max Scan Range", "TargetRange", 10, 500)
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
    row.MouseEnter:Connect(function() Tween:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(40, 45, 40)}):Play() end)
    row.MouseLeave:Connect(function() Tween:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3now(30, 35, 30)}):Play() end)
end
MakeRangeSlider(scF, "Item ESP Range", "ItemESPRange", 30, 2000)

-- Raid
local scR = UI_Master.Elements.Raid_Scroll
UI_Master:AddToggle(scR, "Auto Raid", "AutoRaid")
UI_Master:AddToggle(scR, "Auto Enter", "RaidAutoEnter")
UI_Master:AddToggle(scR, "Auto Retry", "RaidAutoRetry")
UI_Master:AddSlider(scR, "Raid Retry Delay", "RaidDelay", 0, 5, "s")

-- Tools
local scTools = UI_Master.Elements.Tools_Scroll
UI_Master:AddToggle(scTools, "Auto Dialog (Skip NPCs)", "AutoDialog")
UI_Master:AddToggle(scTools, "Stealth Mode", "StealthMode", "Makes your character transparent locally")
UI_Master:AddToggle(scTools, "Auto Stand (Tab Summon)", "AutoStand", "Automatically presses Tab to summon Stand if missing")

local shBtn = Instance.new("TextButton", scTools); shBtn.Size = UDim2now(1, -10, 0, 40); shBtn.BackgroundColor3 = SecondaryGreen; shBtn.Text = "SERVER HOP (Random)"; shBtn.TextColor3 = Color3now(255,255,255); shBtn.Font = Enum.Font.GothamBold; shBtn.TextSize = 14; Instance.new("UICorner", shBtn)
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
local scT = UI_Master.Elements.Teleport_Scroll
UI_Master:AddToggle(scT, "Safe TP", "SafeTP", "Tweens character to destination safely")
UI_Master:AddSlider(scT, "TP Speed", "WalkSpeed", 16, 500)

for i=1, 20 do
    local b = Instance.new("TextButton", scT); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(20, 30, 20); b.Text = "Teleport: Stop " .. i; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 12; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseEnter:Connect(function() Tween:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 50, 40)}):Play() end)
    b.MouseLeave:Connect(function() Tween:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 30, 20)}):Play() end)
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
local scM = UI_Master.Elements.Misc_Scroll
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
            local pct = math_clamp((io.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            local val = math_floor(minV + (maxV-minV)*pct)
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
    row.MouseEnter:Connect(function() Tween:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 45, 40)}):Play() end)
    row.MouseLeave:Connect(function() Tween:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 35, 30)}):Play() end)
end

AddSpeedControl(scM, "Walk Speed (16 = default)", "WalkSpeed", 16, 8, 500)
AddSpeedControl(scM, "Jump Power (50 = default)", "JumpPower", 50, 20, 500)

local mapHdr = Instance.new("TextLabel", scM); mapHdr.Size = UDim2.new(1,-10,0,25); mapHdr.Text = "-- Farm Extras --"; mapHdr.TextColor3 = AccentColor; mapHdr.Font = Enum.Font.GothamBold; mapHdr.TextSize = 12; mapHdr.TextXAlignment = 0; mapHdr.BackgroundTransparency = 1
UI_Master:AddToggle(scM, "Auto Farm Items", "AutoItemFarm")
UI_Master:AddToggle(scM, "Master Toggle (Key: K)", "EngineActive", "Main switch for all combat and farm hooks")

local perfHdr = Instance.new("TextLabel", scM); perfHdr.Size = UDim2.new(1,-10,0,25); perfHdr.Text = "-- Performance Tweaks --"; perfHdr.TextColor3 = AccentColor; perfHdr.Font = Enum.Font.GothamBold; perfHdr.TextSize = 12; perfHdr.TextXAlignment = 0; perfHdr.BackgroundTransparency = 1
UI_Master:AddToggle(scM, "Advanced Scan (Deeper, Slower)", "AdvancedScan")
UI_Master:AddSlider(scM, "Scan Interval (Seconds)", "ScanInterval", 1, 5)

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
local scW = UI_Master.Elements.Wiki_Scroll
UI_Master:AddWikiSearch(scW)
for _, item in ipairs(WikiData) do UI_Master:AddWikiEntry(scW, item) end

-- Settings
local scS = UI_Master.Elements.Settings_Scroll
local function Snd() pcall(function() local s = Instance.new("Sound", game.SoundService); s.SoundId = "rbxassetid://6518811702"; s.Volume = 0.9; s.RollOffMaxDistance = 100; s:Play(); game:GetService("Debris"):AddItem(s, 2) end) end
local function MakeSect(parent, title) local hdr = Instance.new("TextLabel", parent); hdr.Size = UDim2.new(1,-10,0,22); hdr.Text = title; hdr.TextColor3 = Color3.new(1,1,1); hdr.Font = Enum.Font.GothamBold; hdr.TextSize = 13; hdr.TextXAlignment = 0; hdr.BackgroundTransparency = 1; return hdr end
local function MakeInput(parent, label, defaultVal, onChange)
    local wrap = Instance.new("Frame", parent); wrap.Size = UDim2.new(1,-10,0,60); wrap.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", wrap); lbl.Size = UDim2.new(1,0,0,20); lbl.Text = label; lbl.TextColor3 = AccentColor; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = 0; lbl.BackgroundTransparency = 1
    local box = Instance.new("TextBox", wrap); box.Size = UDim2.new(1,0,0,32); box.Position = UDim2.new(0,0,0,22); box.BackgroundColor3 = Color3.fromRGB(8,18,10); box.TextColor3 = Color3.new(1,1,1); box.Font = Enum.Font.GothamBold; box.TextSize = 13; box.Text = tostring(defaultVal); box.ClearTextOnFocus = false; Instance.new("UICorner",box).CornerRadius = UDim.new(0,4); Instance.new("UIStroke",box).Color = AccentColor
    box.Focused:Connect(function() Snd() end)
    box:GetPropertyChangedSignal("Text"):Connect(function() pcall(function() onChange(box.Text) end) end)
    return box
end

MakeInput(scS, "Config File Name:", Settings.ConfigName, function(v) Settings.ConfigName = v end)

local saveBtn = Instance.new("TextButton", scS); saveBtn.Size = UDim2.new(1,-10,0,38); saveBtn.BackgroundColor3 = Color3.fromRGB(0,80,30); saveBtn.TextColor3 = Color3.new(1,1,1); saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 14; saveBtn.Text = "SAVE CONFIG"; Instance.new("UICorner",saveBtn).CornerRadius = UDim.new(0,4)
saveBtn.MouseButton1Click:Connect(function() Snd(); SaveConfig(); saveBtn.Text = "CONFIG SAVED"; saveBtn.BackgroundColor3 = AccentColor; task.delay(2, function() saveBtn.Text = "SAVE CONFIG"; saveBtn.BackgroundColor3 = Color3.fromRGB(0,80,30) end) end)

local loadBtn = Instance.new("TextButton", scS); loadBtn.Size = UDim2.new(1,-10,0,38); loadBtn.BackgroundColor3 = Color3.fromRGB(0,40,80); loadBtn.TextColor3 = Color3.new(1,1,1); loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 14; loadBtn.Text = "LOAD CONFIG"; Instance.new("UICorner",loadBtn).CornerRadius = UDim.new(0,4)
loadBtn.MouseButton1Click:Connect(function() Snd(); LoadConfig(); loadBtn.Text = "LOADED!"; loadBtn.BackgroundColor3 = AccentColor; task.delay(2, function() loadBtn.Text = "LOAD CONFIG"; loadBtn.BackgroundColor3 = Color3.fromRGB(0,40,80) end) end)

UI_Master:AddToggle(scS, "Auto Rejoin", "AutoRejoin")
UI_Master:AddToggle(scS, "Anti AFK", "AntiAFK")
UI_Master:AddSlider(scS, "UI Transparency", "UITransparency", 0, 100, "%")
UI_Master:AddSlider(scS, "Raid Start Delay", "RaidDelay", 0.1, 5, "s", 1)

MakeSect(scS, "Keybinds")
local function MakeBind(label, keySetting)
    local b = Instance.new("TextButton", scS); b.Size = UDim2.new(1,-10,0,38); b.BackgroundColor3 = Color3.fromRGB(30,30,60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.Text = label .. ": [" .. Settings[keySetting] .. "]"; Instance.new("UICorner",b).CornerRadius = UDim.new(0,4); Instance.new("UIStroke",b).Color = AccentColor
    local waiting = false
    b.MouseButton1Click:Connect(function()
        if waiting then return end; waiting = true; b.Text = "Press any key..."; b.BackgroundColor3 = Color3.fromRGB(60,60,0)
        local conn; conn = UIS.InputBegan:Connect(function(inp, gp)
            if gp then return end
            local n = inp.KeyCode.Name ~= "Unknown" and inp.KeyCode.Name or inp.UserInputType.Name
            Settings[keySetting] = n; b.Text = label .. ": [" .. n .. "]"; b.BackgroundColor3 = Color3.fromRGB(0,60,20)
            Snd(); conn:Disconnect(); waiting = false
        end)
    end)
end
MakeBind("Menu Key", "MenuKey")
MakeBind("Master Toggle Key", "MasterKey")

local confFrame = Instance.new("Frame", scS); confFrame.Size = UDim2now(1, -10, 0, 140); confFrame.BackgroundTransparency = 1; Instance.new("UIListLayout", confFrame).Padding = UDim.new(0, 6)
local function PrefBtn(txt, cb) 
    local b = Instance.new("TextButton", confFrame); b.Size = UDim2now(1, 0, 0, 34); b.Text = txt; b.BackgroundColor3 = SecondaryGreen; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.AutoButtonColor = true; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb) 
end

PrefBtn("EXPORT CONFIG (CODE)", function()
    local enc = base64_encode(Http:JSONEncode(Settings))
    setClipboard(enc)
    Line("Config code copied! Share it with friends.", AccentColor)
end)

PrefBtn("IMPORT CONFIG (PASTE CODE)", function()
    local input = getclipboard()
    if not input or #input < 20 then Line("Empty or invalid clipboard!", Color3.new(1,0,0)) return end
    local s, res = pcall(function() return Http:JSONDecode(base64_decode(input)) end)
    if s and type(res) == "table" then
        Line("VALID CONFIG DETECTED", AccentColor)
        local cF = Instance.new("Frame", SG); cF.Size = UDim2now(0, 300, 0, 100); cF.Position = UDim2now(0.5, -150, 0.5, -50); cF.BackgroundColor3 = Color3.new(0.1, 0.2, 0.1); Instance.new("UICorner", cF); cF.ZIndex = 200
        local cT = Instance.new("TextLabel", cF); cT.Size = UDim2now(1, 0, 0, 40); cT.Text = "Use this configuration?"; cT.TextColor3 = Color3.new(1,1,1); cT.Font = Enum.Font.GothamBold; cT.BackgroundTransparency = 1; cT.TextSize = 14; cT.ZIndex = 201
        local yB = Instance.new("TextButton", cF); yB.Size = UDim2now(0.5, -15, 0, 40); yB.Position = UDim2now(0, 10, 0, 50); yB.Text = "YES"; yB.BackgroundColor3 = AccentColor; Instance.new("UICorner", yB); yB.ZIndex = 201
        local nB = Instance.new("TextButton", cF); nB.Size = UDim2now(0.5, -15, 0, 40); nB.Position = UDim2now(0.5, 5, 0, 50); nB.Text = "NO"; nB.BackgroundColor3 = Color3.new(0.4, 0, 0); Instance.new("UICorner", nB); nB.ZIndex = 201
        yB.MouseButton1Click:Connect(function()
            for k,v in pairs(res) do Settings[k] = v end; SaveConfig(); Line("Settings Applied. Re-Teleporting...", AccentColor); cF:Destroy(); task.wait(1); game:GetService("TeleportService"):Teleport(game.PlaceId)
        end)
        nB.MouseButton1Click:Connect(function() cF:Destroy() end)
    else Line("Failed to decode config code!", Color3.new(1,0,0)) end
end)


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
            local active = Settings.EngineActive
            Tween:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                GroupTransparency = active and (Settings.UITransparency/100) or 1
            }):Play()
            local vis = workspace:FindFirstChild("LiteExtreme_Visualizer")
            if vis then vis.Transparency = active and 0.8 or 1 end
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
    
    -- Boss HP Bar update
    local bb = UI_Master.Elements
    if bb.BossBar then
        local target = State.CurrentFarmTarget
        if target and target.Obj and target.IsBoss then
            local th = target.Obj:FindFirstChildOfClass("Humanoid")
            if th and th.MaxHealth > 0 then
                local pct = math.clamp(th.Health / th.MaxHealth, 0, 1)
                bb.BossBar.Visible = true
                bb.BBName.Text = target.Name .. "  |  Lv" .. (target.Obj:FindFirstChild("Level") and target.Obj.Level.Value or "?")
                bb.BBFill.Size = UDim2now(pct, 0, 1, 0)
                bb.BBFill.BackgroundColor3 = (pct > 0.5 and Color3.fromRGB(200, 50, 50) or (pct > 0.2 and Color3.fromRGB(220, 120, 20) or Color3.fromRGB(255, 255, 50)))
                bb.BBText.Text = math_floor(th.Health) .. " / " .. math_floor(th.MaxHealth)
            end
        else
            if bb.BossBar.Visible then bb.BossBar.Visible = false end
        end
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
            local closestItem, minItemDist = nil, 400
            for _, item in ipairs(DetectedItems) do
                if item.IsItem then
                    local d = (hrp.Position - item.Part.Position).Magnitude
                    if d < minItemDist then minItemDist = d; closestItem = item end
                end
            end
            if closestItem then
                pcall(function()
                    -- Teleport exactly to the item
                    hrp.CFrame = closestItem.Part.CFrame
                    task.wait(0.15)
                    local prompt = closestItem.Obj
                    if prompt and prompt:IsA('ProximityPrompt') then
                        local oldHold = prompt.HoldDuration
                        prompt.HoldDuration = 0
                        -- Fire multiple times to ensure pickup in laggy conditions
                        for i=1, 3 do
                            fireproximityprompt(prompt)
                            task.wait(0.1)
                        end
                        pcall(function() prompt.HoldDuration = oldHold end)
                    end
                end)
            end
        end

        -- Hitbox Visualizer
        local visPart = workspace:FindFirstChild("LiteExtreme_Visualizer")
        if Settings.VisualizerActive then
            if not visPart then
                visPart = Instance.new("Part", workspace)
                visPart.Name = "LiteExtreme_Visualizer"
                visPart.Shape = Enum.PartType.Ball
                visPart.CastShadow = false
                visPart.CanCollide = false
                visPart.Anchored = true
                visPart.Material = Enum.Material.ForceField
                visPart.Color = AccentColor
                visPart.Transparency = 0.8
            end
            visPart.CFrame = hrp.CFrame
            visPart.Size = Vector3.new(Settings.TargetRange*2, Settings.TargetRange*2, Settings.TargetRange*2)
        elseif visPart then
            visPart:Destroy()
        end

        -- Auto Raid NPC (Kumbo) Auto-Talk & Auto-Start
        if (Settings.AutoRaid or Settings.RaidAutoEnter) and Settings.EngineActive then
            pcall(function()
                -- Look for Kumbo nearby
                local kumbo = workspace:FindFirstChild("Kumbo", true)
                if kumbo and kumbo:FindFirstChild("HumanoidRootPart") then
                    local dist = (hrp.Position - kumbo.HumanoidRootPart.Position).Magnitude
                    if dist < 15 then
                        local prompt = kumbo:FindFirstChildOfClass("ProximityPrompt", true)
                        if prompt then fireproximityprompt(prompt) end
                        
                        -- Auto-select "Baskın" if dialogue appears
                        local lpGui = Client:FindFirstChild("PlayerGui")
                        if lpGui and lpGui:FindFirstChild("Dialogue") and lpGui.Dialogue.Enabled then
                            local options = lpGui.Dialogue:FindFirstChild("Options", true)
                            if options then
                                for _, opt in ipairs(options:GetChildren()) do
                                    if opt:IsA("TextButton") and (opt.Text:find("Baskın") or opt.Text:find("Raid")) then
                                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                        task.wait(0.1)
                                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        
        -- Auto Stand: summon stand via Tab key if not present (SMART CHECK)
        if Settings.AutoStand and Settings.EngineActive then
            pcall(function()
                local standName = Client.Name .. "'s Stand"
                local hasStand = false
                if workspace:FindFirstChild(standName, true) then hasStand = true end
                if not hasStand and Client.Character then
                    hasStand = Client.Character:FindFirstChild("Stand", true) ~= nil
                end
                if not hasStand then
                    for _, v in ipairs(workspace:GetChildren()) do
                        if v:IsA("Model") and v.Name:find("Stand") and v:FindFirstChild("Owner") and v.Owner.Value == Client then hasStand = true break end
                    end
                end
                
                if not hasStand then
                    VIM:SendKeyEvent(true, Enum.KeyCode.Tab, false, game)
                    task.wait(0.1)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Tab, false, game)
                    task.wait(2) -- Cooldown to let stand appear
                end
            end)
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
    -- HIGH-SPEED CLICKER: runs nearly every frame, boss-death aware
    local lastBossAlive = true
    while true do
        task.wait(0) -- immediate next frame yield (maximum speed)
        local isTyping = UIS:GetFocusedTextBox() ~= nil
        local isPaused = not Settings.EngineActive
        
        -- Boss death check: stop clicking if current target is dead
        local bossAlive = true
        if State.CurrentFarmTarget then
            local th = State.CurrentFarmTarget.Obj and State.CurrentFarmTarget.Obj:FindFirstChild("Humanoid")
            if not th or th.Health <= 0 then
                bossAlive = false
            end
        end
        
        -- Show/hide Play Again banner
        if UI_Master.Elements.PlayAgainBanner then
            UI_Master.Elements.PlayAgainBanner.Visible = (not bossAlive and State.CurrentFarmTarget ~= nil)
        end
        
        if (Settings.AutoM1 or Settings.AutoFarm) and not isTyping and not isPaused and bossAlive then
            pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(Settings.ClickSpeed or 0.005)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                -- Fire auto skills in the same tick
                local skills = {
                    {Key=Enum.KeyCode.E, Active=Settings.AutoSkillE},
                    {Key=Enum.KeyCode.R, Active=Settings.AutoSkillR},
                    {Key=Enum.KeyCode.Z, Active=Settings.AutoSkillZ},
                    {Key=Enum.KeyCode.X, Active=Settings.AutoSkillX},
                    {Key=Enum.KeyCode.C, Active=Settings.AutoSkillC},
                    {Key=Enum.KeyCode.V, Active=Settings.AutoSkillV}
                }
                for _, skill in ipairs(skills) do
                    if skill.Active then
                        VIM:SendKeyEvent(true, skill.Key, false, game)
                        task.wait(0.008)
                        VIM:SendKeyEvent(false, skill.Key, false, game)
                    end
                end
            end)
        else
            task.wait(0.01) -- brief pause when idle to prevent 100% CPU usage
        end
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
        task.spawn(function()
            if not game:IsLoaded() then game.Loaded:Wait() end
            task.wait(1.5)
            warn("[LiteExtreme] Auto-Reloading Engine...")
            
            local s, src = pcall(function()
                return game:HttpGet("https://raw.githubusercontent.com/Aatrxy/BizarreLineage-Lite/main/THE%20REAL.lua", true)
            end)

            if s and src and #src > 100 then
                local func, err = loadstring(src)
                if func then
                    pcall(func)
                    warn("[LiteExtreme] Cloud Reload Complete! UI should be active.")
                else
                    warn("[LiteExtreme] Cloud Syntax Error: ", err)
                end
            else
                warn("[LiteExtreme] Cloud Fetch Failed. Falling back to local files...")
                local success2, localSrc = pcall(function()
                    if isfile("LiteExtreme_V43.lua") then return readfile("LiteExtreme_V43.lua") end
                    if isfile("LiteExtreme.lua") then return readfile("LiteExtreme.lua") end
                    return nil
                end)
                if success2 and localSrc then
                    local f2, e2 = loadstring(localSrc)
                    if f2 then pcall(f2) warn("[LiteExtreme] Local Reload Complete!") end
                else
                    warn("[LiteExtreme] CRITICAL: Backup file not found!")
                end
            end
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
