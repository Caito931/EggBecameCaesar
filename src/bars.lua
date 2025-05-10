-- bars.lua

Bars = {}

function Bars:load()
    self.player_ph = Assets.player_ph
    self.health_ph = Assets.health_ph
    self.ammo_ph = Assets.ammo_ph
    self.fuel_ph = Assets.fuel_ph

    -- Jogador PH
    self.pph_x = 0
    self.pph_y = 0
    self.pph_width = self.player_ph:getWidth()
    self.pph_height = self.player_ph:getHeight()
end

function Bars:draw()
    self:handle()
end

function Bars:handle()
    -- Vida Munição Combustível
    local font = love.graphics.newFont(48)
    love.graphics.setFont(font)
    love.graphics.draw(self.player_ph, self.pph_x, self.pph_y)

    --------------------------------------------------------------
    -- Atrás
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.pph_x + self.pph_width, 5, 200, 50)
    -- Vida
    if Egg.health > 0 then
        --for i = 1, 10, 1 do
            --love.graphics.setColor(i * 10 / 255, i * 20 / 255, i * 10 / 255)
            --love.graphics.rectangle("fill", 0 + i * 5, 5, Egg.health, 50)
            --love.graphics.setColor(1, 1, 1)
        --end
        love.graphics.setColor(0 / 255, 255 / 255, 0 / 255)
        love.graphics.rectangle("fill", self.pph_x + self.pph_width, 5, Egg.health * 2, 50)
    end
    love.graphics.setColor(0 / 255, 102 / 255, 0 / 255)
    --love.graphics.print("Health", self.pph_x + self.pph_width, 5)
    --------------------------------------------------------------

    --------------------------------------------------------------
    -- Atrás
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.pph_x + self.pph_width, 65, 200, 50)
    -- Munição
    if Egg.ammo > 0 then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("fill", self.pph_x + self.pph_width, 65, Egg.ammo * 2, 50)
    end
    love.graphics.setColor(230 / 255, 153 / 255, 0 / 255)
    --love.graphics.print("Ammo", self.pph_x + self.pph_width, 65)
    --------------------------------------------------------------

    --------------------------------------------------------------
    -- Atrás
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.pph_x + self.pph_width, 125, 200, 50)
    -- Combustível
    if Egg.fuel > 0 then
        love.graphics.setColor(255 / 255, 150 / 255, 0 / 255)
        love.graphics.rectangle("fill", self.pph_x + self.pph_width, 125, Egg.fuel * 2, 50)
    end
    love.graphics.setColor(100 / 255, 60 / 255, 0/ 255)
    --love.graphics.print("Fuel", self.pph_x + self.pph_width, 125)
    --------------------------------------------------------------
    
    --------------------------------------------------------------
    -- Atrás 
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 5, 200, 200, 50)
    -- Dinheiro
    if Egg.money > 0 then
        love.graphics.setColor(0 / 255, 100 / 255, 0 / 255)
        love.graphics.rectangle("fill", 5, 200, Egg.money / 50, 50)
    end
    love.graphics.setColor(0 / 255, 150 / 255, 0/ 255)
    love.graphics.print(Egg.money, 5, 200)
    --------------------------------------------------------------
    
    --------------------------------------------------------------
    -- Atrás
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", love.graphics.getWidth() - 205, 70, 200, 50)
    if shootscounts < maxshootcounts then
        -- Tempo Dobro de Dano
        love.graphics.setColor(0 / 255, 100 / 255, 0 / 255)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 205, 70, shootscounts * sc_multiplier, 50)
    else
        love.graphics.setColor(255 / 255, 255 / 255, 100 / 255)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 205, 70, shoottimer * 33.3, 50)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setNewFont(24)
    love.graphics.print("Double Damage", love.graphics.getWidth() - 205, 80)
    --------------------------------------------------------------
    love.graphics.setFont(font)
    
    love.graphics.setColor(1, 1, 1)
    if wave < maxwaves then
        love.graphics.print("Wave: " .. wave, love.graphics.getWidth() - 220, 0)
    elseif wave == maxwaves and not checkWaveFinished() then
        love.graphics.print("Wave: " .. wave, love.graphics.getWidth() - 220, 0)
    elseif wave == maxwaves and checkWaveFinished() then
        love.graphics.print("You Beat The Game!", love.graphics.getWidth() - 500, 0)
        wavefinished = true
        love.graphics.setNewFont(30)
        love.graphics.print("Press M", love.graphics.getWidth() - 350, 80)
    end

    love.graphics.setColor(1, 1, 1)
end

