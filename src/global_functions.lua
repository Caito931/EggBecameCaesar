-- global_functions.lua

-- Função de Cooldown Do Tiro
shoottimer = 6
function HandleShootTime(dt)
    if shootscounts >= maxshootcounts then
        if shoottimer > 0 then
            shoottimer = shoottimer - 1 * dt
            bullet_damage = 50
        end
        if shoottimer <= 0 then
            bullet_damage = 25
            shootscounts = 0
            shoottimer = 6
        end
    end
end
-- Função de Reiniciar
function Restart()
    restarted = true
    Transition.show = true
    gameover = false
    mmenuopen = true
    difficultuselection = true
    difficulty = nil
    Egg.health = 100
    Egg.ammo = 100
    Egg.fuel = 100
    Egg.money = 0
    bullet_damage = 25
    Egg.x = love.graphics.getWidth() / 2
    kangaroos = {}
    sharks = {}
    bananas = {}
    bullets = {}
    wave = 1
    numberofkangaroos = 1
    numberofsharks = 1
    numberofbananas = 0
    coins = {}
    shootscounts = 0
    tips = true
    wavefinished = true
    gamefinished = false
    Kangaroo.rotation_speed = 2
    utils = {}
    deffects = {}
    circleeffects = {}
    Transition.currentscene = 1
    smokeps:reset()
    smokeps2:reset()
end

-- Função de Atirar
function Shoot(x, y, x2, y2, width, height, bSpeed, sprite)
    if not mmenuopen then
        ACS.shootcount = ACS.shootcount + 1
        if Egg.ammo > 0 then

            -- Tipo Jogador E ou Banana B
            local bType 
            if sprite == Banana.bullet_sprite then
                bType = 'B'
            else
                bType = 'E'
                Egg.shoot = true
                Egg.ammocooldown = 2
            end

            if not Egg.infiniteammo and bType ~= 'B' then
                Egg.ammo = Egg.ammo - 1
            end
            local startX = x + width / 2
            local startY = y + height / 2
            local mousex = mouseX
            local mousey = mouseY
            local kx
            local ky

            local angle
            
            if #kangaroos > 0 and gamepadshoot then
                for i, v in pairs(kangaroos) do
                    kx = v.x + v.width / 2
                    ky = v.y + v.height / 2
                end
                angle = math.atan2((ky - startY), (kx - startX))
            else
                angle = math.atan2((y2 - startY), (x2 - startX))
            end
            
            local bulletDx = bSpeed * math.cos(angle)
            local bulletDy = bSpeed * math.sin(angle)

            bullet = {
                x = startX,
                y = startY,
                dx = bulletDx,
                dy = bulletDy,
                angle = angle,
                width = Egg.pulse:getWidth(),
                height = Egg.pulse:getHeight(),
                alpha = 0,
                sprite = sprite,
                bType = bType,
            }
            
            table.insert(bullets, bullet)
            CircEffect:create(0, 100, x+width/2, y+height/2, 150, 3, {1, 1, 1}, 1, "explode")
            --CircEffect:create(0, 100, ceffectx, v.y + v.height / 2, 150, 3, {1, 0, 0}, 1, "explode")

            shoot1:setVolume(1.0)

            -- Audio
            local randomsound = math.random(1, 2)
            if randomsound == 1 then
                --love.audio.play(shoot1)
                shoot1:play()
            else
                shoot2:play()
            end
        end
    end
end
Bullet = {}
function Bullet:update(dt)
    mangle = math.atan2((mouseY - Egg.x + Egg.width / 2), (mouseX - Egg.y + Egg.height / 2))
    -- Atualiza a Posição Do Pulso
    for i,v in ipairs(bullets) do
        v.x = v.x + (v.dx * dt)
        v.y = v.y + (v.dy * dt)
        if v.alpha < 1 then
            v.alpha = v.alpha + 4 * dt
        end
    end
    -- Remove o Pulso
    for i,v in pairs(bullets) do
        if v.x < 0 or v.x > love.graphics.getWidth() or v.y >= floorheight + 100 then
            table.remove(bullets, i)
        end
    end
end
function Bullet:draw()
    for i,v in ipairs(bullets) do
        local angle
        love.graphics.push()
        love.graphics.setColor(1, 1, 1, v.alpha)
        -- Gira se For Uma Banana
        if v.sprite == Banana.bullet_sprite then
            angle = love.timer.getTime() * 2*math.pi / 1
        else
            angle = v.angle
        end
        love.graphics.draw(v.sprite, v.x, v.y, angle, 1, v.alpha, Egg.pwidth / 2, Egg.pheight / 2)
        --love.graphics.draw(drawable (Drawable), x (number), y (number), r (number), sx (number), sy (number), ox (number), oy (number), kx (number), ky (number))
        love.graphics.setColor(1, 1, 1)
        love.graphics.pop()
	end
end

function love.quit()
    saveToFile({wins, loses}, "gamedata.txt")
end

-- Ativar Nova Arte/Estilo
function EnableNewArt()
    newart = not newart
    if newart then
        Egg.sprite = love.graphics.newImage("assets/new/egg.png")
        Egg.defaut_sprite = love.graphics.newImage("assets/new/egg.png")
        Egg.jsprite = love.graphics.newImage("assets/new/egg_jetpack_active.png")
        Egg.rightsprite = love.graphics.newImage("assets/new/egg_right.png")
        Egg.jrightsprite = love.graphics.newImage("assets/new/egg_right_jetpack.png")
        Egg.leftsprite = love.graphics.newImage("assets/new/egg_left.png")
        Egg.jleftsprite = love.graphics.newImage("assets/new/egg_left_jetpack.png")
        Egg.pulse = love.graphics.newImage("assets/pulse.png")
        Egg.default_nyan = love.graphics.newImage("assets/nyan_cat.png")
        Egg.attack_nyan = love.graphics.newImage("assets/nyan_cat_attack.png")
        Egg.nyan = love.graphics.newImage("assets/nyan_cat.png")
        Coin.silver_sprite = love.graphics.newImage("assets/new/silver_coin.png")
        Coin.gold_sprite = love.graphics.newImage("assets/new/gold_coin.png")
        Coin.diamond_sprite = love.graphics.newImage("assets/new/diamond.png")
        Background.background = love.graphics.newImage("assets/new/background.png")
        MainMenu.sprite = love.graphics.newImage("assets/new/menu_background.png")
        Kangaroo.sright = love.graphics.newImage("assets/new/kangaroo_right.png")
        Kangaroo.sleft = love.graphics.newImage("assets/new/kangaroo_left.png")
        Kangaroo.sprite = Kangaroo.sright
    elseif not newart then
        Egg.sprite = love.graphics.newImage("assets/egg.png")
        Egg.defaut_sprite = love.graphics.newImage("assets/egg.png")
        Egg.jsprite = love.graphics.newImage("assets/egg_jetpack_active.png")
        Egg.rightsprite = love.graphics.newImage("assets/egg_right.png")
        Egg.jrightsprite = love.graphics.newImage("assets/egg_right_jetpack.png")
        Egg.leftsprite = love.graphics.newImage("assets/egg_left.png")
        Egg.jleftsprite = love.graphics.newImage("assets/egg_left_jetpack.png")
        Egg.pulse = love.graphics.newImage("assets/pulse.png")
        Egg.default_nyan = love.graphics.newImage("assets/nyan_cat.png")
        Egg.attack_nyan = love.graphics.newImage("assets/nyan_cat_attack.png")
        Egg.nyan = love.graphics.newImage("assets/nyan_cat.png")
        Background.background = love.graphics.newImage("assets/background.png")
        MainMenu.sprite = love.graphics.newImage("assets/menu_background.png")
        Kangaroo.sright = love.graphics.newImage("assets/kangaroo_right.png")
        Kangaroo.sleft = love.graphics.newImage("assets/kangaroo_left.png")
        Kangaroo.sprite = Kangaroo.sprite
    end
end