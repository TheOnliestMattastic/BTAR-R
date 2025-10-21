-- states/game.lua
local Character             = require "core.character"
local GameState             = require "core.gameState"
local Map                   = require "core.map"
local Combat                = require "core.combat"
local AnimationRegistry     = require "core.animationRegistry"

local game = {}
local characters = {}
local map
local state
local registry = AnimationRegistry.new()
registry:loadFX()
registry:loadCharacters()

function game.load()
    -- Load tile sprites
    local tileSprites = {}
    -- for i = 1, 12 do
    --     table.insert(tileSprites, love.graphics.newImage("sprites/tiles/marble_wall_"..i..".png"))
    -- end

    -- Map layout


    map = Map.new(32, layout, tileSprites)
    state = GameState.new()

    -- Create characters
    local charAnims = registry:getCharacter("NinjaDark")
    table.insert(characters, Character.new("NinjaDark",     2, 4, {hp=25, pwr=5, def=2, dex=5, spd=4, rng=2, team=0}))
    ninjaDark.spriteImage = charAnims.image
    ninjaDark.anim = charAnims.animations.idle
    local charAnims = registry:getCharacter("GladiatorBlue")
    table.insert(characters, Character.new("GladiatorBlue",   2, 6, {hp=25, pwr=7, def=5, dex=3, spd=2, rng=1, team=1}))
    gladiatorBlue.spriteImage = charAnims.image
    gladiatorBlue.anim = charAnims.animations.idle
    -- etc...
end

function game.update(dt)
    state:clampAP()
    state:checkWin()

    for _, c in ipairs(characters) do
        c:update(dt)
    end
    for _, e in ipairs(activeFX) do
        e.fx.anim:update(dt)
    end

    -- update char animations
    ninjaDark.animations.idle:update(dt)
    gladiatorBlue.animations.idle:update(dt)
end

function game.draw()
    local mx, my = love.mouse.getPosition()
    map:draw(mx, my)

    for _, c in ipairs(characters) do
        c:draw(map.tileSize)
    end

    for _,e in ipairs(activeFX) do
        e.fx.anim:draw(e.fx.image, e.x * tileSize, e.y * tileSize)
    end

    -- Example: draw turn indicator
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(state:currentTeam() .. "'s Turn", 20, 20)

    ninjaDark.animations.idle:draw(ninjaDark.animations.image, ninjaDark.x * tileSize, ninjaDark.y * tileSize, nil, 2)
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

    local result
    if selected and target then
        if selected.team == target.team and selected.class == "white_mage" then
            result = Combat.heal(selected, target, state)
        else
            result = Combat.attack(selected, target, state)
        end
    end

    if result and result.ok and result.animTag then
        if result.type == "heal" then
            -- play heal anim by tag
            local fx = registry:get(result.animTag)
            if fx then
                fx.anim:gotoFrame(1)
                table.insert(activeFX, {fx=fx, x=defender.x, y=defender.y})
            end

            -- show +amount floating text

        elseif result.type == "attack" then
            if result.result == "hit" then
                -- play attack anim by tag
                if fx then
                    fx.anim:gotoFrame(1)
                    table.insert(activeFX, {fx=fx, x=defender.x, y=defender.y})
                end

                -- show damage; if result.ko then update remaining counts and remove/flag unit

            elseif result.result == "miss" then
                -- show "Missed"

            elseif result.result == "dodge" then
                -- show "Dodged"

            end
        end


    else
    -- Feedback for out_of_range / not_enough_ap / wrong_team
    
    end
end

return game