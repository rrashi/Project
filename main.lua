--Indie Runner Game

--Based on "Pong" written by Colton Ogden 
--cogden@cs50.harvard.edu
--https://github.com/games50/pong


--https://github.com/Ulydev/push/blob/master/push.lua
push = require 'push'

---- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'
require 'Girlie'
require 'Building'

BACKGROUND = love.graphics.newImage("Images/buildings.png")
BACKGROUND_X = 0
BACKGROUND_SPEED = 300
BACKGROUND_LOOPING_POINT = 898

--virtual width and virtual height
VIRTUAL_W = 900
VIRTUAL_H = 600

--window width and window height
WINDOW_W = 1280
WINDOW_H = 720

--varying speeds of the buildings which will be randomly assigned at certain time intervals
BUILDING_SCROLL_SPEEDS = {150, 175, 225, 250, 275, 320, 350}
CURRENT_BUILDING_SPEED = 200

HORIZONTAL_MOVEMENT = true -- true if girlie is not restricted in horizontal movement because of building
VERTICAL_MOVEMENT = true -- true if girlie is not restricted in vertical movement (falling) because of building


local girlie = Girlie(0, (WINDOW_H - GIRLIE_IMAGE:getHeight()))
local buildings = {}
local next_pos = VIRTUAL_W-- to keep track of the x position of each next building
local building_spawn_timer = 0
local building_speed_timer = 0
local score = 0
local scoreFont 
local gameOver = false
local fall = true;

math.randomseed(os.time()) 

-- loads screen initially
function love.load()
  
 --seeds according to current time
love.graphics.setDefaultFilter("nearest", "nearest")

push:setupScreen(VIRTUAL_W, VIRTUAL_H, WINDOW_W, WINDOW_H, {
    fullscreen = false,
    resizable = true,
    vsync = true,
    canvas = false,
  }) -- external class used to setup screen over window

love.keyboard.keysPressed = {} -- a table to keep track of a key pressed

scoreFont = love.graphics.newFont('font.ttf', 48)
end

-- function called when a key is pressed
function love.keypressed(key)
  love.keyboard.keysPressed[key] = true --sets certain key's value to true in table
  
  if key == 'escape' then
    love.event.quit()
  end 
end

-- user defined function in love.keyboard that keeps track of all keys pressed yet
function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end


-- renders screen
function love.draw()
  push:start() 
  
  love.graphics.setFont(scoreFont)
    
  love.graphics.draw(BACKGROUND, -BACKGROUND_X, 0)
  girlie:render()
  
  for k, building in ipairs(buildings) do
    building:render()
  end
  
  if gameOver == true then
  love.graphics.print("GAME OVER", VIRTUAL_W/2-125, VIRTUAL_H/2)
  end
  
  love.graphics.print(girlie.score, VIRTUAL_W - 70, 40)
  
 push:finish()

end
function love.update(dt)
  
if girlie.x < -girlie.width then
    gameOver = true
  end

building_speed_timer = building_speed_timer + dt

--randomized building speeds after specific interval of time
if building_speed_timer > 5 then
  select = math.random(1,7)
  CURRENT_BUILDING_SPEED = BUILDING_SCROLL_SPEEDS[select]
  building_speed_timer = 0
  end
  
BACKGROUND_X = (BACKGROUND_X + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT
  
  building_spawn_timer = building_spawn_timer + dt
  --spawns building at certain intervals of time
  if building_spawn_timer > 2.5 then 
     table.insert(buildings, Building((VIRTUAL_W+math.random(50, 100)), math.random(VIRTUAL_H/2 + 50, VIRTUAL_H - 50)))
     building_spawn_timer = 0
    end 
     
  for k, building in ipairs(buildings) do
    
    if girlie:collide(building) then
      girlie.obstructed = true
      gameOver = true
    end
    
    if not building.passed then
     if building.x + building.width < girlie.x then
       building.passed = true
       girlie.score = girlie.score + 1
      end
    end
    
    building:update(dt)
    if(building.x < (0- BUILDING_IMAGE:getWidth()))then
      table.remove(buildings, k)
    end
  end
  
  girlie:update(dt)
  love.keyboard.keysPressed = {} -- flushes table so that only a single key is stored at once
    
end



function love.resize(w, h)
  push:resize(w, h)
end








  
  


