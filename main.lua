function love.load()
    -- loading libraries / modules
    States = require "States.init" -- loads States/init.lua

    -- setting window/resolution info
    winWidth = 960
    winHeight = 640
    love.window.setMode(winWidth, winHeight)
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- setting game States
    States.setup()
    States.switch("menu")
end

function love.draw()

    --drawing background
    love.graphics.setBackgroundColor(.3, .4, .4)
    -- drawing current state
    if States and States.draw then States.draw() end
end

function love.update(dt)
    if States and States.update then States.update(dt) end
end

function love.mousepressed(x, y, button, istouch)
    if States and States.mousepressed then States.mousepressed(x, y, button, istouch) end
end

function love.keypressed(key)
    if States and States.keypressed then States.keypressed(key) end
end