require("lib/postshader")
require("utils")
require("player")
require("world")
require("lib/building")

gWorld = nil

function init()
	gWorld = World:new(800,600)
	
	gBuilding = {}
	
	math.randomseed(1)
	
	for i = 1, 10 do
		gBuilding[i] = Building:new(gWorld, 100 + i * 50, 32, math.random(2, 7))
	end
end

function love.load()
	init()
end

function love.update(dt)
	gWorld:update(dt)
end

function love.draw()
	gWorld:draw()
	
	for i = 1, 10 do
		gBuilding[i]:draw()
	end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
		gWorld:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
	gWorld:keyreleased(key)
end

function love.textinput(text)

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end

function love.wheelmoved(x, y)

end
