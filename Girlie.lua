Girlie = Class{}

GIRLIE_IMAGE = love.graphics.newImage("girlie.png")
GRAVITY = 12
JUMP = 150

-- Constructor to initialize girlie object
-- x, y = coordinates, dx, dy = horizontal and vertical velocities
function Girlie:init (x, y)
  self.x = x
  self.y = y
  self.dy = 0
  self.dx = 20
  self.width = GIRLIE_IMAGE:getWidth()
  self.height = GIRLIE_IMAGE:getHeight()
  self.obstructed = false
end

-- updates girlie character through call from main
function Girlie:update(dt)
  if self.obstructed == false then 
   if love.keyboard.wasPressed('right') then
    self.x = self.x + self.dx
  end
  
  if love.keyboard.wasPressed('left') then
    self.x = self.x - self.dx
  end

  
  if love.keyboard.wasPressed('up') then
    self.y = self.y - JUMP
  end
  
-- if girlie is in air, applies graviy 
-- otherwise resets her position to original ground
  if self.y < (VIRTUAL_H - GIRLIE_IMAGE:getHeight() - 10) then
      self.dy = self.dy + GRAVITY * dt 
      self.y = self.y + self.dy
    else
      self.y = VIRTUAL_H - GIRLIE_IMAGE:getHeight()
      self.dy = 0
  end
else
  self.x = self.x -(BUILDING_SCROLL * dt)
end

end

function Girlie:collide(building)
  if self.x + self.width - 50 > building.x and
     self.x < building.x + building.width then
       return true
     end
end
  
-- renders girlie on screen at x, y
function Girlie:render()
  love.graphics.draw(GIRLIE_IMAGE, self.x, self.y)
end



  

