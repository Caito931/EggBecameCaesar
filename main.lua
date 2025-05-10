-- main.lua

-- Copyright © 2025 Choraumm. All rights reserved.
-- This game and its source code are protected by copyright law.
-- Unauthorized use, copying, or distribution is prohibited.

function startGlobalAll()
    -- External Libraries
    anim8 = require("libraries.anim8")
    slam = require("libraries.slam")
    push = require("libraries.push")
    tween = require("libraries.tween")

    -- Requiriments
    require("src.assets")
    require("src.egg")
    require("src.background")
    require("src.mainmenu")
    require("src.bars")
    require("src.kangaroo")
    require("src.damageeffect")
    require("src.coin")
    require("src.difficulty") 
    require("src.utilities")
    require("src.circleeffect")
    require("src.pressed_functions")
    require("src.handle_waves")
    require("src.global_functions")
    require("src.transition")
    require("src.shark")
    require("src.banana")
    require("src.savesystem")
    require("src.achievements")

    -- Sounds
    shoot1 = love.audio.newSource("assets/sounds/shoot_1.mp3", "static")
    shoot2 = love.audio.newSource("assets/sounds/shoot_2.mp3", "static")
    jump1 = love.audio.newSource("assets/sounds/jump_1.mp3", "static")
    jump2 = love.audio.newSource("assets/sounds/jump_2.mp3", "static")
    jetpack1 = love.audio.newSource("assets/sounds/jetpack1.mp3", "static")
    click = love.audio.newSource("assets/sounds/click.mp3", "static")
    refuel1 = love.audio.newSource("assets/sounds/refuel.mp3", "static")
    done = love.audio.newSource("assets/sounds/done.mp3", "static")
    egghit = love.audio.newSource("assets/sounds/egg_hit.mp3", "static")
    wavesound = love.audio.newSource("assets/sounds/wave.mp3", "static")
    coin1 = love.audio.newSource("assets/sounds/coin1.mp3", "static")
    coin2 = love.audio.newSource("assets/sounds/coin2.mp3", "static")
    utilsound = love.audio.newSource("assets/sounds/util.mp3", "static")
    unlockedAC = love.audio.newSource("assets/sounds/achievementunlocked.mp3", "static")

    -- Global Variables
    mmenuopen = true
    gameover = false
    gamefinished = false
    difficultuselection = true
    achievementsselection = false
    floorheight = 580
    wave = 1
    wavefinished = true
    startwaves = false
    maxwaves = 11
    tips = true
    shootscounts = 0
    maxshootcounts = nil
    sc_multiplier = nil
    difficulty = nil
    newart = false
    showfps = false
    restarted = false
    wins = 0
    loses = 0
    
end

--------------------------------------------------------------

function love.load()
    startGlobalAll()
    Bars:load()
    joystick = love.joystick.getJoysticks()[1]
    MainMenu:load()
    Background:load()
    Kangaroo:load()
    Shark:load()
    Banana:load()
    Egg:load()
    DEffect:load()
    Coin:load()
    Difficulty:load()
    Util:load()
    CircEffect:load()
    Transition:load()
    EnableNewArt()

    --//////////////////////////////////////--
    debug = false

    if debug == true then
        Egg.infinitehealth = true
        Egg.infiniteammo = trues
        Egg.infinitefuel = true
        bullet_damage = 999
    end
    --//////////////////////////////////////--

    local cursor = love.mouse.newCursor("assets/new/cursor.png")
    love.mouse.setCursor(cursor)
    
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    Transition:update(dt)
    if mmenuopen and not gameover then
        MainMenu:update(dt)
    end
    if not mmenuopen and not gameover and not achievementsselection and difficultuselection  then
        Difficulty:update(dt)
    end
    if not mmenuopen and not gameover and not difficultuselection and not achievementsselection then
        Background:update(dt)
        Egg:update(dt)
        Kangaroo:update(dt)
        Shark:update(dt)
        Banana:update(dt)
        handlewaves(dt)
        DEffect:update(dt)
        Coin:update(dt)
        Util:update(dt)
        CircEffect:update(dt)
        HandleShootTime(dt)
        Bullet:update(dt)
    end
    if debug == true then
        Egg.infinitehealth = true
        Egg.infiniteammo = true
        Egg.infinitefuel = true
        bullet_damage = 999
    elseif not debug then
        Egg.infinitehealth = false
        Egg.infiniteammo = false
        Egg.infinitefuel = false
    end
    if achievementsselection then
        Achievements.update(dt)
    end
end

function love.draw()
    if mmenuopen and not achievementsselection and not gameover then
        MainMenu:draw()
    end
    if not mmenuopen and not gameover and not achievementsselection and difficultuselection then
        Difficulty:draw()
    end
    if not mmenuopen and not gameover and not achievementsselection and not difficultuselection then
        Background:draw()
        Egg:draw()
        Bars:handle()
        Kangaroo:draw()
        Shark:draw()
        Banana:draw()
        DEffect:draw()
        Coin:draw()
        Util:draw()
        CircEffect:draw()
        Bullet:draw()
        -- Mira
        if enableaimline then
            love.graphics.line(
            Egg.x + Egg.width / 2, 
            Egg.y + Egg.height / 2, 
            mouseX, mouseY
        )
        love.graphics.circle(
        "fill",
        mouseX, mouseY,
        10
        )
        end
        if tips then
            love.graphics.print("Press Space To Jetpack\nPress W to Jump\nPress R To Refuel\nClick To Shoot\nPress E To Start", love.graphics.getWidth() / 2 - 300 / 2, 70)
        end
    end
    if gameover then
        local font = love.graphics.getFont()
        local width = font:getWidth("Press R To Restart...")
        local height = font:getHeight("Press R To Restart...")
        love.graphics.print( "Press R To Restart...", (love.graphics.getWidth() / 2) - width / 2, (love.graphics.getHeight() / 2) - height)
    end
    if showfps then
        local FPS = love.timer.getFPS()
        love.graphics.setNewFont(24)
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("Fps:" .. FPS, 0, love.graphics.getHeight() - 40)
        --love.graphics.print("Dt: " .. love.timer.getDelta(), 90, love.graphics.getHeight() - 40)
        love.graphics.setColor(1, 1, 1)
    end
    if achievementsselection and not mmenuopen then
        love.graphics.setBackgroundColor(77/255, 184/255, 255/255)
        Achievements.draw()
    end
    Transition:draw()
end

--------------------------------------------------------------

-- TODO
-- Adicioar a Arma (x)
-- Adicionar o Jetpack(x)
-- Adicionar Menu (x)
-- Adicionar Vida e Munição (x)
-- Adicionar Mecânica de Munição Com A Arma (x)
-- Adiciona Efeitos Sonoros (x)
-- Adicionar Inimigos "Canguru (x), Tubarão (x), Banana (x)" (x)
-- Adicionar Mecânica Dos Inimigos Em Relação Ao Player (x)
-- Adicionar Waves (x)
-- Adicionar GameOver (x)
-- Adicionar Power Ups ()
-- Adicionar Ultilitários (x)
-- Fazer um Assets.lua para armazenar todas as imagens do Jogo (x)
-- Fazer um Sistema de Save Game (x)
-- Fazer Conquistas (x)

-- Efeitos
-- efeitos de dano (x)
-- moedas (x)
-- dificuldade (x)
-- Transição (x)
-- Cursor (x)
-- == novos visuais (x)
--  > Jogador (x)
--  > Armar (x)
--  > Canguru (x)
--  > Moedas (x)
--  > Fundo (x)
--  > UI (x)
-- Efeitos em Geral

-- Devlog --
--------------------------------------------------------------
-- BV2
-- Difficulty Implemented
-- Easy / Normal / Hard
--------------------------------------------------------------
-- BV3
-- New Resolution ( 1280x800 )
-- New Art & Style
--------------------------------------------------------------
-- BV4
-- New Graphic Effects
-- New Sound Effects
-- Utility Implemented 
-- New Difficulty Pattern
-- Debug Function
-- Triple Shoot
--------------------------------------------------------------
-- BV5
-- New Cursor Added
-- Transition Added
-- FPS show Added
-- Aim Track Added
-- New Effects
-- New Enemy Shark
-- New Wave Pattern
-- Sun Added
-- New GUI
--------------------------------------------------------------
-- V 1.0
-- New Effects
-- New Animations
-- Bug Fixes
-- New Enemy (Banana)
-- Achievements (17 in total)
