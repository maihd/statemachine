-- BehaviourMachine is like GameObject+MonoBehaviour in Unity
-- It was hardly based on OOP
-- behaviour is easy an stateful object
-- but cannot be stateless/immutable object

local Behaviour = class("Behaviour", {
    onEnter = function ()

    end,

    onExit = function () 
    
    end,

    update = function ()

    end
})

local IdleBehaviour = class("IdleBehaviour", Behaviour)
local WalkBehaviour = class("WalkBehaviour", Behaviour)

local stateMachine = StateMachine()
stateMachine.start(IdleBehaviour())

local state = stateMachine.state -- instanceof IdleBehaviour

stateMachine.transit(WalkBehaviour())