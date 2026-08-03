local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CONFIGURACIÓN DE LA VENTANA
local Window = WindUI:CreateWindow({
    Title = "NC HUB",
    Author = "By hidjcjgg",
    Folder = "May67Scripts",
    Icon = "solar:bolt-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(580, 420), -- Ancho para evitar bug de texto
    NewElements = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

-- 2. SECCIONES DEL SIDEBAR
local SeccionJugador = Window:Section({
    Title = "JUGADOR"
})

local SeccionTrampas = Window:Section({
    Title = "TRAMPAS"
})

local SeccionSistema = Window:Section({
    Title = "SISTEMA"
})

-- 3. PESTAÑA: MOVIMIENTO
local MovTab = SeccionJugador:Tab({
    Title = "Movimiento",
    Icon = "solar:walking-bold"
})

-- Slider de Velocidad
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

-- Toggle Salto Infinito
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

-- 4. PESTAÑA: TRAMPAS
local CheatTab = SeccionTrampas:Tab({
    Title = "Hacks",
    Icon = "solar:ghost-bold"
})

-- Noclip (Atravesar paredes)
local NoclipEnabled = false
CheatTab:Toggle({
    Title = "Atravesar Paredes (Noclip)",
    Callback = function(state)
        NoclipEnabled = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ESP (Ver Jugadores)
CheatTab:Toggle({
    Title = "Ver Jugadores (ESP)",
    Callback = function(state)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                if state then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                else
                    if p.Character:FindFirstChild("Highlight") then
                        p.Character.Highlight:Destroy()
                    end
                end
            end
        end
    end
})

-- 5. PESTAÑA: VUELO (Fly Profesional Corregido)
local FlyTab = SeccionTrampas:Tab({
    Title = "Vuelo",
    Icon = "solar:plain-bold"
})

local VueloActivo = false
local VelocidadVuelo = 80

FlyTab:Slider({
    Title = "Velocidad de Vuelo",
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
    Desc = "Joystick total + Animación estable",
    Callback = function(state)
        VueloActivo = state
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")
        local hum = character:WaitForChild("Humanoid")
        local camera = workspace.CurrentCamera
        
        if VueloActivo then
            -- Limpiamos fuerzas antiguas
            if root:FindFirstChild("FlyForce") then root.FlyForce:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
            
            -- 1. CONGELAR ANIMACIÓN DE CAÍDA
            hum.PlatformStand = true 
            
            -- 2. FUERZA DE MOVIMIENTO
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyForce"
            bv.Parent = root
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(0, 0, 0)
            
            -- 3. ESTABILIZADOR (Para que no se caiga de lado)
            local bg = Instance.new("BodyGyro")
            bg.Name = "FlyGyro"
            bg.Parent = root
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 10000 -- Fuerza de estabilidad
            bg.CFrame = root.CFrame
            
            task.spawn(function()
                while VueloActivo do
                    local moveDir = hum.MoveDirection
                    if moveDir.Magnitude > 0 then
                        -- Lógica Matemática Pro:
                        -- Convertimos el movimiento del joystick al espacio de la cámara
                        local lookCF = camera.CFrame
                        local direction = lookCF:VectorToWorldSpace(lookCF:VectorToObjectSpace(moveDir))
                        
                        bv.Velocity = direction * VelocidadVuelo
                        -- Hace que el personaje rote suavemente hacia donde vas
                        bg.CFrame = CFrame.new(root.Position, root.Position + direction)
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                        -- Mantiene al personaje mirando al frente cuando está quieto
                        bg.CFrame = CFrame.new(root.Position, root.Position + camera.CFrame.LookVector)
                    end
                    task.wait()
                end
                
                -- AL APAGAR: Restaurar todo
                hum.PlatformStand = false
                if root:FindFirstChild("FlyForce") then root.FlyForce:Destroy() end
                if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end
})

-- 6. PESTAÑA: SISTEMA (Ajustes finales)
local SeccionSistema = Window:Section({
    Title = "SISTEMA"
})

local SysTab = SeccionSistema:Tab({
    Title = "Ajustes",
    Icon = "solar:settings-bold"
})

SysTab:Button({
    Title = "Activar Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        WindUI:Notify({
            Title = "Sistema",
            Content = "Anti-AFK Activado"
        })
    end
})

SysTab:Button({
    Title = "Cerrar Hub",
    Callback = function()
        Window:Destroy()
    end
})
