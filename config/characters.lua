-- config/characters.lua
-- Define per-class sprite sheet and animations
-- Each animation entry: frames (anim8 syntax) + duration
return {
  ninjaDark = {
    path="assets/sprites/chars/NinjaDark/SpriteSheet.png", frameW=16, frameH=16,
    animations = {
      idle   = { frames={1, 1}, duration=1 },
      walk   = { frames={1, "1-4"}, duration=0.15 },
      attack = { frames={1, 5}, duration=0.10 },
    }
  },

  gladiatorBlue = {
    path="assets/sprites/chars/GladiatorBlue/SpriteSheet.png", frameW=16, frameH=16,
    animations = {
      idle   = { frames={1, 1}, duration=1 },
      walk   = { frames={1, "1-4"}, duration=0.15 },
      attack = { frames={1, 5}, duration=0.10 },
    }
  },

  -- Add more classes ...
}