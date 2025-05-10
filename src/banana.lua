-- banana.lua

Banana = {}
bananas = {}

function Banana:load()
    self.sprite = Assets.banana
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.bullet_sprite = Assets.banana_bullet
end

function Banana:update(dt)
    for i = #bananas, 1, -1 do
        local v = bananas[i]
        -- Movimento
        if v.x < v.maxX and v.maxX == 25 then
            v.x = v.x + (v.speed * dt)
            v.xfactor = 1
            v.offsetx = 0
        elseif v.x > v.maxX and v.maxX == love.graphics.getWidth() - 100 then
            v.x = v.x - (v.speed * dt)
            v.xfactor = -1
            v.offsetx = v.width
        end

        -- Tempo e Atirar
        if v.ShootTimer > 0 then
            v.ShootTimer = v.ShootTimer - 1 * dt
        end
        if v.ShootTimer <= 0 then
            v.ShootTimer = v.defaultST
            -- Atira
            Shoot(v.x, v.y, Egg.x, Egg.y, v.width, v.height, 1000, self.bullet_sprite)
        end

        -- Colisão com a Bala
        for bi = #bullets, 1, -1 do  -- vai em reverso, otimização ¯\_(ツ)_/¯ 
            local bv = bullets[bi]
            if bv.x > v.x and
               bv.x < v.x + v.width and
               bv.y > v.y and
               bv.y < v.y + v.height and bv.bType ~= 'B' then
                table.remove(bullets, bi)
                v.hit = true
            end
        end

        -- Dano
        if v.hit then
            v.health = v.health - bullet_damage 
            local ceffectx = v.x+v.width/2
            -- Efeitos
            CircEffect:create(0, 100, ceffectx, v.y+v.height/2, 150, 3, {1, 0, 0}, 1, "explode")
            DEffect:create(v, bullet_damage, {1, 0, 0, 1}, '-')
            v.hit = false
        end

        -- Vida
        if v.health <= 0 then
            ACS.killedfirstenemy = true
            Coin:spawn(v, v.x + v.width / 2, v.y)
            table.remove(bananas, i)
            love.audio.play(done)
        end
    end
end

function Banana:draw()
    for i,v in pairs(bananas) do
        --local angle = math.atan2((Egg.y - v.y), (v.x - Egg.x))
        angle = 1
        love.graphics.setColor(1,1,1, v.health/100)
        love.graphics.draw(v.sprite, v.x + v.offsetx, v.y, nil, v.xfactor, 1, 1, 1)
        love.graphics.setColor(1,1,1,1)
    end
end

function Banana:create(offx, y)
    -- Posição Aleatória
    local arrmaxX = {25, love.graphics.getWidth()-100}
    local randomindex = math.random(1, 2)
    local maxX
    local x
    local ShootTimer = math.random(3, 4)

    if randomindex == 1 then
        maxX = arrmaxX[1]
        x = 0
    else
        maxX =  arrmaxX[2]
        x = love.graphics.getWidth()+50
    end
    local banana = {
        health = 100,
        x = x+offx,
        y = y,
        width = self.width,
        height = self.height,
        speed = 200,
        sprite = self.sprite,
        maxX = maxX,
        ShootTimer = ShootTimer,
        angle = 1,
        offsetx = 0,
        xfactor = 1,
        hit = false,
        defaultST = ShootTimer,
    }
    table.insert(bananas, banana)
end