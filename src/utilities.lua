-- utilities.lua

Util = {}

function Util:load()
    self.gascan_sprite = Assets.Util_gascan_sprite
    self.medkit_sprite = Assets.Util_medkit_sprite
    self.ammo_sprite = Assets.Util_ammo_sprite
    self.util_width = 80
    self.util_height = 80
    self.gravity = 500
    self.randomutilid = math.random(1, 3)
    self.randomchance = math.random(1, 5) 

    -- Table para Armazenar os Ultilizáveis
    utils = {}
end

function Util:update(dt)
    for i = #utils, 1, -1 do
        local v = utils[i]

        -- Prende a Ultilidade a Altura do Chão, mas se tiver obtido inicia a animação
        if v.y  <= floorheight and not v.obtained then
            v.y = v.y + v.velocity * dt
        end

        -- Detecção de Colisão
        if Egg.x + Egg.width > v.x and Egg.x < v.x + v.width and 
           Egg.y + Egg.height > v.y and Egg.y < v.y + v.height and not v.obtained then
                -- Obtido
                v.obtained = true

                local coloreffect = {1, 1, 1, 1} -- cor dependendo do tipo
                -- 1/4 Um Quarto
                if v.id == 1 then -- Gasolina
                    Egg.fuel = Egg.fuel + (100/4) 
                    coloreffect = {255 / 255, 150 / 255, 0 / 255, 1}
                end
                if v.id == 2 then -- Kit Médico
                    Egg.health = Egg.health + (100/4)
                    coloreffect = {50 / 255, 255 / 255, 0 / 255, 1}
                end
                if v.id == 3 then -- Munição
                    Egg.ammo = Egg.ammo + (100/4)
                    coloreffect = {255 / 255, 255 / 255, 0 / 255, 1}
                end
                -- Efeitos
                DEffect:create(v, 100/4, coloreffect, '+')
                CircEffect:create(0, 50, v.x + v.width / 2, v.y + v.height / 2, 150, 2.5, {coloreffect[1], coloreffect[2], coloreffect[3]}, 1, "explode")

                --if not utilsound:isPlaying() then
                    love.audio.play(utilsound)
                --end
        end
        -- Animação de Pegada
        if v.obtained then
            v.alpha = v.alpha - 2 * dt
            v.y = v.y - 50 * dt
            if v.alpha <= 0 then
                -- Remove
                table.remove(utils, i)
            end
        end
    end
end

function Util:draw()
    -- Desenha
    for i,v in pairs(utils) do
        love.graphics.setColor(1, 1, 1, v.alpha)
        love.graphics.draw(v.sprite, v.x, v.y, nil)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Util:create(v, id, value)
    local utilsprite
    if id == 1 then
        utilsprite = self.gascan_sprite
    elseif id == 2 then
        utilsprite = self.medkit_sprite
    elseif id == 3 then
        utilsprite = self.ammo_sprite
    end
    util = {
        x = v.x,
        y = floorheight - self.util_height,
        width = self.util_width,
        height = self.util_height,
        sprite = utilsprite,
        id = id,
        value = value,
        velocity = 200,
        obtained = false,
        alpha = 1,
    }
    table.insert(utils, util)
end

function generateRUtilId(min, max)
    return math.random(min, max)
end

function generateRUtilChance(min, max)
    return math.random(min, max)
end