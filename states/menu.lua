local UIRegistry = require "core.uiRegistry"
local UIButton   = require "core.uiButton"

local menu = {}
local registry = UIRegistry.new()
registry:loadUI()

local buttons = {}

function menu.load()
    table.insert(buttons, UIButton.new(winWidth*0.3, winHeight*0.6, winWidth*0.4, winHeight*0.15, "button", registry, function()
        States.switch("game")
    end))
end

function menu.update(dt)
    local mx, my = love.mouse.getPosition()
    local isDown = love.mouse.isDown(1)
    for _, btn in ipairs(buttons) do
        btn:update(mx, my, isDown)
    end
end

function menu.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("Battle Tactics Arena", 0, winHeight*0.15, winWidth, "center")

    for _, btn in ipairs(buttons) do
        btn:draw()
    end
end

function menu.mousepressed(x, y, button)
    for _, btn in ipairs(buttons) do
        btn:mousepressed(x, y, button)
    end
end

return menu