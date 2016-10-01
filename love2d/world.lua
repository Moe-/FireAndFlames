class "World" {
	screenWidth = 0;
	screenHeight = 0;
}

function World:__init(width, height)
	screenWidth = width;
	screenHeight = height;
	self.objects = {}
	self.players = {}
	table.insert(self.players, Player:new(false, 25, 500))
	table.insert(self.players, Player:new(true, 25, 500))
end

function World:update(dt)
	for i, v in pairs(self.objects) do
		v:update(dt)
	end
	for i, v in pairs(self.players) do
		v:update(dt)
	end
end

function World:draw()
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
