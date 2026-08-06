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
-- 3. PESTAÑA: HOME (BENTO BOX FUTURISTA MORADO/AZUL)
-- ==========================================
local HomeTab = SeccionHome:Tab({
    Title = "Dashboard",
    Icon = "solar:widget-bold"
})

-- OBTENCIÓN DE DATOS (Basado en Archivo 2 y 4)
local userId = game.Players.LocalPlayer.UserId
local fotoUrl = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=420&h=420"

-- --- TARJETA: IDENTIDAD DIGITAL ---
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

CardPerfil:Section({ Title = "👤 Usuario: " .. game.Players.LocalPlayer.Name })
CardPerfil:Section({ Title = "📅 Antigüedad: " .. game.Players.LocalPlayer.AccountAge .. " días" })

-- --- TARJETA: ESTADO DEL SISTEMA ---
local CardSesion = HomeTab:Section({
    Title = "🌌 MONITOR DE SISTEMA",
    Box = true,
    BoxBorder = true
})

local TimeLabel = CardSesion:Section({ Title = "⏳ Tiempo Activo: 0h 0m 0s" })
CardSesion:Section({ Title = "💎 Status: NC HUB Operacional" })

-- Bucle de tiempo
task.spawn(function()
    while true do
        local seg = os.time() - TiempoInicio
        local texto = string.format("%dh %dm %ds", math.floor(seg/3600), math.floor(seg/60)%60, seg%60)
        pcall(function() TimeLabel:SetTitle("⏳ Tiempo Activo: " .. texto) end)
        task.wait(1)
    end
end)

-- ==========================================
-- 6. PESTAÑA: FACTORY TYCOON (FIXED & FULL)
-- ==========================================
local FactoryTab = SeccionJuegos:Tab({
    Title = "Factory Tycoon",
    Icon = "solar:factory-bold"
})

-- VARIABLES DE CONTROL (Scope correcto para que funcionen)
local AutoCollect = false
local AutoBuySafe = false
local AutoRebirth = false
local DelaySeguridad = 0.8

-- --- MONITOR DE RECURSOS (BENTO BOX) ---
local CardStats = FactoryTab:Section({ 
    Title = "📊 ESTADO DE FÁBRICA", 
    Box = true, 
    BoxBorder = true 
})

local MoneyLabel = CardStats:Section({ Title = "💵 Efectivo: $0" })
local GemsLabel = CardStats:Section({ Title = "💎 Gemas: 0" })

task.spawn(function()
    while true do
        pcall(function()
            local data = game.Players.LocalPlayer:WaitForChild("DataFolder")
            MoneyLabel:SetTitle("💵 Efectivo: $" .. data.Money.Value)
            GemsLabel:SetTitle("💎 Gemas: " .. data.Gems.Value)
        end)
        task.wait(1)
    end
end)

-- --- AUTOMATIZACIÓN (BENTO BOX) ---
local CardFarm = FactoryTab:Section({ 
    Title = "🤖 AUTOMATIZACIÓN", 
    Box = true, 
    BoxBorder = true 
})

CardFarm:Slider({
    Title = "Retraso (Seguridad)",
    Value = {Min = 0.1, Max = 5, Default = 0.8},
    Callback = function(v) DelaySeguridad = v end
})

CardFarm:Toggle({
    Title = "Auto-Cobrar Dinero",
    Callback = function(s) AutoCollect = s end
})

CardFarm:Toggle({
    Title = "Auto-Comprar (NO ROBUX)",
    Callback = function(s) AutoBuySafe = s end
})

CardFarm:Toggle({
    Title = "Auto-Rebirth",
    Callback = function(s) AutoRebirth = s end
})

-- --- MEJORAS (BENTO BOX) ---
local CardUpgrades = FactoryTab:Section({ 
    Title = "✨ MEJORAS DE GEMAS", 
    Box = true, 
    BoxBorder = true 
})

CardUpgrades:Button({
    Title = "Comprar Mejoras Gratis",
    Callback = function()
        local remote = game:GetService("ReplicatedStorage").Events.UpgradesRelated:FindFirstChild("BuyUpgrade")
        if remote then
            local lista = {"CoinMultiplier", "GemChance", "DoubleCoinChance", "DoubleGemChance", "ConveyorSpeed", "AutoCollectChance"}
            for _, name in pairs(lista) do
                pcall(function() remote:FireServer(name) end)
            end
            WindUI:Notify({Title = "Upgrades", Content = "Procesando mejoras..."})
        end
    end
})

-- ==========================================
-- LÓGICA DE EJECUCIÓN (UNIFICADA)
-- ==========================================
task.spawn(function()
    local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    
    while true do
        -- 1. Auto Cobrar
        if AutoCollect then
            pcall(function() Events.CollectMoney:FireServer() end)
        end
        
        -- 2. Auto Comprar Botones
        if AutoBuySafe then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "TouchInterest" and v.Parent and v.Parent:FindFirstChild("Price") then
                        local btn = v.Parent
                        local price = btn.Price.Value
                        local money = game.Players.LocalPlayer.DataFolder.Money.Value
                        
                        -- Filtro de Robux
                        local esRobux = btn:FindFirstChild("GamepassID") or btn:FindFirstChild("ProductID")
                        
                        if not esRobux and price >= 0 and money >= price then
                            -- Usamos el remote que descubriste
                            if Events:FindFirstChild("ButtonUsed") then
                                Events.ButtonUsed:FireServer(btn.Name)
                            end
                            -- Respaldo físico
                            local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                firetouchinterest(root, btn, 0)
                                firetouchinterest(root, btn, 1)
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
        
        task.wait(DelaySeguridad)
    end
end)

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
-- 6. PESTAÑA: AJUSTES (HERRAMIENTAS DE HACKER)
-- ==========================================
local AjustesTab = SeccionSistema:Tab({
    Title = "Ajustes",
    Icon = "solar:settings-bold"
})

local DevTools = AjustesTab:Group({ Title = "Herramientas de Búsqueda" })

-- OPCIÓN 1: SIMPLESPY MÓVIL (Link alternativo)
DevTools:Button({
    Title = "Cargar SimpleSpy (Link 2)",
    Desc = "Versión optimizada para celulares",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
    end
})

-- OPCIÓN 2: DARK DEX (Ya sabemos que te funciona)
DevTools:Button({
    Title = "Cargar Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
})
