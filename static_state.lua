-- static state like configurations
-- must be manually get/set data to use for UI/GameObject
-- some time what you need is just an config of object, and manually decise what/when to use the data

local states = {
    idle = {
        animation = "idle",
        animSpeed = 1.0,
    },

    walk = {
        animation = "walk",
        animSpeed = 2.0,
    },
};

local initialState = states.idle 
local currentState = initialState

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

function update(gameObject, dt)
    if isChanged then
        isChanged = false

        local animName = currentState.animation
        local animator = gameObject.animator

        animator.runAnimation(animName, currentState.animSpeed)
    end
end