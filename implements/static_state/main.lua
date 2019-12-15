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

local isChanged = false

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
end