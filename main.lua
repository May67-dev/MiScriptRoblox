local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- */ Configuración de la Ventana /* --
local Window = WindUI:CreateWindow({
    Title = "NC HUB", -- TU NOMBRE AQUÍ
    Author = "By Hidjcjgg",
    Folder = "May67Scripts",
    Icon = "solar:home-2-bold", -- Icono moderno
    Theme = "Dark", -- Puedes probar "Mellowsi" para otro tono
    OpenButton = {
        Title = "Abrir Hub",
        Enabled = true,
        Draggable = true,
        OnlyMobile = true -- Solo aparece el botón en celular
    }
})

-- */ Pestañas /* --
local MainTab = Window:Tab({
    Title = "Principal",
    Icon = "solar:info-square-bold",
    Border = true,
})

local PlayerTab = Window:Tab({
    Title = "Jugador",
    Icon = "solar:user-bold",
    Border = true,
})

-- */ Sección de Bienvenida /* --
local WelcomeSection = MainTab:Section({
    Title = "Bienvenido, May67",
})

WelcomeSection:Button({
    Title = "Cerrar Hub",
    Desc = "Destruye la interfaz por completo",
    Callback = function()
        Window:Destroy()
    end,
})

-- */ Sección de Funciones (Jugador) /* --
local PlayerSection = PlayerTab:Section({
    Title = "Movimiento",
})

-- Slider de Velocidad con Animación
PlayerSection:Slider({
    Title = "Velocidad",
    Desc = "Ajusta tu rapidez",
    Step = 1,
    Value = {Min = 16, Max = 300, Default = 16},
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

-- Toggle de Salto Infinito
PlayerSection:Toggle({
    Title = "Salto Infinito",
    Desc = "Salta sin límites",
    Callback = function(state)
        _G.InfJump = state
    end,
})

-- Lógica del Salto
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Notificación al cargar
WindUI:Notify({
    Title = "Hub Cargado",
    Content = "Todo listo para la acción.",
    Duration = 5
})
