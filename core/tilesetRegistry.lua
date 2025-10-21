-- core/tilesetRegistry.lua
local anim8 = require "lib/anim8"

local TilesetRegistry = {}
TilesetRegistry.__index = TilesetRegistry

local function loadImage(path)
    local img = love.graphics.newImage(path)
    img:setFilter("nearest", "nearest")
    return img
end

function TilesetRegistry.new()
    local self = setmetatable({}, TilesetRegistry)
    self.tilesets = {}
    return self
end

-- Load tilesets from config/tilesets.lua
function TilesetRegistry:loadTilesets(configModule)
    local cfg = require(configModule or "config.tilesets")
    for tag, def in pairs(cfg) do
        local image = loadImage(def.path)
        self.tilesets[tag] = {
            image  = image,
            frameW = def.frameW, 
            frameH = def.frameH,
            grid   = anim8.newGrid(def.frameW, def.frameH, image:getWidth(), image:getHeight())
        }
    end
end

-- Get tileset by tag
function TilesetRegistry:getTileset(tag)
    local entry = self.tilesets[tag]
    if not entry then return nil end
    return {
        image  = entry.image,
        frameW = entry.frameW,
        frameH = entry.frameH,
        grid   = entry.grid
    }
end

return TilesetRegistry