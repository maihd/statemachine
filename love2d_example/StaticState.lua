local StaticState = {
    title = "Static state"
}

local states = {
    idle = {
        animation = "idle",
        animSpeed = 1.0,
    },

    walk = {
        animation = "walk",
        animSpeed = 1.5,
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

function StaticState.load(gameObject)
    idle(gameObject)
end

function StaticState.keypressed(gameObject, key, scancode)
    if key == "space" then
        if currentState == states.walk then
            idle(gameObject)
        elseif currentState == states.idle then
            walk(gameObject)
        end
    end
end

function StaticState.update(gameObject, dt)
    if isChanged then
        isChanged = false

        local animName = currentState.animation
        local animator = gameObject.animator

        animator:runAnimation(animName, currentState.animSpeed)
    end
end

function StaticState.draw(gameObject)
    love.graphics.print("Static state implements")
    love.graphics.print("Press SPACE to transition to " .. (currentState == states.idle and "idle" or "walk"), 0, 16)
end

return StaticState