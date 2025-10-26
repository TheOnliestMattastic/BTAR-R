-- core/gameInit.lua
local Character             = require "core.character"
local GameState             = require "core.gameState"
local Map                   = require "core.map"
local Combat                = require "core.combat"
local AnimationRegistry     = require "core.animationRegistry"
local TilesetRegistry       = require "core.tilesetRegistry"
local UIRegistry            = require "core.uiRegistry"
local CharactersConfig      = require "config.characters"
local GameHelpers           = require "core.gameHelpers"

local gameInit = {}

gameInit.Character = Character
gameInit.GameState = GameState
gameInit.Map = Map
gameInit.Combat = Combat
gameInit.AnimationRegistry = AnimationRegistry
gameInit.TilesetRegistry = TilesetRegistry
gameInit.UIRegistry = UIRegistry
gameInit.CharactersConfig = CharactersConfig
gameInit.GameHelpers = GameHelpers

-- Create instances
gameInit.registry = AnimationRegistry.new()
gameInit.tilesets = TilesetRegistry.new()
gameInit.activeFX = {}
gameInit.ui = UIRegistry.new()

-- Load them
gameInit.registry:loadFX()
gameInit.registry:loadCharacters()
gameInit.tilesets:loadTilesets()
gameInit.ui:loadUI()

function gameInit.init(game, characters, state)
    GameHelpers.init(characters, state, game, gameInit.registry, gameInit.activeFX, Combat)
end

return gameInit
