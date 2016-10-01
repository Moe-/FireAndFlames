class "Building" {
	x = 0;
	y = 0;
}

function Building:__init(world, x, y, height)
	self.world = world
	self.blocks = {};
	
	for i = 1, height do
		local block = {}

		block.type = "block"
		block.health = 100
		block.wet = 0
		block.alive = true
		block.variant = math.random(0, 2)
		block.body = love.physics.newBody(self.world.world, x, self.world.screenHeight - i * self.world.blockHeight - y, "dynamic")
		block.shape = love.physics.newRectangleShape(self.world.blockWidth, self.world.blockHeight)
		block.fixture = love.physics.newFixture(block.body, block.shape)
		
		block.body:setUserData(block)
		block.data = block.body:getUserData()
		
		table.insert(self.blocks, block)
	end
end

function Building:update(dt)
	
end

function Building:draw()
	for i, v in pairs(self.blocks) do
		if v.data.alive then
			self.world.blocksQuad:setViewport(v.variant * self.world.blockWidth, (4 - math.ceil(v.data.health / 25)) * self.world.blockHeight, self.world.blockWidth, self.world.blockHeight)
			love.graphics.draw(self.world.blocksImg, self.world.blocksQuad, v.body:getX(), v.body:getY(), v.body:getAngle(), 1, 1, self.world.blockWidth * 0.5, self.world.blockHeight * 0.5)
		end
	end
	
	for i, v in pairs(self.blocks) do
		if v.data.alive then
			if v.data.wet > 25 or v.data.wet < -33 then
				if v.data.wet > 0 then
					self.world.effectQuad:setViewport(0 * self.world.effectWidth, (4 - math.ceil(v.data.wet / 33)) * self.world.effectHeight, self.world.effectWidth, self.world.effectHeight)
					love.graphics.draw(self.world.effectImg, self.world.effectQuad, v.body:getX(), v.body:getY() - 8, v.body:getAngle(), 1, 1, self.world.effectWidth * 0.5, self.world.effectHeight * 0.5)
				else
					self.world.effectQuad:setViewport(0 * self.world.effectWidth, (2 + math.floor(-v.data.wet / 25)) * self.world.effectHeight, self.world.effectWidth, self.world.effectHeight)
					love.graphics.draw(self.world.effectImg, self.world.effectQuad, v.body:getX(), v.body:getY() - 56, v.body:getAngle(), 1, 1, self.world.effectWidth * 0.5, self.world.effectHeight * 0.5)
				end
			end
		end
	end
end