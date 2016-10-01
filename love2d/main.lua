require("lib/postshader")
require("utils")
require("player")
require("world")
require("lib/building")
require("game_interface")

gWorld = nil

function init()
	gWorld = World:new(800,600)
	
	gBuilding = {}
	
	math.randomseed(4)
	
	for i = 1, 6 do
		gBuilding[i] = Building:new(gWorld, 200 + i * 50, 100, math.random(4, 8))
	end
  gameInterface = GameInterface:new()
end

function love.load()
	init()
end

function love.update(dt)
	gWorld:update(dt)
end

function love.draw()
	gWorld:draw()
	
	for i = 1, 6 do
		gBuilding[i]:draw()
	end
  gameInterface:draw()
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

function beginContact(a, b, coll)

end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end