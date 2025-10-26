-- states/game.lua
local gameInit = require "core.gameInit"

local game = {}
local characters = {}
local charsByName = {}
local map
local state
game.selected = nil
game.message = nil

-- Initialize dependencies
local registry = gameInit.registry
local tilesets = gameInit.tilesets
local activeFX = gameInit.activeFX
local ui = gameInit.ui
local GameHelpers = gameInit.GameHelpers

gameInit.init(game, characters, state)

function game.load()
    -- Build map layout from a tileset spritesheet (use TilesetRegistry)
    -- Get the tileset (tag must match config/tilesets.lua)
    local tilesetTag = "grass"
    local tileset = tilesets:getTileset(tilesetTag)
    local CharactersConfig = gameInit.CharactersConfig
    local Character = gameInit.Character
    local GameState = gameInit.GameState
    local Map = gameInit.Map

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
    local ninjaStats = CharactersConfig.ninjaDark.stats
    local stats = {}
    for k, v in pairs(ninjaStats) do stats[k] = v end
    stats.team = 0
    local ninjaDark = Character.new("ninjaDark", 2, 4, stats)
    ninjaDark:setAnimations(registry:getCharacter("ninjaDark"))
    table.insert(characters, ninjaDark)
    charsByName.ninjaDark = ninjaDark

    local gladiatorStats = CharactersConfig.gladiatorBlue.stats
    stats = {}
    for k, v in pairs(gladiatorStats) do stats[k] = v end
    stats.team = 1
    local gladiatorBlue = Character.new("gladiatorBlue", 4, 6, stats)
    gladiatorBlue:setAnimations(registry:getCharacter("gladiatorBlue"))
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

    -- Highlight movement range for selected character --
    map:highlightMovementRange(game.selected, function(col, row) return GameHelpers.findCharacterAt(col, row) ~= nil end)

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

    local clicked = GameHelpers.findCharacterAt(col, row)

    if GameHelpers.handleSelection(clicked) then return end

    -- If clicked same as selected -> deselect
    if clicked == game.selected then
        game.selected = nil
        game.message = nil
        return
    end

    -- If clicked an ally -> select them
    if clicked and game.selected:isAllyOf(clicked) then
        game.selected = clicked
        game.message = "Selected buddy: " .. tostring(clicked.class or "unit")
        return
    end

    -- At this point, either clicked is enemy (attack target) or empty tile

    -- Move selected character to empty tile
    if not clicked then
        local dist = math.max(math.abs(col - game.selected.x), math.abs(row - game.selected.y))
        if dist <= game.selected.spd then
            game.selected:moveTo(col, row)
            game.message = "Moving to (" .. col .. ", " .. row .. ")"
        else
            game.message = "Out of movement range"
        end
        return
    end

    -- Check if selected can attack target
    local canAttack, reason = game.selected:canBasicAttack(clicked)
    if not canAttack then
        game.message = reason or "Cannot attack"
        return
    end

    -- Perform attack
    GameHelpers.performAttack(game.selected, clicked)
end





return game