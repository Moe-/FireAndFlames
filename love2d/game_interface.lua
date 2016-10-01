class "GameInterface" {
  fgBorderXOffset = 3,
  fgBorderYOffset = 3,
  barHorizontalScreenOffset = 25,
  barVerticalScreenOffset = 15
}

function GameInterface:__init()
  self.waterFillStatus = function () return 100 end --TODO put function to get water status here
  self.fireFillStatus = function () return 75 end --TODO see above
  self.waterBGImage = love.graphics.newImage("gfx/ui-bar-bg-1.png")
  self.waterFGImage = love.graphics.newImage("gfx/ui-bar-1.png")
  self.waterImage = love.graphics.newImage("gfx/symbol-1.png")
  self.fireBGImage = love.graphics.newImage("gfx/ui-bar-bg-0.png")
  self.fireFGImage = love.graphics.newImage("gfx/ui-bar-0.png")
  self.fireImage = love.graphics.newImage("gfx/symbol-0.png")
end

function GameInterface:draw()
  self:drawPlayerBar(self.waterFillStatus(), 1)
  self:drawPlayerBar(self.fireFillStatus(), 0)
  --TODO draw info box in the middle
end

-- fill_size = maybe between 0 and 100
-- side = 1 => water, side = 0 => fire
function GameInterface:drawPlayerBar(fill_size, side)
  --print(fill_size)
  if side == 1 then
    --water
    love.graphics.draw(self.waterImage, self.barHorizontalScreenOffset-28, self.barVerticalScreenOffset-3)
    love.graphics.draw(self.waterBGImage, self.barHorizontalScreenOffset, self.barVerticalScreenOffset)
    love.graphics.draw(self.waterFGImage, self.barHorizontalScreenOffset+self.fgBorderXOffset, self.barVerticalScreenOffset+self.fgBorderYOffset, 0, 10*fill_size/100, 1)
  else
    --fire
    love.graphics.draw(self.fireImage, love.graphics.getWidth()-self.barHorizontalScreenOffset-4, self.barVerticalScreenOffset-3)
    love.graphics.draw(self.fireBGImage, love.graphics.getWidth()-self.barHorizontalScreenOffset, self.barVerticalScreenOffset, 0, -1.0, 1)
    love.graphics.draw(self.fireFGImage, love.graphics.getWidth()-self.barHorizontalScreenOffset-self.fgBorderXOffset, self.barVerticalScreenOffset+self.fgBorderYOffset, 0, -1.0*10*fill_size/100, 1)
  end
end
