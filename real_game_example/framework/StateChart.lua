local function StateChart(chart)
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

return StateChart