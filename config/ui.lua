-- config/ui.lua
return {
  button = {
    path   = "assets/sprites/ui/button.png",
    frameW = 16,
    frameH = 8,
    frames = {
      normal = {1,1},
      hover  = {2,1},
      disabled = {3,1},
      pressed = {4,1},
    }
  },
  panel = {
    path   = "assets/sprites/ui/panel.png",
    frameW = 16,
    frameH = 16,
    frames = {
      cell = {1,1},
      background = {2,1},
      background_dark = {3,1},
      background_alt = {4,1},
      framed = {1,2},
      framed_alt = {2,2},
      framed_dark = {3,2},
      framed_light = {4,2},
    }
  }
}