matrix = {
  mul = function(matr1, matr2)
    local matrF = {}
    for i=1,#matr1 do
      matrF[i] = {}
      for j=1,#matr2[1] do
        matrF[i][j] = matr1[i][1]*matr2[1][j]
        for n=2,#matr2 do
          matrF[i][j] = matrF[i][j] + matr1[i][n]*matr2[n][j]
        end
      end
    end
    return matrF
  end,
}

action = {
  move = function(obj, l, m, n)
    local l = l or 0
    local m = m or 0
    local n = n or 0
    local matr2 = {}
    matr2[1] = {}
    matr2[2] = {}
    matr2[3] = {}
    matr2[4] = {}
    matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 1, 0, 0, 0
    matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 1, 0, 0
    matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0, 0, 1, 0
    matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = l, m, n, 1
    return matrix.mul(obj.matr, matr2)
  end,
  rotate = function(obj, axis, deg, l, m, n)
    local l = l or 0
    local m = m or 0
    local n = n or 0
    obj.matr = action.move(obj, -l, -m, -n)
    local rad = deg*math.pi/180
    local matr2 = {}
    matr2[1] = {}
    matr2[2] = {}
    matr2[3] = {}
    matr2[4] = {}
    if axis == 'x' then
      matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 1, 0, 0, 0
      matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, math.cos(rad), math.sin(rad), 0
      matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0, -math.sin(rad), math.cos(rad), 0
      matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    end
    if axis == 'y' then
      matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = math.cos(rad), 0, -math.sin(rad), 0
      matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 1, 0, 0
      matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = math.sin(rad), 0, math.cos(rad), 0
      matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    end
    if axis == 'z' then
      matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = math.cos(rad), math.sin(rad), 0, 0
      matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = -math.sin(rad), math.cos(rad), 0, 0
      matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0, 0, 1, 0
      matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    end
    obj.matr = matrix.mul(obj.matr, matr2)
    return action.move(obj, l, m, n)
  end,
  scale = function(obj, s)
    local matr2 = {}
    matr2[1] = {}
    matr2[2] = {}
    matr2[3] = {}
    matr2[4] = {}
    matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 1, 0, 0, 0
    matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 1, 0, 0
    matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0, 0, 1, 0
    matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, s
    return matrix.mul(obj, matr2)
  end,
  apply = function(obj)
    for k,v in pairs(obj.points) do
      v.x = obj.matr[k][1]
      v.y = obj.matr[k][2]
      v.z = obj.matr[k][3]
    end
    for k,v in pairs(obj.points) do
      v.x = v.x/(obj.p*v.x + obj.q*v.y + obj.r*v.z + obj.s)
      v.y = v.y/(obj.p*v.x + obj.q*v.y + obj.r*v.z + obj.s)
      v.z = v.z/(obj.p*v.x + obj.q*v.y + obj.r*v.z + obj.s)
    end
    obj.x = (obj.points[1].x + obj.points[7].x)/2
    obj.y = (obj.points[1].y + obj.points[7].y)/2
    obj.z = (obj.points[1].z + obj.points[7].z)/2
  end,
  projection = function(obj, plane)
    local matr2 = {}
    local axisMove = {}
    matr2[1] = {}
    matr2[2] = {}
    matr2[3] = {}
    matr2[4] = {}
    if plane == 'xz' then
      axisMove.x, axisMove.y, axisMove.z = 0, obj.y, 0
      matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 1, 0, 0, 0
      matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 0, 0, 0
      matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0, -1, 1, 0
      matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    elseif plane == 'xy' then
      axisMove.x, axisMove.y, axisMove.z = 0, 0, obj.z
      matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 1, 0, 0, 0
      matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 1, 0, 0
      matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = 0, 0, 0, 0
      matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    elseif plane == 'yz' then
      axisMove.x, axisMove.y, axisMove.z = obj.x, 0, 0
      matr2[1][1], matr2[1][2], matr2[1][3], matr2[1][4] = 0, 0, 0, 0
      matr2[2][1], matr2[2][2], matr2[2][3], matr2[2][4] = 0, 1, 0, 0
      matr2[3][1], matr2[3][2], matr2[3][3], matr2[3][4] = -1, 0, 1, 0
      matr2[4][1], matr2[4][2], matr2[4][3], matr2[4][4] = 0, 0, 0, 1
    end
    obj.matr = matrix.mul(obj.matr, matr2)
    return action.move(obj, axisMove.x, axisMove.y, axisMove.z)
  end,
}

function table.ifInsert(tabl, value) --вставить в таблицу, если этого объекта там ещё нет
  for k,v in pairs(tabl) do
    if v == value then
      return
    end
  end
  tabl[#tabl + 1] = value
end

function math.maxInTabl(tabl, key, start)
  local start = start or 1
  local max = start
  for i=start+1,#tabl do
    if tabl[max][key] < tabl[i][key] then
      max = i
    end
  end
  return max
end

function math.minInTabl(tabl, key, start)
  local start = start or 1
  local min = start
  for i=start+1,#tabl do
    if tabl[min][key] > tabl[i][key] then
      max = i
    end
  end
  return min
end

function table.exchange(tabl, k1, k2)
  local temp = tabl[k1]
  tabl[k1] = tabl[k2]
  tabl[k2] = temp
  return tabl
end

geometry = {
  lineVSline = function(a, b, c, d)
    return geometry.intersect(a.x, b.x, c.x, d.x)
    		and geometry.intersect(a.y, b.y, c.y, d.y)
    		and geometry.area(a,b,c) * geometry.area(a,b,d) <= 0
    		and geometry.area(c,d,a) * geometry.area(c,d,b) <= 0;
  end,
  intersect = function(a, b, c, d)
    if (a > b) then
      local temp = a
      a = b
      b = temp
    end
    if (c > d) then
      local temp = c
      c = d
      d = temp
    end
    return math.max(a, c) <= math.min(b, d);
  end,
  area = function(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
  end,
  pointsInFigure = function(points)
    --функция находит середину по Y точек и сортирует по X сначало верхнюю сторону, в после сортирует по x на убывание нижнюю, таким образом образуя контур
    --local points = {...}
    local figure = {}

    local minY = 1
    for i=2,#points,2 do
      if points[minY] > points[i] then
        minY = i
      end
    end
    local maxY = 1
    for i=2,#points,2 do
      if points[maxY] < points[i] then
        maxY = i
      end
    end
    local centerY = (points[minY]+points[maxY])/2
    local tempUP = {}
    local tempDOWN = {}
    for i=2,#points,2 do
      if points[i] <= centerY then
        table.insert(tempUP, i-1)
      else
        table.insert(tempDOWN, i-1)
      end
    end

    while #tempUP > 1 do
      local min = 1
      for i=1,#tempUP do
        if points[tempUP[min]] > points[tempUP[i]] then
          min = i
        elseif points[tempUP[min]] == points[tempUP[i]] then
          if points[tempUP[min]+1] > points[tempUP[i]+1] then
            min = i
          end
        end
      end
      table.insert(figure, tempUP[min])
      table.remove(tempUP, min)
    end
    table.insert(figure, tempUP[1])

    while #tempDOWN > 1 do
      local max = 1
      for i=1,#tempDOWN do
        if points[tempDOWN[max]] < points[tempDOWN[i]] then
          max = i
        elseif points[tempDOWN[max]] == points[tempDOWN[i]] then
          if points[tempDOWN[max]+1] < points[tempDOWN[i]+1] then
            max = i
          end
        end
      end
      table.insert(figure, tempDOWN[max])
      table.remove(tempDOWN, max)
    end
    table.insert(figure, tempDOWN[1])

    local finalPoints = {}
    for i=1,#figure do
      finalPoints[i*2-1] = points[figure[i]]
      finalPoints[i*2] = points[figure[i]+1]
    end
    return finalPoints
  end,
}

-- for k,v in pairs(self.points) do
--   local found = false
--   if v.x == points[1] and v.y == points[2] then
--     found = true
--   end
--   if not found then
--     for i=3,#points,2 do
--       local p = (v.x - points[i])/(points[i-2] - points[i]) --уровнение прямой, мать его
--       if p*points[i-1]+(1-p)*points[i+1] == v.y then -- если точка лежит на прямой
--         found = true
--         break
--       end
--     end
--   end
--   if not found then
--     table.insert(points, v.x)
--     table.insert(points, v.y)
--   end
-- end
