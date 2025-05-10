-- achievements.lua
Achievements = {}
achievements = {}
scrollX = 0
scrollSpeed = 10 -- Velocidade

ACS = { -- ac state
    jumpcount = 0,
    usedtripleshot = false,
    winagame = false,
    loseagame = false,
    killedfirstenemy = false,
    diedforK = false,
    diedforS = false,
    diedforB = false,
    usedjetpack = false,
    reloadfirsttime = false,
    refuelfirsttime = false,
    shootcount = 0,
    hited = false,
    all = false,
}

-- Constructor 
function Achievements.new(x, y, icon, w, h, completed, name, description) 
    local self = setmetatable({}, { __index = Achievements }) 
    self.x = x
    self.y = y
    self.icon = icon
    self.w = w
    self.h = h
    self.completed = completed
    self.name = name
    self.description = description
    return self
end

-- Conquistas
local function initializeAchievements()
    -- Nomes e Descrições
    local achievementData = {
        { name = "Little Frog", description = "Jump a total of 100 times" },
        { name = "Triple Trouble", description = "Use the Triple Shot" },
        { name = "World Champion", description = "Win a Game" },
        { name = "Losing is Part of It", description = "Lose a Game" },
        { name = "Child's Play", description = "Win on Easy Mode" },
        { name = "Killer", description = "Kill Your First Enemy" },
        { name = "Punch in the Face", description = "Die to the Kangaroo" },
        { name = "Shark Attack", description = "Die to the Shark" },
        { name = "Banana Hit", description = "Die to the Banana" },
        { name = "To Infinity and Beyond", description = "Use the Jetpack" },
        { name = "Reloading", description = "Reload for the First Time" },
        { name = "Changing the Engine", description = "Refuel for the First Time" },
        { name = "Professional Shooter", description = "Shoot a total of 1000 times" },
        { name = "It's Getting Harder", description = "Win on Normal Mode" },
        { name = "True Caesar", description = "Win on Hard Mode" },
        { name = "Flawless Caesar", description = "Win Hard Mode without Taking Damage" },
        { name = "TRUE CAESAR", description = "Achieve all Achievements" },
    }

    for i = 1, #achievementData do
        local icon = Assets["ac" .. i]
        local name = achievementData[i].name
        local description = achievementData[i].description
        
        if icon then
            achievements[i] = Achievements.new((i - 1) * 10 + 5, 5, icon, 100, 100, false, name)
            achievements[i].description = description 
        else
            print("Warning: Missing asset for ac" .. i) -- Debug
        end
    end
end


initializeAchievements()

function Achievements.update(dt)
    updateAchievementState(dt)
    -- Scroll
    if achievementsselection then
        if love.keyboard.isDown("right") then
            scrollX = scrollX + scrollSpeed
        elseif love.keyboard.isDown("left") then
            scrollX = scrollX - scrollSpeed
        end
        local maxScroll = (#achievements * (100 + 50)) - 1280 -- Total width of all achievements + spacing - window width
        scrollX = math.max(0, math.min(scrollX, maxScroll))
    end
end

function Achievements.draw()
    local xOffset = 5 - scrollX 
    local yOffset = 5
    local spacing = 300
    local iconSize = 100
    local windowWidth = 1280
    local windowHeight = 800

    for i = 1, #achievements do
        if achievements[i] then
            -- Desenha Limpo
            love.graphics.draw(achievements[i].icon, xOffset, yOffset)
            -- Desenha um Quadrado Transparente se Nao Estiver Completo
            if not achievements[i].completed then
                love.graphics.setColor(0,0,0, 0.7)
                love.graphics.rectangle("fill", xOffset, yOffset, 100, 100)
                love.graphics.setColor(1,1,1,1)
            end

            -- Nome
            love.graphics.print(achievements[i].name, xOffset + iconSize + 5, yOffset + (iconSize / 2) - 10) -- Nome 

            -- Descrição
            love.graphics.print("- "..achievements[i].description, xOffset + iconSize + 5, yOffset + (iconSize / 2) + 20) -- Debaixo do Nome

            yOffset = yOffset + iconSize + spacing/3

            if yOffset + iconSize > windowHeight then
                yOffset = 5
                xOffset = xOffset + iconSize + spacing + 100 
            end

            -- Checagem para ver se vai para fora da janela
            if xOffset > windowWidth then
                break -- para de desenhar se for o caso
            end

        end
    end
end

function updateAchievementState(dt)
    -- ac1
    if ACS.jumpcount >= 100 then
        achievements[1].completed = true
    end
    -- ac2
    if ACS.usedtripleshot then
        achievements[2].completed = true
    end
    -- ac3
    if ACS.winagame then
        achievements[3].completed = true
    end
    -- ac4
    if ACS.loseagame then
        achievements[4].completed = true
    end
    -- ac6
    if ACS.killedfirstenemy then
        achievements[6].completed = true
    end
    -- ac7
    if ACS.diedforK then
        achievements[7].completed = true
    end
    -- ac8
    if ACS.diedforS then
        achievements[8].completed = true
    end
    -- ac9
    if ACS.diedforB then
        achievements[9].completed = true
    end
    -- ac10
    if ACS.usedjetpack then
        achievements[10].completed = true
    end
    -- ac11
    if ACS.reloadfirsttime then
        achievements[11].completed = true
    end
    -- ac12
    if ACS.refuelfirsttime then
        achievements[12].completed = true
    end
    -- ac13
    if ACS.shootcount >= 1000 then
        achievements[13].completed = true
    end
    -- ac 14 15 e 16 estão no pressed_functions.lua na key == "m"
    -- ac17
    if ACS.all then
        achievements[17].completed = true
    end
    -- Lógica do Achievement todos
    for i = 1, #achievements, 1 do
        if not achievements[i].completed then break end
        if i == 17 and not achievements[i].completed then 
            ACS.all = true 
        end
    end
end