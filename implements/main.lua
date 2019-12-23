local Animation = require("Animation")
local Atlas = require("Atlas")

local StaticState = require("StaticState")
local StateChart  = require("StateChart")

local atlas = Atlas.load("assets/adventurer-Sheet.png", 11, 7)

local gameObject = {
    animator = {
        animation = nil,
        animSpeed = 0,

        runAnimation = function (self, name, speed)
            if name == "idle" then
                self.animation = Animation.load(atlas, { 1, 2, 3, 4 }, 0.25)
                self.animSpeed = speed
            elseif name == "walk" then
                self.animation = Animation.load(atlas, { 10, 11, 12, 13, 14 }, 0.2)
                self.animSpeed = speed
            else
                error("unknown animation: " .. name)
            end
        end
    },
}

function love.load()
    StateChart.load(gameObject)

    love.window.setTitle("StateMachine - " .. StateChart.title)
end

function love.keypressed(key, scancode)
    StateChart.keypressed(gameObject, key, scancode)
end

function love.update(dt)
    StateChart.update(gameObject, dt)

    if gameObject.animator.animation then
        Animation.update(gameObject.animator.animation, gameObject.animator.animSpeed * dt)
    end
end

function love.draw()
    StateChart.draw(gameObject)

    if gameObject.animator.animation then
        local animation = gameObject.animator.animation
        Animation.draw(animation, love.graphics.getWidth() * 0.5 - animation.width * 0.5, love.graphics.getHeight() * 0.5 - animation.height * 0.5, 0, 1.0, 1.0)
    end
end