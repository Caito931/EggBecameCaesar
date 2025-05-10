-- shark.lua

Shark = {}
sharks = {}

function Shark:load()
    self.sprite1 = Assets.Shark_sprite1
    self.sprite2 = Assets.Shark_sprite2
    self.spritestimer = 0.5
    self.currSprite = 1
    self.maxSpriteTimer = 0.5 -- Tempo para cada sprite
    self.randomy = math.random(floorheight, 100)
end

function Shark:update(dt)
    for i = #sharks, 1, -1 do
        local v = sharks[i]

        -- Atualiza o Tempo
        if v.spritetimer > 0 then
            v.spritetimer = v.spritetimer - 1 * dt
        end

        -- Tempo Acabou
        if v.spritetimer < 0 then
            v.currSprite = v.currSprite % 2 + 1
            v.spritetimer = self.maxSpriteTimer
        end 

        -- Mudança de Sprite
        if v.currSprite == 1 then v.sprite = self.sprite1 
        elseif v.currSprite == 2 then v.sprite = self.sprite2 end

        -- Esquerda e Direita da Tela
        if v.x < 0 - v.width then
            v.direction = 'right'
            v.randomy = math.random(floorheight, 100)
            v.y = v.randomy
        end

        if v.x > love.graphics.getWidth() then
            v.randomy = math.random(floorheight, 100)
            v.direction = 'left'
            v.y = v.randomy
        end
        -- Direção
        if v.direction == 'right' then
            v.x = v.x + v.speed * dt
            v.xfactor = -1
            v.offsetx = v.width
        elseif v.direction == 'left' then
            v.x = v.x - v.speed * dt
            v.xfactor = 1
            v.offsetx = 0
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
            local ceffectx = v.x + v.width 
            -- Efeitos
            CircEffect:create(0, 100, ceffectx, v.y + v.height / 2, 150, 3, {1, 0, 0}, 1, "explode")
            DEffect:create(v, bullet_damage, {1, 0, 0, 1}, '-')
            v.hit = false
        end

        -- Vida
        if v.health <= 0 then
            ACS.killedfirstenemy = true
            Coin:spawn(v, v.x + v.width / 2, v.y)
            table.remove(sharks, i)
            love.audio.play(done)
        end

        -- Colisão Entre o Tubarão e o Jogador
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
                    ACS.diedforS = true
                end
        end
    end
end

function Shark:draw()
    for i,v in pairs(sharks) do
        love.graphics.setColor(1, 1, 1, v.health / 100)
        love.graphics.draw(v.sprite, v.x + v.offsetx, v.y, nil, v.xfactor, 1)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Shark:create(x, y)
    local shark = {
        health = 100,
        damage = 20,
        x = x,
        y= y,
        randomy = math.random(floorheight, 100),
        width = self.sprite1:getWidth(),
        height = self.sprite1:getHeight(),
        speed  = 300,
        direction = 'right',
        sprite = self.sprite1,
        spritetimer = self.spritestimer,
        currSprite = self.currSprite,
        offsetx = 0,
        xfactor = 1,
        hit = false
    }
    table.insert(sharks, shark)
end