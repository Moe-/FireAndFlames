class "World" {
	screenWidth = 0;
	screenHeight = 0;
	offsetx = 0;
	offsety = 0;
}

function World:__init(width, height)
	self.screenWidth = width;
	self.screenHeight = height;
	self.objects = {}

	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81 * 64, true)

	self.ground = {}
	self.ground.body = love.physics.newBody(self.world, self.screenWidth * 0.5, self.screenHeight - 16)
	self.ground.shape = love.physics.newRectangleShape(self.screenWidth, 32)
	self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)

	self.players = {}
	table.insert(self.players, Player:new(false, 25, 500))
	table.insert(self.players, Player:new(true, 25, 500))
end

function World:update(dt)
	self.world:update(dt)
	
	for i, v in pairs(self.objects) do
		v:update(dt)
	end
end

function World:draw()
	love.graphics.setColor(0, 255, 0)
	love.graphics.polygon("fill", self.ground.body:getWorldPoints(self.ground.shape:getPoints()))

	for i, v in pairs(self.objects) do
		v:draw(self.offsetx, self.offsety)
	end
end
