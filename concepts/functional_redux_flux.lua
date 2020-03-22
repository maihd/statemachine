local state = 
    nil

local listeners = 
    {}

local reducer = 
    require("./path/to/reducer")

local getState = 
    function ()
        return state
    end

local dispatch = 
    function (action)
        if type(action) == "function" then
            return action(dispatch, getState)
        elseif action and action.type then
            local oldState = getState()
            local newState = reducer(oldState, action)

            state = newState
            for _, listener in pairs(listeners) do
                listener(newState, action)
            end
            
            return action
        else
            error("action is not valid")
        end
    end

local subscribe = 
    function (listener)
        table.insert(listeners, listener)

        return function ()
            table.remove(listeners, listener)
        end
    end

local store = 
    { getState = getState
    , dispatch = dispatch
    , subscribe = subscribe
    }

-- example
store.subscribe(
    function (state, action)
        local gameObject = state.gameObject
        local animator = gameObject.animator

        if action.type == "walk" then
            animator.run("walk")
            animator.setSpeed(action.payload.speed)
        elseif action.type == "idle" then
            animator.run("idle")
            animator.setSpeed(action.payload.speed)
        end
    end)

store.dispatch(actions.idle(1.0))
store.dispatch(actions.walk(2.0))
