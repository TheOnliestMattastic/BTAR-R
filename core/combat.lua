-- core/combat.lua
local Combat = {}
Combat.__index = Combat

-- Customize for balance
local CONFIG = {
    maxHP = 25,
    apCostAttack = 1,
    apCostHeal   = 2,
    baseHit      = 60, -- baseline accuracy %
    dexHitScale  = 8,  -- attacker dex contribution
    dexDodgeScale= 5,  -- defender dex dodge contribution
}

-- Manhattan distance on tile grid
local function distance(ax, ay, bx, by)
    return math.abs(ax - bx) + math.abs(ay - by)
end

-- Check if target is within range
function Combat.inRange(attacker, target)
    return distance(attacker.x, attacker.y, target.x, target.y) <= attacker.rng
end

-- Resolve accuracy and evasion
-- Returns: "hit" | "miss" | "dodge"
function Combat.resolveHit(attacker, defender)
    local hitChance   = CONFIG.baseHit + attacker.dex * CONFIG.dexHitScale
    local hitRoll     = love.math.random(100)
    if hitRoll > hitChance then
        return "miss"
    end
    local dodgeChance = defender.dex * CONFIG.dexDodgeScale
    local dodgeRoll   = love.math.random(100)
    if dodgeRoll <= dodgeChance then
        return "dodge"
    end
    return "hit"
end

-- Damage formula
function Combat.computeDamage(attacker, defender)
    local raw = attacker.pwr - defender.def
    return math.max(1, raw) -- minimum 1 damage to ensure impact
end

-- Apply damage; returns final damage dealt and KO flag
function Combat.applyDamage(defender, dmg)
    defender.hp = defender.hp - dmg
    if defender.hp <= 0 then
        defender.hp = 0
        defender.alive = false
        return dmg, true
    end
    return dmg, false
end

-- Apply heal (clamped)
function Combat.applyHeal(target, amount)
    local before = target.hp
    target.hp = math.min(target.hp + amount, CONFIG.maxHP)
    return target.hp - before
end

-- Class tags for special behavior (example)
local CLASS = {
    isHealer = {
        white_mage = true,
    },
    slash = {
        ninja = true, knight = true,
    },
    bash = {
        paladin = true, dark_knight = true, battlemage = true,
    },
    projectile = {
        scout = true, marksman = true, ranger = true,
    },
    fire = {
        black_mage = true,
    },
    dual = {
        assassin = true,
    },
}

-- Pick animation tag (consumer maps tag → actual anim/sprite)
function Combat.pickAnimTag(attacker, action)
    if action == "heal" then return "heal" end
    if CLASS.fire[attacker.class] then return "fire" end
    if CLASS.projectile[attacker.class] then return "pierce" end
    if CLASS.slash[attacker.class] then return "slash" end
    if CLASS.bash[attacker.class] then return "swing" end
    if CLASS.dual[attacker.class] then return "dslash" end
    return "slash"
end

-- Attempt a heal (same-team, in range). Returns a result table.
function Combat.heal(attacker, target, state)
    if attacker.team ~= target.team then
        return { ok=false, reason="wrong_team" }
    end
    if not Combat.inRange(attacker, target) then
        return { ok=false, reason="out_of_range" }
    end
    if not state:spendAP(CONFIG.apCostHeal) then
        return { ok=false, reason="not_enough_ap" }
    end
    local healed = Combat.applyHeal(target, attacker.pwr)
    local animTag = Combat.pickAnimTag(attacker, "heal")
    return {
        ok=true, type="heal", healed=healed, target=target, attacker=attacker, animTag=animTag,
    }
end

-- Attempt an attack (enemy, in range). Returns a result table.
function Combat.attack(attacker, defender, state)
    if attacker.team == defender.team then
        return { ok=false, reason="same_team" }
    end
    if not Combat.inRange(attacker, defender) then
        return { ok=false, reason="out_of_range" }
    end
    if not state:spendAP(CONFIG.apCostAttack) then
        return { ok=false, reason="not_enough_ap" }
    end

    local outcome = Combat.resolveHit(attacker, defender)
    local animTag = Combat.pickAnimTag(attacker, "attack")

    if outcome == "miss" then
        return { ok=true, type="attack", result="miss", attacker=attacker, defender=defender, animTag=animTag }
    elseif outcome == "dodge" then
        return { ok=true, type="attack", result="dodge", attacker=attacker, defender=defender, animTag=animTag }
    else
        local dmg = Combat.computeDamage(attacker, defender)
        local dealt, ko = Combat.applyDamage(defender, dmg)
        return {
        ok=true, type="attack", result="hit", damage=dealt, ko=ko,
        attacker=attacker, defender=defender, animTag=animTag,
    }
    end
end

return Combat