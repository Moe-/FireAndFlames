require("lib/postshader")
require("utils")
require("player")
require("world")
require("lib/building")
require("game_interface")

-- one shots
sfx = {}
sfx.blockFallImpack = {
	love.audio.newSource("sfx/block_fall_impact.wav"), 
}
sfx.explosion = {
	love.audio.newSource("sfx/explosion.wav"), 
}
sfx.fireImpact = {
	love.audio.newSource("sfx/fire_impact-001.wav"), 
	love.audio.newSource("sfx/fire_impact-002.wav"), 
	love.audio.newSource("sfx/fire_impact-003.wav"), 
}
sfx.waterImpact = {
	love.audio.newSource("sfx/water_impact-001.wav"), 
	love.audio.newSource("sfx/water_impact-002.wav"), 
	love.audio.newSource("sfx/water_impact-003.wav"), 
}
-- loops
sfx.fireLoop = love.audio.newSource("sfx/fire_loop.wav")
sfx.waterLoop = love.audio.newSource("sfx/water_loop.wav")

gWorld = nil

function init()
	gWorld = World:new(800,600)
	
	gBuilding = {}
	
	math.randomseed(4)
	
	for i = 1, 6 do
		gBuilding[i] = Building:new(gWorld, 200 + i * 50, 80, math.random(4, 8))
	end
	
	gWorld:setBlockCount()
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
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "t" then
			init()
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
		if d1.type == "shot" and d2.type == "block" then
			local b1_dummy = b1
			local d1_dummy = d1
			
			b1 = b2
			d1 = d2
			
			b2 = b1_dummy
			d2 = d1_dummy
		end
		
		if d1.type == "block" and d2.type == "shot" then
			if d2.water then
				if d1.wet < 100 then
					d1.wet = d1.wet + 10
				end
			else
				if d1.wet > 0 then
					d1.wet = d1.wet - 10
				else
					if d1.wet > -100 then
						d1.wet = d1.wet - 10
					end
					d1.health = d1.health - 10
				end
			end

			b1:setUserData(d1)
			
			if d1.health <= 0 then
				b1:destroy()
				d1.data.alive = false
			end
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
