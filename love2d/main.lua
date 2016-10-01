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
		gBuilding[i] = Building:new(gWorld, 200 + i * 50, 80, math.random(4, 8))
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
	local b1 = a:getBody()
	local b2 = b:getBody()
	
	local d1 = b1:getUserData()
	local d2 = b2:getUserData()
	
	if d1 and d2 then
		if d1.type == "block" and d2.type == "shot" then
			d1.health = d1.health - 10
			b1:setUserData(d1)
			
			if d1.health <= 0 then
				b1:destroy()
				d1.data.alive = false
			end
		end

		if d2.type == "block" and d1.type == "shot" then
			print("lol")
		end
	end
	
	if d1 and d1.type == "shot" then
		b1:destroy()
	end
	
	if d2 and d2.type == "shot" then
		b2:destroy()
	end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end