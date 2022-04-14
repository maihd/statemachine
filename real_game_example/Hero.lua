local Entity = require("Entity")

local Animation = require("Animation")
local Atlas = require("Atlas")
local StateChart = require("StateChart")

local Hero = class(Entity)

function Hero:ctor(defs)
    Entity.ctor(self, defs)

    if not defs then
        self.name = "Hero"
    end

    self.atlas = Atlas.load("assets/adventurer-Sheet.png", 11, 7)
    self.animation = nil
    self.animSpeed = 0

    StateChart.load(self)
end

function Hero:update(dt)
    StateChart.update(self, dt)

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
    StateChart.keypressed(self, key, scancode)
end

function Hero:runAnimation(name, speed)
    StateChart.draw(self)

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