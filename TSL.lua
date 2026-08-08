--[[
    NC HUB - THE STRONGER LIFTER | MASTER EDITION (V3.0)
    AUTOR: hidjcjgg
    ESTILO: BENTO BOX PREMIUM (DARK/PURPLE)
    MEJORAS: SLIDER FIX, STRUGGLE BYPASS, TELEPORTS, ANTI-AFK
]]

local LP = game.Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- VARIABLES DE CONTROL
local AutoLift, AutoSell, AutoBuy, AutoStage, AutoEgg = false, false, false, false, false
local SelectedEgg = "Basic Egg"
local VelocidadUsuario = 16
local AntiAFK = true

-- SEGURIDAD: FIX VELOCIDAD
local function ApplySpeed()
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = VelocidadUsuario
        end
    end)
end

-- 1. VENTANA PRINCIPAL
local Window = WindUI:CreateWindow({
    Title = "NC HUB | TSL MASTER",
    Author = "By hidjcjgg",
    Folder = "NCHUBScripts",
    Icon = "solar:dumbbell-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(580, 480),
    NewElements = true,
    Topbar = { Height = 44, ButtonsType = "Mac" }
})

-- 2. SECCIONES DEL SIDEBAR
local SeccionHome = Window:Section({ Title = "DASHBOARD" })
local SeccionFarm = Window:Section({ Title = "AUTOMATIZACIÓN" })
local SeccionTeleport = Window:Section({ Title = "TELEPORTS" })
local SeccionPlayer = Window:Section({ Title = "JUGADOR" })
local SeccionSistema = Window:Section({ Title = "SISTEMA" })

-- 3. DASHBOARD (MONITOR DE STATS)
local HomeTab = SeccionHome:Tab({ Title = "Dashboard", Icon = "solar:home-2-bold" })
local StatsCard = HomeTab:Section({ Title = "💪 MONITOR DE PROGRESO", Box = true, BoxBorder = true })
local MuscleLabel = StatsCard:Section({ Title = "💪 Músculo: 0" })
local StageLabel = StatsCard:Section({ Title = "🆙 Etapa: 0" })
local CoinsLabel = StatsCard:Section({ Title = "💰 Monedas: 0" })

task.spawn(function()
    while true do
        pcall(function()
            local ls = LP:FindFirstChild("leaderstats")
            if ls then
                MuscleLabel:SetTitle("💪 Músculo: " .. (ls:FindFirstChild("Muscle") and ls.Muscle.Value or 0))
                StageLabel:SetTitle("🆙 Etapa: " .. (ls:FindFirstChild("Stage") and ls.Stage.Value or 0))
                CoinsLabel:SetTitle("💰 Monedas: " .. (ls:FindFirstChild("Coins") and ls.Coins.Value or 0))
            end
        end)
        task.wait(1)
    end
end)

-- 4. AUTO-FARM (LIFT, SELL, BUY, STAGE)
local FarmTab = SeccionFarm:Tab({ Title = "Auto-Farm", Icon = "solar:bolt-bold" })
local FarmCard = FarmTab:Section({ Title = "🤖 FARMING", Box = true, BoxBorder = true })
FarmCard:Toggle({ Title = "Auto-Levantar (Bypass)", Callback = function(s) AutoLift = s end })
FarmCard:Toggle({ Title = "Auto-Vender", Callback = function(s) AutoSell = s end })
FarmCard:Toggle({ Title = "Auto-Comprar Pesas", Callback = function(s) AutoBuy = s end })
FarmCard:Toggle({ Title = "Auto-Etapa (Stage)", Callback = function(s) AutoStage = s end })

local EggCard = FarmTab:Section({ Title = "🥚 AUTO-HUEVOS", Box = true, BoxBorder = true })
EggCard:Dropdown({
    Title = "Seleccionar Huevo",
    Values = {"Basic Egg", "Rare Egg", "Epic Egg", "Legendary Egg"},
    Callback = function(v) SelectedEgg = v end
})
EggCard:Toggle({ Title = "Abrir Automáticamente", Callback = function(s) AutoEgg = s end })

-- 5. TELEPORTS (ZONAS CLAVE)
local TPTab = SeccionTeleport:Tab({ Title = "Zonas", Icon = "solar:map-bold" })
local Zones = {
    ["Zona de Venta"] = Vector3.new(0, 5, 0), 
    ["Gimnasio Principal"] = Vector3.new(100, 5, 100),
    ["Zona de Huevos"] = Vector3.new(-50, 5, -50)
}

for name, pos in pairs(Zones) do
    TPTab:Button({
        Title = "Ir a " .. name,
        Callback = function()
            pcall(function() LP.Character.HumanoidRootPart.CFrame = CFrame.new(pos) end)
        end
    })
end

-- 6. JUGADOR (HACKS & ANTI-AFK)
local PlayerTab = SeccionPlayer:Tab({ Title = "Hacks", Icon = "solar:ghost-bold" })
PlayerTab:Slider({
    Title = "Velocidad",
    Step = 1,
    Value = { Min = 16, Max = 256, Default = 16 },
    Callback = function(v) 
        VelocidadUsuario = v 
        ApplySpeed()
    end
})
PlayerTab:Toggle({ Title = "Anti-AFK (VirtualUser)", Default = true, Callback = function(s) AntiAFK = s end })

-- 7. SISTEMA
local SisTab = SeccionSistema:Tab({ Title = "Herramientas", Icon = "solar:settings-bold" })
SisTab:Button({ Title = "Dark Dex", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end })
SisTab:Button({ Title = "SimpleSpy", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))() end })
SisTab:Button({ Title = "Cerrar NC HUB", Callback = function() Window:Destroy() end })

-- 🏁 LÓGICA DE EJECUCIÓN (TSL ENGINE)
task.spawn(function()
    local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
    local Remotes = require(Shared.Remotes)
    
    while true do
        pcall(function()
            if AutoLift then
                Remotes.Lifting.LiftingStatus:Fire(true)
                task.wait(0.05)
                Remotes.Lifting.LiftRequest:Fire()
                if Remotes.Lifting:FindFirstChild("StruggleRemote") then Remotes.Lifting.StruggleRemote:Fire() end
                task.wait(0.05)
                Remotes.Lifting.LiftingStatus:Fire(false)
            end
            if AutoSell then Remotes.ClientRequests.SellMuscle:Fire() end
            if AutoStage then Remotes.Bloodline.UpgradeRequest:Fire() end
            if AutoBuy then
                local W = {"Stick", "Mouse", "Water", "Soccer Ball", "Bottle", "Textbook", "Bucket", "Wood", "Guitar", "Dumbbell", "Chair", "Cart", "TV", "Bicycle", "Desk", "Bed", "Log", "Canoe", "Tyre", "Refrigerator", "Drum", "Hydrant", "Piano", "Motorcycle", "Safe", "Flag", "ATM", "RX-7", "EVO", "G-Class", "Van", "Tree", "Container", "Sailboat", "Bus", "Truck"}
                for _, weight in pairs(W) do Remotes.Shops.BuyItem:Fire(weight, "Weights") end
            end
            if AutoEgg then Remotes.Shops.OpenEgg:Fire(SelectedEgg) end
            ApplySpeed()
        end)
        task.wait(0.1)
    end
end)

-- ANTI-AFK LOGIC
local VirtualUser = game:GetService("VirtualUser")
LP.Idled:Connect(function()
    if AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

WindUI:Notify({ Title = "NC HUB", Content = "TSL Master Edition Cargada", Duration = 5 })
