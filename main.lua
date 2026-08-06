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
-- 5. PESTAÑA: JUEGOS (FACTORY TYCOON)
-- ==========================================
local FactoryTab = SeccionJuegos:Tab({
    Title = "Factory Tycoon",
    Icon = "solar:factory-bold"
})

local AutoCollectF = false
local AutoBuyF = false
local AutoRebirthF = false

local CardStatsF = FactoryTab:Section({ Title = "📊 ESTADO DE FÁBRICA", Box = true, BoxBorder = true })
local MoneyLabelF = CardStatsF:Section({ Title = "💵 Efectivo: $0" })
local GemsLabelF = CardStatsF:Section({ Title = "💎 Gemas: 0" })

task.spawn(function()
    while true do
        pcall(function()
            local data = LP:WaitForChild("DataFolder")
            MoneyLabelF:SetTitle("💵 Efectivo: $" .. data.Money.Value)
            GemsLabelF:SetTitle("💎 Gemas: " .. data.Gems.Value)
        end)
        task.wait(1)
    end
end)

local CardFarmF = FactoryTab:Section({ Title = "🤖 AUTOMATIZACIÓN", Box = true, BoxBorder = true })
CardFarmF:Toggle({ Title = "Auto-Cobrar (Oficial)", Callback = function(s) AutoCollectF = s end })
CardFarmF:Toggle({ Title = "Auto-Comprar (Anti-Robux)", Callback = function(s) AutoBuyF = s end })
CardFarmF:Toggle({ Title = "Auto-Rebirth Inteligente", Callback = function(s) AutoRebirthF = s end })

-- LÓGICA DE FÁBRICA (LIMPIA)
task.spawn(function()
    local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    while true do
        local tycoon = LP:FindFirstChild("TycoonOwned") and LP.TycoonOwned.Value
        
        -- Auto Cobrar
        if AutoCollectF and tycoon then
            pcall(function() 
                local collectPart = tycoon:FindFirstChild("Build") and tycoon.Build:FindFirstChild("Collect")
                if collectPart then Events.CollectMoney:FireServer(collectPart) end
            end)
        end
        
        -- Auto Comprar
        if AutoBuyF and tycoon then
            pcall(function()
                for _, v in pairs(tycoon:GetDescendants()) do
                    if v:IsA("BasePart") and v:FindFirstChild("Price") then
                        local isRobux = v:FindFirstChild("GamepassID") or v:FindFirstChild("ProductID")
                        if not isRobux and v.Price.Value <= LP.DataFolder.Money.Value then
                            Events.ButtonUsed:FireServer(v.Name)
                            firetouchinterest(LP.Character.HumanoidRootPart, v, 0)
                        end
                    end
                end
            end)
        end
        
        -- Auto Rebirth (El glitch)
        if AutoRebirthF and tycoon then
            pcall(function()
                local args = { [1] = 653, [2] = 653, [3] = tycoon }
                Events.RequestRebirth:FireServer(unpack(args))
            end)
        end
        task.wait(0.8)
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
