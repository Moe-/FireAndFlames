class "Player" {
	posx = 0;
	posy = 0;
	angle = 0;
	rotate = 0;
}

cRotateSpeed = 0.45

function Player:__init(water, posx, posy)
	self.water = water
	self.posx = posx
	self.posy = posy
	if self.water then
		self.image = love.graphics.newImage("gfx/car-1.png")
		self.gunImage = love.graphics.newImage("gfx/gun-1.png")
	else
		self.image = love.graphics.newImage("gfx/car-0.png")
		self.gunImage = love.graphics.newImage("gfx/gun-0.png")
	end
	
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
	self.gunQuad = love.graphics.newQuad(0, 0, self.gunImage:getWidth(), self.gunImage:getHeight(), self.gunImage:getWidth(), self.gunImage:getHeight())
end

function Player:update(dt)
	self.angle = self.angle + dt * self.rotate
end

function Player:draw()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.image, self.quad, self.posx, self.posy)
		love.graphics.draw(self.gunImage, self.gunQuad, self.posx + self.image:getWidth()/2 - self.gunImage:getWidth()/2 + 10, self.posy + 10, 
											self.angle, 1, 1, self.gunImage:getWidth()/2, self.gunImage:getHeight() - 5)
end

function Player:keyreleased(key)
	if self.water then
		if key == "w" or key == "s" then
			self.rotate = 0
		end
	end
	
	if not self.water then
		if key == "o" or key == "l" then
			self.rotate = 0
		end
	end
end

function Player:keypressed(key, scancode, isrepeat)
	if self.water then
		if key == "w" then
			self.rotate = cRotateSpeed
		elseif key == "s" then
			self.rotate = -cRotateSpeed
		end
	end
	
	if not self.water then
		if key == "o" then
			self.rotate = cRotateSpeed
		elseif key == "l" then
			self.rotate = -cRotateSpeed
		end
	end
end
