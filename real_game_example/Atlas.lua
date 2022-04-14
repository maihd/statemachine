local Atlas = {}

function Atlas.load(path, rows, columns)
    local atlas = {}

    atlas.image = love.graphics.newImage(path)
    atlas.quads = {}

    local w = atlas.image:getWidth() / columns
    local h = atlas.image:getHeight() / rows
    atlas.quadWidth = w
    atlas.quadHeight = h

    for i = 0, rows do 
        for j = 0, columns do
            local quad = love.graphics.newQuad(j * w, i * h, w, h, atlas.image:getDimensions())
            table.insert(atlas.quads, quad)
        end
    end

    return atlas
end

function Atlas.draw(atlas, index, x, y, r, sx, sy)
    local quad = atlas.quads[index]
    local image = atlas.image

    love.graphics.draw(image, quad, x, y, r, sx, sy)
end

return Atlas