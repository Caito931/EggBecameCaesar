-- pressed_functions

-- Mouse
function love.mousepressed(x , y , button , isTouch )
    local abletoshot = true
    if not achievementsselection then
    
        --[[
    if button == 1 and not gameover and not mmenuopen and not difficultuselection and Egg.velY == 0 then
        if x < Egg.jumpbutton_x + Egg.jumpbutton_width and
        x > Egg.jumpbutton_x and 
        y < Egg.jumpbutton_y + Egg.jumpbutton_height and
        y > Egg.jumpbutton_y then
            Egg.jumped = true
            Egg:jump()
            abletoshot = false
        end
    end
        if button == 1 and not gameover and not mmenuopen and not difficultuselection and abletoshot and isTouch then
        Shoot(Egg.x, Egg.y, mouseX, mouseY, Egg.width, Egg.height, bulletSpeed, Egg.pulse)
        shootscounts = shootscounts + 1
    end
    ]]

    local tripleshootdistance = 50
    -- Tiro Triplo
    if button == 2 and not gameover and not mmenuopen and not difficultuselection and abletoshot then
        ACS.usedtripleshot = true
        gamepadshoot = false
        Shoot(Egg.x, Egg.y, mouseX, mouseY, Egg.width, Egg.height, bulletSpeed, Egg.pulse)
        Shoot(Egg.x + tripleshootdistance, Egg.y + tripleshootdistance, mouseX, mouseY, Egg.width, Egg.height, bulletSpeed, Egg.pulse)
        Shoot(Egg.x - tripleshootdistance, Egg.y - tripleshootdistance, mouseX, mouseY, Egg.width, Egg.height, bulletSpeed, Egg.pulse)
        shootscounts = shootscounts + 1 -- Debuff
    end

    -- Tiro Normal
    if button == 1 and not gameover and not mmenuopen and not difficultuselection and abletoshot then
        gamepadshoot = false
        Shoot(Egg.x, Egg.y, mouseX, mouseY, Egg.width, Egg.height, bulletSpeed, Egg.pulse)
        shootscounts = shootscounts + 1
    end
end
    -- Start
    if button == 1 and not gameover and mmenuopen  or isTouch then
        if x < MainMenu.start_x + MainMenu.start_width and
        x > MainMenu.start_x and 
        y < MainMenu.start_y + MainMenu.start_height and
        y > MainMenu.start_y then
            Transition.currentscene = 1
            Transition.show = true
            love.audio.play(click)
        end
    end
    -- Quit
    if button == 1 and not gameover and mmenuopen  or isTouch then
        if x < MainMenu.quit_x + MainMenu.quit_width and
        x > MainMenu.quit_x and 
        y < MainMenu.quit_y + MainMenu.quit_height and
        y > MainMenu.quit_y then
            love.event.quit()
        end
    end
    -- Achievements
    if button == 1 and not gameover and mmenuopen or isTouch then
        if x < MainMenu.achievements_x + MainMenu.achievements_width and
           x > MainMenu.achievements_x and
           y < MainMenu.achievements_y + MainMenu.achievements_height and
           y > MainMenu.achievements_y then
                Transition.currentscene = 3
                Transition.show = true
                love.audio.play(click)
           end
    end
    --------------------------------------------------------------
    -- Dificuldades --
    -- Fácil
    if button == 1 and not gameover and not mmenuopen and difficultuselection then
        if x < Difficulty.easyDifficulty.x + Difficulty.icons_width and
           x > Difficulty.easyDifficulty.x and
           y < Difficulty.easyDifficulty.y + Difficulty.icons_height and
           y > Difficulty.easyDifficulty.y then
            difficulty = 'easy'
        end
    end
    -- Normal
    if button == 1 and not gameover and not mmenuopen and difficultuselection then
        if x < Difficulty.normalDifficulty.x + Difficulty.icons_width and
           x > Difficulty.normalDifficulty.x and
           y < Difficulty.normalDifficulty.y + Difficulty.icons_height and
           y > Difficulty.normalDifficulty.y then
            difficulty = 'normal'
        end
    end
    -- Difícil
    if button == 1 and not gameover and not mmenuopen and difficultuselection then
        if x < Difficulty.hardDifficulty.x + Difficulty.icons_width and
           x > Difficulty.hardDifficulty.x and
           y < Difficulty.hardDifficulty.y + Difficulty.icons_height and
           y > Difficulty.hardDifficulty.y then
            difficulty = 'hard'
        end
    end

    if button == 1 and not gameover and not mmenuopen and difficultuselection and difficulty ~= nil then
        Transition.currentscene = 2
        love.audio.play(click)
        -- Dificuldade 
        if difficulty == "easy" then
            maxshootcounts = 15
            sc_multiplier = 13.3
            maxwaves = 10
            Kangaroo.health = 50
            Kangaroo.damage = 3
        end
        if difficulty == "normal" then
            sc_multiplier = 10
            maxshootcounts = 20
            maxwaves = 15
            Kangaroo.health = 100
            Kangaroo.damage = 5
        end
        if difficulty == "hard" then
            sc_multiplier = 5
            maxshootcounts = 40
            maxwaves = 20
            Kangaroo.health = 200
            Kangaroo.damage = 20
        end
        Transition.show = true
    end
    --------------------------------------------------------------
end
-- Key
function love.keypressed(key, scancode, isrepeat)
    -- Menu Cima e Baixo
    if mmenuopen then
        if key == "up" then
            if MainMenu.finger_y > MainMenu.start_y then  
                if not click:isPlaying() then
                    love.audio.play(click)
                end
                MainMenu.finger_y = MainMenu.finger_y - 75
            end
        end

        if key == "down" then
            if MainMenu.finger_y < MainMenu.achievements_y then  
                if not click:isPlaying() then
                    love.audio.play(click)
                end
                MainMenu.finger_y = MainMenu.finger_y + 75
            end
        end

        if key == "return" then
            love.audio.play(click)
            if MainMenu.finger_y == MainMenu.start_y then
                Transition.currentscene = 1
                Transition.show = true
            elseif MainMenu.finger_y == MainMenu.quit_y then
                love.event.quit()
            elseif MainMenu.finger_y == MainMenu.newart_y then
                EnableNewArt()
            elseif MainMenu.finger_y == MainMenu.achievements_y then
                Transition.currentscene = 3
                Transition.show = true
            end
        end
    end

    --[[
    if key == "k" then
        Kangaroo:spawn(1)
    end
    if key == "s" then
        Shark:create(-200, floorheight)
    end
    -- Banana
    if key == "b" and not mmenuopen and not difficultuselection then
        Banana:create(0, 50)
    end
        -- Debug
    if key == "f1" then
        debug = not debug
    end
    ]]
    if key == "o" then
        Background.background = Assets.background2
    end
    
    -- Restart
    if key == "r" and not mmenuopen then
        if gameover then
            Restart()
            loses = loses + 1
        end
    end
    
    if key == "m" and not mmenuopen and gamefinished then
        -- ac5
        if ACS.winagame and difficulty == 'easy' then
            achievements[5].completed = true
        end
        -- ac14
        if ACS.winagame and difficulty == 'normal' then
            achievements[14].completed = true
        end
        -- ac15
        if ACS.winagame and difficulty == 'hard' then
            achievements[15].completed = true
        end
        -- ac16
        if ACS.winagame and difficulty == 'hard' and not ACS.hited then
            achievements[16].completed = true
        end
        Restart()
        wins = wins + 1
    end
    if not gameover and not mmenuopen and not difficultuselection then
        if key == "e" then
            tips = false
            startwaves = true
        end
        -- Mira
        if key == "f2" then
            enableaimline = not enableaimline
        end
        -- fps
        if key == "f3" then
            showfps = not showfps
        end
    end

    -- Sair das Conquistas e das Dificuldades
    if key == "escape" then
        if achievementsselection or difficultuselection then
        Transition.currentscene = 4
        Transition.show = true
        end
    end
end

--[[
function love.joystickpressed(joystick, button)
    if button == 3 then
        if not gameover and not mmenuopen and not difficultuselection then
            gamepadshoot = true
            Shoot(Egg.x, Egg.y, Egg.width, Egg.height)
            shootscounts = shootscounts + 1
        end
    end
    if button == 1 then
        if not gameover and not mmenuopen and not difficultuselection then
            Egg:jump()
        end
    end
end
]]