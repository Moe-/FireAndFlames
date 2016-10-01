class "Player" {
	posx = 0;
	posy = 0;
}

function Player:__init(good, posx, posy)
	self.good = good
	self.posx = posx
	self.posy = posy
	self.image = nil
	--if(self.good)
	--	self.image = love.graphics.newImage("gfx/food.png")
	--else
	--	self.image = love.graphics.newImage("gfx/food.png")
	
  --self.quad = love.graphics.newQuad(0, 0, 24, 32, self.image:getWidth(), self.image:getHeight())
end

function Player:update(dt)

end

function Player:draw()
--		love.graphics.draw(self.image, self.quad, self.posx, self.posy)
end

function Player:keyreleased(key)
	
end

function Player:keypressed(key, scancode, isrepeat)
	
end
