-- states/game.lua
local Character = require "core.character"
local GameState = require "core.gameState"
local Map       = require "core.map"

local game = {}
local characters = {}
local map
local state

function game.load()
    -- Load tile sprites
    local tileSprites = {}
    -- for i = 1, 12 do
    --     table.insert(tileSprites, love.graphics.newImage("sprites/tiles/marble_wall_"..i..".png"))
    -- end

    -- -- Map layout
    -- local layout = {
    --     {9, 6, 5, 1, 6, 4, 3, 8, 4, 6, 12},
    --     -- etc...
    -- }

    map = Map.new(32, layout, tileSprites)
    state = GameState.new()

    -- Create characters
    table.insert(characters, Character.new("NinjaDark",     2, 4, {hp=25, pwr=5, def=2, dex=5, spd=4, rng=2, team=0}))
    table.insert(characters, Character.new("GladiatorBlue",   2, 6, {hp=25, pwr=7, def=5, dex=3, spd=2, rng=1, team=1}))
    -- etc...
end

function game.update(dt)
    state:clampAP()
    state:checkWin()

    for _, c in ipairs(characters) do
        c:update(dt)
    end
end

function game.draw()
    local mx, my = love.mouse.getPosition()
    map:draw(mx, my)

    for _, c in ipairs(characters) do
        c:draw(map.tileSize)
    end

    -- Example: draw turn indicator
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(state:currentTeam() .. "'s Turn", 20, 20)
end

function game.mousepressed(x, y, button)
    if state.over then
        -- handle rematch/menu buttons
        return
    end

    if button == 1 then
        local hovered = map:getHoveredTile()
        if hovered then
            local col, row = hovered[1], hovered[2]
            -- check if a character is there, select/attack/etc.
        end
    end
end

return game