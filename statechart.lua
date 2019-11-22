-- create a state machine with a definition/configuration/description
-- they call its is state chart
-- @ref: https://statecharts.github.io

local chart = {
    initial = "idle",
    props = {
        -- no common props
    },

    states = {
        idle = {
            props = {
                animation = "idle"
            },

            inputs = {
                -- no custom inputs
            },

            events = {
                enter = function (gameObject, props, payload)
                    local animName = props.animation
                    local animator = gameObject.animator

                    animator.playAnimation(animName)
                    animator.setSpeed(1.0)
                end,

                exit = function (gameObject, props)
                    -- no thing to do, but it should be presented when have "enter" presented
                end
            }
        },

        walk = {
            props = {
                animation = "walk",
                walkSpeed = 1.0,
            },

            inputs = {
                CHANGE_SPEED = function (gameObject, props, payload)
                    local speed    = payload.animation
                    local animator = gameObject.animator

                    animator.setSpeed(speed)

                    -- new props
                    return utils.newTable(props, {
                        walkSpeed = speed
                    })
                end
            },

            events = {
                enter = function (gameObject, props, payload)
                    local animName = props.animation
                    local animator = gameObject.animator

                    animator.playAnimation(animName)
                    animator.setSpeed(props.walkSpeed)
                end,

                exit = function (gameObject, props)
                    -- no thing to do, but it should be presented when have "enter" presented
                end
            }
        }
    }
}

local stateMachine = StateMachine(gameObject, chart)

local props = stateMachine.props -- should be common props + "idle" props
local state = stateMachine.state -- should be "idle"

local transitPayload = {} -- default payload is {}, its never be nil
state.transit("walk", transitPayload)
state.input("CHANGE_SPEED", { walkSpeed = 2.0 })