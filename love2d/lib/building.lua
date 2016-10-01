class "Building" {
	x = 0;
	y = 0;
}

function Building:__init(world, x, y, height)
	self.world = world
	self.blocks = {};
	
	for i = 1, height do
		local block = {}

		block.variant = math.random(0, 2)
		block.body = love.physics.newBody(self.world.world, x, self.world.screenHeight - i * self.world.blockHeight - y, "dynamic")
		block.shape = love.physics.newRectangleShape(self.world.blockWidth, self.world.blockHeight)
		block.fixture = love.physics.newFixture(block.body, block.shape)
		
		table.insert(self.blocks, block)
	end
end

function Building:update(dt)
	
end

function Building:draw()
	love.graphics.setColor(127, 127, 127)

	for i, v in pairs(self.blocks) do
		self.world.blocksQuad:setViewport(v.variant * self.world.blockWidth, 0, self.world.blockWidth, self.world.blockHeight)
		love.graphics.draw(self.world.blocksImg, self.world.blocksQuad, v.body:getX(), v.body:getY())
	end
end