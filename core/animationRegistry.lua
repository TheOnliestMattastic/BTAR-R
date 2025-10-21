-- core/animationRegistry.lua
local anim8 = require "lib/anim8"

local AnimationRegistry = {}
AnimationRegistry.__index = AnimationRegistry

function AnimationRegistry.new()
    local self = setmetatable({}, AnimationRegistry)
    self.fx = {}        -- attack/heal FX animations
    self.characters = {} -- character idle/walk/attack animations
    return self
end

-- Helper: load a sprite sheet and build an animation
local function loadAnim(path, frameW, frameH, frames, duration)
    local image = love.graphics.newImage(path)
    local grid  = anim8.newGrid(frameW, frameH, image:getWidth(), image:getHeight())
    local anim  = anim8.newAnimation(grid(table.unpack(frames)), duration)
    return { image=image, anim=anim }
end

-- Load FX animations (attack/heal effects)
function AnimationRegistry:loadFX()
    self.fx["slash"]  = loadAnim("assets/fx/slash.png",   64, 64, {"1-5",1}, 0.07)
    self.fx["dslash"] = loadAnim("assets/fx/dslash.png",  64, 64, {"1-5",1}, 0.07)
    self.fx["swing"]  = loadAnim("assets/fx/swing.png",   64, 64, {"1-10",1},0.07)
    self.fx["pierce"] = loadAnim("assets/fx/pierce.png",  64, 64, {"1-5",1}, 0.07)
    self.fx["fire"]   = loadAnim("assets/fx/fire.png",    64, 64, {"1-11",1},0.07)
    self.fx["heal"]   = loadAnim("assets/fx/heal.png",    64, 64, {"1-4","1-2"},0.07)
end

-- Load character animations (idle/walk/attack)
function AnimationRegistry:loadCharacters()
    local classes = {
        ninja      = { file="assets/chars/ninja.png",      fw=16, fh=16 },
        paladin    = { file="assets/chars/paladin.png",    fw=16, fh=16 },
        knight     = { file="assets/chars/knight.png",     fw=16, fh=16 },
        assassin   = { file="assets/chars/assassin.png",   fw=16, fh=16 },
        ranger     = { file="assets/chars/ranger.png",     fw=16, fh=16 },
        black_mage = { file="assets/chars/black_mage.png", fw=16, fh=16 },
        white_mage = { file="assets/chars/white_mage.png", fw=16, fh=16 },
        -- add more classes here
    }

    for class, data in pairs(classes) do
        local image = love.graphics.newImage(data.file)
        local grid  = anim8.newGrid(data.fw, data.fh, image:getWidth(), image:getHeight())

        self.characters[class] = {
            image = image,
            idle  = anim8.newAnimation(grid("1-2",1), 0.5),
            walk  = anim8.newAnimation(grid("1-4",2), 0.15),
            attack= anim8.newAnimation(grid("1-3",3), 0.1),
        }
    end
end

-- Get FX animation by tag
function AnimationRegistry:getFX(tag)
    local entry = self.fx[tag]
    if not entry then return nil end
    return { image=entry.image, anim=entry.anim:clone() }
end

-- Get character animation set by class
function AnimationRegistry:getCharacter(class)
    local entry = self.characters[class]
    if not entry then return nil end
    -- clone each anim so multiple characters can animate independently
    return {
        image  = entry.image,
        idle   = entry.idle:clone(),
        walk   = entry.walk:clone(),
        attack = entry.attack:clone(),
    }
end

return AnimationRegistry