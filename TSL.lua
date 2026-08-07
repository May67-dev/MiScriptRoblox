--[[
    NC HUB - THE STRONGER LIFTER EDITION
    AUTOR: hidjcjgg
    ESTILO: BENTO BOX FUTURISTA (MORADO/AZUL)
]]

local TiempoInicio = os.time()
local LP = game.Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CONFIGURACIÓN DE LA VENTANA
local Window = WindUI:CreateWindow({
    Title = "NC HUB | TSL",
    Author = "By hidjcjgg",
    Folder = "NCHUBScripts",
    Icon = "solar:dumbbell-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(580, 460),
    NewElements = true,
    Topbar = { Height = 44, ButtonsType = "Mac" }
})

-- 2. SECCIONES DEL SIDEBAR (PERSONALIZADAS PARA TSL)
local SeccionPrincipal = Window:Section({ Title = "ENTRENAMIENTO" })
local SeccionPersonaje = Window:Section({ Title = "JUGADOR" })
local SeccionSistema = Window:Section({ Title = "SISTEMA" })

-- 3. PESTAÑA: DASHBOARD (HOME)
local HomeTab = SeccionPrincipal:Tab({ Title = "Dashboard", Icon = "solar:home-2-bold" })
local StatsCard = HomeTab:Section({ Title = "💪 TUS ESTADÍSTICAS", Box = true })
local MuscleLabel = StatsCard:Section({ Title = "Fuerza: 0" })
local StageLabel = StatsCard:Section({ Title = "Etapa: 0" })
local FameLabel = StatsCard:Section({ Title = "Fama: 0" })
local TimeLabel = StatsCard:Section({ Title = "⏳ Sesión: 0h 0m 0s" })

task.spawn(function()
    while true do
        pcall(function()
            local ls = LP:FindFirstChild("leaderstats")
            if ls then
                MuscleLabel:SetTitle("💪 Músculo: " .. (ls:FindFirstChild("Muscle") and ls.Muscle.Value or 0))
                StageLabel:SetTitle("🆙 Etapa: " .. (ls:FindFirstChild("Stage") and ls.Stage.Value or 0))
                FameLabel:SetTitle("⭐ Fama: " .. (ls:FindFirstChild("Fame") and ls.Fame.Value or 0))
            end
            local s = os.time() - TiempoInicio
            local m, h = math.floor(s/60), math.floor(s/3600)
            TimeLabel:SetTitle(string.format("⏳ Sesión: %dh %dm %ds", h, m%60, s%60))
        end)
        task.wait(1)
    end
end)

-- 4. PESTAÑA: AUTO-FARM (LA JOYITA)
local FarmTab = SeccionPrincipal:Tab({ Title = "Auto-Farm", Icon = "solar:ghost-bold" })
local AutoLift, AutoSell, AutoBuy, AutoStage = false, false, false, false

FarmTab:Toggle({ Title = "Auto-Levantar (Loop Infinito)", Callback = function(s) AutoLift = s end })
FarmTab:Toggle({ Title = "Auto-Vender Músculo", Callback = function(s) AutoSell = s end })
FarmTab:Toggle({ Title = "Auto-Subir Etapa (Stage)", Callback = function(s) AutoStage = s end })
FarmTab:Toggle({ Title = "Auto-Comprar Pesas", Callback = function(s) AutoBuy = s end })

-- 5. PESTAÑA: MOVIMIENTO (JUGADOR)
local MoveTab = SeccionPersonaje:Tab({ Title = "Movimiento", Icon = "solar:walking-bold" })
MoveTab:Slider({ Title = "Velocidad", Default = 16, Min = 16, Max = 250, Callback = function(v) LP.Character.Humanoid.WalkSpeed = v end })
MoveTab:Slider({ Title = "Salto", Default = 50, Min = 50, Max = 300, Callback = function(v) LP.Character.Humanoid.JumpPower = v end })

-- 6. PESTAÑA: SISTEMA
local SisTab = SeccionSistema:Tab({ Title = "Herramientas", Icon = "solar:settings-bold" })
SisTab:Button({ Title = "Dark Dex", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end })
SisTab:Button({ Title = "SimpleSpy", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))() end })
SisTab:Button({ Title = "Cerrar Hub", Callback = function() Window:Destroy() end })

-- ==========================================
-- 🏁 MOTOR DE EJECUCIÓN (LÓGICA TSL)
-- ==========================================
task.spawn(function()
    local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
    local Remotes = require(Shared:WaitForChild("Remotes"))
    
    while true do
        if AutoLift then
            pcall(function()
                Remotes.Lifting.LiftingStatus:Fire(true)
                task.wait(0.05)
                Remotes.Lifting.LiftRequest:Fire()
                task.wait(0.05)
                Remotes.Lifting.LiftingStatus:Fire(false)
            end)
        end
        
        if AutoSell then pcall(function() Remotes.ClientRequests.SellMuscle:Fire() end) end
        if AutoStage then pcall(function() Remotes.Bloodline.UpgradeRequest:Fire() end) end
        
        if AutoBuy then
            pcall(function()
                local W = {"Stick", "Mouse", "Water", "Soccer Ball", "Bottle", "Textbook", "Bucket", "Wood", "Guitar", "Dumbbell", "Chair", "Cart", "TV", "Bicycle", "Desk", "Bed", "Log", "Canoe", "Tyre", "Refrigerator", "Drum", "Hydrant", "Piano", "Motorcycle", "Safe", "Flag", "ATM", "RX-7", "EVO", "G-Class", "Van", "Tree", "Container", "Sailboat", "Bus", "Truck"}
                for _, w in pairs(W) do Remotes.Shops.BuyItem:Fire(w, "Weights") end
            end)
        end
        task.wait(0.1)
    end
end)
