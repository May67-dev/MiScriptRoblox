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
        Max = 500,
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

-- ----------------------------------------
-- MM2 (Murder Mystery 2)
-- PlaceId principal: 142823291
-- ----------------------------------------
local MM2_PLACE_ID = 142823291
local enMM2 = (game.PlaceId == MM2_PLACE_ID)

local MM2Tab = SeccionJuegos:Tab({
    Title = "MM2",
    Icon = "solar:knife-bold-duotone"
})

-- Aviso si no estás en el juego
MM2Tab:Section({
    Title = enMM2 and "✅ Estás en Murder Mystery 2" or "⚠️ Entra a MM2 para usar estas opciones"
})

MM2Tab:Section({
    Title = "PlaceId: " .. tostring(game.PlaceId)
})

-- --- UTILIDADES MM2 ---
local CardMM2Util = MM2Tab:Section({
    Title = "🛠️ UTILIDADES",
    Box = true,
    BoxBorder = true
})

CardMM2Util:Button({
    Title = "Teleport al Lobby",
    Callback = function()
        if not enMM2 then
            WindUI:Notify({ Title = "MM2", Content = "Debes estar en Murder Mystery 2" })
            return
        end
        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") or ReplicatedStorage:FindFirstChild("ChatEvents")
        -- Método 1: teleport usando "Lobby" si existe en TeleportService
        local TeleportService = game:GetService("TeleportService")
        pcall(function()
            TeleportService:Teleport(MM2_PLACE_ID, LP)
        end)
        WindUI:Notify({ Title = "MM2", Content = "Teleport al Lobby enviado" })
    end
})

CardMM2Util:Button({
    Title = "Recoger Arma (Gun)",
    Callback = function()
        if not enMM2 then
            WindUI:Notify({ Title = "MM2", Content = "Debes estar en Murder Mystery 2" })
            return
        end
        local LP = game.Players.LocalPlayer
        local Character = LP.Character or LP.CharacterAdded:Wait()
        local Root = Character:FindFirstChild("HumanoidRootPart")
        if not Root then return end

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remote = ReplicatedStorage:FindFirstChild("GrabGun") or ReplicatedStorage:FindFirstChild("GrabGunRemote") or ReplicatedStorage:FindFirstChild("ToolRemote")

        -- Buscar armas en el suelo
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:match("Gun") then
                Root.CFrame = obj.CFrame * CFrame.new(0, 0, 2)
                if Remote then
                    pcall(function() Remote:FireServer(obj) end)
                else
                    -- Fallback: tocar la herramienta
                    LP.Character.Humanoid:EquipTool(obj)
                end
                WindUI:Notify({ Title = "MM2", Content = "Intentando recoger arma..." })
                return
            end
        end
        WindUI:Notify({ Title = "MM2", Content = "No hay armas cerca" })
    end
})

-- --- VISUALES MM2 ---
local CardMM2Visual = MM2Tab:Section({
    Title = "👁️ VISUALES",
    Box = true,
    BoxBorder = true
})

local MM2_ESP = false
CardMM2Visual:Toggle({
    Title = "ESP Roles (Murderer / Sheriff)",
    Callback = function(state)
        MM2_ESP = state
        if not enMM2 then
            WindUI:Notify({ Title = "MM2", Content = "Debes estar en Murder Mystery 2" })
            return
        end

        -- Limpiar ESP previo
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                if p.Character:FindFirstChild("MM2Highlight") then
                    p.Character.MM2Highlight:Destroy()
                end
            end
        end

        if state then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local h = Instance.new("Highlight")
                        h.Name = "MM2Highlight"
                        h.Parent = root

                        -- Color según rol (si existe el tag)
                        if p.Character:FindFirstChild("Murderer") or p.Character:FindFirstChild("IsMurderer") then
                            h.FillColor = Color3.fromRGB(255, 0, 0) -- Rojo = Murderer
                        elseif p.Character:FindFirstChild("Sheriff") or p.Character:FindFirstChild("IsSheriff") then
                            h.FillColor = Color3.fromRGB(0, 100, 255) -- Azul = Sheriff
                        else
                            h.FillColor = Color3.fromRGB(255, 255, 255) -- Blanco = Inocente
                        end
                    end
                end
            end
        end
        WindUI:Notify({
            Title = "MM2 ESP",
            Content = state and "ESP activado" or "ESP desactivado"
        })
    end
})

-- --- COMBATE MM2 ---
local CardMM2Combat = MM2Tab:Section({
    Title = "⚔️ COMBATE",
    Box = true,
    BoxBorder = true
})

local MM2_KillAura = false
local MM2_KillAuraRange = 20

CardMM2Combat:Toggle({
    Title = "Kill Aura (Murderer)",
    Callback = function(state)
        MM2_KillAura = state
        if not enMM2 then
            WindUI:Notify({ Title = "MM2", Content = "Debes estar en Murder Mystery 2" })
            return
        end
        WindUI:Notify({
            Title = "MM2",
            Content = state and "Kill Aura ON" or "Kill Aura OFF"
        })
    end
})

CardMM2Combat:Slider({
    Title = "Rango Kill Aura",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = 20
    },
    Callback = function(v)
        MM2_KillAuraRange = v
    end
})

-- Bucle de Kill Aura
task.spawn(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local killRemote = ReplicatedStorage:FindFirstChild("Murderer") or ReplicatedStorage:FindFirstChild("Kill") or ReplicatedStorage:FindFirstChild("KillPlayer")

    while true do
        if MM2_KillAura and enMM2 then
            local Character = LP.Character
            if Character then
                local root = Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local tRoot = p.Character:FindFirstChild("HumanoidRootPart")
                            if tRoot and (tRoot.Position - root.Position).Magnitude <= MM2_KillAuraRange then
                                if killRemote then
                                    pcall(function() killRemote:FireServer(p) end)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- --- FARM MM2 ---
local CardMM2Farm = MM2Tab:Section({
    Title = "💰 FARM",
    Box = true,
    BoxBorder = true
})

local MM2_AutoCoins = false
CardMM2Farm:Toggle({
    Title = "Auto Farm Coins",
    Callback = function(state)
        MM2_AutoCoins = state
        if not enMM2 then
            WindUI:Notify({ Title = "MM2", Content = "Debes estar en Murder Mystery 2" })
            return
        end
        WindUI:Notify({
            Title = "MM2 Farm",
            Content = state and "Auto Coins ON" or "Auto Coins OFF"
        })
    end
})

task.spawn(function()
    local LP = game.Players.LocalPlayer

    while true do
        if MM2_AutoCoins and enMM2 then
            local Character = LP.Character
            if Character then
                local root = Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("coin") then
                            root.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)