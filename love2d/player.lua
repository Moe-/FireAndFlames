class "Player" {
	posx = 0;
	posy = 0;
	angle = 0;
	rotate = 0;
}

cRotateSpeed = 0.85
cCanonImpulse = 40
cShotRadius = 8
cShotTick = 0.10
cShootTimeout = 0.1

function Player:__init(water, posx, posy, world)
	self.water = water
	self.posx = posx
	self.posy = posy
	self.world = world
	self.inputRotateLeft = false
	self.inputRotateRight = false
	self.inputShoot = false
	self.shootIdleTime = cShootTimeout
	
	if self.water then
		self.image = love.graphics.newImage("gfx/car-1.png")
		self.gunImage = love.graphics.newImage("gfx/gun-1.png")
		
		self.keyLeft = "a"
		self.keyRight = "d"
		self.keyShoot = "space"
	else
		self.image = love.graphics.newImage("gfx/car-0.png")
		self.gunImage = love.graphics.newImage("gfx/gun-0.png")
		
		self.keyLeft = "left"
		self.keyRight = "right"
		self.keyShoot = "return"		
	end
	
	self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
	self.gunQuad = love.graphics.newQuad(0, 0, self.gunImage:getWidth(), self.gunImage:getHeight(), self.gunImage:getWidth(), self.gunImage:getHeight())
end

function Player:update(dt)
	self.rotate = 0
	if self.inputRotateLeft then self.rotate = self.rotate - cRotateSpeed end
	if self.inputRotateRight then self.rotate = self.rotate + cRotateSpeed end
	
	self.angle = self.angle + dt * self.rotate
	
	self.shootIdleTime = self.shootIdleTime + dt
	
	if self.inputShoot and self.shootIdleTime >= cShootTimeout then
		self.shootIdleTime = 0
		self:shoot()
	end
end

function Player:draw()
	love.graphics.setColor(255, 255, 255)
	if self.water then
		love.graphics.draw(self.image, self.quad, self.posx, self.posy)
		love.graphics.draw(self.gunImage, self.gunQuad, self.posx - self.gunImage:getWidth()/2 + 20, self.posy + 30, 
										self.angle, 1, 1, self.gunImage:getWidth()/2, self.gunImage:getHeight())
	else
		love.graphics.draw(self.image, self.quad, self.posx, self.posy)
		love.graphics.draw(self.gunImage, self.gunQuad, self.posx + 20, self.posy + 25, 
										self.angle, 1, 1, 3, self.gunImage:getHeight())
	end
end

function Player:keyreleased(key)
	if key == self.keyLeft then
		self.inputRotateLeft = false
	end
	if key == self.keyRight then
		self.inputRotateRight = false
	end
	if key == self.keyShoot then
		self.inputShoot = false
	end
end

function Player:shoot()
	local body = love.physics.newBody(self.world, self.posx, self.posy, "dynamic")
	local data = {}
	data.type = "shot"
	data.water = self.water
	data.age = 0
	body:setUserData(data)
	local shape = love.physics.newCircleShape(cShotRadius)
	local fixture = love.physics.newFixture(body, shape)
	
	body:applyLinearImpulse(math.cos(self.angle - math.pi/2) * cCanonImpulse, math.sin(self.angle - math.pi/2) * cCanonImpulse)
end

function Player:keypressed(key, scancode, isrepeat)	
	if key == self.keyLeft then
		self.inputRotateLeft = true
	end
	if key == self.keyRight then
		self.inputRotateRight = true
	end
	if key == self.keyShoot then
		self.inputShoot = true
	end
end
