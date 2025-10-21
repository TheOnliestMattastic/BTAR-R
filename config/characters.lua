-- config/characters.lua
-- Define per-class sprite sheet and animations
-- Each animation entry: frames (anim8 syntax) + duration
return {
  ninjaDark = {
    path="assets/chars/ninja.png", frameW=16, frameH=16,
    animations = {
      idle   = { frames={"1-2", 1}, duration=0.5 },
      walk   = { frames={"1-4", 2}, duration=0.15 },
      attack = { frames={"1-3", 3}, duration=0.10 },
    }
  },

  gladiatorBlue = {
    path="assets/chars/paladin.png", frameW=16, frameH=16,
    animations = {
      idle   = { frames={"1-2", 1}, duration=0.5 },
      walk   = { frames={"1-4", 2}, duration=0.15 },
      attack = { frames={"1-3", 3}, duration=0.10 },
    }
  },

  -- Add more classes ...
}