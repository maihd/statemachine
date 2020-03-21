local Atlas = require("Atlas")
local Animation = {}

function Animation.load(atlas, frames, interval)
    local animation = {}

    animation.atlas  = atlas
    animation.frames = frames

    animation.interval = interval
    animation.timer    = 0
    animation.current  = 1
    animation.width    = atlas.quadWidth
    animation.height   = atlas.quadHeight

    return animation
end

function Animation.update(animation, dt)
    animation.timer = animation.timer + dt
    if animation.timer >= animation.interval then
        animation.timer = animation.timer - animation.interval

        animation.current = animation.current + 1
        if animation.current > #animation.frames then
            animation.current = 1
        end
    end
end

function Animation.draw(animation, x, y, r, sx, sy)
    local quadIndex = animation.frames[animation.current]

    Atlas.draw(animation.atlas, quadIndex, x, y, r, sx, sy)
end

return Animation