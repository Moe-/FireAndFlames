class "Building" {
	x = 0;
	y = 0;
	blocks = {};
}

function Building:__init(world, x, y, height)
	for i = 1, height do
		local block = {}

		block.body = love.physics.newBody(world.world, x, world.screenHeight - i * 32 - y, "dynamic")
		block.shape = love.physics.newRectangleShape(32, 32)
		block.fixture = love.physics.newFixture(block.body, block.shape)
		
		table.insert(self.blocks, block)
	end
end

function Building:update(dt)
	
end

function Building:draw()
	love.graphics.setColor(127, 127, 127)

	for i, v in pairs(self.blocks) do
		love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
	end
end