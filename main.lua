-- REGISTRO DE TIEMPO
local TiempoInicio = os.time()

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CONFIGURACIÓN DE LA VENTANA
local Window = WindUI:CreateWindow({
    Title = "NC HUB",
    Author = "By hidjcjgg",
    Folder = "May67Scripts",
    Icon = "solar:bolt-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(600, 450), -- Tamaño extra para evitar bugs
    NewElements = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

-- 2. SECCIONES DEL SIDEBAR (Organizadas como pediste)
local SeccionHome = Window:Section({
    Title = "HOME"
})

local SeccionTrampas = Window:Section({
    Title = "TRAMPAS"
})

local SeccionSistema = Window:Section({
    Title = "SISTEMA"
})

-- ==========================================
-- 3. PESTAÑA: INICIO (DISEÑO BENTO BOX FUTURISTA)
-- ==========================================
local HomeTab = SeccionHome:Tab({
    Title = "Dashboard",
    Icon = "solar:widget-bold"
})

-- OBTENCIÓN DE DATOS (Se mantienen tus variables originales)
local MarketplaceService = game:GetService("MarketplaceService")
local infoJuego = MarketplaceService:GetProductInfo(game.PlaceId)
local nombreJuego = infoJuego.Name or "Juego Desconocido"
local maxJugadores = game.Players.MaxPlayers
local jugadoresActuales = #game.Players:GetPlayers()
local userId = game.Players.LocalPlayer.UserId

-- --- TARJETA 1: PERFIL DEL JUGADOR (Estilo Caja) ---
local CardPerfil = HomeTab:Section({
    Title = "👤 PERFIL DEL USUARIO",
    Box = true,
    BoxBorder = true
})

-- Imagen de Perfil
CardPerfil:Image({
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=420&h=420",
    AspectRatio = "1:1",
    Radius = 100
})

-- Usamos :Section para el texto (que es lo que no da error)
CardPerfil:Section({
    Title = "Usuario: " .. game.Players.LocalPlayer.Name
})

CardPerfil:Section({
    Title = "ID: " .. userId
})

-- --- TARJETA 2: DATOS DEL JUEGO (Estilo Caja) ---
local CardJuego = HomeTab:Section({
    Title = "🎮 INFORMACIÓN DEL JUEGO",
    Box = true,
    BoxBorder = true
})

CardJuego:Section({
    Title = "Juego: " .. nombreJuego
})

CardJuego:Section({
    Title = "👥 Servidor: " .. jugadoresActuales .. " / " .. maxJugadores
})

-- --- TARJETA 3: ESTADO DE SESIÓN (Estilo Caja) ---
local CardSesion = HomeTab:Section({
    Title = "⚡ ESTADO DE SESIÓN",
    Box = true,
    BoxBorder = true
})

local TimeLabel = CardSesion:Section({
    Title = "⏳ Tiempo activo: 0h 0m 0s"
})

CardSesion:Section({
    Title = "✨ Status: Operacional"
})

-- Bucle de actualización (Asegúrate de tener TiempoInicio al principio del script)
task.spawn(function()
    while true do
        local segundos = os.time() - TiempoInicio
        local mins = math.floor(segundos / 60)
        local horas = math.floor(mins / 60)
        local texto = string.format("%dh %dm %ds", horas, mins % 60, segundos % 60)
        
        pcall(function()
            TimeLabel:SetTitle("⏳ Tiempo activo: " .. texto)
        end)
        
        task.wait(1)
    end
end)

-- ==========================================
-- 4. PESTAÑA: MOVIMIENTO (Ahora en Trampas)
-- ==========================================
local MovTab = SeccionTrampas:Tab({
    Title = "Movimiento",
    Icon = "solar:walking-bold"
})

MovTab:Slider({
    Title = "Velocidad",
    Step = 1,
    Value = {
        Min = 16,
        Max = 128,
        Default = 16
    },
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

local InfJumpEnabled = false
MovTab:Toggle({
    Title = "Salto Infinito",
    Callback = function(state)
        InfJumpEnabled = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ==========================================
-- 5. PESTAÑA: HACKS (Noclip y ESP)
-- ==========================================
local CheatTab = SeccionTrampas:Tab({
    Title = "Hacks",
    Icon = "solar:ghost-bold"
})

local NoclipEnabled = false
CheatTab:Toggle({
    Title = "Atravesar Paredes",
    Callback = function(state)
        NoclipEnabled = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

CheatTab:Toggle({
    Title = "Ver Jugadores (ESP)",
    Callback = function(state)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                if state then
                    local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                else
                    if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
                end
            end
        end
    end
})

-- ==========================================
-- 6. PESTAÑA: VUELO (Con Slider recuperado)
-- ==========================================
local FlyTab = SeccionTrampas:Tab({
    Title = "Vuelo",
    Icon = "solar:plain-bold"
})

local VueloActivo = false
local VelocidadVuelo = 80

FlyTab:Slider({
    Title = "Velocidad Vuelo",
    Step = 1,
    Value = {
        Min = 10,
        Max = 400,
        Default = 80
    },
    Callback = function(v)
        VelocidadVuelo = v
    end
})

FlyTab:Toggle({
    Title = "Activar Vuelo",
    Callback = function(state)
        VueloActivo = state
        local root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local hum = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        
        if VueloActivo then
            hum.PlatformStand = true
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "FlyForce"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            local bg = Instance.new("BodyGyro", root)
            bg.Name = "FlyGyro"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            
            task.spawn(function()
                while VueloActivo do
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    if hum.MoveDirection.Magnitude > 0 then
                        local look = workspace.CurrentCamera.CFrame.LookVector
                        local right = workspace.CurrentCamera.CFrame.RightVector
                        local forwardVec = Vector3.new(look.X, 0, look.Z).Unit
                        local rightVec = Vector3.new(right.X, 0, right.Z).Unit
                        local forwardAmount = hum.MoveDirection:Dot(forwardVec)
                        local rightAmount = hum.MoveDirection:Dot(rightVec)
                        bv.Velocity = ((look * forwardAmount) + (right * rightAmount)).Unit * VelocidadVuelo
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                    task.wait()
                end
                hum.PlatformStand = false
                if root:FindFirstChild("FlyForce") then root.FlyForce:Destroy() end
                if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end
})

-- ==========================================
-- 7. PESTAÑA: AJUSTES (SISTEMA)
-- ==========================================
local SysTab = SeccionSistema:Tab({
    Title = "Ajustes",
    Icon = "solar:settings-bold"
})

SysTab:Button({
    Title = "Activar Anti-AFK",
    Callback = function()
        game.Players.LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
        WindUI:Notify({Title = "Sistema", Content = "Anti-AFK Activado"})
    end
})

SysTab:Button({
    Title = "Cerrar Hub",
    Callback = function()
        Window:Destroy()
    end
})

-- ==========================================
-- SECCIÓN: JUEGOS
-- ==========================================
local SeccionJuegos = Window:Section({
    Title = "JUEGOS"
})

-- ==========================================
-- MM2 (solo marco, sin hacks)
-- ==========================================
local MM2_PLACE_ID = 142823291
local enMM2 = (game.PlaceId == MM2_PLACE_ID)

local MM2Tab = SeccionJuegos:Tab({
    Title = "MM2",
    Icon = "solar:knife-bold-duotone"
})

MM2Tab:Section({
    Title = enMM2 and "✅ Estás en Murder Mystery 2" or "⚠️ Entra a MM2 para funciones específicas"
})

MM2Tab:Section({
    Title = "PlaceId: " .. tostring(game.PlaceId)
})

local CardMM2Info = MM2Tab:Section({
    Title = "ℹ️ INFO",
    Box = true,
    BoxBorder = true
})

CardMM2Info:Section({
    Title = "Juego grande con anti-cheat fuerte."
})

CardMM2Info:Section({
    Title = "Por ahora solo utilidades básicas."
})

local CardMM2Util = MM2Tab:Section({
    Title = "🛠️ UTILIDADES",
    Box = true,
    BoxBorder = true
})

CardMM2Util:Button({
    Title = "Copiar PlaceId",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
        WindUI:Notify({ Title = "MM2", Content = "PlaceId copiado" })
    end
})

-- ==========================================
-- BLADE BALL
-- ==========================================
local BB_PLACE_ID = 2240312267  -- PlaceId principal de Blade Ball
local enBB = (game.PlaceId == BB_PLACE_ID)

local BBTab = SeccionJuegos:Tab({
    Title = "Blade Ball",
    Icon = "solar:sword-bold-duotone"
})

BBTab:Section({
    Title = enBB and "✅ Estás en Blade Ball" or "⚠️ Entra a Blade Ball para usar estas opciones"
})

BBTab:Section({
    Title = "PlaceId: " .. tostring(game.PlaceId)
})

-- --- UTILIDADES BLADE BALL ---
local CardBBUtil = BBTab:Section({
    Title = "🛠️ UTILIDADES",
    Box = true,
    BoxBorder = true
})

CardBBUtil:Button({
    Title = "TEST: Speed + Jump",
    Callback = function()
        local LP = game.Players.LocalPlayer
        local Character = LP.Character or LP.CharacterAdded:Wait()
        local Hum = Character:FindFirstChildOfClass("Humanoid")
        if Hum then
            Hum.WalkSpeed = 200
            Hum.JumpPower = 200
            WindUI:Notify({ Title = "Blade Ball", Content = "Speed/Jump a 200" })
        else
            WindUI:Notify({ Title = "Blade Ball", Content = "No hay Humanoid" })
        end
    end
})

CardBBUtil:Button({
    Title = "Copiar PlaceId",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
        WindUI:Notify({ Title = "Blade Ball", Content = "PlaceId copiado" })
    end
})

-- --- COMBATE / AUTO ---
local CardBBCombat = BBTab:Section({
    Title = "⚔️ AUTO",
    Box = true,
    BoxBorder = true
})

local BB_AutoParry = false
CardBBCombat:Toggle({
    Title = "Auto Parry (base)",
    Callback = function(state)
        BB_AutoParry = state
        if not enBB then
            WindUI:Notify({ Title = "Blade Ball", Content = "Debes estar en Blade Ball" })
            return
        end
        WindUI:Notify({
            Title = "Blade Ball",
            Content = state and "Auto Parry ON (base)" or "Auto Parry OFF"
        })
    end
})

-- Ejemplo de bucle base (sin remotes raros)
task.spawn(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    while true do
        if BB_AutoParry and enBB then
            local Character = LP.Character
            if Character then
                local Hum = Character:FindFirstChildOfClass("Humanoid")
                if Hum and Hum.Health > 0 then
                    -- Aquí iría tu lógica de auto-parry
                    -- Ej: detectar cuando la bola viene cerca y pulsar parry
                end
            end
        end
        task.wait(0.2)
    end
end)

-- --- VISUALES ---
local CardBBVisual = BBTab:Section({
    Title = "👁️ VISUALES",
    Box = true,
    BoxBorder = true
})

local BB_ESP = false
CardBBVisual:Toggle({
    Title = "ESP Jugadores",
    Callback = function(state)
        BB_ESP = state
        if not enBB then
            WindUI:Notify({ Title = "Blade Ball", Content = "Debes estar en Blade Ball" })
            return
        end

        -- Limpiar ESP previo
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                if p.Character:FindFirstChild("BBHighlight") then
                    p.Character.BBHighlight:Destroy()
                end
            end
        end

        if state then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local h = Instance.new("Highlight")
                        h.Name = "BBHighlight"
                        h.Parent = root
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                        h.OutlineColor = Color3.fromRGB(0, 0, 0)
                    end
                end
            end
            WindUI:Notify({ Title = "Blade Ball", Content = "ESP activado" })
        else
            WindUI:Notify({ Title = "Blade Ball", Content = "ESP desactivado" })
        end
    end
})

-- --- TELEPORTS ---
local CardBBTele = BBTab:Section({
    Title = "📍 TELEPORTS",
    Box = true,
    BoxBorder = true
})

CardBBTele:Button({
    Title = "Ir al centro del mapa",
    Callback = function()
        if not enBB then
            WindUI:Notify({ Title = "Blade Ball", Content = "Debes estar en Blade Ball" })
            return
        end
        local LP = game.Players.LocalPlayer
        local Character = LP.Character or LP.CharacterAdded:Wait()
        local Root = Character:FindFirstChild("HumanoidRootPart")
        if not Root then
            WindUI:Notify({ Title = "Blade Ball", Content = "No hay HumanoidRootPart" })
            return
        end

        -- Ajusta estas coordenadas al mapa actual de Blade Ball
        Root.CFrame = CFrame.new(0, 10, 0)
        WindUI:Notify({ Title = "Blade Ball", Content = "Teleport al centro" })
    end
})