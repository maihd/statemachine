-- Base on Qt State Machine framework
-- It like behaviour machine but have some improvement, more like a state machine
-- @ref: https://doc.qt.io/qt-5/statemachine-api.html


local alive = State();
local die = FinalState();

local idle = State(alive); -- child state of alive
local walk = State(alive); -- child state of alive

idle.addTransition(gameObject, signal("walk"), walk)
walk.addTransition(gameObject, signal("idle"), idle)

alive.setInitialState(idle)

machine.addState(alive)
machine.addState(die)
machine.setInitialState(alive)

machine.start(gameObject)

idle.on("enter", function ()
    local animator = gameObject.animator
    animator.setAnimation("idle")
    animator.setSpeed(1.0)
end)

walk.on("enter", function () 
    local animator = gameObject.animator
    animator.setAnimation("walk")
    animator.setSpeed(2.0)
end)

die.on("enter", function () 
    local animator = gameObject.animator
    animator.setAnimation("die")
    animator.setSpeed(1.0)
end)

die.on("exit", function () 
    gameObject.destroySelf()
end)