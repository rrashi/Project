Building = Class{}

BUILDING_IMAGE = love.graphics.newImage("single_building.png")

function  Building:init(x, y)
  self.x = x
  self.y = y
  self.width = BUILDING_IMAGE:getWidth()
  self.height = BUILDING_IMAGE:getHeight()
end

function Building:render()
  love.graphics.draw(BUILDING_IMAGE, self.x, self.y)
end

function Building:update(dt)
  self.x = self.x - (BUILDING_SCROLL * dt)
  end
  