-- states/init.lua
local M = {}

local active = nil
local registry = {}

-- Load available state modules from the states/ folder
function M.setup()
    -- require known states; keep names in registry
    registry.game = require "states.game"
    registry.menu = require "states.menu"
end

-- Switch to a named state (calls load if present)
function M.switch(name, ...)
    local s = registry[name]
    if not s then
        error("Unknown state: " .. tostring(name))
    end
    active = s
    if active.load then active.load(...) end
end

-- Delegation helpers
function M.update(dt)
    if active and active.update then active.update(dt) end
end

function M.draw()
    if active and active.draw then active.draw() end
end

function M.mousepressed(x, y, button, istouch)
    if active and active.mousepressed then active.mousepressed(x, y, button, istouch) end
end

function M.keypressed(key)
    if active and active.keypressed then active.keypressed(key) end

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

return M
