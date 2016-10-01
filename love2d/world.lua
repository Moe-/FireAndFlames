class "World" {
	screenWidth = 0;
	screenHeight = 0;
}

function World:__init(width, height)
	screenWidth = width;
	screenHeight = height;
	self.objects = {}

	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81 * 64, true)

	self.ground = {}
	self.ground.body = love.physics.newBody(self.world, screenWidth * 0.5, screenHeight - 16) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	self.ground.shape = love.physics.newRectangleShape(screenWidth, 32) --make a rectangle with a width of 650 and a height of 50
	self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape) --attach shape to body

	self.players = {}
	table.insert(self.players, Player:new(false, 25, 500))
	table.insert(self.players, Player:new(true, 25, 500))
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
	love.graphics.setColor(0, 255, 0)
	love.graphics.polygon("fill", self.ground.body:getWorldPoints(self.ground.shape:getPoints()))

	for i, v in pairs(self.objects) do
		v:draw()
	end
	for i, v in pairs(self.players) do
		v:draw()
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
