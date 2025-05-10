-- coin.lua

Coin = {}
coins = {}

function Coin:load()

    self.silver_sprite = Assets.silver_coin_sprite
    self.gold_sprite = Assets.gold_coin_sprite
    self.diamond_sprite = Assets.diamond_coin_sprite
    self.randomcoin = math.random(1, 3)

    self.silver_price = 1
    self.gold_price = 10
    self.diamond_price = 50
end

function Coin:update(dt)

    for i = #coins, 1, -1 do -- Vai Ao Contrario Para Melhor Otimização ¯\_(ツ)_/¯
        local v = coins[i]

        -- Detecção 
        if Egg.x + Egg.width > v.x and Egg.x < v.x + v.width and 
           Egg.y + Egg.height > v.y and Egg.y < v.y + v.height and not v.obtained then
           
            v.obtained = true

            -- Preços Para o Dinheiro Total
            if v.id == 1 then
                Egg.money = Egg.money + self.silver_price
                v.price = self.silver_price
            elseif v.id == 2 then
                Egg.money = Egg.money + self.gold_price
                v.price = self.gold_price
            elseif v.id == 3 then
                Egg.money = Egg.money + self.diamond_price
                v.price = self.diamond_price
            end

            -- Efeito  Do Preço Ganho
            DEffect:create(v, v.price, {0, 1, 0, 1}, '+')

            -- Som
            if math.random(1, 2) == 1 then
                love.audio.play(coin1)
            else
                love.audio.play(coin2)
            end

            -- Efeito
            CircEffect:create(0, 50, v.x + v.width / 2, v.y + v.height / 2, 150, 2.5, {1, 1, 1}, 1, "explode")

        else
            -- Animação de Pegada(Quando O Jogador Coleta)
            if v.y < v.maxheight - 1 then
                v.y = v.y + (200 * dt);
            end
            -- Animação 
            if v.y <= v.maxheight then
                v.direction = 'down'
            elseif v.y >= floorheight + v.height then 
                v.direction = 'up'
            end
            if v.direction == 'up' then
                v.y = v.y - (50 * dt)
            elseif v.direction == 'down' then
                v.y = v.y + (50 * dt)
            end
        end
        if v.obtained then
            v.alpha = v.alpha - 2 * dt
            -- Remove A Moeda
            if(v.alpha <= 0) then
                table.remove(coins, i)
            end
        end
    end
end

function Coin:draw()
    for i,v in pairs(coins) do
        if v.obtained then
            love.graphics.setColor(1, 1, 1, v.alpha)
        end
        if v.id == 1 then
            love.graphics.draw(self.silver_sprite, v.x, v.y)
        elseif v.id == 2 then
            love.graphics.draw(self.gold_sprite, v.x, v.y)
        elseif v.id == 3 then
            love.graphics.draw(self.diamond_sprite, v.x, v.y)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Coin:spawn(v, x, y)
    self.randomcoin = math.random(1, 3)
    coin = {
        width = 50,
        height = 50,
        x = x,
        y = y,
        obtained = false,
        id = self.randomcoin,
        direction = 'up',
        alpha = 1,
        price = 0,
    }
    coin.maxheight = 605
    table.insert(coins, coin)
end
