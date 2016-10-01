class "World" {
	screenWidth = 0;
	screenHeight = 0;
	offsetx = 0;
	offsety = 0;
}

function World:__init(width, height)
	screenWidth = width;
	screenHeight = height;
	self.objects = {}
end

function World:update(dt)
	for i, v in pairs(self.objects) do
		v:update(dt)
	end
end

function World:draw()
	for i, v in pairs(self.objects) do
		v:draw(self.offsetx, self.offsety)
	end
end
