local StaticState = {}
local Animation = require("Animation")
local Atlas = require("Atlas")

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

local states = {
    idle = {
        animation = "idle",
        animSpeed = 1.0,
    },

    walk = {
        animation = "walk",
        animSpeed = 2.0,
    },
}

local currentState = nil
local isChanged = false

function idle(gameObject)
    if currentState ~= states.idle then
        currentState = states.idle
        isChanged = true
    end
end

function walk(gameObject)
    if currentState ~= states.walk then
        currentState = states.walk
        isChanged = true
    end
end

function StaticState.load()
    idle(gameObject)
end

function StaticState.keypressed(key)
    if key == "space" then
        if currentState == states.walk then
            idle(gameObject)
        elseif currentState == states.idle then
            walk(gameObject)
        end
    end
end

function StaticState.update(dt)
    if isChanged then
        isChanged = false

        local animName = currentState.animation
        local animator = gameObject.animator

        animator:runAnimation(animName, currentState.animSpeed)
    end

    Animation.update(gameObject.animator.animation, gameObject.animator.animSpeed * dt)
end

function StaticState.draw()
    love.graphics.print("Static state implements")
    love.graphics.print("Press SPACE to " .. (currentState == states.idle and "idle" or "walk"), 0, 16)

    local animation = gameObject.animator.animation
    Animation.draw(animation, love.graphics.getWidth() * 0.5 - animation.width * 0.5, love.graphics.getHeight() * 0.5 - animation.height * 0.5, 0, 1.0, 1.0)
end

return StaticState