local Entity = require("Entity")

local Animation = require("Animation")
local Atlas = require("Atlas")
local StateChart = require("framework/StateChart")

local Hero = class(Entity)

function Hero:ctor(defs)
    Entity.ctor(self, defs)

    if not defs then
        self.name = "Hero"
    end

    self.atlas = Atlas.load("assets/adventurer-Sheet.png", 11, 7)
    self.animation = nil
    self.animSpeed = 0

    self.stateChart = {
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
                    action = function (state, props, entity) 
                        print(props.animation)
                        entity:runAnimation(props.animation, props.animSpeed)
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
                    action = function (state, props, entity)
                        print(props.animation)
                        entity:runAnimation(props.animation, props.animSpeed)
                    end
                }
            }
        }
    }

    self.stateMachine = StateChart(self.stateChart)
    
    local props = self.stateMachine.getProps()
    self:runAnimation(props.animation, props.animSpeed)
end

function Hero:update(dt)
    if self.animation then
        Animation.update(self.animation, self.animSpeed * dt)
    end
end

function Hero:draw()


    if self.animation then
        local animation = self.animation
        Animation.draw(animation, love.graphics.getWidth() * 0.5 - animation.width * 0.5, love.graphics.getHeight() * 0.5 - animation.height * 0.5, 0, 1.0, 1.0)
    end
end

function Hero:keypressed(key, scancode)
    if key == "space" then
        if self.stateMachine.getName() == "walk" then
            self.stateMachine.dispatch("IDLE", self)
        elseif self.stateMachine.getName() == "idle" then
            self.stateMachine.dispatch("WALK", self)
        end
    end
end

function Hero:runAnimation(name, speed)
    if name == "idle" then
        self.animation = Animation.load(self.atlas, { 1, 2, 3, 4 }, 0.25)
        self.animSpeed = speed
    elseif name == "walk" then
        self.animation = Animation.load(self.atlas, { 10, 11, 12, 13, 14 }, 0.2)
        self.animSpeed = speed
    else
        error("unknown animation: " .. name)
    end
end

return Hero