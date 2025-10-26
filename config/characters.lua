-- config/characters.lua
-- Define per-class sprite sheet and animations
-- Row (x in frames) = direction (1=down, 2=up, 3=left, 4=right)
-- Col (y in frames) = animation frames
return {
  ninjaDark = {
    path="assets/sprites/chars/ninjaDark/SpriteSheet.png", frameW=16, frameH=16,
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.025 },
    }
  },

  gladiatorBlue = {
    path="assets/sprites/chars/gladiatorBlue/SpriteSheet.png", frameW=16, frameH=16,
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.025 },
    }
  },

  -- Add more classes ...
}