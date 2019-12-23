local StaticState = require("StaticState")
local Animation = require("Animation")
local Atlas = require("Atlas")

local atlas = Atlas.load("assets/adventurer-Sheet.png", 11, 7)
local animation = Animation.load(atlas, { 1, 2, 3, 4 }, 0.25)

function love.keypressed(key, scancode)
    StaticState.keypressed(key, scancode)
end

function love.update(dt)
    StaticState.update(dt)
    Animation.update(animation, dt)
end

function love.draw()
    StaticState.draw()
    Animation.draw(animation, love.graphics.getWidth() * 0.5 - animation.width * 0.5, love.graphics.getHeight() * 0.5 - animation.height * 0.5, 0, 1.0, 1.0)
end