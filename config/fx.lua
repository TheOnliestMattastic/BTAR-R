-- config/fx.lua
-- Each entry defines: path, frameW/H, frames (anim8 syntax), duration
return {
  slash  = { path="assets/sprites/fx/slash.png",      frameW=32, frameH=32, frames={"1-4", 1},    duration=0.07 },
  -- dslash = { path="assets/fx/dslash.png",  frameW=64, frameH=64, frames={"1-5", 1},    duration=0.07 },
  -- swing  = { path="assets/fx/swing.png",   frameW=64, frameH=64, frames={"1-10", 1},   duration=0.07 },
  -- pierce = { path="assets/fx/pierce.png",  frameW=64, frameH=64, frames={"1-5", 1},    duration=0.07 },
  -- fire   = { path="assets/fx/fire.png",    frameW=64, frameH=64, frames={"1-11", 1},   duration=0.07 },
  heal   = { path="assets/sprites/fx/heal.png",       frameW=32, frameH=32, frames={"1-5", 1},    duration=0.07 },
}