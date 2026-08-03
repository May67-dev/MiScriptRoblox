local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CREACIÓN DE VENTANA (Con tamaño forzado)
local Window = WindUI:CreateWindow({
    Title = "MAY67 HUB",
    Author = "by May67-dev",
    Folder = "May67Config",
    Icon = "solar:ghost-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(580, 400), -- Forzamos más ancho para evitar letras verticales
    NewElements = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

-- 2. SECCIÓN LATERAL
local SeccionLateral = Window:Section({
    Title = "CATEGORIAS"
})

-- 3. PESTAÑA
local PestanaPrincipal = SeccionLateral:Tab({
    Title = "Principal",
    Icon = "solar:home-2-bold"
})

-- 4. SLIDER DIRECTO (Sin Grupo para tener más espacio)
PestanaPrincipal:Slider({
    Title = "Velocidad",
    Desc = "Ajustar rapidez", -- La descripción ayuda a que el layout se expanda
    Step = 1,
    Value = {
        Min = 16,
        Max = 500,
        Default = 16
    },
    Callback = function(valor)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = valor
    end
})

-- 5. BOTÓN DE PRUEBA
PestanaPrincipal:Button({
    Title = "Cerrar Hub",
    Callback = function()
        Window:Destroy()
    end
})
