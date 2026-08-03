-- REGISTRO DE TIEMPO
local TiempoInicio = os.time()

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CONFIGURACIÓN DE LA VENTANA (Estilo Pro)
local Window = WindUI:CreateWindow({
    Title = "NC HUB | DASHBOARD",
    Author = "By hidjcjgg",
    Folder = "May67Scripts",
    Icon = "solar:widget-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(600, 460),
    NewElements = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

-- 2. SECCIONES DEL SIDEBAR
local SeccionHome = Window:Section({ Title = "PRINCIPAL" })
local SeccionTrampas = Window:Section({ Title = "HERRAMIENTAS" })
local SeccionSistema = Window:Section({ Title = "SISTEMA" })

-- ==========================================
-- 3. PESTAÑA: HOME (DISEÑO BENTO BOX)
-- ==========================================
local HomeTab = SeccionHome:Tab({
    Title = "Dashboard",
    Icon = "solar:home-2-bold"
})

-- --- TARJETA 1: PERFIL ---
local UserGroup = HomeTab:Group({ Title = "PERFIL DEL USUARIO" })
local userId = game.Players.LocalPlayer.UserId

UserGroup:Image({
    Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=420&height=420&format=png",
    AspectRatio = "1:1",
    Radius = 100
})

UserGroup:Label({
    Title = "Usuario: " .. game.Players.LocalPlayer.Name,
    Desc = "ID: " .. userId
})

-- --- TARJETA 2: ESTADO DEL JUEGO ---
local GameGroup = HomeTab:Group({ Title = "ESTADO DEL JUEGO" })
local infoJuego = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)

GameGroup:Label({
    Title = "🎮 " .. (infoJuego.Name or "Juego"),
    Desc = "Servidor: " .. #game.Players:GetPlayers() .. " / " .. game.Players.MaxPlayers
})

-- --- TARJETA 3: MONITOR DE SESIÓN ---
local SessionGroup = HomeTab:Group({ Title = "MONITOR DE SESIÓN" })
local TimeLabel = SessionGroup:Label({
    Title = "⏳ Tiempo: 0h 0m 0s",
    Desc = "Estado: Conectado y Seguro"
})

task.spawn(function()
    while true do
        local segundos = os.time() - TiempoInicio
        local mins = math.floor(segundos / 60)
        local horas = math.floor(mins / 60)
        local texto = string.format("%dh %dm %ds", horas, mins % 60, segundos % 60)
        pcall(function()
            TimeLabel:SetTitle("⏳ Tiempo: " .. texto)
        end)
        task.wait(1)
    end
end)

-- ==========================================
-- 4. PESTAÑA: MOVIMIENTO (TRAMPAS)
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
-- 6. PESTAÑA: VUELO (Fly Pro)
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
