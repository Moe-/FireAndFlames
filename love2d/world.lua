class "World" {
	screenWidth = 0;
	screenHeight = 0;
	blockCount = 0;
	blocksDestroyed = 0;
}

wins = {fire = 0, water = 0}

cTimelimit = 60
cFireSpread = -2
cFireBurn = 0.2
cFireSpreadBurnThreshold = -20
cDestroyNecessaryFactor = 0.5
cHumansJumpOutOfTheWindowThreshold = 50
cHumansJumpOutOfTheWindowProb = 0.025

function World:__init(width, height)
	self.screenWidth = width;
	self.screenHeight = height;
	self.background = love.graphics.newImage("gfx/background.png")
	self.blockWidth = 48;
	self.blockHeight = 48;
	self.blocksImg = love.graphics.newImage("gfx/blocks.png")
	self.blocksQuad = love.graphics.newQuad(0, 0, self.blockWidth, self.blockHeight, self.blocksImg:getWidth(), self.blocksImg:getHeight())
	self.effectWidth = 48;
	self.effectHeight = 64;
	self.effectImg = love.graphics.newImage("gfx/blocks-overlay.png")
	self.effectQuad = love.graphics.newQuad(0, 0, self.effectWidth, self.effectHeight, self.effectImg:getWidth(), self.effectImg:getHeight())
	
	self.timelimit = cTimelimit
	self.gameOver = false
	self.winner = false
	
	self:loadGfx()
	
	self.objects = {}

	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81 * 64, true)
	self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	self.ground = {}
	self.ground.body = love.physics.newBody(self.world, self.screenWidth * 0.5, self.screenHeight - 80)
	self.ground.shape = love.physics.newRectangleShape(self.screenWidth * 2, 32)
	self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)

	self.players = {}
	table.insert(self.players, Player:new(false, 130, 455, self.world))
	table.insert(self.players, Player:new(true, 25, 455, self.world))
	
	love.graphics.setDefaultFilter("nearest", "nearest")

  gameInterface = GameInterface:new(self)
end

function World:update(dt)
	self.world:update(dt)
	
	for i, v in pairs(self.objects) do
		v:update(dt)
	end
	for i, v in pairs(self.players) do
		v:update(dt)
	end
	
	local bodies = self.world:getBodyList()
	for i,v in pairs(bodies) do
		local data = v:getUserData()
		
		if data ~= nil and data.type == "shot" then
			data.age = data.age + dt
		end
		
		if data ~= nil and data.type == "human" then
			data.age = data.age + dt
			if data.age > 3.0 then
				v:destroy()
				love.audio.play(sfx.pain)
			end
		end
		
		if data ~= nil and data.type == "block" then
			if data.wet < cFireSpreadBurnThreshold then
				data.wet = data.wet + cFireSpread * dt
				data.health = data.health + cFireBurn * data.wet * dt
			end
			
			if data.health < 0 then
				v:destroy()
				data.alive = false
				love.audio.play(pick_random(sfx.explosion))
			end
			
			if math.abs(data.wet) > cHumansJumpOutOfTheWindowThreshold and 
				math.random() < cHumansJumpOutOfTheWindowProb and
				not v:isDestroyed()
			then
				local x, y = v:getPosition()
				
				local body = love.physics.newBody(self.world, x, y, "dynamic")
				local data = {}
				data.type = "human"
				data.age = 0
				body:setUserData(data)
				local shape = love.physics.newCircleShape(4)
				local fixture = love.physics.newFixture(body, shape)
				local power = 5 + math.random() * 5
				local angle = math.random() * math.pi * 2
				body:applyLinearImpulse(
					math.cos(angle) * power,
					math.sin(angle) * power)
					
				body:applyTorque((0.5 - math.random() * 2) * 2 * math.pi)
			end
		end
	end
	
	self.timelimit = self.timelimit - dt	
	if not self.gameOver and self.timelimit < 0 then
		self.gameOver = true
		self.blocksDestroyed = self.blockCount - self:countBlocks()
		if self.blocksDestroyed >= self.blockCount * cDestroyNecessaryFactor then
			self.winner = false
			wins.fire = wins.fire + 1
		else
			self.winner = true
			wins.water = wins.water + 1
		end
	end
end

function World:loadGfx()
	self.partice00Img = love.graphics.newImage("gfx/particle-0-0.png")
	self.partice01Img = love.graphics.newImage("gfx/particle-0-1.png")
	self.partice02Img = love.graphics.newImage("gfx/particle-0-2.png")
	self.partice03Img = love.graphics.newImage("gfx/particle-0-3.png")
	self.partice04Img = love.graphics.newImage("gfx/particle-0-4.png")
	self.partice10Img = love.graphics.newImage("gfx/particle-1-0.png")
	self.partice11Img = love.graphics.newImage("gfx/particle-1-1.png")
	self.partice12Img = love.graphics.newImage("gfx/particle-1-2.png")
	self.partice13Img = love.graphics.newImage("gfx/particle-1-3.png")
	self.partice14Img = love.graphics.newImage("gfx/particle-1-4.png")
	self.partice00Quad = love.graphics.newQuad(0, 0, self.partice00Img:getWidth(), self.partice00Img:getHeight(), self.partice00Img:getWidth(), self.partice00Img:getHeight())
	self.partice01Quad = love.graphics.newQuad(0, 0, self.partice01Img:getWidth(), self.partice01Img:getHeight(), self.partice01Img:getWidth(), self.partice01Img:getHeight())
	self.partice02Quad = love.graphics.newQuad(0, 0, self.partice02Img:getWidth(), self.partice02Img:getHeight(), self.partice02Img:getWidth(), self.partice02Img:getHeight())
	self.partice03Quad = love.graphics.newQuad(0, 0, self.partice03Img:getWidth(), self.partice03Img:getHeight(), self.partice03Img:getWidth(), self.partice03Img:getHeight())
	self.partice04Quad = love.graphics.newQuad(0, 0, self.partice04Img:getWidth(), self.partice04Img:getHeight(), self.partice04Img:getWidth(), self.partice04Img:getHeight())
	self.partice10Quad = love.graphics.newQuad(0, 0, self.partice10Img:getWidth(), self.partice10Img:getHeight(), self.partice10Img:getWidth(), self.partice10Img:getHeight())
	self.partice11Quad = love.graphics.newQuad(0, 0, self.partice11Img:getWidth(), self.partice11Img:getHeight(), self.partice11Img:getWidth(), self.partice11Img:getHeight())
	self.partice12Quad = love.graphics.newQuad(0, 0, self.partice12Img:getWidth(), self.partice12Img:getHeight(), self.partice12Img:getWidth(), self.partice12Img:getHeight())
	self.partice13Quad = love.graphics.newQuad(0, 0, self.partice13Img:getWidth(), self.partice13Img:getHeight(), self.partice13Img:getWidth(), self.partice13Img:getHeight())
	self.partice14Quad = love.graphics.newQuad(0, 0, self.partice14Img:getWidth(), self.partice14Img:getHeight(), self.partice14Img:getWidth(), self.partice14Img:getHeight())	
	
	self.imgHuman = love.graphics.newImage("gfx/human.png")
	self.quadHuman = love.graphics.newQuad(0, 0, self.imgHuman:getWidth(), self.imgHuman:getHeight(), self.imgHuman:getWidth(), self.imgHuman:getHeight())
end


function World:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.background)
	
	for i, v in pairs(self.objects) do
		v:draw()
	end
	for i, v in pairs(self.players) do
		v:draw()
	end
	
	local bodies = self.world:getBodyList()
	for i,v in pairs(bodies) do
		local data = v:getUserData()
		
		if data ~= nil and data.type == "human" then
			local x, y = v:getPosition()
			local angle = v:getAngle()
			
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(self.imgHuman, self.quadHuman, 
				x, 
				y,
				angle,
				1,1,
				self.imgHuman:getWidth()/2,
				self.imgHuman:getHeight()/2)
		end
		
		if data ~= nil and data.type == "shot" then
			local quad = nil
			local img = nil
			if data.water then
				if data.age <= cShotTick then
					img = self.partice10Img
					quad = self.partice10Quad
				elseif data.age <= 2 * cShotTick then
					img = self.partice11Img
					quad = self.partice11Quad
				elseif data.age <= 3 * cShotTick then
					img = self.partice12Img
					quad = self.partice12Quad
				elseif data.age <= 4 * cShotTick then
					img = self.partice13Img
					quad = self.partice13Quad
				else --if data.age <= 5 * cShotTick then
					img = self.partice14Img
					quad = self.partice14Quad
				end
			else
				if data.age <= cShotTick then
					img = self.partice00Img
					quad = self.partice00Quad
				elseif data.age <= 2 * cShotTick then
					img = self.partice01Img
					quad = self.partice01Quad
				elseif data.age <= 3 * cShotTick then
					img = self.partice02Img
					quad = self.partice02Quad
				elseif data.age <= 4 * cShotTick then
					img = self.partice03Img
					quad = self.partice03Quad
				else --if data.age <= 5 * cShotTick then
					img = self.partice04Img
					quad = self.partice04Quad
				end
			end
			local x, y = v:getPosition()
			
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(img, quad, x - img:getWidth()/2, y - img:getHeight()/2)
		end
	end
  gameInterface:draw()
end

function World:keyreleased(key)
	for i, v in pairs(self.players) do
		v:keyreleased(key)
	end
end

function World:keypressed(key, scancode, isrepeat)
	for i, v in pairs(self.players) do
		v:keypressed(key, scancode, isrepeat)
	end
end

function World:getTimeLeft()
	return round(self.timelimit, 2)
end

function World:setBlockCount()
	self.blockCount = self:countBlocks()
end

function World:countBlocks()
	local count = 0
	local bodies = self.world:getBodyList()
	for i,v in pairs(bodies) do
		local data = v:getUserData()
		if data ~= nil and data.type == "block" then
			count = count + 1
		end
	end
	return count
end

function World:getWinner()
  return self.winner
end

function World:getDestroyedBlocks()
  return self.blockCount - self:countBlocks()
end

function World:getGameStatusFunction()
  return function() return {
      ["remainingTime"] = self:getTimeLeft(),
      ["gameOver"] = self:getTimeLeft()<=0,
      ["winner"] = self:getWinner(),
      ["blocksDestroyed"] = self:getDestroyedBlocks(),
      ["blockCount"] = self.blockCount,
      ["winsFire"] = wins.fire,
      ["winsWater"] = wins.water,
      } end
end
