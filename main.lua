function love.load()
    -- loading libraries / modules
    states = require "states.init" -- loads states/init.lua

    -- setting window/resolution info
    winWidth = 960
    winHeight = 640
    love.window.setMode(winWidth, winHeight)
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- setting game states
    states.setup()
    states.switch("menu")
end

function love.draw()

    --drawing background
    love.graphics.setBackgroundColor(.3, .4, .4)
    -- drawing current state
    if states and states.draw then states.draw() end
end

function love.update(dt)
    if states and states.update then states.update(dt) end
end

function love.mousepressed(x, y, button, istouch)
    if states and states.mousepressed then states.mousepressed(x, y, button, istouch) end
end

function love.keypressed(key)
    if states and states.keypressed then states.keypressed(key) end
end