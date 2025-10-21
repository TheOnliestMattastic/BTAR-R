local function createCharacter(x, y, class, team, stats)
    local spriteSheet = love.graphics.newImage("sprites/chars/" .. class .. ".png")
    local grid = anim8.newGrid(16, 16, spriteSheet:getWidth(), spriteSheet:getHeight())
    local anim = anim8.newAnimation(grid("1-2", 1), 1)

    return {
        x = x,
        y = y,
        hp = stats.hp or 25,
        pwr = stats.pwr,
        def = stats.def,
        dex = stats.dex,
        spd = stats.spd,
        rng = stats.rng,
        team = team,
        class = class,
        spriteSheet = spriteSheet,
        grid = grid,
        anim = anim,
        isSelected = false,
        selected = false,
        moving = false,
        attacking = false,
        missed = false,
        dodged = false,
        attacked = false,
        damage = 0,
        healed = false,
        heal = 0
    }
end