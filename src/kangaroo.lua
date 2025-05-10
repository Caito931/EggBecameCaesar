-- kangaroo.lua

Kangaroo = {}

kangaroos = {}

function Kangaroo:load()
    self.sright = Assets.Kangaroo_sright
    self.sleft = Assets.Kangaroo_sleft
    self.sprite = self.sright
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.rightx = love.graphics.getWidth() + self.width
    self.leftx = 0 - self.width
    self.speed = 150
    self.randomxs = {self.rightx, self.leftx}
    self.health = 100
    self.damage = 5
    self.rotation_speed = 2
end

function Kangaroo:spawn(offx)
    local randomIndex = math.random(#self.randomxs)  
    local randomx = Kangaroo.randomxs[randomIndex]  
    local direction
    if randomIndex == 1 then
        direction = 'right'
    else
        direction = 'left'
    end
    -- Declaração do Offset X
    if randomx == Kangaroo.randomxs[1] then
        offx = offx
    elseif randomx == Kangaroo.randomxs[2] then
        offx = -offx
    end  
    kangaroo = {
        health = Kangaroo.health,
        damage = Kangaroo.damage,
        x = randomx + offx,
        y = floorheight,
        width = Kangaroo.width,
        height = Kangaroo.height,
        dx = Kangaroo.speed,
        direction = direction,
        hit = false,
    }

    table.insert(kangaroos, kangaroo)
end

function Kangaroo:update(dt)

    for i,v in pairs(kangaroos) do
        -- Movimento Em Relação Ao Jogador
        if v.x < Egg.x then
            v.x = v.x + v.dx * dt
            v.direction = "left"
        end
        if v.x > Egg.x then
            v.x = v.x - v.dx * dt
            v.direction = "right"
        end
        
        -- Colisão Entre o Canguru e A Bala
        for bi = #bullets, 1, -1 do  -- vai em reverso, optimização ¯\_(ツ)_/¯
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
            -- Dano
            v.health = v.health - bullet_damage
            local ceffectx = v.x
            if v.x < Egg.x then
                ceffectx = v.x + v.width / 2
            elseif v.x > Egg.x then
                ceffectx = v.x - v.width / 2
            end
            -- Efeitos
            CircEffect:create(0, 100, ceffectx, v.y + v.height / 2, 150, 3, {1, 0, 0}, 1, "explode")
            DEffect:create(v, bullet_damage, {1, 0, 0, 1}, '-')
            v.hit = false
        end

        -- Vida
        if v.health <= 0 then
            ACS.killedfirstenemy = true
            Coin:spawn(v, v.x, floorheight + 50)
            local rui
            if difficulty == 'hard' then
                rui = generateRUtilId(1, 3)
            else
                rui = generateRUtilId(1, 3)
            end
            local chance = difficulty == 'hard' and 0.1 or 0.2  -- 10% para difícil, 20% para fácil e normal
            if math.random() < chance then
                Util:create(v, rui, 100)
            end
            table.remove(kangaroos, i)
            love.audio.play(done)
        end
        -- Colisão Entre o Canguru e o Jogador
        if  Egg.x + Egg.width > v.x and
            Egg.x < v.x + v.width and
            Egg.y + Egg.height > v.y and
            Egg.y < v.y + v.height then
                if not Egg.infinitehealth then
                    Egg.health = Egg.health - v.damage * dt
                end
                if not egghit:isPlaying() then
                    love.audio.play(egghit)
                end
                if Egg.health <= 0 then
                    ACS.diedforK = true
                end
        end
    end
end

function Kangaroo:draw()
    -- Desenha Todos 
    for _,v in pairs(kangaroos) do
            if v.direction == "left" then
                self.sprite = self.sleft
            else
            self.sprite = self.sright
        end
        local angle  = love.timer.getTime() * self.rotation_speed*math.pi / 2.5 -- Rotate one turn per 2.5 seconds.
        love.graphics.setColor(1, 1, 1, v.health / 100)
        love.graphics.draw(self.sprite, v.x, v.y + 50, angle, 1, 1, v.width/2, v.height/2)
        love.graphics.setColor(1, 1, 1)
    end
end
