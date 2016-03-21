require('classes')
require('common')

function love.load()
  local x = love.graphics.getWidth()/2
  local y = love.graphics.getHeight()/2
  cube = body:new(x, y, 1, 50, 50, 50)
  ismove = false
end


function love.update(dt)
  if isRotate then
    cube.matr = action.rotate(cube, 'y', love.mouse.getX() - mouseX, cube.x, cube.y, cube.z)
    cube.matr = action.rotate(cube, 'x', mouseY - love.mouse.getY(), cube.x, cube.y, cube.z)
    action.apply(cube)
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    -- isRotate = false
  elseif isMove then
    cube.matr = action.move(cube, love.mouse.getX() - mouseX, love.mouse.getY() - mouseY)
    action.apply(cube)
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    -- isMove = false
  end
end


function love.mousepressed(x, y, button)
  if button == 1 then
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    isRotate = true
  else
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    isMove = true
  end
end


function love.mousereleased( x, y, button )
  if button == 1 then
    isRotate = false
  else
    isMove = false
  end
end


function love.draw()
  cube:draw()
end
