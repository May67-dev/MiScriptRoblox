local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- CREACIÓN DE VENTANA
local Window = WindUI:CreateWindow({
    Title = "ESCRIBE_NOMBRE",
    Author = "TU_NOMBRE",
    Folder = "MiConfig",
    Icon = "solar:ghost-bold",
    Theme = "Dark",
    NewElements = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

-- SECCIÓN LATERAL
local MiSeccion = Window:Section({
    Title = "CATEGORIA"
})

-- PESTAÑA
local MiPestana = MiSeccion:Tab({
    Title = "INICIO",
    Icon = "solar:home-2-bold"
})

-- GRUPO (Contenedor de botones)
local MiGrupo = MiPestana:Group({
    Title = "AJUSTES"
})

-- SLIDER (Aquí corregimos el bug del texto vertical)
MiGrupo:Slider({
    Title = "Velocidad", -- Mantén los nombres cortos para evitar el bug
    Step = 1,
    Value = {
        Min = 16,
        Max = 300,
        Default = 16
    },
    Callback = function(valor)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = valor
    end
})

-- BOTÓN
MiGrupo:Button({
    Title = "BOTON_1",
    Callback = function()
        -- Tu código aquí
    end
})
