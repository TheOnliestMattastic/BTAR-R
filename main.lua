function love.load()

    --loading libraries
    require "lib/helper"
    states = require "lib/states"

    --setting window/resolution info
    winWidth = 960
    winHeight = 640
    love.window.setMode(winWidth, winHeight)
    love.graphics.setDefaultFilter("nearest", "nearest")

    --setting game states
    states.setup()
    states.switch("menu")
end

function love.draw()

    --drawing background
    love.graphics.setBackgroundColor(.3, .4, .4)

    --drawing game states
    states.draw()
end