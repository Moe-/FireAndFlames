class "GameInterface" {
  fgBorderXOffset = 3,
  fgBorderYOffset = 3,
  barHorizontalScreenOffset = 36,
  barVerticalScreenOffset = 15
}

function GameInterface:__init(world)
  -- The functions should return some value between 0 and 1
  --local waterFillStatusFunction = waterPlayer.getPower
  local waterFillStatusFunction = world.players[2]:getPowerFunction()
  local fireFillStatusFunction = world.players[1]:getPowerFunction()
  local gameStatusFunction = world:getGameStatusFunction()
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

--[[example: gameStatus = {
      ["remainingTime"] = 1,
      ["gameOver"] = 2,
      ["winner"] = 3
      }
--]]
function GameInterface:drawMiddleBar(gameStatus)
  oldR, oldG, oldB = love.graphics.getColor()
  if gameStatus.gameOver then
    love.graphics.setColor(255,0,0)
    self.guiText:set("Game Over")
    love.graphics.draw(self.guiText, love.graphics.getWidth()/2, self.barVerticalScreenOffset, 0, 2, 2, self.guiText:getWidth()/2, 0)
    if gameStatus.winner then -- fire fighter wins
			love.graphics.setColor(0, 0, 255, 255)
			self.guiText:set("Fire fighter wins: " .. gameStatus.blocksDestroyed .. " of " .. gameStatus.blockCount .. " blocks destroyed")
		else
			love.graphics.setColor(255, 0, 0, 255)
			self.guiText:set("Fire snake wins: " .. gameStatus.blocksDestroyed .. " of " .. gameStatus.blockCount .. " blocks destroyed")
		end
    love.graphics.draw(self.guiText, love.graphics.getWidth()/2, 50, 0, 1.5, 1.5, self.guiText:getWidth()/2, 0)
  else
    love.graphics.setColor(255, 255 * gameStatus.remainingTime / cTimelimit, 255 * gameStatus.remainingTime / cTimelimit, 255)
    self.guiText:set(string.format("%.2f", gameStatus.remainingTime))
  love.graphics.draw(self.guiText, love.graphics.getWidth()/2, self.barVerticalScreenOffset, 0, 2, 2, self.guiText:getWidth()/2, 0)
  end
  love.graphics.setColor(oldR, oldG, oldB)
end