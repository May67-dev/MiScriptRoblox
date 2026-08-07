-- ==========================================
-- NC HUB | OFFICIAL LOADER (V1.0)
-- ==========================================
-- Este es el único código que debes poner en Delta.
-- Detecta el juego y carga el módulo correspondiente.

local PlaceId = game.PlaceId
local BaseURL = "https://raw.githubusercontent.com/May67-dev/MiScriptRoblox/refs/heads/main/"

-- DICCIONARIO DE JUEGOS (ID del Juego = Nombre del Archivo)
local Games = {
    [14856037045] = "FactoryTycoon.lua",   -- Factory Tycoon
    [18365117365] = "TSL.lua",             -- The Stronger Lifter
    [142823291]    = "MM2.lua",            -- Murder Mystery 2
    [16148666753] = "HackABusiness.lua"    -- Hack a Business (ID estimado)
}

-- Si el juego no está en la lista, carga el Universal
local scriptToLoad = Games[PlaceId] or "Universal.lua"

-- Notificación de Carga
print("[NC HUB] Detectado PlaceID: " .. PlaceId)
print("[NC HUB] Cargando módulo: " .. scriptToLoad)

-- Ejecución
local success, err = pcall(function()
    loadstring(game:HttpGet(BaseURL .. scriptToLoad))()
end)

if not success then
    warn("[NC HUB] Error al cargar el módulo: " .. tostring(err))
    -- Intento de respaldo con Universal si el específico falla
    loadstring(game:HttpGet(BaseURL .. "Universal.lua"))()
end
