-- core/gameHelpers.lua
local GameHelpers = {}

local characters, state, game, registry, activeFX, Combat

function GameHelpers.init(chars, st, g, reg, fx, comb)
    characters = chars
    state = st
    game = g
    registry = reg
    activeFX = fx
    Combat = comb
end

function GameHelpers.findCharacterAt(col, row)
    for _, character in ipairs(characters) do
        if character.x == col and character.y == row and character.alive ~= false then
            return character
        end
    end
    return nil
end

function GameHelpers.removeCharacter(target)
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

function GameHelpers.handleSelection(clicked)
    if not game.selected then
        if clicked then
            game.selected = clicked
            game.message = "Selected: " .. tostring(clicked.class or "unit")
        else
            game.message = nil
        end
        return true
    end
    return false
end

function GameHelpers.performAttack(attacker, defender)
    local res = Combat.attack(attacker, defender, state)
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
                GameHelpers.removeCharacter(res.defender)
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

return GameHelpers
