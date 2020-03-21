function StateMachine(chart)
    local states = chart.states

    local getFirstState = pairs(states)
    local firstName, firstState = getFirstState(states)

    local currentState = states[chart.initial] or firstState
    local currentProps = currentState.props or chart.props
    local currentName  = chart.initial or firstName

    local function dispatch(input, ...)
        if input == "props" then
            error("invalid input: " .. input .. ", which cannot be 'props'")
        end

        local transition = currentState[input]
        local targetState = nil
        local targetProps = nil
        local action = nil

        if type(transition) == "string" then
            targetState = states[transition]
            currentName = transition
        elseif type(transition) == "table" then
            targetState = states[transition.target]
            targetProps = transition.props
            currentName = transition.target
            action = transition.action
        end 

        if targetState then
            currentState = targetState
            currentProps = targetProps or targetState.props
        end

        if type(action) == "function" then
            action(currentState, currentProps, ...)
        end

        return currentState
    end

    local function getState()
        return currentState
    end

    local function getProps()
        return currentProps
    end

    local function getName()
        return currentName
    end

    return {
        getName = getName,
        getProps = getProps,
        getState = getState,
        dispatch = dispatch,
    }
end

local chart = {
    initial = "idle",
    props = {
        animation = "",
        animSpeed = 0
    },

    states = {
        idle = {
            props = {
                animation = "idle",
                animSpeed = 1.0
            },

            WALK = { 
                target = "walk",
                action = function (state, props, gameObject) 
                    print(props.animation)
                    gameObject.animator:runAnimation(props.animation, props.animSpeed)
                end
            }
        },

        walk = {
            props = {
                animation = "walk",
                animSpeed = 1.0,
            },

            IDLE = { 
                target = "idle",
                action = function (state, props, gameObject)
                    print(props.animation)
                    gameObject.animator:runAnimation(props.animation, props.animSpeed)
                end
            }
        }
    }
}

local stateMachine = nil

local StateChart = {
    title = "State chart"
}

function StateChart.load(gameObject)
    stateMachine = StateMachine(chart)
    
    local props = stateMachine.getProps()
    gameObject.animator:runAnimation(props.animation, props.animSpeed)
end

function StateChart.keypressed(gameObject, key, scancode)
    if key == "space" then
        if stateMachine.getName() == "walk" then
            stateMachine.dispatch("IDLE", gameObject)
        elseif stateMachine.getName() == "idle" then
            stateMachine.dispatch("WALK", gameObject)
        end
    end
end

function StateChart.update(gameObject, dt)

end

function StateChart.draw(gameObject)
    love.graphics.print("State chart implements")
    love.graphics.print("Press SPACE to transition to " .. (stateMachine.getName() == "walk" and "idle" or "walk"), 0, 16)
end

return StateChart