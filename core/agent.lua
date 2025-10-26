-- core/agent.lua
-- AI Agent for controlling characters in BTAR-R

local Combat = require "core.combat"

local Agent = {}
Agent.__index = Agent

-- Constructor
function Agent.new(team, difficulty)
    local self = setmetatable({}, Agent)
    
    self.team = team -- 0 = green, 1 = red
    self.difficulty = difficulty or "normal" -- "easy", "normal", "hard"
    self.thinkTimer = 0
    self.thinkDelay = 0.5 -- seconds between actions
    self.enabled = true
    
    return self
end

-- Manhattan distance helper
local function distance(ax, ay, bx, by)
    return math.abs(ax - bx) + math.abs(ay - by)
end

-- Find all characters on a specific team
local function getTeamCharacters(characters, team)
    local result = {}
    for _, char in ipairs(characters) do
        if char.alive and char.team == team then
            table.insert(result, char)
        end
    end
    return result
end

-- Find all enemy characters
local function getEnemyCharacters(characters, team)
    local result = {}
    for _, char in ipairs(characters) do
        if char.alive and char.team ~= team then
            table.insert(result, char)
        end
    end
    return result
end

-- Find the closest enemy to a character
local function findClosestEnemy(character, enemies)
    local closest = nil
    local minDist = math.huge
    
    for _, enemy in ipairs(enemies) do
        local dist = distance(character.x, character.y, enemy.x, enemy.y)
        if dist < minDist then
            minDist = dist
            closest = enemy
        end
    end
    
    return closest, minDist
end

-- Find the most damaged ally (for healing)
local function findMostDamagedAlly(character, allies, maxHP)
    local mostDamaged = nil
    local lowestHP = maxHP or 25
    
    for _, ally in ipairs(allies) do
        if ally ~= character and ally.hp < lowestHP then
            lowestHP = ally.hp
            mostDamaged = ally
        end
    end
    
    return mostDamaged
end

-- Evaluate threat level of an enemy
local function evaluateThreat(enemy)
    -- Higher power and closer proximity = higher threat
    return enemy.pwr * 10 + (25 - enemy.hp)
end

-- Choose best target based on difficulty
local function chooseBestTarget(character, enemies, difficulty)
    if #enemies == 0 then return nil end
    
    if difficulty == "easy" then
        -- Easy: random targeting
        return enemies[math.random(1, #enemies)]
    elseif difficulty == "hard" then
        -- Hard: prioritize weak targets or high-threat targets
        local bestTarget = nil
        local bestScore = -math.huge
        
        for _, enemy in ipairs(enemies) do
            local dist = distance(character.x, character.y, enemy.x, enemy.y)
            local inRange = dist <= character.rng
            
            -- Score: prioritize low HP enemies in range, then high threat
            local score = 0
            if inRange then score = score + 50 end
            score = score + (25 - enemy.hp) * 3 -- prefer weak targets
            score = score - dist * 2 -- prefer close targets
            
            if score > bestScore then
                bestScore = score
                bestTarget = enemy
            end
        end
        
        return bestTarget
    else
        -- Normal: closest enemy
        return findClosestEnemy(character, enemies)
    end
end

-- Decide if character should heal instead of attack
local function shouldHeal(character, allies, state, maxHP)
    if not character.isHealer then return false, nil end
    if state.ap[state:currentTeam()] < 2 then return false, nil end
    
    local target = findMostDamagedAlly(character, allies, maxHP)
    if target and target.hp < (maxHP or 25) * 0.6 then
        -- Heal if ally is below 60% HP and in range
        if distance(character.x, character.y, target.x, target.y) <= character.rng then
            return true, target
        end
    end
    
    return false, nil
end

-- Execute an agent turn action
function Agent:executeAction(character, characters, state, removeCharacterFn, activeFXTable, fxRegistry)
    if not self.enabled or not character.alive then return nil end
    
    local allies = getTeamCharacters(characters, self.team)
    local enemies = getEnemyCharacters(characters, self.team)
    
    if #enemies == 0 then
        return { ok = false, reason = "no_enemies" }
    end
    
    -- Check if should heal
    local shouldDoHeal, healTarget = shouldHeal(character, allies, state, 25)
    if shouldDoHeal and healTarget then
        local result = Combat.heal(character, healTarget, state)
        
        if result.ok and result.animTag and fxRegistry then
            local fx = fxRegistry:getFX(result.animTag)
            if fx then
                fx.anim:gotoFrame(1)
                table.insert(activeFXTable, {
                    fx = fx, 
                    x = healTarget.x, 
                    y = healTarget.y
                })
            end
        end
        
        return result
    end
    
    -- Otherwise, attack
    local target = chooseBestTarget(character, enemies, self.difficulty)
    if not target then
        return { ok = false, reason = "no_valid_target" }
    end
    
    local result = Combat.attack(character, target, state)
    
    if result.ok then
        -- Handle FX
        if result.animTag and fxRegistry then
            local fx = fxRegistry:getFX(result.animTag)
            if fx then
                fx.anim:gotoFrame(1)
                table.insert(activeFXTable, {
                    fx = fx, 
                    x = target.x, 
                    y = target.y
                })
            end
        end
        
        -- Handle KO
        if result.ko and removeCharacterFn then
            removeCharacterFn(target)
        end
    end
    
    return result
end

-- Update agent AI (call each frame)
function Agent:update(dt, characters, state, removeCharacterFn, activeFXTable, fxRegistry)
    if not self.enabled then return end
    
    -- Check if it's this agent's turn
    local currentTeam = state:currentTeam()
    if (currentTeam == "green" and self.team ~= 0) or 
       (currentTeam == "red" and self.team ~= 1) then
        return
    end
    
    -- Check if game is over
    if state.over then return end
    
    -- Update think timer
    self.thinkTimer = self.thinkTimer + dt
    
    if self.thinkTimer >= self.thinkDelay then
        self.thinkTimer = 0
        
        -- Check if we have AP to act
        if state.ap[currentTeam] > 0 then
            -- Find a character on our team to act
            local teamChars = getTeamCharacters(characters, self.team)
            
            if #teamChars > 0 then
                -- Pick a random character to act (or prioritize based on difficulty)
                local actor = teamChars[math.random(1, #teamChars)]
                
                local result = self:executeAction(
                    actor, 
                    characters, 
                    state, 
                    removeCharacterFn, 
                    activeFXTable, 
                    fxRegistry
                )
                
                -- Optional: log result for debugging
                if result and not result.ok then
                    print("Agent action failed: " .. (result.reason or "unknown"))
                end
            end
        else
            -- No AP left, end turn
            state:endTurn()
            self.thinkTimer = -1 -- delay before next turn starts
        end
    end
end

-- Toggle agent on/off
function Agent:toggle()
    self.enabled = not self.enabled
end

-- Set difficulty
function Agent:setDifficulty(difficulty)
    self.difficulty = difficulty
end

return Agent
