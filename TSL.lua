--[[
    NC HUB - THE STRONGER LIFTER EDITION (V2.0)
    FIX: LOOP INFINITO + STRUGGLE BYPASS
]]

local TiempoInicio = os.time()
local LP = game.Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. VENTANA
local Window = WindUI:CreateWindow({
    Title = "NC HUB | TSL PRO",
    Author = "By hidjcjgg",
    Folder = "NCHUBScripts",
    Icon = "solar:dumbbell-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(580, 460),
    NewElements = true,
    Topbar = { Height = 44, ButtonsType = "Mac" }
})

-- 2. SECCIONES
local SeccionPrincipal = Window:Section({ Title = "ENTRENAMIENTO" })
local SeccionPersonaje = Window:Section({ Title = "JUGADOR" })
local SeccionSistema = Window:Section({ Title = "SISTEMA" })

-- 3. DASHBOARD (HOME)
local HomeTab = SeccionPrincipal:Tab({ Title = "Dashboard", Icon = "solar:home-2-bold" })
local StatsCard = HomeTab:Section({ Title = "💪 TU PROGRESO", Box = true, BoxBorder = true })
local MuscleLabel = StatsCard:Section({ Title = "💪 Músculo: 0" })
local StageLabel = StatsCard:Section({ Title = "🆙 Etapa: 0" })
local CoinsLabel = StatsCard:Section({ Title = "💰 Monedas: 0" })

-- 4. TRAMPAS (FARM)
local FarmTab = SeccionPrincipal:Tab({ Title = "Auto-Farm", Icon = "solar:bolt-bold" })
local AutoLift, AutoSell, AutoBuy, AutoStage = false, false, false, false

FarmTab:Toggle({ Title = "Auto-Levantar (Struggle Bypass)", Callback = function(s) AutoLift = s end })
FarmTab:Toggle({ Title = "Auto-Vender Músculo", Callback = function(s) AutoSell = s end })
FarmTab:Toggle({ Title = "Auto-Comprar Pesas", Callback = function(s) AutoBuy = s end })
FarmTab:Toggle({ Title = "Auto-Evolucionar (Stage)", Callback = function(s) AutoStage = s end })

-- 5. MOVIMIENTO
local MovTab = SeccionPersonaje:Tab({ Title = "Movimiento", Icon = "solar:walking-bold" })
MovTab:Slider({ Title = "Velocidad", Min = 16, Max = 200, Default = 16, Callback = function(v) LP.Character.Humanoid.WalkSpeed = v end })

-- 6. SISTEMA
local SisTab = SeccionSistema:Tab({ Title = "Herramientas", Icon = "solar:settings-bold" })
SisTab:Button({ Title = "Dark Dex", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end })
SisTab:Button({ Title = "SimpleSpy", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))() end })
SisTab:Button({ Title = "Cerrar Hub", Callback = function() Window:Destroy() end })

-- ==========================================
-- 🏁 LÓGICA MAESTRA (TSL ENGINE)
-- ==========================================
task.spawn(function()
    local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
    local Remotes = require(Shared.Remotes)
    
    while true do
        pcall(function()
            -- Monitor de Stats
            local ls = LP:FindFirstChild("leaderstats")
            if ls then
                MuscleLabel:SetTitle("💪 Músculo: " .. (ls:FindFirstChild("Muscle") and ls.Muscle.Value or 0))
                StageLabel:SetTitle("🆙 Etapa: " .. (ls:FindFirstChild("Stage") and ls.Stage.Value or 0))
                CoinsLabel:SetTitle("💰 Monedas: " .. (ls:FindFirstChild("Coins") and ls.Coins.Value or 0))
            end

            -- 2. Lógica de Auto-Levantar (SIMULACIÓN HUMANA)
            if AutoLift then
                pcall(function()
                    -- 1. Iniciamos el levantamiento
                    Remotes.Lifting.LiftingStatus:Fire(true)
                    
                    -- 2. SIMULACIÓN DE ESFUERZO DINÁMICO
                    -- Si te cuesta levantarla, el servidor espera más tiempo.
                    -- Vamos a probar con 0.5 segundos, que es un tiempo estándar de "repetición".
                    task.wait(0.5) 
                    
                    -- 3. Enviamos la petición de músculo
                    Remotes.Lifting.LiftRequest:Fire()
                    
                    -- 4. Mantenemos un poco más para asegurar que el servidor registre el éxito
                    task.wait(0.1)
                    
                    -- 5. Terminamos la repetición (Limpieza de estado)
                    Remotes.Lifting.LiftingStatus:Fire(false)
                    
                    -- 6. Pequeño descanso antes de la siguiente (Vital para que el servidor no se bloquee)
                    task.wait(0.2)
                end)
            end

            if AutoSell then Remotes.ClientRequests.SellMuscle:Fire() end
            if AutoStage then Remotes.Bloodline.UpgradeRequest:Fire() end
            
            if AutoBuy then
                local W = {"Stick", "Mouse", "Water", "Soccer Ball", "Bottle", "Textbook", "Bucket", "Wood", "Guitar", "Dumbbell", "Chair", "Cart", "TV", "Bicycle", "Desk", "Bed", "Log", "Canoe", "Tyre", "Refrigerator", "Drum", "Hydrant", "Piano", "Motorcycle", "Safe", "Flag", "ATM", "RX-7", "EVO", "G-Class", "Van", "Tree", "Container", "Sailboat", "Bus", "Truck"}
                for _, weight in pairs(W) do Remotes.Shops.BuyItem:Fire(weight, "Weights") end
            end
        end)
        task.wait(0.1)
    end
end)
