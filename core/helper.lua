--!referencing mouse position to corresponding tile
function mouseHover(l, t, w, h, mx, my)
    local mx, my = love.mouse.getPosition()
    if mx > l and my > t and mx < l + w and my < t + h then
        return true
    end
end

--!check if player has enough AP
function enoughAP(a)
    if game[1] % 2 == 0 then
        if game[3] >= a then
            return true
        else
            return false
        end
    else
        if game[2] >= a then
            return true
        else
            return false
        end
    end
end

--!remove AP from player
function spendAP(a)
    if game[1] % 2 == 0 then
        game[3] = game[3] - a
    else
        game[2] = game[2]- a
    end
end

function resetGame()

    --resetting game data
    game[1], game[2], game[3], game[4], game[5] = 1, 3, 3, 6, 6
    game.over = false

    --resetting char pos and hp
    char[1][1], char[1][2], char[1][3] = 2, 4, 25
    char[2][1], char[2][2], char[2][3] = 2, 6, 25
    char[3][1], char[3][2], char[3][3] = 2, 8, 25
    char[4][1], char[4][2], char[4][3] = 1, 7, 25
    char[5][1], char[5][2], char[5][3] = 1, 5, 25
    char[6][1], char[6][2], char[6][3] = 1, 3, 25
    char[7][1], char[7][2], char[7][3] = 10, 8, 25
    char[8][1], char[8][2], char[8][3] = 10, 6, 25
    char[9][1], char[9][2], char[9][3] = 10, 4, 25
    char[10][1], char[10][2], char[10][3] = 11, 5, 25
    char[11][1], char[11][2], char[11][3] = 11, 7, 25
    char[12][1], char[12][2], char[12][3] = 11, 9, 25
    char.isSelected = false
    char.selected = false
    char.moving = false
    char.attacking = false
    char.missed = false
    char.dodged = false
    char.attacked = false
    char.damage = 0
    char.healed = false
    char.heal = 0
    s = 0
    a = 0
end