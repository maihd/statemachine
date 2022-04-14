local Entity = class()

function Entity:ctor(defs)
    if defs then
        self.x, self.y = defs.x, defs.y
        self.w, self.h = defs.width, defs.height
        self.visible = defs.visible
        self.name = defs.identifier or "Entity"
    else
        self.x, self.y = 0, 0
        self.w, self.h = 0, 0
        self.visible = true
        self.name = "Entity"
    end
end

function Entity:runAnimation(name, speed)

end

return Entity