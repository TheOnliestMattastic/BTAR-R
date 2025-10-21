-- core/character.lua
local anim8 = require "lib/anim8"

local Character = {}
Character.__index = Character

-- Constructor
function Character.new(class, x, y, stats)
    local self = setmetatable({}, Character)

    -- Basic identity
    self.class = class
    self.x, self.y = x, y

    -- Stats (hp, pwr, def, dex, spd, rng, alignment)
    self.hp   = stats.hp or 25
    self.pwr  = stats.pwr or 5
    self.def  = stats.def or 2
    self.dex  = stats.dex or 2
    self.spd  = stats.spd or 2
    self.rng  = stats.rng or 1
    self.team = stats.team or 0  -- 0 = green, 1 = red

    -- State flags
    self.isSelected = false
    self.alive = true

    -- Sprites & animation
    self.spriteSheet = love.graphics.newImage("sprites/chars/"..class..".png")
    self.grid = anim8.newGrid(16, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.anim = anim8.newAnimation(self.grid("1-2", 1), 0.2)

    return self
end

-- Update animation
function Character:update(dt)
    self.anim:update(dt)
end

-- Draw character
function Character:draw(tileSize)
    if not self.alive then return end
    love.graphics.setColor(1, 1, 1, 1)
    self.anim:draw(self.spriteSheet, self.x * tileSize, self.y * tileSize, nil, 3)
end

-- Take damage
function Character:takeDamage(amount)
    self.hp = self.hp - math.max(0, amount - self.def)
    if self.hp <= 0 then
        self.alive = false
    end
end

-- Heal
function Character:heal(amount, maxHP)
    self.hp = math.min(self.hp + amount, maxHP or 25)
end

-- Move
function Character:moveTo(x, y)
    self.x, self.y = x, y
end

return Character