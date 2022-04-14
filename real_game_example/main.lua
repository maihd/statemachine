require "core"
require "unit_tests/tests"

--loading ldtk library
local ldtk = require 'ldtk'

--[[
    I recommend checking "Minify JSON", "Save levels to separate files"
    and "Advanced --> discard pre-CSV..." in project settings to save space
    and increase loading speed.

    You can add your tilesets' images anywhere relative to main.lua

    You have to save the LDtk project to take effect.
    You don't have to relaunch the game to get edited levels if you use separate
    files. But, You will need to relaunch or LDtk:load(file) if you add new levels or
    you have a single file.

    You may notice bleeding when moving and scaling. To fix this you have to add a border of the
    same color to every tile in the tileset then set a spacing of 2px and a padding of 1px to the
    tile in LDtk. Check LÖVE wiki to know more about bleeding and how to fix it.
    https://love2d.org/wiki/Quad
]]

local Animation = require("Animation")
local Atlas = require("Atlas")

local StateChart  = require("StateChart")

local Hero = require("Hero")

local hero = Hero()

local objects = {} --all objects are here

--object class 
local Entity = class()

function Entity:ctor(defs)
    for k, v in pairs(defs.props) do
        print(k, v)
    end

    self.x, self.y = defs.x, defs.y
    self.w, self.h = defs.width, defs.height
    self.visible = defs.visible
    self.name = defs.identifier or "Entity"
end

function Entity:draw()
    if self.visible then
        --drawing a rectangle to represent the entity
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    end
end
--

function love.load()
    --resizing the screen to 512px width and 512px height
    love.window.setMode(512, 512)

    --setting up the project for pixelart
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    --

    --loads a .ldtk file
    ldtk:load('ldtk/game.ldtk')
    ldtk:setFlipped(true) --flips the loop
                          --you may not need this if you have your own custom loop

    --[[
        This is called when an entity is created
        
        entity = {x = (int), y = (int), width = (int), height = (int), visible = (bool)
                    px = (int), py = (int), order = (int), props = (table)}
        
        px is pivot x and py is pivot y
        props contains all custom fields defined in LDtk for that entity
        remember that colors are HEX not RGB. 
        You can use ldtk ldtk.getColorHex(color) to get an RGB table like {0.21, 0.57, 0.92}
    ]]
    function ldtk.entity(entity)
        local newObject = Entity(entity) --creating new object based on the class we defined before
        table.insert(objects, newObject) --add the object to the table we use to draw
    end

    --[[
        This is called when a new layer object is created
        The given object has x, y, order, identifier, visible, color and a draw function
        layer:draw() --used to draw the layer
    ]]
    function ldtk.layer(layer) 
        table.insert(objects, layer) --adding layer to the table we use to draw 
    end

    --[[
        This is called before we create the new level.
        You may use it to remove old objects and change some settings like background color
        level = {bgColor = (table), identifier = (string), worldX  = (int), worldY = (int), 
                 width = (int), height = (int), props = (table)}
        
        props table has the custom fields defined in LDtk
    ]]
    function ldtk.onLevelLoad(level)
        objects = {} --removing all objects so we can create our new room
        love.graphics.setBackgroundColor(level.bgColor) --changing background color
    end

    --[[
        This is called after the new level is created. (after creating all layers and entities)
        You may use it to change some settings for objects or to call a function.
        level = {bgColor = (table), identifier = (string), worldX  = (int), worldY = (int), 
                 width = (int), height = (int), props = (table)}
    ]]
    function ldtk.onLevelCreated(level)
        load(level.props.create)() --here we use a string defined in LDtk as a function
    end

    --Loading the first level.
    ldtk:goTo(1)

    --[[
        You can load a level by its name
        ldtk:level('Level_0')

        You can load a level by its index (starting at 1 as the first level)
        ldtk:goTo(4) --loads the forth level
        
        You can load the next and previous levels
        ldtk:next() --loads the next level or the first if we are in the last one
        ldtk:previous() --loads the previous level or the last if we are in the first

        You can reload current level (if player loses for example)
        ldtk:reload()
    ]]

    hero = Hero()
end


-- keyboard keys switch statement for lua
-- this is much faster than if - elseif
local keys = {
    right = function ()
        ldtk:next()
    end,

    left = function ()
        ldtk:previous()
    end,

    r = function ()
        ldtk:reload()
    end
}

function love.keypressed(key, scancode)
    if keys[key] then keys[key]() end

    hero:keypressed(key, scancode)
end

function love.update(dt)
    hero:update(dt)
end

local len
function love.draw()
    love.graphics.scale(2, 2) --scalling the screen for pixelart
    
    len = #objects 
    for i = 1, len, 1 do
        objects[i]:draw() --drawing every object in order
    end

    love.graphics.scale(0.5, 0.5) --scaling for the UI
    love.graphics.print('Use left and right arrows to change the level.\nWhite squares are entities.', 10, 10)

    hero:draw()
end