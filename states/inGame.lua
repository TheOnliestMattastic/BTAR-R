-- inGame.lua (refactored skeleton)

local inGame = {}
local anim8 = require "lib/anim8"
local Timer = require "lib/timer"

-- Constants
local TILE_SIZE = 48
local MAX_HP = 25
local MAX_AP = 5
local START_AP = 3

-- Fonts
local fonts = {
    small = love.graphics.newFont("alagard.ttf", 16),
    medium = love.graphics.newFont("alagard.ttf", 26),
    large = love.graphics.newFont("alagard.ttf", 50)
}

-- Tile data
local tile = {
    size = TILE_SIZE,
    x = 0, y = 0,
    sprites = {}
}

for i = 1, 12 do
    tile.sprites[i] = love.graphics.newImage("sprites/tiles/marble_wall_"..i..".png")
end

-- Character factory
local function newCharacter(x, y, class, team, stats)
    local spriteSheet = love.graphics.newImage("sprites/chars/"..class..".png")
    local grid = anim8.newGrid(16, 16, spriteSheet:getWidth(), spriteSheet:getHeight())
    return {
        x = x, y = y,
        hp = stats.hp or MAX_HP,
        pwr = stats.pwr,
        def = stats.def,
        dex = stats.dex,
        spd = stats.spd,
        rng = stats.rng,
        team = team,
        class = class,
        spriteSheet = spriteSheet,
        anim = anim8.newAnimation(grid("1-2", 1), 1),
        isSelected = false
    }
end

-- Example team setup
local characters = {
    newCharacter(2, 4, "ninja", 0, {hp=25, pwr=8, def=2, dex=5, spd=5, rng=1}),
    newCharacter(11, 7, "black_mage", 1, {hp=25, pwr=10, def=1, dex=2, spd=2, rng=5})
}

-- Game state
local game = {
    turn = 1,
    ap = {START_AP, START_AP},
    remaining = {6, 6},
    over = false
}

-- Helpers
local function endTurn()
    local currentTeam = (game.turn % 2) + 1
    game.ap[currentTeam] = START_AP
    game.turn = game.turn + 1
end

local function performAttack(attacker, defender)
    local hitChance = attacker.dex * 8 + 60
    local evadeChance = defender.dex * 5
    if love.math.random(100) < hitChance and love.math.random(100) > evadeChance then
        local damage = math.max(0, attacker.pwr - defender.def)
        defender.hp = defender.hp - damage
        return damage
    else
        return "miss"
    end
end

-- Update
function inGame.update(dt)
    for _, c in ipairs(characters) do
        c.anim:update(dt)
    end
    Timer.update(dt)
end

-- Draw
function inGame.draw()
    -- break into helpers for clarity
    drawMap()
    drawCharacters()
    drawUI()
end

-- Mouse handling
function inGame.mousepressed(x, y, button)
    if button == 1 then
        handleLeftClick(x, y)
    elseif button == 2 then
        handleRightClick()
    end
end

return inGame