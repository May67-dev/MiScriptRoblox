local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- */ Creación de la Ventana con estilo Mac /* --
local Window = WindUI:CreateWindow({
    Title = "NC HUB",
    Author = "By hidjcjgg",
    Folder = "May67Scripts",
    Icon = "solar:ghost-bold", -- Un icono con estilo
    Theme = "Dark",
    NewElements = true, -- Activa el diseño más moderno
    Topbar = {
        Height = 44,
        ButtonsType = "Mac", -- Esto pone los botones rojo/amarillo/verde arriba
    },
    OpenButton = {
        Title = "Abrir NC HUB",
        Enabled = true,
        Draggable = true,
        OnlyMobile = true
    }
})

-- */ Secciones del Menú Lateral (Esto es lo que lo hace diferente) /* --
local Categorias = Window:Section({
    Title = "CATEGORÍAS",
})

-- */ Pestañas dentro de la Sección /* --
local MainTab = Categorias:Tab({
    Title = "Inicio",
    Icon = "solar:home-2-bold",
    Border = true,
})

local ScriptsTab = Categorias:Tab({
    Title = "Scripts",
    Icon = "solar:code-bold",
    Border = true,
})

-- */ Contenido de la Pestaña Inicio /* --
local WelcomeGroup = MainTab:Group({ Title = "Bienvenida" })

WelcomeGroup:Button({
    Title = "Cerrar Interfaz",
    Callback = function()
        Window:Destroy()
    end,
})

-- */ Contenido de la Pestaña Scripts /* --
local PlayerGroup = ScriptsTab:Group({ Title = "Movimiento" })

PlayerGroup:Slider({
    Title = "Velocidad",
    Value = {Min = 16, Max = 250, Default = 16},
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

PlayerGroup:Toggle({
    Title = "Salto Infinito",
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

WindUI:Notify({
    Title = "NC HUB",
    Content = "Script cargado con éxito.",
    Duration = 5
})
