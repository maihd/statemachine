local StaticState = require("StaticState")
local Animation = require("Animation")

local animation = Animation.load("adventurer-Sheet.png", 7, 11, 0.1)

function love.keypressed(key, scancode)
    StaticState.keypressed(key, scancode)
end

function love.update(dt)
    StaticState.update(dt)
    Animation.update(animation, dt)
end

function love.draw()
    StaticState.draw()
    Anmation.draw(animation)
end