-- circleeffect.lua

CircEffect = {}

function CircEffect:load()
    circleeffects = {}
end

function CircEffect:update(dt)
    for i = #circleeffects, 1, -1 do
        local v = circleeffects[i]
        -- Implodir e Explodir
        if v.mode == "implode" then
            v.radius = v.radius - v.speed * dt
            v.alpha = v.alpha - v.alphaspeed * dt
        elseif v.mode == "explode" then
            v.radius = v.radius + v.speed * dt
            v.alpha = v.alpha - v.alphaspeed * dt
        end
        if v.radius <= 0 and v.alpha <= 0 or v.radius >= v.maxradius and v.alpha <= 0 then
            v.dead = true
        end
        if v.dead then
            table.remove(circleeffects, i)
        end
    end
end

function CircEffect:draw()
    for i = #circleeffects, 1, -1 do
        local v = circleeffects[i]
        -- Draw the circle
        love.graphics.setColor(v.color[1], v.color[2], v.color[3], v.alpha)
        love.graphics.circle("fill", v.x, v.y, v.radius)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function CircEffect:create(radius, maxradius, x, y, speed, alphaspeed, color, alpha, mode)
    local circleeffect = { 
        radius = radius,
        maxradius = maxradius,
        x = x,
        y = y,
        speed = speed,
        alphaspeed = alphaspeed,
        color = color,  
        alpha = alpha,
        mode = mode,
        dead = false,
    }
    table.insert(circleeffects, circleeffect) 
end

return CircEffect