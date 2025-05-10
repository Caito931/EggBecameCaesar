-- egg.lua

Egg = {}

function Egg:load()
    self.sprite = Assets.Egg_sprite
    self.defaut_sprite = Assets.Egg_defaut_sprite
    self.jsprite = Assets.Egg_jsprite
    self.rightsprite = Assets.Egg_rightsprite
    self.jrightsprite = Assets.Egg_jrightsprite
    self.leftsprite = Assets.Egg_leftsprite
    self.jleftsprite = Assets.Egg_jleftsprite
    self.width = self.sprite:getWidth() 
    self.height = self.sprite:getHeight() 

    self.pulse = Assets.Egg_pulse
    self.pwidth = self.pulse:getWidth()  
    self.pheight = self.pulse:getHeight()

    self.default_gun = Assets.Egg_default_gun
    self.attack_gun = Assets.Egg_attack_gun
    self.gun = Assets.Egg_gun
    self.gun_width = self.gun:getWidth()
    self.gun_height = self.gun:getHeight()
    self.shoot = false

    self.x = love.graphics.getWidth() / 2
    self.y = floorheight - self.height
    self.velY = 0
    self.speed = 200
    self.direction = 'front'
    self.gravity = 1000
    self.jumpheight = self.height * 5
    self.inair = false
    self.health = 100
    self.ammo = 100   
    self.fuel = 100
    self.money = 0
    bulletSpeed = 2000
	bullets = {}
    bullet_damage = 25 --Kangaroo.health / 4
    self.infiniteammo = false
    self.infinitehealth = false
    self.infinitefuel = false
    self.nx = self.x + (self.width / 2)
    self.ny = self.y + (self.height / 2)

    self.maxHealth = 100
    self.maxAmmo = 100
    self.maxFuel = 100

    -- JumpButton
    self.jumpbutton = love.graphics.newImage("assets/jump_button.png")
    self.jumpbutton_width = self.jumpbutton:getWidth()
    self.jumpbutton_height = self.jumpbutton:getHeight()
    self.jumpbutton_x = 10
    self.jumpbutton_y = love.graphics.getHeight() - self.jumpbutton_height * 1.2
end

function Egg:update(dt)
    self:move(dt)
    self:handleammo(dt)
    self:handlegun(dt)
    self:handleMax()
    -- Checagem de GameOver
    if self.health < 0 then
        ACS.loseagame = true
        gameover = true
    end
        -- Colisão com a Bala
        for bi = #bullets, 1, -1 do  -- vai em reverso, otimização ¯\_(ツ)_/¯ 
            local bv = bullets[bi]
            if bv.x > self.x and
               bv.x < self.x + self.width and
               bv.y > self.y and
               bv.y < self.y + self.height and bv.bType ~= 'E' then
                table.remove(bullets, bi)
                if  debug then -- Previne do Jogador de Tomar dano no Modo Debug
                    self.health = self.health
                else
                    self.health = self.health - 5
                end
                if not egghit:isPlaying() then
                    love.audio.play(egghit)
                end
                if Egg.health <= 0 then
                    ACS.diedforB = true
                end
            end
        end
    if self.health < 100 then
        ACS.hited = true
    end
    if restarted then
        ACS.hited = false
    end
end

function Egg:draw()
    --love.graphics.push()
    --love.graphics.scale(0.75, 0.75)
    --love.graphics.pop()

    -- Ovo
    love.graphics.draw(self.sprite, self.x, self.y, nil, 1, 1)

    -- Botão De Pular
    --love.graphics.draw(self.jumpbutton, self.jumpbutton_x, self.jumpbutton_y)

    -- Arma
    local gunyfactor = 1
    if mouseX < self.x then
        gunyfactor = -1
    else
        gunyfactor = 1
    end
    love.graphics.draw(self.gun, self.gun_x , self.gun_y, mangle, 1, gunyfactor, self.gun_width / 2, self.gun_height / 2)  

    love.graphics.draw(smokeps)
    love.graphics.draw(smokeps2)
end

-- Sistema de Particulas de Fumaça
smokepng = love.graphics.newImage("assets/new/smoke.png")

-- Um para cada lado do foguete
smokeps = love.graphics.newParticleSystem(smokepng, 100) -- Lembrando que 100 é o máximo de partículas que podem existir, mude se quiser
smokeps2 = love.graphics.newParticleSystem(smokepng, 100)  

-- Configuração
local function configureSmoke(ps)
    ps:setColors(1, 0.9609375, 0, 0.5, 0.83203125, 0.47116613388062, 0.15275573730469, 0.78515625, 0.7265625, 0.7265625, 0.7265625, 0.56640625, 0.43359375, 0.43359375, 0.43359375, 0.03515625)
    ps:setDirection(1.5707963705063)
    ps:setEmissionRate(40) -- 14.131490707397
    ps:setEmitterLifetime(-1) -- 1.6259033679962
    ps:setInsertMode("top")
    ps:setLinearAcceleration(-14.749563217163, 0, 11.4832239151, 0)
    ps:setLinearDamping(0, 0.00020414621394593)
    ps:setOffset(40, 40)
    ps:setParticleLifetime(1.5684961080551, 2.7177577018738)
    ps:setRadialAcceleration(36.848392486572, 0)
    ps:setRelativeRotation(false)
    ps:setRotation(0, 0)
    ps:setSizes(0.76904326677322)
    ps:setSizeVariation(0)
    ps:setSpeed(90, 100)
    ps:setSpin(6.7854218482971, -0.62851732969284)
    ps:setSpinVariation(0)
    ps:setSpread(1.3763167858124) -- 1.3763167858124
    ps:setTangentialAcceleration(0, 0)
end

-- Aplica a Configuração
configureSmoke(smokeps)
configureSmoke(smokeps2)

-- Direita
function Egg:moveR(dt)
    self.isMoving = true
    self.direction = 'right'
    self.sprite = self.rightsprite
    if self.jetpacking then
        self.x = self.x + (self.speed * 1.5) * dt
    else
        self.x = self.x + self.speed * dt
    end
end
-- Esquerda
function Egg:moveL(dt) 
    self.isMoving = true
    self.direction = 'left'
    self.sprite = self.leftsprite
    if self.jetpacking then
        self.x = self.x - (self.speed * 1.5) * dt
    else
        self.x = self.x - self.speed * dt
    end
end
-- Jetpack
function Egg:moveJetpack(dt)
    if self.fuel > 0 then
        ACS.usedjetpack = true
        self.jetpacking = true
        self.y = self.y - 200 * dt
        self.velY = 0
        if not self.infinitefuel then
            self.fuel = self.fuel - 20 * dt
        end
        if not jetpack1:isPlaying() then
            love.audio.play(jetpack1)
        end
        -- Partículas
        smokeps:setPosition(self.x, self.y + self.height)
        smokeps2:setPosition(self.x + self.width, self.y + self.height)
        smokeps:start()
        smokeps2:start()
    end
end
-- Combustível
function Egg:refuel(dt)
    if self.y >= floorheight and self.fuel < 100 then
        ACS.refuelfirsttime = true
        self.fuel = self.fuel  + 20 * dt
        if not refuel1:isPlaying() then
            love.audio.play(refuel1)
        end
    end
end

-- Movimento
function Egg:move(dt)
    if not self.jetpacking then
        smokeps:stop()
        smokeps2:stop()
    end
    smokeps:update(dt)
    smokeps2:update(dt)
    self.isMoving = false
    self.jumped = false
    self.gun_x = self.x + (self.width / 2)
    self.gun_y = self.y + (self.height / 2)

    -- Colissão com o Chão
    if self.y > floorheight then
        self.velY = 0
        self.y = floorheight
        self.inair = false
        self.speed = 200
        self.jumped = false
    end

    -- Movimento
    if love.keyboard.isDown("d") then
        self:moveR(dt)
    end
    if love.keyboard.isDown("a") then
        self:moveL(dt)
    end
    if love.keyboard.isDown("w") then
        self:jump()
    end 

    self.jetpacking = false
    -- Jetpack
    if love.keyboard.isDown("space") then
        self:moveJetpack(dt)
    else
        love.audio.stop(jetpack1)
    end
        -- Aplica Gravida Quando Está no Ar
        if self.y < floorheight then
            if self.velY == 0 then
                self.velY = -2 
            end
            self.inair = true
        end
    if love.keyboard.isDown("r") then
        self:refuel(dt)
    end

    if not self.isMoving then
        self.direction = 'front'
        self.sprite = self.defaut_sprite
    end

    if self.jetpacking and self.direction == 'front' then
        self.sprite = self.jsprite
    end
    if self.jetpacking and self.direction == 'right' then
        self.sprite = self.jrightsprite
    end
    if self.jetpacking and self.direction == 'left' then
        self.sprite = self.jleftsprite
    end
    if not self.jetpacking and self.direction == 'front' then
        self.sprite = self.defaut_sprite
    end

    -- Pulo
    if self.velY ~= 0 then
        self.y = self.y - self.velY * dt
        self.velY = self.velY - self.gravity * dt
        self.inair = true
        self.speed = 250
        self.jumped = true
        if self.y > floorheight then
            self.velY = 0
            self.y = floorheight
            self.inair = false
            self.speed = 200
            self.jumped = false
        end
    end

    -- Sair Da Tela
    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.width
    end
    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end

    -- Coice Recoil
    --if self.shoot then
        --if self.direction == 'left' or mouseX < self.x then
            --self.x = self.x + 2
        --end
        --if self.direction == 'right' or mouseX > self.x then
            --self.x = self.x - 2
        --end
    --end
end

-- CoolDown De Recarregar a Munição
function Egg:handleammo(dt)
    if self.ammo < 100 then
        if self.ammocooldown > 0 then
            self.ammocooldown = self.ammocooldown - dt
        else
            ACS.reloadfirsttime = true
            self.ammo = self.ammo + 10 * dt
        end
    end
end
-- Animação Da Arma(Galinha)
local guntimer = 0.2
function Egg:handlegun(dt)
    if self.shoot then
        self.gun = self.attack_gun
        if guntimer > 0 then
            guntimer = guntimer - dt
        end
        if guntimer <= 0 then
            self.gun = self.default_gun
            self.shoot = false
            guntimer = 0.2
        end
    end
end

-- Função de Pulo
function Egg:jump()
    if self.velY == 0 and self.y >= floorheight then
        ACS.jumpcount = ACS.jumpcount + 1
        self.velY = self.jumpheight   
        -- Som
        local randomjumpsound = math.random(1, 2)
        if randomjumpsound == 1 and not jump1:isPlaying() then
            love.audio.play(jump1)
        elseif randomjumpsound == 2 and not jump2:isPlaying() then
            love.audio.play(jump2)
        end
    end
end

-- Função de Máximo
function Egg:handleMax()
    if Egg.health > Egg.maxHealth then
        Egg.health = Egg.maxHealth
    end
    if Egg.ammo > Egg.maxAmmo then
        Egg.ammo = Egg.maxAmmo
    end
    if Egg.fuel > Egg.maxFuel then
        Egg.fuel = Egg.maxFuel
    end
end