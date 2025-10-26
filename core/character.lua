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
    self.isHealer = (class == "whiteMage" or class == "sage")

    -- Sprites & animation
    self.spriteSheet = love.graphics.newImage("assets/sprites/chars/"..class.."/SpriteSheet.png")
    self.grid = anim8.newGrid(16, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    return self
end

function Character:update(dt)
    if self.anim then
        self.anim:update(dt)
    end
    
    -- Handle walking animation
    if self.walkTarget then
        self.walkProgress = self.walkProgress + dt * self.walkSpeed
        if self.walkProgress >= 1 then
            -- Animation complete
            self.x = self.walkTarget.x
            self.y = self.walkTarget.y
            self.walkTarget = nil
            self.walkStart = nil
            self.walkProgress = 0
        else
            -- Interpolate position
            local t = self.walkProgress
            self.x = self.walkStart.x + (self.walkTarget.x - self.walkStart.x) * t
            self.y = self.walkStart.y + (self.walkTarget.y - self.walkStart.y) * t
        end
    end
end

-- Draw character
function Character:draw(tileSize)
    if not self.alive then return end
    love.graphics.setColor(1, 1, 1, 1)
    self.anim:draw(self.spriteSheet, self.x * tileSize, self.y * tileSize, nil, 2)
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