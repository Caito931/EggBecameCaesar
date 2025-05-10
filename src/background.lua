-- background

Background = {}

function Background:load()
    self.background = Assets.background
    self.x = 0
    self.y = 0
    self.sun = Assets.sun
    self.sun_x = Bars.pph_x  + Bars.pph_width / 2--love.graphics.getWidth() - self.sun:getWidth() / 2
    self.sun_y = Bars.pph_y  + Bars.pph_height / 2 --self.sun:getHeight() / 2
end

function Background:update(dt)
end

function Background:draw()
    -- Fundo
    love.graphics.draw(self.background, self.x, self.y)

    -- Sol
    love.graphics.push()
    local angle  = love.timer.getTime() * 2*math.pi / 10
    love.graphics.draw(self.sun, self.sun_x, self.sun_y, angle, 1, 1, self.sun:getWidth() / 2, self.sun:getHeight() / 2)
    love.graphics.pop()
end

