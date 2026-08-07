--[[
    NC HUB - MASTER EDITION (VERSION 4.0)
    AUTOR: hidjcjgg
    ESTILO: BENTO BOX FUTURISTA (MORADO/AZUL)
    LONGITUD: +550 LÍNEAS DE CÓDIGO PURO
]]

-- ==========================================
-- 0. CONFIGURACIÓN INICIAL Y VARIABLES
-- ==========================================
local TiempoInicio = os.time()
local LP = game.Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CREACIÓN DE LA VENTANA (TAMAÑO PRO)
local Window = WindUI:CreateWindow({
    Title = "NC HUB",
    Author = "By hidjcjgg",
    Folder = "NCHUBScripts",
    Icon = "solar:bolt-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(600, 480),
    NewElements = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

-- 2. SECCIONES DEL SIDEBAR
local SeccionHome = Window:Section({ Title = "HOME" })
local SeccionTrampas = Window:Section({ Title = "TRAMPAS" })
local SeccionJuegos = Window:Section({ Title = "JUEGOS" })
local SeccionSistema = Window:Section({ Title = "SISTEMA" })

-- ==========================================
-- 3. PESTAÑA: DASHBOARD (DISEÑO BENTO BOX)
-- ==========================================
local HomeTab = SeccionHome:Tab({
    Title = "Dashboard",
    Icon = "solar:widget-bold"
})

local userId = LP.UserId
local fotoUrl = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=420&h=420"

-- TARJETA: PERFIL
local CardPerfil = HomeTab:Section({
    Title = "🔮 IDENTIDAD DIGITAL",
    Box = true,
    BoxBorder = true
})

CardPerfil:Image({
    Image = fotoUrl,
    AspectRatio = "1:1",
    Radius = 100
})

CardPerfil:Section({ Title = "👤 Usuario: " .. LP.Name })
CardPerfil:Section({ Title = "📅 Antigüedad: " .. LP.AccountAge .. " días" })

-- TARJETA: SISTEMA
local CardSesion = HomeTab:Section({
    Title = "🌌 MONITOR DE SISTEMA",
    Box = true,
    BoxBorder = true
})

local TimeLabel = CardSesion:Section({ Title = "⏳ Tiempo Activo: 0h 0m 0s" })
CardSesion:Section({ Title = "💎 Status: NC HUB Operacional" })

task.spawn(function()
    while true do
        local seg = os.time() - TiempoInicio
        local h = math.floor(seg / 3600)
        local m = math.floor(seg / 60) % 60
        local s = seg % 60
        local texto = string.format("%dh %dm %ds", h, m, s)
        pcall(function() TimeLabel:SetTitle("⏳ Tiempo Activo: " .. texto) end)
        task.wait(1)
    end
end)

-- ==========================================
-- 4. PESTAÑA: TRAMPAS (MOVIMIENTO, HACKS, VUELO)
-- ==========================================
local MovTab = SeccionTrampas:Tab({ Title = "Movimiento", Icon = "solar:walking-bold" })
local HackTab = SeccionTrampas:Tab({ Title = "Hacks", Icon = "solar:ghost-bold" })
local FlyTab = SeccionTrampas:Tab({ Title = "Vuelo", Icon = "solar:plain-bold" })

-- MOVIMIENTO
MovTab:Slider({
    Title = "Velocidad",
    Step = 1,
    Value = { Min = 16, Max = 256, Default = 16 },
    Callback = function(v) LP.Character.Humanoid.WalkSpeed = v end
})

local InfJump = false
MovTab:Toggle({ Title = "Salto Infinito", Callback = function(s) InfJump = s end })
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and LP.Character then LP.Character.Humanoid:ChangeState("Jumping") end
end)

-- HACKS
local Noclip = false
HackTab:Toggle({ Title = "Noclip (Paredes)", Callback = function(s) Noclip = s end })
game:GetService("RunService").Stepped:Connect(function()
    if Noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

HackTab:Toggle({
    Title = "ESP (Ver Jugadores)",
    Callback = function(s)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character then
                if s then
                    local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(150, 0, 255)
                else
                    if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
                end
            end
        end
    end
})

-- VUELO PRO (MANTENIDO INTACTO)
local Vuelo = false
local VelVuelo = 80
FlyTab:Slider({ Title = "Velocidad Vuelo", Value = { Min = 10, Max = 400, Default = 80 }, Callback = function(v) VelVuelo = v end })
FlyTab:Toggle({
    Title = "Activar Vuelo",
    Callback = function(s)
        Vuelo = s
        local root = LP.Character:WaitForChild("HumanoidRootPart")
        local hum = LP.Character:WaitForChild("Humanoid")
        if Vuelo then
            hum.PlatformStand = true
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "FlyForce"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            local bg = Instance.new("BodyGyro", root)
            bg.Name = "FlyGyro"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            task.spawn(function()
                while Vuelo do
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    if hum.MoveDirection.Magnitude > 0 then
                        local look = workspace.CurrentCamera.CFrame.LookVector
                        local right = workspace.CurrentCamera.CFrame.RightVector
                        bv.Velocity = ((look * hum.MoveDirection:Dot(Vector3.new(look.X, 0, look.Z).Unit)) + (right * hum.MoveDirection:Dot(Vector3.new(right.X, 0, right.Z).Unit))).Unit * VelVuelo
                    else bv.Velocity = Vector3.new(0, 0, 0) end
                    task.wait()
                end
                hum.PlatformStand = false
                if root:FindFirstChild("FlyForce") then root.FlyForce:Destroy() end
                if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
                hum:ChangeState("GettingUp")
            end)
        end
    end
})

-- ==========================================
-- 5. PESTAÑA: MURDER MYSTERY 2 (MANTENIDA)
-- ==========================================
local MM2Tab = SeccionJuegos:Tab({ Title = "Murder Mystery 2", Icon = "solar:danger-bold" })
local RolesESP = false
local AutoGrab = false
local MM2Visuals = MM2Tab:Group({ Title = "Visuales y ESP" })
MM2Visuals:Toggle({
    Title = "Revelar Roles",
    Callback = function(state)
        RolesESP = state
        task.spawn(function()
            while RolesESP do
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local color = Color3.fromRGB(0, 255, 0)
                        local hasKnife = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                        local hasGun = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                        if hasKnife then color = Color3.fromRGB(255, 0, 0) elseif hasGun then color = Color3.fromRGB(0, 0, 255) end
                        local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                        h.FillColor = color
                        h.Enabled = true
                    end
                end
                task.wait(1)
            end
            for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end
        end)
    end
})
local MM2Combat = MM2Tab:Group({ Title = "Ventajas de Combate" })
MM2Combat:Toggle({
    Title = "Auto-Grab Gun",
    Callback = function(state)
        AutoGrab = state
        task.spawn(function()
            while AutoGrab do
                for _, v in pairs(workspace:GetDescendants()) do
                    if (v.Name == "GunDrop" or v.Name == "Gun") and v:IsA("Model") then
                        if not v:FindFirstAncestorOfClass("Model") or not v:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            local root = LP.Character:FindFirstChild("HumanoidRootPart")
                            local target = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                            if root and target then root.CFrame = target.CFrame; task.wait(1) end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
})

-- ==========================================
-- PESTAÑA: FACTORY TYCOON (MONITOR PRO)
-- ==========================================
local FactoryTab = SeccionJuegos:Tab({ Title = "Factory Tycoon", Icon = "solar:factory-bold" })
local AutoCollectF, AutoBuyF, AutoRebirthF = false, false, false

local CardStatsF = FactoryTab:Section({ Title = "📊 ESTADO DE FÁBRICA", Box = true, BoxBorder = true })
local MoneyLabelF = CardStatsF:Section({ Title = "💵 Efectivo: $0" })
local GemsLabelF = CardStatsF:Section({ Title = "💎 Gemas: 0" })
local LevelLabelF = CardStatsF:Section({ Title = "🆙 Nivel: 0" })

task.spawn(function()
    while true do
        pcall(function()
            local df = LP:WaitForChild("DataFolder")
            MoneyLabelF:SetTitle("💵 Efectivo: $" .. df.Money.Value)
            GemsLabelF:SetTitle("💎 Gemas: " .. df.Gems.Value)
            LevelLabelF:SetTitle("🆙 Nivel: " .. LP.leaderstats.Level.Value)
        end)
        task.wait(1)
    end
end)

local CardFarmF = FactoryTab:Section({ Title = "🤖 AUTOMATIZACIÓN", Box = true, BoxBorder = true })
CardFarmF:Toggle({ Title = "Auto-Collect Remoto", Callback = function(s) AutoCollectF = s end })
CardFarmF:Toggle({ Title = "Auto-Buy Inteligente", Callback = function(s) AutoBuyF = s end })
CardFarmF:Toggle({ Title = "Auto-Rebirth Glitch", Callback = function(s) AutoRebirthF = s end })

-- --- LABORATORIO EXPERIMENTAL (VERSIÓN FINAL CON INYECCIÓN) ---
local CardExp = FactoryTab:Section({ 
    Title = "🧪 LABORATORIO (EXPERIMENTAL)", 
    Box = true, 
    BoxBorder = true 
})

CardExp:Button({
    Title = "Generar 1 Billón (Inyección)",
    Desc = "Usa UpdateNormalData para sumar dinero",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Events.UpdateNormalData:FireServer("Increment", LP, LP.DataFolder.Money, 1000000000)
        end)
        WindUI:Notify({Title = "NC HUB", Content = "Petición de 1B enviada."})
    end
})

CardExp:Button({
    Title = "Desbloquear Base Completa",
    Desc = "Marca todos los botones como comprados",
    Callback = function()
        local tycoon = LP:FindFirstChild("TycoonOwned") and LP.TycoonOwned.Value
        if tycoon then
            pcall(function()
                for _, v in pairs(tycoon.Buttons:GetChildren()) do
                    game:GetService("ReplicatedStorage").Events.UpdateNormalData:FireServer("Tycoon_SetTrue", LP, nil, v.Name)
                end
            end)
            WindUI:Notify({Title = "NC HUB", Content = "Desbloqueo masivo iniciado."})
        end
    end
})

CardExp:Button({
    Title = "Simular Pago (Replay Attack)",
    Callback = function()
        pcall(function()
            local args = {[1] = "\48\7\t\21vXX@o<\14-\8\5\2\2(\17DNtn^Y@?\n\17\17/'\19\11\20:\1\11/XDNx{9\13\21\2\17\0\2\"\28\8\1\t\26" .. "SZvPJ_"}
            game:GetService("ReplicatedStorage").Events.PayPlayer:FireServer(unpack(args))
        end)
    end
})

CardExp:Button({
    Title = "Maxear Boost 5x (Local)",
    Callback = function()
        pcall(function()
            local boost = LP.DataFolder:FindFirstChild("Money5xBoost")
            if boost then boost.Value = os.time() + 999999 end
        end)
    end
})

CardExp:Button({
    Title = "Desbloquear Pases (Server Spoof)",
    Callback = function()
        local pases = {"2xGems", "2xMoney", "2xXP", "AutoCollect", "ExtremeGrinder", "ShinyOres", "VIP"}
        for _, v in pairs(pases) do
            pcall(function()
                game:GetService("ReplicatedStorage").Events.GamepassRelated.UpdateGamepassOwnership:FireServer(v, true)
                game:GetService("ReplicatedStorage").Events.GamepassEffect:FireServer(v)
            end)
        end
    end
})

-- LÓGICA DE FÁBRICA (VERSIÓN 5.0)
task.spawn(function()
    local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    while true do
        local tycoon = LP:FindFirstChild("TycoonOwned") and LP.TycoonOwned.Value
        if tycoon then
            -- Auto Collect
            if AutoCollectF then pcall(function() Events.CollectMoney:FireServer(tycoon.Build.Collect) end) end
            
            -- Auto Buy Inteligente (Usa ButtonUsed real)
            if AutoBuyF then
                pcall(function()
                    for _, v in pairs(tycoon.Buttons:GetChildren()) do
                        if v:FindFirstChild("Price") and v:FindFirstChild("IsButtonVisible") and v.IsButtonVisible.Value then
                            if not (v:FindFirstChild("GamepassID") or v:FindFirstChild("ProductID")) then
                                if LP.DataFolder.Money.Value >= v.Price.Value then
                                    Events.ButtonUsed:FireServer(v.Name)
                                end
                            end
                        end
                    end
                end)
            end
            
            -- Auto Rebirth Glitch
            if AutoRebirthF then pcall(function() Events.RequestRebirth:FireServer(184, 184, tycoon) end) end
        end
        task.wait(0.5)
    end
end)

-- --- 📈 SECCIÓN: LABORATORIO DE ESTADÍSTICAS ---
local CardStats = FactoryTab:Section({ 
    Title = "📈 STATS MODIFIER (BETA)", 
    Box = true, 
    BoxBorder = true 
})

CardStats:Button({
    Title = "Subir 1 Nivel (Inyección XP)",
    Desc = "Intenta darte XP para subir de nivel y ganar 1 gema",
    Callback = function()
        local Events = game:GetService("ReplicatedStorage").Events
        pcall(function()
            -- Buscamos el valor de XP. Si no sabes dónde está, 
            -- intentaremos inyectar directamente al Nivel
            local Level = LP.leaderstats:FindFirstChild("Level")
            if Level then
                -- Intentamos incrementar el nivel directamente en 1
                Events.UpdateNormalData:FireServer("Increment", LP, Level, 1)
                WindUI:Notify({Title = "Stats", Content = "Petición de +1 Nivel enviada."})
            end
        end)
    end
})

CardStats:Button({
    Title = "Gemas Gratis (Micro-Pack)",
    Desc = "Intenta inyectar 10 gemas de forma segura",
    Callback = function()
        local Events = game:GetService("ReplicatedStorage").Events
        pcall(function()
            local Gems = LP.DataFolder:FindFirstChild("Gems")
            if Gems then
                -- Pedimos solo 10 para no activar alarmas
                Events.UpdateNormalData:FireServer("Increment", LP, Gems, 10)
            end
        end)
    end
})

CardStats:Button({
    Title = "Loop de Nivel (Auto-Farm Gemas)",
    Desc = "Sube niveles sin parar (si funciona el de arriba)",
    Callback = function()
        _G.LevelLoop = not _G.LevelLoop
        task.spawn(function()
            local Events = game:GetService("ReplicatedStorage").Events
            local Level = LP.leaderstats:FindFirstChild("Level")
            while _G.LevelLoop and Level do
                pcall(function() 
                    Events.UpdateNormalData:FireServer("Increment", LP, Level, 1) 
                end)
                task.wait(2) -- Esperamos 2 segundos entre niveles para disimular
            end
        end)
        local estado = _G.LevelLoop and "Activado" or "Desactivado"
        WindUI:Notify({Title = "Loop", Content = "Auto-Nivel: " .. estado})
    end
})


-- ==========================================
-- PESTAÑA: HACK A BUSINESS (NEW!)
-- ==========================================
local HABTab = SeccionJuegos:Tab({ Title = "Hack Business", Icon = "solar:cup-bold" })
local AutoHABCollect, AutoHABDeposit, AutoHABBuy, AutoHABRob = false, false, false, false

-- MONITOR DE RECURSOS
local HABStats = HABTab:Section({ Title = "📊 ESTADO DE NEGOCIO", Box = true, BoxBorder = true })
local HABMoneyLabel = HABStats:Section({ Title = "💵 Dinero: $0" })
local HABFilesLabel = HABStats:Section({ Title = "💾 Archivos: 0" })

task.spawn(function()
    while true do
        pcall(function()
            local ls = LP:WaitForChild("leaderstats")
            HABMoneyLabel:SetTitle("💵 Dinero: $" .. ls.Money.Value)
            HABFilesLabel:SetTitle("💾 Archivos: " .. ls.Files.Value)
        end)
        task.wait(1)
    end
end)

-- AUTOMATIZACIÓN
local HABFarm = HABTab:Section({ Title = "🤖 AUTO-HACKER", Box = true, BoxBorder = true })
HABFarm:Toggle({ Title = "Auto-Collect (Money)", Callback = function(s) AutoHABCollect = s end })
HABFarm:Toggle({ Title = "Auto-Deposit (Files)", Callback = function(s) AutoHABDeposit = s end })
HABFarm:Toggle({ Title = "Auto-Buy Business", Callback = function(s) AutoHABBuy = s end })
HABFarm:Toggle({ Title = "Auto-Rob Files", Callback = function(s) AutoHABRob = s end })

-- LÓGICA DE EJECUCIÓN HACK A BUSINESS
task.spawn(function()
    local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToServer")
    
    while true do
        if AutoHABCollect then pcall(function() Events.Collect:FireServer() end) end
        if AutoHABDeposit then pcall(function() Events.Deposit:FireServer() end) end
        
        if AutoHABRob then
            pcall(function()
                -- Intentamos iniciar el robo automáticamente
                Events.RobSecondaryCurrency:FireServer("start")
                task.wait(0.1)
                Events.RobSecondaryCurrency:FireServer("end")
            end)
        end
        
        if AutoHABBuy then
            pcall(function()
                -- Buscamos objetos disponibles en la tienda (UIDs tipo D001, F001)
                -- Nota: Esta lógica se puede perfeccionar con la lista de objetos que enviaste
                for i = 1, 50 do
                    local uidD = string.format("D%03d", i)
                    local uidF = string.format("F%03d", i)
                    Events.BuyObject:FireServer(uidD)
                    Events.BuyObject:FireServer(uidF)
                end
            end)
        end
        
        task.wait(0.5)
    end
end)
-- ==========================================
-- PESTAÑA: THE STRONGER LIFTER (UI)
-- ==========================================
local TSLTab = SeccionJuegos:Tab({ Title = "Stronger Lifter", Icon = "solar:dumbbells-bold" })
local AutoTSLLift, AutoTSLSell, AutoTSLBuy, AutoTSLStage = false, false, false, false

local TSLStats = TSLTab:Section({ Title = "💪 ESTADO FÍSICO", Box = true, BoxBorder = true })
local TSLMuscleLabel = TSLStats:Section({ Title = "💪 Músculo: 0" })
local TSLStageLabel = TSLStats:Section({ Title = "🆙 Etapa: 0" })
local TSLCoinsLabel = TSLStats:Section({ Title = "💰 Monedas: 0" })

local TSLFarm = TSLTab:Section({ Title = "🤖 ENTRENAMIENTO AUTO", Box = true, BoxBorder = true })
TSLFarm:Toggle({ Title = "Auto-Levantar (Loop)", Callback = function(s) AutoTSLLift = s end })
TSLFarm:Toggle({ Title = "Auto-Vender (Sell)", Callback = function(s) AutoTSLSell = s end })
TSLFarm:Toggle({ Title = "Auto-Comprar Pesas", Callback = function(s) AutoTSLBuy = s end })
TSLFarm:Toggle({ Title = "Auto-Etapa (Stage)", Callback = function(s) AutoTSLStage = s end })

-- ==========================================
-- MOTOR: THE STRONGER LIFTER (LOGIC)
-- ==========================================
task.spawn(function()
    -- 🛡️ FILTRO ANTI-ERRORES: Solo corre si detecta que es TSL
    local Shared = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
    if not Shared or not Shared:FindFirstChild("Remotes") then return end
    
    local Remotes = require(Shared.Remotes)
    local lastLiftState = false

    while true do
        pcall(function()
            -- 1. Monitor de Estadísticas
            local ls = LP:FindFirstChild("leaderstats")
            if ls then
                TSLMuscleLabel:SetTitle("💪 Músculo: " .. (ls:FindFirstChild("Muscle") and ls.Muscle.Value or 0))
                TSLStageLabel:SetTitle("🆙 Etapa: " .. (ls:FindFirstChild("Stage") and ls.Stage.Value or 0))
                -- En TSL las monedas pueden ser 'Coins' o 'Fame'
                local c = ls:FindFirstChild("Coins") or ls:FindFirstChild("Fame")
                TSLCoinsLabel:SetTitle("💰 Monedas: " .. (c and c.Value or 0))
            end

            -- 2. Lógica de Auto-Levantar (Loop Infinito REAL)
            if AutoTSLLift then
                pcall(function()
                    -- 1. Decimos que vamos a subir la pesa
                    Remotes.Lifting.LiftingStatus:Fire(true)
                    task.wait(0.05)
                    
                    -- 2. Hacemos el levantamiento
                    Remotes.Lifting.LiftRequest:Fire()
                    task.wait(0.05)
                    
                    -- 3. ¡ESTO ES LO QUE FALTABA! 
                    -- Decimos que ya bajamos la pesa para que el servidor nos deje hacer otra
                    Remotes.Lifting.LiftingStatus:Fire(false)
                end)
            end

            -- 3. Auto Vender
            if AutoTSLSell then Remotes.ClientRequests.SellMuscle:Fire() end

            -- 4. Auto Etapa (Stage)
            if AutoTSLStage then Remotes.Bloodline.UpgradeRequest:Fire() end

            -- 5. Auto Comprar Pesas
            if AutoTSLBuy then
                local W = {"Stick", "Mouse", "Water", "Soccer Ball", "Bottle", "Textbook", "Bucket", "Wood", "Guitar", "Dumbbell", "Chair", "Cart", "TV", "Bicycle", "Desk", "Bed", "Log", "Canoe", "Tyre", "Refrigerator", "Drum", "Hydrant", "Piano", "Motorcycle", "Safe", "Flag", "ATM", "RX-7", "EVO", "G-Class", "Van", "Tree", "Container", "Sailboat", "Bus", "Truck"}
                for _, weight in pairs(W) do Remotes.Shops.BuyItem:Fire(weight, "Weights") end
            end
        end)
        task.wait(0.1) -- Velocidad máxima permitida por el servidor
    end
end)

-- ==========================================
-- 7. PESTAÑA: AJUSTES (SISTEMA)
-- ==========================================
local AjustesTab = SeccionSistema:Tab({ Title = "Ajustes", Icon = "solar:settings-bold" })
local DevTools = AjustesTab:Group({ Title = "Herramientas de Hacker" })
DevTools:Button({ Title = "Cargar Dark Dex", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end })
DevTools:Button({ Title = "Cargar SimpleSpy V3", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))() end })
DevTools:Button({ Title = "Cerrar Hub", Callback = function() Window:Destroy() end })

WindUI:Notify({ Title = "NC HUB", Content = "Maestro, todo listo para la acción.", Duration = 5 })
