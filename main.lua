require('classes')
require('common')

function love.load()
  local x = love.graphics.getWidth()/2
  local y = love.graphics.getHeight()/2
  cube = body:new(x, y, 1, 50, 50, 100)
  ismove = false

  ball = sphere:new(100, 100, 1, 50)
end


function love.update(dt)
  if isRotate then
    cube.matr = action.rotate(cube, 'y', love.mouse.getX() - mouseX, cube.x, cube.y, cube.z)
    cube.matr = action.rotate(cube, 'x', mouseY - love.mouse.getY(), cube.x, cube.y, cube.z)
    action.apply(cube)

    ball.matr = action.rotate(ball, 'y', love.mouse.getX() - mouseX, ball.x, ball.y, ball.z)
    ball.matr = action.rotate(ball, 'x', mouseY - love.mouse.getY(), ball.x, ball.y, ball.z)
    action.apply(ball)

    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    -- isRotate = false
  elseif isMove then
    cube.matr = action.move(cube, love.mouse.getX() - mouseX, love.mouse.getY() - mouseY)
    action.apply(cube)

    ball.matr = action.move(ball, love.mouse.getX() - mouseX, love.mouse.getY() - mouseY)
    action.apply(ball)

    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    -- isMove = false
  end
end


function love.mousepressed(x, y, button)
  if button == 1 then

    -- local figure = geometry.pointsInFigure(3,0, 3,2, 1,2, 1,0, 4,1, 0,1, 2,2, 2,0)
    -- for i=1,#figure do
    --   print(figure[i])
    -- end

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

function love.keyreleased(key)
  if key=="t" then
    local matr2 = {}
    matr2[1] = {}
    matr2[2] = {}
    matr2[3] = {}
    matr2[4] = {}
    matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 0.925820, 0.133631, -0.353553, 0
    matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 0.935414, 0.353553, 0
    matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0.377964, -0.327321, 0.866025, 0
    matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    cube.matr = matrix.mul(cube.matr, matr2)
    action.apply(cube)
  elseif key=="q" then
    local matr2 = {}
    matr2[1] = {}
    matr2[2] = {}
    matr2[3] = {}
    matr2[4] = {}
    matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 1, 0, 0, 0
    matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 1, 0, 0
    matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0, 0, 1, 0
    matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    cube.s = 2
    cube.matr = matrix.mul(cube.matr, matr2)
    action.apply(cube)
  elseif key=="f" then
    --сортировка по z
    local n = 1
    for i=n,#cube.points-1 do
      local max = math.maxInTabl(cube.points, 'z', n)
      cube.points = table.exchange(cube.points, max, n)
      n = n + 1
    end
    --создание прорисовываемых точек
    cube.drawPoints={}
    table.insert(cube.drawPoints, cube.points[1].x)
    table.insert(cube.drawPoints, cube.points[1].y)
    table.insert(cube.drawPoints, cube.points[2].x)
    table.insert(cube.drawPoints, cube.points[2].y)
    table.insert(cube.drawPoints, cube.points[3].x)
    table.insert(cube.drawPoints, cube.points[3].y)
    max = math.maxInTabl(cube.points, 'x')
    i = 4
  elseif key=='g' then
print(#cube.points, i)
      local painting = true
      for j=1,#cube.drawPoints-2,2 do
        if geometry.lineVSline({x = cube.points[i].x, y = cube.points[i].y}, {x = cube.points[max].x+5, y = cube.points[i].y}, {x = cube.drawPoints[j], y = cube.drawPoints[j+1]}, {x = cube.drawPoints[j+2], y = cube.drawPoints[j+3]}) then
          painting = not painting
          print(painting)
        end
      end
      if geometry.lineVSline({x = cube.points[i].x, y = cube.points[i].y}, {x = cube.points[max].x+5, y = cube.points[i].y}, {x = cube.drawPoints[#cube.drawPoints-1], y = cube.drawPoints[#cube.drawPoints]}, {x = cube.drawPoints[1], y = cube.drawPoints[2]}) then
        painting = not painting
        print(painting)
      end
      if painting then
        table.insert(cube.drawPoints, cube.points[i].x)
        table.insert(cube.drawPoints, cube.points[i].y)
      end
      print()
      print(painting)
      cube.drawPoints = geometry.pointsInFigure(cube.drawPoints)
      -- for i=1,#points,2 do
      --   print(cube.drawPoints[i], cube.drawPoints[i+1])
      -- end
      cube.line = {cube.points[i].x, cube.points[i].y, cube.points[max].x+5, cube.points[i].y}
      i = i + 1

  end

end

function love.draw()
  cube:draw()

  ball:draw()
end
