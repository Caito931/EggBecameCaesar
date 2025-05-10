-- mainmenu.lua

MainMenu = {}

function MainMenu:load()
    self.font = love.graphics.newFont(30)
    self.sprite = Assets.MainMenu_sprite
    self.finger = Assets.MainMenu_finger
    self.finger_x = 180
    self.finger_y = 350
    self.minfinger_x = 180
    self.maxfinger_x = 250
    self.finger_direction = 'right'
    self.finger_speed = 100
    -- Start
    self.start_x = 100
    self.start_y = 350
    self.start_width = self.font:getWidth("Start")
    self.start_height = self.font:getHeight("Start")
    -- Quit
    self.quit_x = 100
    self.quit_y = 425
    self.quit_width = self.font:getWidth("Quit")
    self.quit_height = self.font:getHeight("Quit")
    -- New Art 
    self.newart_x = 100
    self.newart_y = 500
    self.newart_width = self.font:getWidth("New Art")
    self.newart_height = self.font:getHeight("New Art")
    self.rainbow = {}
    self.rainbow.speed = 5  -- Adjust this to change the speed of color change
    self.rainbow.colors = {
        {255, 0, 0},     -- Red
        {255, 165, 0},   -- Orange
        {255, 255, 0},   -- Yellow
        {0, 255, 0},     -- Green
        {0, 0, 255},     -- Blue
        {75, 0, 130},    -- Indigo
        {238, 130, 238}  -- Violet
    }
    self.rainbow.currentColor = 1
    self.rainbow.timer = 0
    -- Achievements
    self.achievements_x = 100
    self.achievements_y = 575
    self.achievements_width = self.font:getWidth("Achievements")
    self.achievements_height = self.font:getHeight("Achievements")
end

function MainMenu:update(dt)
    if self.finger_x < self.maxfinger_x and self.finger_direction == 'right' then
        self.finger_x = self.finger_x + self.finger_speed * dt
    elseif self.finger_x > self.minfinger_x and self.finger_direction == 'left' then
        self.finger_x = self.finger_x - self.finger_speed * dt
    end
    if self.finger_x >= self.maxfinger_x then
        self.finger_direction = 'left'
    end
    if self.finger_x <= self.minfinger_x then
        self.finger_direction = 'right'
    end
    if MainMenu.finger_y == MainMenu.achievements_y then
        if self.finger_x < self.minfinger_x then
            self.finger_speed = 500
        else
            self.finger_speed = 100
        end
        MainMenu.minfinger_x = 300
        MainMenu.maxfinger_x = 320
    elseif MainMenu.finger_y == MainMenu.start_y or MainMenu.finger_y == MainMenu.quit_y then
        if self.finger_x > self.minfinger_x and self.finger_x > self.maxfinger_x then
            self.finger_speed = 500
        else
            self.finger_speed = 100
        end
        MainMenu.minfinger_x = 180
        MainMenu.maxfinger_x = 200
    elseif MainMenu.finger_y == MainMenu.newart_y then
        if self.finger_x > self.minfinger_x and self.finger_x > self.maxfinger_x then
            self.finger_speed = 500
        else
            self.finger_speed = 100
        end
        MainMenu.minfinger_x = 250
        MainMenu.maxfinger_x = 270
    end
    -- Animação do Arco íris
    self.rainbow.timer = self.rainbow.timer + dt
    if self.rainbow.timer > 1 / self.rainbow.speed then
        self.rainbow.timer = 0
        self.rainbow.currentColor = self.rainbow.currentColor % #self.rainbow.colors + 1
    end
end

function MainMenu:draw()
    love.graphics.setFont(self.font)

    -- Fundo
    love.graphics.draw(self.sprite, 0, 0)

    -- Start
    love.graphics.setColor(1, 1 ,1)
    love.graphics.print("Start", self.start_x, self.start_y)

    -- Quit
    love.graphics.print("Quit", self.quit_x, self.quit_y)

    -- New Art
    self.checked = ''
    if newart then
        self.checked = 'x'
    else
        self.checked = ''
    end
    love.graphics.setColor(self.rainbow.colors[self.rainbow.currentColor])
    love.graphics.print("New Art " .. self.checked, self.newart_x, self.newart_y)
    love.graphics.setColor(1, 1, 1)

    -- Achievements
    love.graphics.print("Achievements", self.achievements_x, self.achievements_y)

    -- Dedo
    love.graphics.draw(self.finger, self.finger_x, self.finger_y)

    -- Créditos
    love.graphics.print("Made By: Choraumm", love.graphics.getWidth() - 330, 0)
    local font = love.graphics.newFont(26)
    love.graphics.setFont(font)
    love.graphics.print("©2025 All Rights Reserved", love.graphics.getWidth() - 360, 40)
end
