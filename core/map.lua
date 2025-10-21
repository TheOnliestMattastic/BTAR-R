-- core/map.lua
local Map = {}
Map.__index = Map

-- Constructor
function Map.new(tileSize, layout, tileSprites)
    local self = setmetatable({}, Map)

    self.tileSize = tileSize or 48
    self.layout = layout or {}        -- 2D array of tile indices
    self.sprites = tileSprites or {}  -- array of loaded tile images

    -- Derived properties
    self.rows = #self.layout
    self.cols = #self.layout[1] or 0
    self.width = self.cols * self.tileSize
    self.height = self.rows * self.tileSize

    return self
end

-- Draw the map
function Map:draw(mouseX, mouseY)
    for rowIndex, row in ipairs(self.layout) do
        for colIndex, tileIndex in ipairs(row) do
            local x = colIndex * self.tileSize
            local y = rowIndex * self.tileSize

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(self.sprites[tileIndex], x, y, nil, 1.5)

            -- Highlight hovered tile
            if self:isHovered(x, y, mouseX, mouseY) then
                love.graphics.setColor(1, 1, 1, 0.6)
                love.graphics.rectangle("fill", x, y, self.tileSize, self.tileSize)
                self.hoveredTile = {colIndex, rowIndex}
            end
        end
    end
end

-- Check if mouse is over a tile
function Map:isHovered(x, y, mouseX, mouseY)
    return mouseX > x and mouseX < x + self.tileSize
       and mouseY > y and mouseY < y + self.tileSize
end

-- Get tile coordinates under mouse
function Map:getHoveredTile()
    return self.hoveredTile
end

-- Utility: is a tile inside the map?
function Map:isInside(col, row)
    return col >= 1 and col <= self.cols and row >= 1 and row <= self.rows
end

return Map