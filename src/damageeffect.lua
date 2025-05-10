-- damageeffect.lua

DEffect = {}
deffects = {}

function DEffect:load()
end

function DEffect:update(dt)
    for i,v in pairs(deffects) do
        if v.timer > 0 then
            v.timer = v.timer - dt
            v.y = v.y - 2
            v.color[4] = v.color[4] - 0.05
        end
        if v.timer <= 0 then
            v.finished = true
        end
        if v.finished then
            table.remove(deffects, i)
        end
    end
end

function DEffect:draw()
    -- Desenha O Efeito
    for i,v in pairs(deffects) do
        love.graphics.print({v.color, v.sign ..  v.text}, v.x, v.y)
    end
end

function DEffect:create(v, value, color, sign)
    deffect = {
        x = v.x,
        y = v.y + 20,
        text = value,
        timer = 0.5,
        finished = false,
        color = color,
        sign = sign,
    }
    table.insert(deffects, deffect)
end