require("lib/postshader")
require("utils")
require("player")
require("world")
require("lib/building")

gWorld = nil

function init()
	gWorld = World:new(800,600)
	
	gBuilding1 = Building:new(gWorld, 200, 32, 3)
	gBuilding2 = Building:new(gWorld, 250, 32, 5)
	gBuilding3 = Building:new(gWorld, 300, 32, 4)
end

function love.load()
	init()
end

function love.update(dt)
	gWorld:update(dt)
end

function love.draw()
	gWorld:draw()
	gBuilding1:draw()
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
