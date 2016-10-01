require("lib/postshader")
require("utils")
require("player")
require("world")

gWorld = nil

function init()
	gWorld = World:new(800,600)
end

function love.load()
	init()
end

function love.update(dt)

end

function love.draw()

end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
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
