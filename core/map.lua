-- core/map.lua
local Map = {}
Map.__index = Map

function Map.new(tileSize, layout, tilesetRegistry, tilesetTag)
    local self = setmetatable({}, Map)

    self.tileSize = tileSize or 32
    self.layout = layout or {} -- 2D array of tile tags (strings)
    self.tileset = tilesetRegistry:getTileset(tilesetTag)

    self.rows = #self.layout
    self.cols = #self.layout[1] or 0
    self.width = self.cols * self.tileSize
    self.height = self.rows * self.tileSize

    return self
end

-- Draw the map
function Map:draw(mouseX, mouseY)
    for rowIndex, row in ipairs(self.layout) do
        for colIndex, tileTag in ipairs(row) do
            local x = (colIndex - 1) * self.tileSize
            local y = (rowIndex - 1) * self.tileSize

            -- Each tileTag corresponds to a frame in the tileset grid
            -- Example: "1,1" means column 1, row 1 in the grid
            local col, row = tileTag:match("(%d+),(%d+)")
            col, row = tonumber(col), tonumber(row)

            -- anim8's grid(col,row) returns a list of quads (frames).
            -- Use the first returned frame as the quad to draw.
            local frames = self.tileset.grid(col, row)
            local quad = nil
            if type(frames) == 'table' then quad = frames[1] end
            if quad then
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(self.tileset.image, quad, x, y)
            else
                -- fallback: draw a placeholder rectangle if quad missing
                love.graphics.setColor(1,0,1,0.5)
                love.graphics.rectangle("fill", x, y, self.tileSize, self.tileSize)
            end

            -- Highlight hovered tile
            if self:isHovered(x, y, mouseX, mouseY) then
                love.graphics.setColor(1, 1, 1, 0.4)
                love.graphics.rectangle("fill", x, y, self.tileSize, self.tileSize)
                self.hoveredTile = {colIndex, rowIndex}
            end
        end
    end
end

function Map:isHovered(x, y, mouseX, mouseY)
    return mouseX > x and mouseX < x + self.tileSize
       and mouseY > y and mouseY < y + self.tileSize
end

function Map:getHoveredTile()
    return self.hoveredTile
end

return Map