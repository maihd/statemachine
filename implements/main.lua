local StaticState = require("StaticState")

function love.load()
    StaticState.load()
end

function love.keypressed(key, scancode)
    StaticState.keypressed(key, scancode)
end

function love.update(dt)
    StaticState.update(dt)
end

function love.draw()
    StaticState.draw()
end