class "Player" {
	posx = 0;
	posy = 0;
	angle = 0.5;
	rotate = 0;
	power = 1;
}

cRotateSpeed = 0.85
cCanonImpulse = 40
cShotRadius = 8
cShotTick = 0.10
cShootTimeout = 0.1
cShootVolumeChange = 3

function Player:__init(water, posx, posy, world)
	self.water = water
	self.posx = posx
	self.posy = posy
	self.gunOffX = 25
	self.gunOffY = 25
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
		self.shootLoop = sfx.waterLoop
	else
		self.image = love.graphics.newImage("gfx/car-0.png")
		self.gunImage = love.graphics.newImage("gfx/gun-0.png")
		
		self.keyLeft = "left"
		self.keyRight = "right"
		self.keyShoot = "return"		
		self.shootLoop = sfx.fireLoop
	end
	
	self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
	self.gunQuad = love.graphics.newQuad(0, 0, self.gunImage:getWidth(), self.gunImage:getHeight(), self.gunImage:getWidth(), self.gunImage:getHeight())
	
	self.shootLoopTargetVolume = 0
	self.shootLoop:setLooping(true)
	love.audio.play(self.shootLoop)
	self.shootLoop:setVolume(0)
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
	
	self.power = self.power + 0.375 * dt
	if self.power > 1 then self.power = 1 end
	
	-- shoot loop handling
	local vol = self.shootLoop:getVolume()
	local dvol = self.shootLoopTargetVolume - vol
	if dvol > 0 then vol = vol + cShootVolumeChange * dt
	else vol = vol - cShootVolumeChange * dt end
	
	self.shootLoop:setVolume(clamp(vol, 0, 1))
end

function Player:draw()
	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(self.image, self.quad, self.posx, self.posy)
	
	love.graphics.draw(self.gunImage, self.gunQuad, 
		self.posx + self.gunOffX,
		self.posy + self.gunOffY,
		self.angle, 1, 1, 
		self.gunImage:getWidth()/2, 
		self.gunImage:getHeight())
end

function Player:keyreleased(key)
	if key == self.keyLeft then
		self.inputRotateLeft = false
	end
	if key == self.keyRight then
		self.inputRotateRight = false
	end
	if key == self.keyShoot then
		self.shootLoopTargetVolume = 0
		self.inputShoot = false
	end
end

function Player:shoot()
	if self.power <= 0 then return end
	
	local body = love.physics.newBody(self.world, self.posx + self.gunOffX, self.posy + self.gunOffY, "dynamic")
	local data = {}
	data.type = "shot"
	data.water = self.water
	data.age = 0
	body:setUserData(data)
	local shape = love.physics.newCircleShape(cShotRadius)
	local fixture = love.physics.newFixture(body, shape)
	
	body:applyLinearImpulse(math.cos(self.angle - math.pi/2) * cCanonImpulse * self.power, math.sin(self.angle - math.pi/2) * cCanonImpulse * self.power)
	
	self.power = self.power - 0.05
end

function Player:keypressed(key, scancode, isrepeat)	
	if key == self.keyLeft then
		self.inputRotateLeft = true
	end
	if key == self.keyRight then
		self.inputRotateRight = true
	end
	if key == self.keyShoot then
		self.shootLoopTargetVolume = 1
		self.inputShoot = true
	end
end

function Player:getPowerFunction()
  return function () return self.power end
end
