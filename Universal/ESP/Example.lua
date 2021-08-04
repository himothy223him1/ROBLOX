-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- // Vars
local LocalPlayer = Players.LocalPlayer
local Manager = {} -- // Contains every player

-- // Get character
local getCharacter = function(Player)
    local Character = Player.Character

    if (Character) then
        return Character, Character.PrimaryPart
    end
end

-- // Initialise ESP for that player
local initialisePlayer = function(Player)
    -- // Create the ESP Objects
    local Box = ESP:Box({Model = Player.Character})
    local Header = ESP:Header({Model = Player.Character})
    local Tracer = ESP:Tracer({Model = Player.Character})

    -- // Add to manager
    table.insert(Manager, {Player, {Box, Header, Tracer}})
end

-- // Deinitialise ESP for that player
local deinitialisePlayer = function(Player)
    -- // Find player in manager
    for i = 1, #Manager do
        -- // Vars
        local Object = Manager[i]

        -- // Check for player
        if not (Object[1] == Player) then
            continue
        end

        -- // Remove each object
        local ESPObjects = Object[2]
        for x = 1, #ESPObjects do
            local ESPObject = ESPObjects[x]
            ESPObject:Remove()
        end

        -- // Remove from table
        table.remove(Manager, i)

        -- // Break
        break
    end
end

-- // Initialise for existing players
do
    local AllPlayers = game:GetService("Players"):GetPlayers()
    for i = 1, #AllPlayers do
        -- // Vars
        local Player = AllPlayers[i]

        -- // Skip LocalPlayer
        if (Player == LocalPlayer) then
            continue
        end

        -- // Initialise the player
        initialisePlayer(Player)
    end
end

-- // Initialise for new players
Players.PlayerAdded:Connect(initialisePlayer)

-- // Deinitialise left players
Players.PlayerAdded:Connect(deinitialisePlayer)

-- // Update loop
RunService:BindToRenderStep("ESPUpdate", 0, function()
    -- // Loop through manager
    for i = 1, #Manager do
        -- // Vars
        local Object = Manager[i]
        local Character = getCharacter(Object[1])

        -- // Update every ESP Object
        local ESPObjects = Object[2]
        for x = 1, #ESPObjects do
            local ESPObject = ESPObjects[x]
            ESPObject:Update({Model = Character})
        end
    end
end)