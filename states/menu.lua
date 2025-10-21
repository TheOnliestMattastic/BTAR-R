local menu = {}
local font65 = love.graphics.newFont("alagard.ttf", 65)
local font95 = love.graphics.newFont("alagard.ttf", 95)

function menu.draw()

    --title
    love.graphics.setColor(.9, .9, .9, 1)
    love.graphics.setFont(font95)
    love.graphics.printf("Battle Tactics Arena", 1, winHeight * .15, winWidth, "center")

    --online button
    love.graphics.setFont(font65)
    love.graphics.setColor(.6, .6, .6, 1)
    love.graphics.rectangle("fill", winWidth * .3, winHeight * .4, winWidth * .4, winHeight * .15, 10, 10)
    love.graphics.setColor(.1, .1, .1, 1)
    love.graphics.rectangle("line", winWidth * .3, winHeight * .4, winWidth * .4, winHeight * .15, 10, 10)
    love.graphics.printf("Online", winWidth * .3, winHeight * .43, winWidth * .4, "center")

    --pass & play button
    love.graphics.setColor(.6, .6, .6, 1)
    love.graphics.rectangle("fill", winWidth * .3, winHeight * .6, winWidth * .4, winHeight * .15, 10, 10)
    love.graphics.setColor(.1, .1, .1, 1)
    love.graphics.rectangle("line", winWidth * .3, winHeight * .6, winWidth * .4, winHeight * .15, 10, 10)
    love.graphics.printf("Pass & Play", winWidth * .3, winHeight * .63, winWidth * .4, "center")

    --rules button
    love.graphics.setColor(.6, .6, .6, 1)
    love.graphics.rectangle("fill", winWidth * .3, winHeight * .8, winWidth * .4, winHeight * .15, 10, 10)
    love.graphics.setColor(.1, .1, .1, 1)
    love.graphics.rectangle("line", winWidth * .3, winHeight * .8, winWidth * .4, winHeight * .15, 10, 10)
    love.graphics.printf("Rules", winWidth * .3, winHeight * .83, winWidth * .4, "center")

    --disabling buttons
    love.graphics.setColor(.3, .3, .3, .7)
    love.graphics.rectangle("fill", winWidth * .3, winHeight * .4, winWidth * .4, winHeight * .15, 10, 10)
    --love.graphics.rectangle("fill", winWidth * .3, winHeight * .6, winWidth * .4, winHeight * .15, 10, 10)
    love.graphics.rectangle("fill", winWidth * .3, winHeight * .8, winWidth * .4, winHeight * .15, 10, 10)
end

function menu.mousepressed(x, y, button, istouch)
    if mouseHover(winWidth * .3, winHeight * .6, winWidth * .4, winHeight * .15, x, y) and button == 1 then
        states.switch("inGame")
    end
end

return menu