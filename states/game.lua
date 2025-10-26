-- states/game.lua
local Character             = require "core.character"
local GameState             = require "core.gameState"
local Map                   = require "core.map"
local Combat                = require "core.combat"
local AnimationRegistry     = require "core.animationRegistry"
local TilesetRegistry       = require "core.tilesetRegistry"
local UIRegistry            = require "core.uiRegistry"

local game = {}
local characters = {}
local charsByName = {}
local map
local state
game.selected = nil
game.message = nil

-- Helpers
local function findCharacterAt(col, row)
    for _, character in ipairs(characters) do
        if character.x == col and character.y == row and character.alive ~= false then
            return character
        end
    end
    return nil
end

local function removeCharacter(target)
    for i, character in ipairs(characters) do
        if character == target then
            table.remove(characters, i)
            if target.team == 0 then
                state.remaining.green = (state.remaining.green or 1) - 1
            else
                state.remaining.red = (state.remaining.red or 1) - 1
            end
            return true
        end
    end
    return false
end
local registry = AnimationRegistry.new()
local tilesets = TilesetRegistry.new()
local activeFX = {}
local ui = UIRegistry.new()

registry:loadFX()
registry:loadCharacters()
tilesets:loadTilesets()
ui:loadUI()

function game.load()
    -- Build map layout from a tileset spritesheet (use TilesetRegistry)
    -- Get the tileset (tag must match config/tilesets.lua)
    local tilesetTag = "grass"
    local tileset = tilesets:getTileset(tilesetTag)

    -- compute how many frames (cols/rows) the tileset contains
    local atlasCols = math.floor(tileset.image:getWidth() / tileset.frameW)
    local atlasRows = math.floor(tileset.image:getHeight() / tileset.frameH)
    if atlasCols == 0 or atlasRows == 0 then
        error("Tileset has zero width or height frames. Check frameW/frameH in config/tilesets.lua for " .. tilesetTag)
        return
    end

    -- choose map size (fit to window or fixed size)
    local tileSize = 32
    local mapCols = math.floor((winWidth or 960) / tileSize)
    local mapRows = math.floor((winHeight or 640) / tileSize)

    -- seed rng once (optional)
    math.randomseed(os.time())

    -- build randomized layout where each cell is a string "col,row" matching Map expectations
    local layout = {}
    for row = 1, mapRows do
        layout[row] = {}
        for col = 1, mapCols do
            local tileCoordinates = math.random(1, atlasCols) .. "," .. math.random(1, atlasRows)
            layout[row][col] = tileCoordinates
        end
    end

    if not tileset then
        error("Tileset not found: " .. tostring(tilesetTag))
    end

     if not tileset then
        error("Tileset is nil after tilesets:getTileset()")
        return
    end

    -- Initialize map and handle potential errors
    map = Map.new(tileSize, layout, tilesets, tilesetTag)
    state = GameState.new()

    if not map then
        error("Map is nil after Map.new()")
        return
    end

    -- Create characters
    local ninjaDark = Character.new("ninjaDark", 2, 4, {hp=25, pwr=5, def=2, dex=5, spd=4, rng=2, team=0})
    local charAnims = registry:getCharacter("ninjaDark")
    if charAnims and charAnims.image and charAnims.animations and charAnims.animations.idle then
        ninjaDark.spriteSheet = charAnims.image
        ninjaDark.spriteImage = charAnims.image
        ninjaDark.anim = charAnims.animations.idle
    end
    table.insert(characters, ninjaDark)
    charsByName.ninjaDark = ninjaDark

    local gladiatorBlue = Character.new("gladiatorBlue", 4, 6, {hp=25, pwr=7, def=5, dex=2, spd=2, rng=1, team=1})
    local charAnims = registry:getCharacter("gladiatorBlue")
    if charAnims and charAnims.image and charAnims.animations and charAnims.animations.idle then
        gladiatorBlue.spriteSheet = charAnims.image
        gladiatorBlue.spriteImage = charAnims.image
        gladiatorBlue.anim = charAnims.animations.idle
    end
    table.insert(characters, gladiatorBlue)
    charsByName.gladiatorBlue = gladiatorBlue
    -- etc...
end

function game.update(dt)
    
    -- Check win/loss and clamp AP --
    state:clampAP()
    state:checkWin()

    -- Update char and anim --
    for _, character in ipairs(characters) do
        if character.update then pcall(character.update, character, dt) end
        if character.anim and character.anim.update then pcall(character.anim.update, character.anim, dt) end
    end

    -- Update FX--
    for _, activeEffect in ipairs(activeFX) do
        if activeEffect.fx and activeEffect.fx.anim and activeEffect.fx.anim.update then pcall(activeEffect.fx.anim.update, activeEffect.fx.anim, dt) end
    end
end

function game.draw()

    -- Draw map --
    local mx, my = love.mouse.getPosition()
    map:draw(mx, my)

    for _, character in ipairs(characters) do
        -- Character:draw will handle anim drawing if character has anim/sheet set
        pcall(function() character:draw(map.tileSize) end)
        -- highlight selected
        if game.selected == character then
            love.graphics.setColor(1, 1, 0, 0.5)
            love.graphics.rectangle("line", character.x * map.tileSize, character.y * map.tileSize, map.tileSize, map.tileSize)
            love.graphics.setColor(1,1,1,1)
        end
    end

    for _,activeEffect in ipairs(activeFX) do
        activeEffect.fx.anim:draw(activeEffect.fx.image, activeEffect.x * map.tileSize, activeEffect.y * map.tileSize)
    end

    -- draw message --
    if game.message then
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(game.message, 1, 1, 0, 3)
    end
end

function game.mousepressed(x, y, button)
    if state.over then return end

    if button ~= 1 then return end

    local hovered = map:getHoveredTile(x, y)
    if not hovered then return end
    local col, row = hovered[1], hovered[2]

    local clicked = findCharacterAt(col, row)

    -- If nothing selected yet --
    if not game.selected then
        if clicked then
            game.selected = clicked
            game.message = "Selected: " .. tostring(clicked.class or "unit")
        else
            game.message = nil
        end
        return
    end

    -- If clicked same as selected -> deselect --
    if clicked == game.selected then
        game.selected = nil
        game.message = nil
        return
    end

    -- If clicked an ally -> select them --
    if clicked and clicked.team == game.selected.team then
        game.selected = clicked
        game.message = "Selected buddy: " .. tostring(clicked.class or "unit")
        return
    end

    -- At this point, either clicked is enemy (attack target) or empty tile --
   
    -- Move selected character to empty tile --
    if not clicked then
        
        game.selected.x = col
        game.selected.y = row
        game.message = "Moved to (" .. col .. ", " .. row .. ")"
        return
    end

    -- Prevent healer (class containing 'white_mage' or tag you use) from basic attacks
    if game.selected.isHealer then
        game.message = "Healer cannot perform basic attacks!" 
        return
    end

    -- Perform attack using Combat and handle result
    local res = Combat.attack(game.selected, clicked, state)
    if not res then
        game.message = "No result from attack"
        return
    end

    if not res.ok then
        game.message = "Action failed: " .. tostring(res.reason or "unknown")
        return
    end

    -- Play FX if specified
    if res.animTag then
        local fx = registry:getFX(res.animTag)
        if fx then
            fx.anim:gotoFrame(1)
            table.insert(activeFX, {fx=fx, x=res.defender.x, y=res.defender.y})
        end
    end

    -- Feedback messages for hit/miss/dodge
    if res.type == "attack" then
        if res.result == "hit" then
            game.message = "Hit for " .. tostring(res.damage)
            if res.ko then
                game.message = game.message .. " - KO!"
                -- remove unit and update counts
                removeCharacter(res.defender)
            end
        elseif res.result == "miss" then
            game.message = "Missed"
        elseif res.result == "dodge" then
            game.message = "Dodged"
        end
    end

    -- After action, deselect
    game.selected = nil
end





return game