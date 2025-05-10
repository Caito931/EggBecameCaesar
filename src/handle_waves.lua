-- handle_waves.lua

numberofbananas = 0
numberofsharks = 0

-- Summonar Cangurus
function spawnK(n)
    for i = 1, n, 1 do
        Kangaroo:spawn(i*50); -- Valor Multiplicado para A Distância entre cada Cangaru
    end
end
-- Summonar Tubarões
function spawnS(n)
    for i = 1, n, 1 do
        Shark:create(-200, floorheight)
    end
end
-- Summonar Bananas
function spawnB(n)
    for i = 1, n, 1 do
        Banana:create(0, 50)
    end
end
-- Checa se a 'Wave' acabou
function checkWaveFinished()
    if next(kangaroos) == nil and next(sharks) == nil and next(bananas) == nil then
        return true 
    else
        return false
    end
end
-- Summonar Onda
function spawnWave(waveNumber)
    -- Cangurus
    numberofkangaroos = waveNumber * 2
    spawnK(numberofkangaroos)

    -- Tubarões
    if numberofkangaroos >= 4 then
        numberofsharks = numberofsharks + 0.5
        spawnS(math.floor(numberofsharks))
    end
    -- Bananas
    if numberofkangaroos ~= 0 and numberofsharks >= 4 then
        numberofbananas = numberofbananas + 0.25
        spawnB(math.floor(numberofbananas))
    end 
end

-- Tempo
timer = 0
function handlewaves(dt)
    if startwaves and not tips and wave < maxwaves then
        if wavefinished then
            timer = timer + dt

            if timer >= 3 then
                spawnWave(wave)
                love.audio.play(wavesound)
                wavefinished = false  
                wave = wave + 1     
                Kangaroo.rotation_speed = Kangaroo.rotation_speed + 1
                timer = 0  
            end
        else
            if checkWaveFinished() then
                wavefinished = true  
            end
        end
    elseif wave == maxwaves and checkWaveFinished() then
        ACS.winagame = true
        gamefinished = true
    end
end