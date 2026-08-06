--[[
    NC HUB - VERSIÓN FINAL ORGANIZADA
    AUTOR: hidjcjgg
    ESTILO: BENTO BOX FUTURISTA (MORADO/AZUL)
]]

-- ==========================================
-- 0. CONFIGURACIÓN INICIAL
-- ==========================================
local TiempoInicio = os.time()
local LP = game.Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CREACIÓN DE LA VENTANA
local Window = WindUI:CreateWindow({
    Title = "NC HUB",
    Author = "By hidjcjgg",
    Folder = "NCHUBScripts",
    Icon = "solar:bolt-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(600, 460),
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
-- 3. PESTAÑA: HOME (LIMPIA Y FUTURISTA)
-- ==========================================
local HomeTab = SeccionHome:Tab({
    Title = "Dashboard",
    Icon = "solar:widget-bold"
})

-- OBTENCIÓN DE DATOS
local userId = game.Players.LocalPlayer.UserId
local fotoUrl = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=420&h=420"

-- --- TARJETA 1: IDENTIDAD DIGITAL ---
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

CardPerfil:Section({
    Title = "👤 Usuario: " .. game.Players.LocalPlayer.Name
})

CardPerfil:Section({
    Title = "📅 Antigüedad: " .. game.Players.LocalPlayer.AccountAge .. " días"
})

-- --- TARJETA 2: MONITOR DE SESIÓN ---
local CardSesion = HomeTab:Section({
    Title = "⚡ MONITOR DE SESIÓN",
    Box = true,
    BoxBorder = true
})

local TimeLabel = CardSesion:Section({
    Title = "⏳ Tiempo Activo: 0h 0m 0s"
})

CardSesion:Section({
    Title = "💎 Status: NC HUB Operacional"
})

-- Bucle de actualización
task.spawn(function()
    while true do
        local segundos = os.time() - TiempoInicio
        local mins = math.floor(segundos / 60)
        local horas = math.floor(mins / 60)
        local texto = string.format("%dh %dm %ds", horas, mins % 60, segundos % 60)
        
        pcall(function()
            TimeLabel:SetTitle("⏳ Tiempo Activo: " .. texto)
        end)
        
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
    Value = { Min = 16, Max = 500, Default = 16 },
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

-- VUELO PRO
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
-- 5. SECCIÓN: JUEGOS (ESTRUCTURA BASE)
-- ==========================================

-- ==========================================
-- 5. PESTAÑA: MURDER MYSTERY 2 (LIMPIA)
-- ==========================================
local MM2Tab = SeccionJuegos:Tab({
    Title = "Murder Mystery 2",
    Icon = "solar:danger-bold"
})

local RolesESP = false
local AutoGrab = false

-- --- GRUPO 1: VISUALES ---
local MM2Visuals = MM2Tab:Group({ 
    Title = "Visuales y ESP" 
})

MM2Visuals:Toggle({
    Title = "Revelar Roles",
    Desc = "Detección por Inventario (Asesino/Sheriff)",
    Callback = function(state)
        RolesESP = state
        task.spawn(function()
            while RolesESP do
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character then
                        local color = Color3.fromRGB(0, 255, 0) -- Inocente
                        local hasKnife = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                        local hasGun = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                        
                        if hasKnife then
                            color = Color3.fromRGB(255, 0, 0) -- Rojo
                        elseif hasGun then
                            color = Color3.fromRGB(0, 0, 255) -- Azul
                        end
                        
                        local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                        h.FillColor = color
                        h.Enabled = true
                    end
                end
                task.wait(1)
            end
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Highlight") then
                    p.Character.Highlight:Destroy()
                end
            end
        end)
    end
})

-- --- GRUPO 2: COMBATE (AHORA SOLO UNO) ---
local MM2Combat = MM2Tab:Group({ 
    Title = "Ventajas de Combate" 
})

MM2Combat:Toggle({
    Title = "Auto-Grab Gun",
    Desc = "Recoge la pistola solo si está en el suelo",
    Callback = function(state)
        AutoGrab = state
        task.spawn(function()
            while AutoGrab do
                for _, v in pairs(workspace:GetDescendants()) do
                    if (v.Name == "GunDrop" or v.Name == "Gun") and v:IsA("Model") then
                        -- Verificamos que no sea de un jugador vivo
                        if not v:FindFirstAncestorOfClass("Model") or not v:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                            local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local target = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                            if root and target then
                                root.CFrame = target.CFrame
                                WindUI:Notify({Title = "MM2", Content = "Pistola recogida"})
                                task.wait(1)
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
})

-- ==========================================
-- 6. PESTAÑA: FACTORY TYCOON (GOD MODE)
-- ==========================================
local FactoryTab = SeccionJuegos:Tab({
    Title = "Factory Tycoon",
    Icon = "solar:factory-bold"
})

-- --- MONITOR DE RECURSOS ---
local FactoryStats = FactoryTab:Group({ Title = "Monitor de Recursos" })
local MoneyLabel = FactoryStats:Section({ Title = "💵 Efectivo: $0" })
local GemsLabel = FactoryStats:Section({ Title = "💎 Gemas: 0" })
local RebirthLabel = FactoryStats:Section({ Title = "👑 Rebirths: 0" })

task.spawn(function()
    while true do
        pcall(function()
            local data = game.Players.LocalPlayer:WaitForChild("DataFolder")
            MoneyLabel:SetTitle("💵 Efectivo: $" .. data.Money.Value)
            GemsLabel:SetTitle("💎 Gemas: " .. data.Gems.Value)
            RebirthLabel:SetTitle("👑 Rebirths: " .. data.Rebirths.Value)
        end)
        task.wait(1)
    end
end)

-- --- AUTOMATIZACIÓN TOTAL ---
local FactoryFarm = FactoryTab:Group({ Title = "Automatización" })

-- Auto-Cobrar (Ya funcionaba)
local AutoCollectFactory = false
FactoryFarm:Toggle({
    Title = "Auto-Cobrar Dinero",
    Callback = function(s) AutoCollectFactory = s end
})

-- NUEVO: Auto-Comprar Botones (Usa ButtonUsed)
local AutoBuyButtons = false
FactoryFarm:Toggle({
    Title = "Auto-Comprar Botones",
    Desc = "Compra todo lo que puedas pagar",
    Callback = function(s) AutoBuyButtons = s end
})

-- NUEVO: Auto-Rebirth (Usa RequestRebirth)
local AutoRebirth = false
FactoryFarm:Toggle({
    Title = "Auto-Rebirth",
    Desc = "Renace automáticamente al terminar",
    Callback = function(s) AutoRebirth = s end
})

-- LÓGICA DE AUTOMATIZACIÓN CORREGIDA
task.spawn(function()
    local Events = game:GetService("ReplicatedStorage").Events
    while true do
        -- 1. Auto Cobrar (Sin cambios)
        if AutoCollectFactory then
            pcall(function() Events.CollectMoney:FireServer() end)
        end
        
        -- 2. Auto Comprar Botones (FILTRADO)
        if AutoBuyButtons then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    -- Buscamos botones que tengan un precio
                    if v.Name == "TouchInterest" and v.Parent and v.Parent:FindFirstChild("Price") then
                        local button = v.Parent
                        local priceValue = button.Price.Value
                        
                        -- FILTRO: Solo si el precio es mayor a 0 (Los de Robux suelen ser 0 o -1 en el valor de Price)
                        -- Y solo si NO tiene un ID de Gamepass/Producto asociado
                        if priceValue > 0 and not button:FindFirstChild("GamepassID") and not button:FindFirstChild("ProductID") then
                            -- Verificamos si tenemos dinero suficiente para no spamear
                            if game.Players.LocalPlayer.DataFolder.Money.Value >= priceValue then
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, button, 0)
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, button, 1)
                            end
                        end
                    end
                end
            end)
        end
        
        -- 3. Auto Rebirth
        if AutoRebirth then
            pcall(function() Events.RequestRebirth:FireServer() end)
        end
        
        task.wait(0.8) -- Aumentamos un poco el tiempo para evitar lag por el escaneo
    end
end)

-- --- MEJORAS DE GEMAS (FILTRADAS) ---
FactoryUpgrades:Button({
    Title = "Comprar Mejoras Gratuitas",
    Desc = "Solo gasta gemas (Ignora Robux)",
    Callback = function()
        local upgradeRemote = game:GetService("ReplicatedStorage").Events.UpgradesRelated:FindFirstChild("BuyUpgrade")
        if upgradeRemote then
            -- Lista de mejoras que confirmamos que son por gemas en tu imagen
            local safeUpgrades = {
                "CoinMultiplier", 
                "GemChance", 
                "DoubleCoinChance", 
                "DoubleGemChance", 
                "ConveyorSpeed", 
                "AutoCollectChance",
                "IncomeTracker",
                "OreLimit"
            }
            for _, name in pairs(safeUpgrades) do
                pcall(function() upgradeRemote:FireServer(name) end)
            end
            WindUI:Notify({Title = "Upgrades", Content = "Mejoras de gemas procesadas."})
        end
    end
})

-- --- PESTAÑA: HACK A BUSINESS ---
local HABTab = SeccionJuegos:Tab({
    Title = "Hack A Business",
    Icon = "solar:computer-bold"
})

-- Grupo de Auto Farm
local HABFarm = HABTab:Group({ 
    Title = "Automatización (Farm)" 
})

HABFarm:Toggle({
    Title = "Auto Recoger",
    Desc = "Recoge Servers y Datos solo",
    Callback = function(state)
        -- Bucle de recolección pendiente
        print("Auto Collect cambiado a:", state)
    end
})

HABFarm:Toggle({
    Title = "Auto Vender",
    Desc = "Vende en la mejor zona",
    Callback = function(state)
        -- Remote de venta pendiente
        print("Auto Sell cambiado a:", state)
    end
})

HABFarm:Toggle({
    Title = "Auto Robar (Steal)",
    Desc = "Roba a otros jugadores",
    Callback = function(state)
        -- Lógica de robo pendiente
        print("Auto Steal cambiado a:", state)
    end
})

-- ==========================================
-- 6. PESTAÑA: AJUSTES (SISTEMA ACTUALIZADO)
-- ==========================================
local AjustesTab = SeccionSistema:Tab({
    Title = "Ajustes",
    Icon = "solar:settings-bold"
})

-- Herramientas de Desarrollador (Para encontrar Hacks)
local DevTools = AjustesTab:Group({ Title = "Herramientas Pro" })

DevTools:Button({
    Title = "Cargar Dark Dex V3",
    Desc = "Explorador de objetos y archivos",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        WindUI:Notify({Title = "Sistema", Content = "Dex Cargado"})
    end
})

DevTools:Button({
    Title = "Cargar SimpleSpy V3",
    Desc = "Detecta los Remotes del juego al instante",
    Callback = function()
        -- Este es el link oficial y más estable para móvil
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ex70/SimpleSpyV3/main/main.lua"))()
        WindUI:Notify({Title = "Sistema", Content = "SimpleSpy Cargado"})
    end
})

-- Utilidades de Sesión
local Utils = AjustesTab:Group({ Title = "Utilidades" })

Utils:Button({
    Title = "Activar Anti-AFK",
    Callback = function()
        game.Players.LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
        WindUI:Notify({Title = "Sistema", Content = "Anti-AFK Activado"})
    end
})

Utils:Button({
    Title = "Cerrar Hub",
    Callback = function() Window:Destroy() end
})
