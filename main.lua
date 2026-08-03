local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Nc Hub",
   LoadingTitle = "Cargando Script...",
   LoadingSubtitle = "Nc Hub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MisScripts",
      FileName = "ConfigPrincipal"
   },
   KeySystem = false -- Ponlo en true si quieres ponerle contraseña
})

-- Pestaña de Información (Igual a la de tu foto)
local InfoTab = Window:CreateTab("Info", 4483362458) -- Icono de Info

local Section = InfoTab:CreateSection("Discord 🎉")

InfoTab:CreateButton({
   Name = "Próximamente 👻",
   Callback = function()
      -- Aquí pondrías el link
      print("Link copiado")
   end,
})

-- Pestaña de Funciones
local MainTab = Window:CreateTab("Main", 4483362458) -- Icono de Gamepad

MainTab:CreateButton({
   Name = "Velocidad (Speed) 100",
   Callback = function()
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
   end,
})

-- Barra de búsqueda (Rayfield la trae por defecto en las pestañas)