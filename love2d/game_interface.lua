class "GameInterface" {
  fgBorderXOffset = 3,
  fgBorderYOffset = 3,
  barHorizontalScreenOffset = 36,
  barVerticalScreenOffset = 15
}

function GameInterface:__init(waterFillStatusFunction, fireFillStatusFunction, gameStatusFunction)
  -- The functions should return some value between 0 and 1
  --local waterFillStatusFunction = waterPlayer.getPower
  self.waterFillStatusFunction = waterFillStatusFunction or function () return 1 end --TODO put function to get water status here
  self.fireFillStatusFunction = fireFillStatusFunction or function () return 0.75 end --TODO see above
  self.waterBGImage = love.graphics.newImage("gfx/ui-bar-bg-1.png")
  self.waterFGImage = love.graphics.newImage("gfx/ui-bar-1.png")
  self.waterImage = love.graphics.newImage("gfx/symbol-1.png")
  self.fireBGImage = love.graphics.newImage("gfx/ui-bar-bg-0.png")
  self.fireFGImage = love.graphics.newImage("gfx/ui-bar-0.png")
  self.fireImage = love.graphics.newImage("gfx/symbol-0.png")
  self.gameStatusFunction = gameStatusFunction or function () return {["saved"] = 85, ["existing"] = 100} end -- TODO put function to get game state here
  local imageFontSymbols = " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""
  self.guiFont = love.graphics.newImageFont("data/default_imagefont.png", imageFontSymbols)
  self.guiFont:setFilter("nearest", "nearest")
  self.guiText = love.graphics.newText(self.guiFont, "test/test")
end

function GameInterface:draw()
  self:drawPlayerBars()
  self:drawMiddleBar(self.gameStatusFunction())
end

function GameInterface:drawPlayerBars()
  oldR, oldG, oldB = love.graphics.getColor()
  love.graphics.setColor(255,255,255)
  --water
  love.graphics.draw(self.waterImage, self.barHorizontalScreenOffset-34, self.barVerticalScreenOffset-2)
  love.graphics.draw(self.waterBGImage, self.barHorizontalScreenOffset, self.barVerticalScreenOffset)
  -- self.waterFillStatusFunction()/10 -> *10 for total size and /100 for value from fill status => /10
  love.graphics.draw(self.waterFGImage, self.barHorizontalScreenOffset+self.fgBorderXOffset, self.barVerticalScreenOffset+self.fgBorderYOffset, 0, 10*self.waterFillStatusFunction(), 1)
  --fire
  love.graphics.draw(self.fireImage, love.graphics.getWidth()-self.barHorizontalScreenOffset+2, self.barVerticalScreenOffset-2)
  love.graphics.draw(self.fireBGImage, love.graphics.getWidth()-self.barHorizontalScreenOffset, self.barVerticalScreenOffset, 0, -1.0, 1)
  love.graphics.draw(self.fireFGImage, love.graphics.getWidth()-self.barHorizontalScreenOffset-self.fgBorderXOffset, self.barVerticalScreenOffset+self.fgBorderYOffset, 0, -1.0*10*self.fireFillStatusFunction(), 1)
  love.graphics.setColor(oldR, oldG, oldB)
end

-- gameStatus = {["saved"] = 75, ["existing"] = 100}
function GameInterface:drawMiddleBar(gameStatus)
  self.guiText:set(gameStatus.saved.."/"..gameStatus.existing)
  oldR, oldG, oldB = love.graphics.getColor()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(self.guiText, love.graphics.getWidth()/2, self.barVerticalScreenOffset, 0, 2, 2, self.guiText:getWidth()/2, 0)
  love.graphics.setColor(oldR, oldG, oldB)
end