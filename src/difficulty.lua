-- dificulty.lua

Difficulty = {}

function Difficulty:load()

    self.background = Assets.Diff_background

    self.easy_sprite = Assets.Diff_easy_sprite
    self.normal_sprite = Assets.Diff_normal_sprite
    self.hard_sprite = Assets.Diff_hard_sprite

    self.icons_width = self.easy_sprite:getWidth()
    self.icons_height = self.easy_sprite:getHeight()
    self.icons_y = love.graphics.getHeight() / 2 - love.graphics.getHeight() / 3


    -- Fácil
    self.easyDifficulty = {
        x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 3,
        y = self.icons_y,
        sx = 1,
        sy = 1,
        textX = 1,
        textY = 1,
    }
    self.easyDifficulty.textX = self.easyDifficulty.x + self.icons_width / 2 - 35
    self.easyDifficulty.textY = self.icons_y + self.icons_height

    -- Normal
    self.normalDifficulty = {
        x = love.graphics.getWidth() / 2 - self.normal_sprite:getWidth() / 2,
        y = self.icons_y,
        sx = 1,
        sy = 1,
        textX = 1,
        textY = 1,
    }
    self.normalDifficulty.textX = self.normalDifficulty.x + self.icons_width / 2 - 50
    self.normalDifficulty.textY = self.icons_y + self.icons_height

    -- Dificil
    self.hardDifficulty = {
        x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 6,
        y = self.icons_y,
        sx = 1,
        sy = 1,
        textX = 1,
        textY = 1,
    }
    self.hardDifficulty.textX = self.hardDifficulty.x + self.icons_width / 2 - 35
    self.hardDifficulty.textY = self.icons_y + self.icons_height

end

function Difficulty:update(dt)
    -- Facil
    self:updateMouseHover(dt, self.easyDifficulty,mouseX, mouseY)
    -- Normal
    self:updateMouseHover(dt, self.normalDifficulty, mouseX, mouseY)
    -- Dificil
    self:updateMouseHover(dt, self.hardDifficulty, mouseX, mouseY)
end

function Difficulty:draw()
    -- Fonte
    love.graphics.setNewFont(30)
    font = love.graphics.getFont()
    -- Fundo
    love.graphics.draw(self.background, 0, 0)

    -- Fácil
    self:drawButton(self.easy_sprite, self.easyDifficulty, "Easy")
    -- Normal
    self:drawButton(self.normal_sprite, self.normalDifficulty, "Normal")
    -- Difícil
    self:drawButton(self.hard_sprite, self.hardDifficulty, "Hard")

    --love.graphics.draw(drawable (Drawable), x (number), y (number), r (number), sx (number), sy (number), ox (number), oy (number), kx (number), ky (number))
end

-- Funcão para Desenhar
function Difficulty:drawButton(sprite, button, text)
    local scaledWidth = self.icons_width * button.sx
    local scaledHeight = self.icons_height * button.sy
    local offsetX = (scaledWidth - self.icons_width) / 2
    local offsetY = (scaledHeight - self.icons_height) / 2

    -- Desenha O Sprite
    love.graphics.draw(sprite, button.x - offsetX, button.y - offsetY, 0, button.sx, button.sy)

    -- Dimensões do Texto
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()

    -- Desenha o Texto Centrado abaixo do Sprite
    local textX = (button.x + self.icons_width / 2 - textWidth/2)
    local textY = (button.y + self.icons_height + textHeight/2) + button.sy*10
    love.graphics.print(text, textX, textY)
end
 
-- Função para Atualizar a Função de Passada do Mouse
function Difficulty:updateMouseHover(dt, button, mouseX, mouseY)
    local maxScale = 1.2
    local normalScale = 1
    local speed = 5 -- velocidade
    
    -- Inicializa o Progresso
    button.progress = button.progress or 0
    
    -- Checa se o Mouse esta Passando
    if mouseX > button.x and mouseX < button.x + self.icons_width and
       mouseY > button.y and mouseY < button.y + self.icons_height then
        button.progress = math.min(1, button.progress + dt * speed)
    else
        button.progress = math.max(0, button.progress - dt * speed)
    end
    
    -- Aplica o "easing"
    local ease = easeInOutBack(button.progress)
    button.sx = normalScale + (maxScale - normalScale) * ease
    button.sy = normalScale + (maxScale - normalScale) * ease
end

---------------------------EASINGS---------------------------

-- Elastic Easing Function (easings.net)
function easeOutElastic(x)
    local c4 = (2 * math.pi) / 3
    if x == 0 then return 0 end
    if x == 1 then return 1 end
    return math.pow(2, -10 * x) * math.sin((x * 10 - 0.75) * c4) + 1
end

-- Bounce Easing Function (easings.net)
function easeOutBounce(x)
    n1 = 7.5625
    d1 = 2.75
    
    if x < 1 / d1 then return n1 * x * x 
    elseif x < 2 / d1 then return n1 * (x - 1.5 / d1) * x + 0.75 
    elseif (x < 2.5 / d1) then return n1 * (x - 2.25 / d1) * x + 0.9375 
    else return n1 * (x - 2.625 / d1) * x + 0.984375 end
end

-- Back Easing Function (easings.net)
function easeInOutBack(x)
    c1 = 1.70158;
    c2 = c1 * 1.525;
    
    if x < 0.5 then return (math.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2 
    else return (math.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2 end
    
end