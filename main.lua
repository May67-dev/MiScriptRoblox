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

-- 5. PESTAÑA: VUELO
local FlyTab = SeccionTrampas:Tab({
    Title = "Vuelo",
    Icon = "solar:plain-bold"
})

FlyTab:Button({
    Title = "Activar Vuelo (Fly)",
    Callback = function()
        -- Aquí puedes pegar tu script de Fly favorito o usar este básico
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
    end
})

-- 6. PESTAÑA: SISTEMA
local SysTab = SeccionSistema:Tab({
    Title = "Ajustes",
    Icon = "solar:settings-bold"
})

-- Anti-AFK
SysTab:Button({
    Title = "Activar Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
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
