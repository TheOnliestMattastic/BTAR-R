-- core/uiButton.lua
local UIButton = {}
UIButton.__index = UIButton

function UIButton.new(x, y, w, h, tag, registry, callback)
    local self = setmetatable({}, UIButton)

    self.x, self.y = x, y
    self.w, self.h = w, h
    self.tag = tag              -- e.g. "button"
    self.registry = registry    -- instance of UIRegistry
    self.callback = callback    -- function to call on click

    self.state = "normal"       -- "normal", "hover", "pressed", "disabled"
    self.enabled = true

    return self
end

function UIButton:update(mx, my, isDown)
    if not self.enabled then
        self.state = "disabled"
        return
    end

    local inside = mx > self.x and mx < self.x + self.w and my > self.y and my < self.y + self.h

    if inside then
        if isDown then
            self.state = "pressed"
        else
            self.state = "hover"
        end
    else
        self.state = "normal"
    end
end

function UIButton:draw()
    local entry = self.registry:get(self.tag, self.state)
    if entry then
        love.graphics.setColor(1,1,1,1)
        local _, _, quadW, quadH = entry.quad:getViewport()
        local sx, sy = self.w / quadW, self.h / quadH
        love.graphics.draw(entry.image, entry.quad, self.x, self.y, 0, sx, sy)
    else
        -- fallback: draw a rectangle if no sprite found
        love.graphics.setColor(0.6,0.6,0.6,1)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 6, 6)
    end
end

function UIButton:mousepressed(x, y, button)
    if not self.enabled then return end
    if button == 1 and x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
        if self.callback then self.callback() end
    end
end

function UIButton:setEnabled(flag)
    self.enabled = flag
    if not flag then self.state = "disabled" end
end

return UIButton