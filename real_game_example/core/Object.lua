local Object = {}

function Object.extends(...)
    local class = {
        ctor = function (self, ...)

        end
    }
    
    local supers = { ... }
    for _, super in pairs(supers) do
        for k, v in pairs(super) do
            class[k] = v
        end
    end

    setmetatable(class, {
        __call = function (self, ...)
            local object = {}
            
            setmetatable(object, self)
            object:ctor(...)

            return object
        end
    })

    class.__index = class
    class.__super = supers[1] or Object

    return class
end

return Object
