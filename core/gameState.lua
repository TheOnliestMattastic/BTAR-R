-- core/gameState.lua
local GameState = {}
GameState.__index = GameState

function GameState.new()
    local self = setmetatable({}, GameState)

    -- turn = 1 (odd = Green, even = Red)
    self.turn = 1
    self.ap = { green = 3, red = 3 }
    self.remaining = { green = 6, red = 6 }
    self.over = false
    self.winner = nil

    return self
end

-- Whose turn is it?
function GameState:currentTeam()
    return (self.turn % 2 == 0) and "red" or "green"
end

-- Spend AP
function GameState:spendAP(amount)
    local team = self:currentTeam()
    if self.ap[team] >= amount then
        self.ap[team] = self.ap[team] - amount
        return true
    end
    return false
end

-- End turn
function GameState:endTurn()
    local team = self:currentTeam()
    self.turn = self.turn + 1
    self.ap[self:currentTeam()] = 3 -- reset AP for next team
end

-- Clamp AP (max 5)
function GameState:clampAP()
    self.ap.green = math.min(self.ap.green, 5)
    self.ap.red   = math.min(self.ap.red, 5)
end

-- Update win condition
function GameState:checkWin()
    if self.remaining.green <= 0 then
        self.over = true
        self.winner = "Red"
    elseif self.remaining.red <= 0 then
        self.over = true
        self.winner = "Green"
    end
end

return GameState