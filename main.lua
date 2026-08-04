-- REGISTRO DE TIEMPO
local TiempoInicio = os.time()

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- 1. CONFIGURACIÓN DE LA VENTANA
local Window = WindUI:CreateWindow({
    Title = "NC HUB",
    Author = "By hidjcjgg",
    Folder = "May67Scripts",
    Icon = "solar:bolt-bold",
    Theme = "Dark",
    Size = UDim2.fromOffset(600, 450), -- Tamaño extra para evitar bugs
    NewElements = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

-- 2. SECCIONES DEL SIDEBAR (Organizadas como pediste)
local SeccionHome = Window:Section({
    Title = "HOME"
})

local SeccionTrampas = Window:Section({
    Title = "TRAMPAS"
})

local SeccionSistema = Window:Section({
    Title = "SISTEMA"
})

-- ==========================================
-- 3. PESTAÑA: HOME (DISEÑO BENTO BOX FUTURISTA)
-- ==========================================
local HomeTab = SeccionHome:Tab({
    Title = "Dashboard",
    Icon = "solar:widget-bold"
})

-- OBTENCIÓN DE DATOS DINÁMICOS
local MarketplaceService = game:GetService("MarketplaceService")
local infoJuego = MarketplaceService:GetProductInfo(game.PlaceId)
local nombreJuego = infoJuego.Name or "Juego Desconocido"
local userId = game.Players.LocalPlayer.UserId
local fotoUrl = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=420&h=420"

-- --- TARJETA 1: IDENTIDAD DIGITAL (ESTILO MORADO) ---
local CardPerfil = HomeTab:Section({
    Title = "🔮 IDENTIDAD DIGITAL",
    Box = true,
    BoxBorder = true
})

CardPerfil:Image({
    Image = fotoUrl,
    AspectRatio = "1:1",
    Radius = 100 -- Foto redonda tipo perfil premium
})

CardPerfil:Section({
    Title = "👤 Usuario: " .. game.Players.LocalPlayer.Name
})

CardPerfil:Section({
    Title = "🆔 UserID: " .. userId
})

CardPerfil:Section({
    Title = "📅 Antigüedad: " .. game.Players.LocalPlayer.AccountAge .. " días"
})

-- --- TARJETA 2: NÚCLEO DEL SISTEMA (ESTILO AZUL) ---
local CardJuego = HomeTab:Section({
    Title = "🌌 NÚCLEO DEL JUEGO",
    Box = true,
    BoxBorder = true
})

CardJuego:Section({
    Title = "🎮 Mapeado en: " .. nombreJuego
})

CardJuego:Section({
    Title = "📡 Servidor: " .. #game.Players:GetPlayers() .. " / " .. game.Players.MaxPlayers
})

CardJuego:Section({
    Title = "📍 Place ID: " .. game.PlaceId
})

-- --- TARJETA 3: MONITOR DE SESIÓN (FUTURISTA) ---
local CardSesion = HomeTab:Section({
    Title = "⚡ MONITOR DE SESIÓN",
    Box = true,
    BoxBorder = true
})

local TimeLabel = CardSesion:Section({
    Title = "⏳ Tiempo Activo: 0h 0m 0s"
})

CardSesion:Section({
    Title = "💎 Status: NC HUB Operacional"
})

-- Bucle de actualización (Usa la variable TiempoInicio de la línea 2)
task.spawn(function()
    while true do
        local segundos = os.time() - TiempoInicio
        local mins = math.floor(segundos / 60)
        local horas = math.floor(mins / 60)
        local texto = string.format("%dh %dm %ds", horas, mins % 60, segundos % 60)
        
        pcall(function()
            TimeLabel:SetTitle("⏳ Tiempo Activo: " .. texto)
        end)
        
        task.wait(1)
    end
end)

-- ==========================================
-- 4. PESTAÑA: MOVIMIENTO (Ahora en Trampas)
-- ==========================================
local MovTab = SeccionTrampas:Tab({
    Title = "Movimiento",
    Icon = "solar:walking-bold"
})

MovTab:Slider({
    Title = "Velocidad",
    Step = 1,
    Value = {
        Min = 16,
        Max = 128,
        Default = 16
    },
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

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

-- ==========================================
-- 5. PESTAÑA: HACKS (Noclip y ESP)
-- ==========================================
local CheatTab = SeccionTrampas:Tab({
    Title = "Hacks",
    Icon = "solar:ghost-bold"
})

local NoclipEnabled = false
CheatTab:Toggle({
    Title = "Atravesar Paredes",
    Callback = function(state)
        NoclipEnabled = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

CheatTab:Toggle({
    Title = "Ver Jugadores (ESP)",
    Callback = function(state)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                if state then
                    local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                else
                    if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
                end
            end
        end
    end
})

-- ==========================================
-- 6. PESTAÑA: VUELO (Con Slider recuperado)
-- ==========================================
local FlyTab = SeccionTrampas:Tab({
    Title = "Vuelo",
    Icon = "solar:plain-bold"
})

local VueloActivo = false
local VelocidadVuelo = 80

FlyTab:Slider({
    Title = "Velocidad Vuelo",
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
    Callback = function(state)
        VueloActivo = state
        local root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local hum = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        
        if VueloActivo then
            hum.PlatformStand = true
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "FlyForce"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            local bg = Instance.new("BodyGyro", root)
            bg.Name = "FlyGyro"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            
            task.spawn(function()
                while VueloActivo do
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    if hum.MoveDirection.Magnitude > 0 then
                        local look = workspace.CurrentCamera.CFrame.LookVector
                        local right = workspace.CurrentCamera.CFrame.RightVector
                        local forwardVec = Vector3.new(look.X, 0, look.Z).Unit
                        local rightVec = Vector3.new(right.X, 0, right.Z).Unit
                        local forwardAmount = hum.MoveDirection:Dot(forwardVec)
                        local rightAmount = hum.MoveDirection:Dot(rightVec)
                        bv.Velocity = ((look * forwardAmount) + (right * rightAmount)).Unit * VelocidadVuelo
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                    task.wait()
                end
                hum.PlatformStand = false
                if root:FindFirstChild("FlyForce") then root.FlyForce:Destroy() end
                if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end
})

-- ==========================================
-- 7. PESTAÑA: AJUSTES (SISTEMA)
-- ==========================================
local SysTab = SeccionSistema:Tab({
    Title = "Ajustes",
    Icon = "solar:settings-bold"
})

SysTab:Button({
    Title = "Activar Anti-AFK",
    Callback = function()
        game.Players.LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
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

-- ==========================================
-- DEBUG UNIVERSAL - CUALQUIER JUEGO (En un Tab separado)
-- ==========================================
local DebugTab = SeccionSistema:Tab({
    Title = "Debug",
    Icon = "solar:bug-bold"
})

local DebugSection = DebugTab:Section({
    Title = "Nombres Reales",
    Box = true,
    BoxBorder = true
})

local ListaWorkspace = ""
local ListaRS = ""
local ListaObjetos = ""
local ListaRemotes = ""

DebugSection:Button({
    Title = "Listar Workspace",
    Callback = function()
        local l = {}
        table.insert(l, "WORKSPACE:")
        for _, o in ipairs(game.Workspace:GetChildren()) do
            table.insert(l, "- " .. o.Name)
        end
        ListaWorkspace = table.concat(l, string.char(10))
        WindUI:Notify({
            Title = "Debug",
            Content = ListaWorkspace
        })
    end
})

DebugSection:Button({
    Title = "Copiar Workspace",
    Callback = function()
        if ListaWorkspace ~= "" then
            setclipboard(ListaWorkspace)
            WindUI:Notify({
                Title = "Debug",
                Content = "Copiado!"
            })
        else
            WindUI:Notify({
                Title = "Debug",
                Content = "Primero dale a Listar Workspace"
            })
        end
    end
})

DebugSection:Button({
    Title = "Listar ReplicatedStorage",
    Callback = function()
        local l = {}
        table.insert(l, "ReplicatedStorage:")
        for _, o in ipairs(game.ReplicatedStorage:GetChildren()) do
            table.insert(l, "- " .. o.Name)
        end
        ListaRS = table.concat(l, string.char(10))
        WindUI:Notify({
            Title = "Debug",
            Content = ListaRS
        })
    end
})

DebugSection:Button({
    Title = "Copiar ReplicatedStorage",
    Callback = function()
        if ListaRS ~= "" then
            setclipboard(ListaRS)
            WindUI:Notify({
                Title = "Debug",
                Content = "Copiado!"
            })
        else
            WindUI:Notify({
                Title = "Debug",
                Content = "Primero dale a Listar"
            })
        end
    end
})

DebugSection:Button({
    Title = "Buscar Objetos",
    Callback = function()
        local l = {}
        table.insert(l, "OBJETOS:")
        for _, o in ipairs(game.Workspace:GetDescendants()) do
            local n = o.Name:lower()
            if n:find("data") or n:find("server") or n:find("antenna") or n:find("base") or n:find("sell") or n:find("collect") or n:find("steal") or n:find("hack") or n:find("buy") or n:find("place") or n:find("cash") or n:find("money") or n:find("item") or n:find("product") then
                table.insert(l, "+ " .. o.Name)
            end
        end
        ListaObjetos = table.concat(l, string.char(10))
        WindUI:Notify({
            Title = "Debug",
            Content = ListaObjetos
        })
    end
})

DebugSection:Button({
    Title = "Copiar Objetos",
    Callback = function()
        if ListaObjetos ~= "" then
            setclipboard(ListaObjetos)
            WindUI:Notify({
                Title = "Debug",
                Content = "Copiado!"
            })
        else
            WindUI:Notify({
                Title = "Debug",
                Content = "Primero dale a Buscar Objetos"
            })
        end
    end
})

DebugSection:Button({
    Title = "Buscar Remotes",
    Callback = function()
        local l = {}
        table.insert(l, "REMOTES:")
        for _, o in ipairs(game.ReplicatedStorage:GetDescendants()) do
            if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
                table.insert(l, "- " .. o.Name)
            end
        end
        ListaRemotes = table.concat(l, string.char(10))
        WindUI:Notify({
            Title = "Debug",
            Content = ListaRemotes
        })
    end
})

DebugSection:Button({
    Title = "Copiar Remotes",
    Callback = function()
        if ListaRemotes ~= "" then
            setclipboard(ListaRemotes)
            WindUI:Notify({
                Title = "Debug",
                Content = "Copiado!"
            })
        else
            WindUI:Notify({
                Title = "Debug",
                Content = "Primero dale a Buscar Remotes"
            })
        end
    end
})
-- ==========================================

-- ==========================================
-- EXPLORADOR DE JUEGO (Tipo Infinite Yield)
-- ==========================================
local ExplorerTab = SeccionSistema:Tab({
    Title = "Explorador",
    Icon = "solar:folder-bold"
})

local ExplorerSection = ExplorerTab:Section({
    Title = "Explorador de Objetos",
    Box = true,
    BoxBorder = true
})

local SelectedParent = game

local function RefreshExplorer()
    ExplorerSection:Clear()
    
    local function AddChildren(parent, depth)
        if depth > 10 then return end
        
        for _, child in ipairs(parent:GetChildren()) do
            local buttonName = child.Name .. " [" .. child.ClassName .. "]"
            
            ExplorerSection:Button({
                Title = string.rep("  ", depth) .. "📄 " .. buttonName,
                Callback = function()
                    SelectedParent = child
                    WindUI:Notify({
                        Title = "Seleccionado",
                        Content = child.Name .. "\
Clase: " .. child.ClassName .. "\
Padre: " .. parent.Name
                    })
                end
            })
            
            if #child:GetChildren() > 0 then
                AddChildren(child, depth + 1)
            end
        end
    end
    
    AddChildren(SelectedParent, 0)
end

ExplorerSection:Button({
    Title = "📁 game",
    Callback = function()
        SelectedParent = game
        RefreshExplorer()
    end
})

ExplorerSection:Button({
    Title = "📁 Workspace",
    Callback = function()
        SelectedParent = game.Workspace
        RefreshExplorer()
    end
})

ExplorerSection:Button({
    Title = "📁 ReplicatedStorage",
    Callback = function()
        SelectedParent = game.ReplicatedStorage
        RefreshExplorer()
    end
})

ExplorerSection:Button({
    Title = "📁 Players",
    Callback = function()
        SelectedParent = game.Players
        RefreshExplorer()
    end
})

ExplorerSection:Button({
    Title = "🔄 Refresh",
    Callback = function()
        RefreshExplorer()
    end
})

ExplorerSection:Button({
    Title = "📋 Copiar Lista Completa",
    Callback = function()
        local function GetAllChildren(parent, depth)
            local result = ""
            if depth > 10 then return result end
            
            for _, child in ipairs(parent:GetChildren()) do
                result = result .. string.rep("  ", depth) .. child.Name .. " [" .. child.ClassName .. "]"
                result = result .. GetAllChildren(child, depth + 1)
            end
            return result
        end
        
        local fullList = GetAllChildren(SelectedParent, 0)
        setclipboard(fullList)
        WindUI:Notify({
            Title = "Explorador",
            Content = "Lista copiada!"
        })
    end
})

task.wait(1)
RefreshExplorer()

-- SECCIÓN: JUEGOS
-- ==========================================
local SeccionJuegos = Window:Section({
    Title = "JUEGOS"
})

-- ==========================================
-- HACK A BUSINESS
-- ==========================================
local HABTab = SeccionJuegos:Tab({
    Title = "Hack A Business",
    Icon = "solar:computer-bold"
})

local AutoSection = HABTab:Section({
    Title = "Auto",
    Box = true,
    BoxBorder = true
})

local AutoCollect = false
local AutoSteal = false
local SellBest = false

AutoSection:Toggle({
    Title = "Auto Collect",
    Callback = function(state)
        AutoCollect = state
    end
})

AutoSection:Toggle({
    Title = "Auto Steal",
    Callback = function(state)
        AutoSteal = state
    end
})

AutoSection:Toggle({
    Title = "Sell Best Zone",
    Callback = function(state)
        SellBest = state
    end
})

-- Main Loop
task.spawn(function()
    local LP = game.Players.LocalPlayer
    local RS = game.ReplicatedStorage
    local WS = game.Workspace
    
    local PickUpRemote = RS:FindFirstChild("PickUpObject")
    local SellRemote = RS:FindFirstChild("SellObject")
    
    while true do
        local Char = LP.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        
        if Root and Char then
            -- Auto Collect: recoger Servers
            if AutoCollect and PickUpRemote then
                for _, obj in ipairs(WS:GetDescendants()) do
                    if obj.Name == "Server" or obj.Name == "toxic-server" then
                        pcall(function()
                            PickUpRemote:FireServer(obj)
                        end)
                    end
                end
            end
            
            -- Auto Steal: buscar Bases y Antennas (falta remote de robar)
            if AutoSteal then
                -- Aqui iría el remote de robar cuando lo encontremos
            end
            
            -- Sell Best Zone: vender con SellObject
            if SellBest and SellRemote then
                pcall(function()
                    SellRemote:FireServer()
                end)
            end
        end
        
        task.wait(0.2)
    end
end)

-- Utilidades
local UtilSection = HABTab:Section({
    Title = "Utilidades",
    Box = true,
    BoxBorder = true
})

UtilSection:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 500,
        Default = 16
    },
    Callback = function(v)
        local Char = LP.Character or LP.CharacterAdded:Wait()
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if Hum then
            Hum.WalkSpeed = v
        end
    end
})

UtilSection:Slider({
    Title = "JumpPower",
    Step = 1,
    Value = {
        Min = 50,
        Max = 500,
        Default = 50
    },
    Callback = function(v)
        local Char = LP.Character or LP.CharacterAdded:Wait()
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if Hum then
            Hum.JumpPower = v
        end
    end
})