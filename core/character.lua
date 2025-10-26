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
    self.direction = 1  -- 1=down, 2=up, 3=left, 4=right

    -- Sprites & animation
    self.spriteSheet = love.graphics.newImage("assets/sprites/chars/"..class.."/SpriteSheet.png")
    self.grid = anim8.newGrid(16, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    return self
end

function Character:update(dt)
    if self.anim then
        self.anim:update(dt)
    end
    
    -- Handle walking animation --
    if self.walkTarget then
        self.walkProgress = self.walkProgress + dt * self.walkSpeed
        if self.walkProgress >= 1 then
            -- Animation complete --
            self.x = self.walkTarget.x
            self.y = self.walkTarget.y
            self.walkTarget = nil
            self.walkStart = nil
            self.walkProgress = 0
            -- Switch back to idle with same direction
            self:setAnim("idle")
        else
            -- Interpolate position --
            local t = self.walkProgress
            self.x = self.walkStart.x + (self.walkTarget.x - self.walkStart.x) * t
            self.y = self.walkStart.y + (self.walkTarget.y - self.walkStart.y) * t
        end
    end
end

-- Draw character --
function Character:draw(tileSize)
    if not self.alive then return end
    if not self.anim or not self.spriteSheet then return end
    love.graphics.setColor(1, 1, 1, 1)
    self.anim:draw(self.spriteSheet, self.x * tileSize, self.y * tileSize, nil, 2)
end

-- Take damage --
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

-- Move with animation
function Character:moveTo(x, y)
    self.walkTarget = {x = x, y = y}
    self.walkStart = {x = self.x, y = self.y}
    self.walkProgress = 0
    self.walkSpeed = 1  -- tiles per second
    
    -- Calculate direction based on movement
    local dx = x - self.x
    local dy = y - self.y
    if math.abs(dy) > math.abs(dx) then
        -- Vertical movement
        self.direction = dy > 0 and 1 or 2  -- down or up
    else
        -- Horizontal movement
        self.direction = dx > 0 and 4 or 3  -- right or left
    end
    
    -- Switch to walk animation with correct direction
    self:setAnim("walk")
end

-- Set animations from registry
function Character:setAnimations(charAnims)
    if not charAnims then return end
    if charAnims.image then
        self.spriteSheet = charAnims.image
        self.spriteImage = charAnims.image
    end
    if charAnims.grid and charAnims.animDefs then
        self.grid = charAnims.grid
        self.animDefs = charAnims.animDefs
        -- Set initial idle animation
        self:setAnim("idle")
    end
end

-- Create and set animation based on name and current direction
function Character:setAnim(animName)
    if not self.animDefs or not self.grid then return end
    local def = self.animDefs[animName]
    if not def then return end
    
    -- Build frames with direction as row, cols from definition
    self.anim = anim8.newAnimation(self.grid(self.direction, def.cols), def.duration)
end

-- Check if another character is an ally --
function Character:isAllyOf(other)
    return other and self.team == other.team
end

-- Check if this character can perform a basic attack --
function Character:canBasicAttack(target)
    if self.isHealer then
        return false, "Healer cannot perform basic attacks!"
    end
    return true
end

return Character