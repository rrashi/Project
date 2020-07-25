push = require 'push'
Class = require 'class'
require 'Girlie'
require 'Building'

BACKGROUND = love.graphics.newImage("buildings.png")
BACKGROUND_X = 0
BACKGROUND_SPEED = 300
BACKGROUND_LOOPING_POINT = 898

VIRTUAL_W = 900
VIRTUAL_H = 600

CLOUDS = love.graphics.newImage("clouds.png")
CLOUDS_SPEED = 20
CLOUDS_X = VIRTUAL_W
CLOUDS_Y = CLOUDS:getHeight()- 50

WINDOW_W = 1280
WINDOW_H = 720


BUILDING_SCROLL = 250

HORIZONTAL_MOVEMENT = true -- true if girlie is not restricted in horizontal movement because of building
VERTICAL_MOVEMENT = true -- true if girlie is not restricted in vertical movement (falling) because of building

local girlie = Girlie(0, (WINDOW_H - GIRLIE_IMAGE:getHeight()))
local buildings = {}
local next_pos = VIRTUAL_W-- to keep track of the x position of each next building
local timer = 0
local score = 0
local scoreFont 


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
  
  love.graphics.draw(BACKGROUND, -BACKGROUND_X, 0)
  girlie:render()
  
  for k, building in ipairs(buildings) do
    building:render()
  end
  
  love.graphics.setFont(scoreFont)
  
  love.graphics.print(girlie.score, VIRTUAL_W - 70, 40)
 
 push:finish()

end
function love.update(dt)

BACKGROUND_X = (BACKGROUND_X + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT
  
  timer = timer + dt
  if timer > 2.5 then 
     table.insert(buildings, Building((VIRTUAL_W+math.random(50, 100)), math.random(VIRTUAL_H/2 + 50, VIRTUAL_H - 50)))
     timer = 0
    end 
     
  for k, building in ipairs(buildings) do
    
    if girlie:collide(building) then
      girlie.obstructed = true
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






  
  


