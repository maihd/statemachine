local gameObject = {
    animator = {
        runAnimation = function (name, speed)
            if name == "idle" then
                
            elseif name == "walk" then

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

local currentState = states.idle

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

function love.keypressed(key)
    if key == "space" then
        if currentState == states.walk then
            idle(gameObject)
        elseif currentState == states.idle then
            walk(gameObject)
        end
    end
end

function love.update()
    if isChanged then
        isChanged = false

        local animName = currentState.animation
        local animator = gameObject.animator

        animator.runAnimation(animName, currentState.animSpeed)
    end
end

function love.draw()
    love.graphics.print("Static state implements")
    love.graphics.print("Press SPACE to " .. (currentState == states.idle and "idle" or "walk"), 0, 16)

    
end