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
    Folder = "May67Scripts",
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
-- 3. PESTAÑA: HOME (DISEÑO BENTO BOX)
-- ==========================================
local HomeTab = SeccionHome:Tab({
    Title = "Dashboard",
    Icon = "solar:home-2-bold"
})

-- --- TARJETA: PERFIL ---
local CardPerfil = HomeTab:Section({ Title = "🔮 IDENTIDAD", Box = true, BoxBorder = true })
CardPerfil:Image({
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=420&h=420",
    AspectRatio = "1:1",
    Radius = 100
})
CardPerfil:Section({ Title = "👤 Usuario: " .. LP.Name })
CardPerfil:Section({ Title = "📅 Antigüedad: " .. LP.AccountAge .. " días" })

-- --- TARJETA: JUEGO ---
local CardJuego = HomeTab:Section({ Title = "🌌 NÚCLEO", Box = true, BoxBorder = true })
local infoJuego = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
CardJuego:Section({ Title = "🎮 Juego: " .. (infoJuego.Name or "Desconocido") })
CardJuego:Section({ Title = "📡 Servidor: " .. #game.Players:GetPlayers() .. " / " .. game.Players.MaxPlayers })

-- --- TARJETA: SESIÓN ---
local CardSesion = HomeTab:Section({ Title = "⚡ SESIÓN", Box = true, BoxBorder = true })
local TimeLabel = CardSesion:Section({ Title = "⏳ Tiempo: 0h 0m 0s" })

task.spawn(function()
    while true do
        local seg = os.time() - TiempoInicio
        local mins = math.floor(seg / 60)
        local horas = math.floor(mins / 60)
        pcall(function() TimeLabel:SetTitle(string.format("⏳ Tiempo: %dh %dm %ds", horas, mins % 60, seg % 60)) end)
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
-- 5. PESTAÑA: JUEGOS (VACÍA)
-- ==========================================
local JuegosTab = SeccionJuegos:Tab({
    Title = "Lista de Juegos",
    Icon = "solar:gamepad-bold"
})

JuegosTab:Section({ Title = "Próximamente..." })

-- ==========================================
-- 6. PESTAÑA: AJUSTES (SISTEMA)
-- ==========================================
local AjustesTab = SeccionSistema:Tab({
    Title = "Ajustes",
    Icon = "solar:settings-bold"
})

AjustesTab:Button({
    Title = "Activar Anti-AFK",
    Callback = function()
        game.Players.LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
        WindUI:Notify({ Title = "Sistema", Content = "Anti-AFK Activado" })
    end
})

-- Botón para el Dex que pediste antes (Lo puse aquí para que no estorbe)
AjustesTab:Button({
    Title = "Cargar Dark Dex V3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
})

AjustesTab:Button({
    Title = "Cerrar Hub",
    Callback = function() Window:Destroy() end
})

-- NOTIFICACIÓN FINAL
WindUI:Notify({ Title = "NC HUB", Content = "Script cargado correctamente.", Duration = 5 })
