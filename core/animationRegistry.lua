-- core/animationRegistry.lua
local anim8 = require "lib/anim8"

-- compatibility: Lua 5.1 has global `unpack`, 5.2+ exposes `table.unpack`
local _unpack = table and table.unpack or unpack

local AnimationRegistry = {}
AnimationRegistry.__index = AnimationRegistry

local function loadImage(path)
  local img = love.graphics.newImage(path)
  img:setFilter("nearest", "nearest")
  return img
end

local function makeAnimation(image, frameW, frameH, frames, duration)
  local grid = anim8.newGrid(frameW, frameH, image:getWidth(), image:getHeight())
  -- frames is a list like {"1-5", 1} or {"1-4", "1-2"}
  local anim = anim8.newAnimation(grid(_unpack(frames)), duration, "pauseAtEnd")
  return anim
end

function AnimationRegistry.new()
  local self = setmetatable({}, AnimationRegistry)
  self.fx = {}         -- tag -> { image, protoAnim }
  self.characters = {} -- class -> { image, proto = { idle=..., walk=..., attack=... } }
  return self
end

-- Load FX from config/fx.lua
function AnimationRegistry:loadFX(configModule)
  local cfg = require(configModule or "config.fx")
  for tag, def in pairs(cfg) do
    local image = loadImage(def.path)
    local anim  = makeAnimation(image, def.frameW, def.frameH, def.frames, def.duration)
    self.fx[tag] = { image=image, protoAnim=anim }
  end
end

-- Load character animations from config/characters.lua
function AnimationRegistry:loadCharacters(configModule)
  local cfg = require(configModule or "config.characters")
  for class, def in pairs(cfg) do
    local image = loadImage(def.path)
    local grid = anim8.newGrid(def.frameW, def.frameH, image:getWidth(), image:getHeight())
    -- Store animation definitions to create them dynamically based on direction
    self.characters[class] = { 
      image=image, 
      grid=grid,
      animDefs=def.animations 
    }
  end
end

-- Get FX clone by tag
function AnimationRegistry:getFX(tag)
  local entry = self.fx[tag]
  if not entry then return nil end
  return { image=entry.image, anim=entry.protoAnim:clone() }
end

-- Get character data by class (image, grid, animation definitions)
function AnimationRegistry:getCharacter(class)
  local entry = self.characters[class]
  if not entry then return nil end
  return { 
    image=entry.image, 
    grid=entry.grid,
    animDefs=entry.animDefs 
  }
end

return AnimationRegistry
