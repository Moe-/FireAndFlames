class "World" {
	screenWidth = 0;
	screenHeight = 0;
}

function World:__init(width, height)
	self.screenWidth = width;
	self.screenHeight = height;
	self.background = love.graphics.newImage("gfx/background.png")
	self.blockWidth = 48;
	self.blockHeight = 48;
	self.blocksImg = love.graphics.newImage("gfx/blocks.png")
	self.blocksQuad = love.graphics.newQuad(0, 0, self.blockWidth, self.blockHeight, self.blocksImg:getWidth(), self.blocksImg:getHeight())
	
	self.objects = {}

	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81 * 64, true)
	self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	self.ground = {}
	self.ground.body = love.physics.newBody(self.world, self.screenWidth * 0.5, self.screenHeight - 24)
	self.ground.shape = love.physics.newRectangleShape(self.screenWidth * 2, 32)
	self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)

	self.players = {}
	table.insert(self.players, Player:new(false, 25, 525, self.world))
	table.insert(self.players, Player:new(true, 675, 525, self.world))
end

function World:update(dt)
	self.world:update(dt)
	
	for i, v in pairs(self.objects) do
		v:update(dt)
	end
	for i, v in pairs(self.players) do
		v:update(dt)
	end
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
		if data ~= nil and data.type == "shot" then
			if data.water then
				love.graphics.setColor(0, 0, 255)
			else
				love.graphics.setColor(255, 0, 0)
			end
			local x, y = v:getPosition()
			love.graphics.circle("fill", x, y, cShotRadius, 15)
		end
	end
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
