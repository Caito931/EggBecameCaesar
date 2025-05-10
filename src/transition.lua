-- transition.lua

Transition = {}

function Transition:load()
    self.show = false
    self.width = 1
    self.height = love.graphics.getHeight()
    self.x = 0
    self.y = 0
    self.direction = 'right'
    self.speed = 5000
    self.currentscene = 1
    restarttime = 0.2
end

function Transition:update(dt)
    if restarted then
        if restarttime > 0 then
            restarttime = restarttime - 1 * dt
        end
        if restarttime <= 0 then
            self.show = false
            restarted = false
            restarttime = 0.2
        end
    end
    if self.show and not restarted then
        -- Vai
        if self.x + self.width <= love.graphics.getWidth() and self.direction == 'right' then
            self.width = self.width + self.speed * dt
        end
        -- Volta
        if self.x + self.width >= love.graphics.getWidth() then
            self.direction = 'left'
            self.x = self.x + self.speed * dt
        end
        -- Para de Mostrar e Volta a Posição Inicial
        if self.x >= love.graphics.getWidth() and self.direction == 'left' then
            self.show = false
            self.x = 0
            self.width = 1
            self.direction = 'right'
        end
        if self.x > 0 then
                -- Menu para Seleção de Difficuldade
                if self.currentscene == 1 then
                    mmenuopen = false
                    achievementsselection = false
                    difficultuselection = true
                -- Seleção de Dificuldade para Gameplay
                elseif self.currentscene == 2 then
                    difficultuselection = false
                elseif self.currentscene == 4 then
                    achievementsselection = false
                    mmenuopen = true
                -- Conquistas
                elseif self.currentscene == 3 then
                    difficultuselection = false
                    mmenuopen = false
                    achievementsselection = true
                end
        end
    end
end

function Transition:draw()
    if self.show then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
    end
end