require("lib/postshader")
require("utils")
require("world")

gWorld = nil

function init()
	gWorld = World:new(800,600)
end

function love.load()
	init()
end

function love.update(dt)
	gWorld:update(dt)
end

function love.draw()
	gWorld:draw()
end

function love.keypressed(key, scancode, isrepeat)

end

function love.keyreleased(key)

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
