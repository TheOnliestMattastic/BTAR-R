-- core/uiRegistry.lua
local anim8 = require "lib/anim8"

-- compatibility: Lua 5.1 has global `unpack`, 5.2+ exposes `table.unpack`
local _unpack = table and table.unpack or unpack

local UIRegistry = {}
UIRegistry.__index = UIRegistry

local function loadImage(path)
    local img = love.graphics.newImage(path)
    img:setFilter("nearest", "nearest")
    return img
end

function UIRegistry.new()
    local self = setmetatable({}, UIRegistry)
    self.elements = {} -- tag -> { image, grid, quads }
    return self
end

-- Load UI elements from config/ui.lua
function UIRegistry:loadUI(configModule)
    local cfg = require(configModule or "config.ui")
    for tag, def in pairs(cfg) do
        local image = loadImage(def.path)
        local grid  = anim8.newGrid(def.frameW, def.frameH, image:getWidth(), image:getHeight())
        local quads = {}
        for name, coords in pairs(def.frames) do
            -- coords is {col, row}
            quads[name] = grid(_unpack(coords))[1]
        end
        self.elements[tag] = { image=image, quads=quads }
    end
end

-- Get a UI element by tag and frame name
function UIRegistry:get(tag, frameName)
    local entry = self.elements[tag]
    if not entry then return nil end
    return { image=entry.image, quad=entry.quads[frameName] }
end

return UIRegistry