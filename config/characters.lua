-- config/characters.lua
-- Define per-class sprite sheet and animations
-- Row (x in frames) = direction (1=down, 2=up, 3=left, 4=right)
-- Col (y in frames) = animation frames
-- Stats: hp  = health points
--        pwr = multiplier for action strength
--        def = points reduced from incoming damage
--        dex = multiplier for accuracy and evasion
--        spd = influences movement speed and turn order
--        rng = range of attack
return {
  ninjaDark = {
    path="assets/sprites/chars/ninjaDark/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  gladiatorBlue = {
    path="assets/sprites/chars/gladiatorBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=7, def=5, dex=2, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.025 },
    }
  },

  -- Add more classes ...
}
