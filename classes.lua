body = {
  new = function(self, x, y, z, xs, ys, zs, h)
    local h = h or 1
    local ys = ys or xs
    local zs = zs or ys or xs
		local tabl = {}
		setmetatable(tabl, self)
		self.__index = self
    tabl.points = {}
    tabl.x, tabl.y, tabl.z, tabl.xs, tabl.ys, tabl.zs, tabl.h = x, y, z, xs, ys, zs, h
    table.insert(tabl.points, {x = x - xs, y = y + ys, z = z - zs, h = h})
    table.insert(tabl.points, {x = x + xs, y = y + ys, z = z - zs, h = h})
    table.insert(tabl.points, {x = x + xs, y = y + ys, z = z + zs, h = h})
    table.insert(tabl.points, {x = x - xs, y = y + ys, z = z + zs, h = h})
    table.insert(tabl.points, {x = x - xs, y = y - ys, z = z - zs, h = h})
    table.insert(tabl.points, {x = x + xs, y = y - ys, z = z - zs, h = h})
    table.insert(tabl.points, {x = x + xs, y = y - ys, z = z + zs, h = h})
    table.insert(tabl.points, {x = x - xs, y = y - ys, z = z + zs, h = h})
    --[костыль] полигоны, которые должны формироваться оавтомически
    tabl.polygons = {}
    table.insert(tabl.polygons, {tabl.points[1].x, tabl.points[1].y, tabl.points[2].x, tabl.points[2].y, tabl.points[3].x, tabl.points[3].y, tabl.points[4].x, tabl.points[4].y})
    table.insert(tabl.polygons, {tabl.points[5].x, tabl.points[5].y, tabl.points[6].x, tabl.points[6].y, tabl.points[7].x, tabl.points[7].y, tabl.points[8].x, tabl.points[8].y})
    table.insert(tabl.polygons, {tabl.points[1].x, tabl.points[1].y, tabl.points[2].x, tabl.points[2].y, tabl.points[6].x, tabl.points[6].y, tabl.points[5].x, tabl.points[5].y})
    table.insert(tabl.polygons, {tabl.points[2].x, tabl.points[2].y, tabl.points[3].x, tabl.points[3].y, tabl.points[7].x, tabl.points[7].y, tabl.points[6].x, tabl.points[6].y})
    table.insert(tabl.polygons, {tabl.points[3].x, tabl.points[3].y, tabl.points[4].x, tabl.points[4].y, tabl.points[8].x, tabl.points[8].y, tabl.points[7].x, tabl.points[7].y})
    table.insert(tabl.polygons, {tabl.points[4].x, tabl.points[4].y, tabl.points[1].x, tabl.points[1].y, tabl.points[5].x, tabl.points[5].y, tabl.points[8].x, tabl.points[8].y})

    tabl.matr = {}
    for k,v in pairs(tabl.points) do
      tabl.matr[k] = {}
      tabl.matr[k][1], tabl.matr[k][2], tabl.matr[k][3], tabl.matr[k][4] = v.x, v.y, v.z, v.h
    end
    tabl.p = 0 -- координата плоскости, на которую производится проекция
    tabl.q = 0 -- 2 координата плоскости, на которую производится проекция
    tabl.r = 0 -- 3 координата плоскости, на которую производится проекция
    tabl.s = 1 -- масштаб
		return tabl
	end,
  draw = function(self)


    -- копирование self.points в self.pointsZ, чтобы points не сортировалось по z, чтобы структура полигонов не нарушалась
    self.pointsZ = {}
    for k,v in pairs(self.points) do
      self.pointsZ[k] = {}
      for k2,v2 in pairs(v) do
        self.pointsZ[k][k2] = v2
      end
    end
    --сортировка self.pointsZ по z
    local n = 1
    for i=n,#self.pointsZ-1 do
      local max = math.maxInTabl(self.pointsZ, 'z', n)
      self.pointsZ = table.exchange(self.pointsZ, max, n)
      n = n + 1
    end
    --создание прорисовываемых точек
    self.drawPoints={}
    table.insert(self.drawPoints, self.pointsZ[1].x)
    table.insert(self.drawPoints, self.pointsZ[1].y)
    table.insert(self.drawPoints, self.pointsZ[2].x)
    table.insert(self.drawPoints, self.pointsZ[2].y)
    table.insert(self.drawPoints, self.pointsZ[3].x)
    table.insert(self.drawPoints, self.pointsZ[3].y)
    max = math.maxInTabl(self.pointsZ, 'x')

    --создание контура и проверка всех точек фигуры, принадлежат ли они этому контуру (если нет, то добавление их в контур)
    for i=4,#self.pointsZ do
      local painting = true
      for j=1,#self.drawPoints-2,2 do
        -- функция проверки перемечения отрезков.
        -- из точки проводится луч из искомой точки за пределы фигуры и проверяется, пересекает ли он какое-либо ребро контура (если пересекает четное кол-во раз - то точка не лежит в контуре)
        if geometry.lineVSline({x = self.pointsZ[i].x, y = self.pointsZ[i].y}, {x = self.pointsZ[max].x+5, y = self.pointsZ[i].y}, {x = self.drawPoints[j], y = self.drawPoints[j+1]}, {x = self.drawPoints[j+2], y = self.drawPoints[j+3]}) then
          painting = not painting
        end
      end
      -- проверка отрезка, соеденяющего последнюю точку и первую
      if geometry.lineVSline({x = self.pointsZ[i].x, y = self.pointsZ[i].y}, {x = self.pointsZ[max].x+5, y = self.pointsZ[i].y}, {x = self.drawPoints[#self.drawPoints-1], y = self.drawPoints[#self.drawPoints]}, {x = self.drawPoints[1], y = self.drawPoints[2]}) then
        painting = not painting
      end
      --добавление точки в "рисованные"
      if painting then
        table.insert(self.drawPoints, self.pointsZ[i].x)
        table.insert(self.drawPoints, self.pointsZ[i].y)
      end
      -- сортировка точек таким образом, чтобы они состовляли правильный контур
      self.drawPoints = geometry.pointsInFigure(self.drawPoints)
    end

    ----[костыль] полигоны, которые должны формироваться оавтомически
    self.polygons = {}
    table.insert(self.polygons, {self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y})
    table.insert(self.polygons, {self.points[5].x, self.points[5].y, self.points[6].x, self.points[6].y, self.points[7].x, self.points[7].y, self.points[8].x, self.points[8].y})
    table.insert(self.polygons, {self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[6].x, self.points[6].y, self.points[5].x, self.points[5].y})
    table.insert(self.polygons, {self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[7].x, self.points[7].y, self.points[6].x, self.points[6].y})
    table.insert(self.polygons, {self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y, self.points[8].x, self.points[8].y, self.points[7].x, self.points[7].y})
    table.insert(self.polygons, {self.points[4].x, self.points[4].y, self.points[1].x, self.points[1].y, self.points[5].x, self.points[5].y, self.points[8].x, self.points[8].y})
    --проверки, если все точки полигона также принадлежат таблице drawPoints, то полигон рисуется
    for k,v in pairs(self.polygons) do
      local sovpadenie = 0
      for i=1,#v,2 do
        for j=1,#self.drawPoints,2 do
          if v[i] == self.drawPoints[j] and v[i+1] == self.drawPoints[j+1] then
            sovpadenie = sovpadenie + 1
            break
          end
        end
      end
      if sovpadenie == 4 then
          love.graphics.setColor(0, 0, 255)
          love.graphics.polygon('fill', v)
          love.graphics.setColor(0, 255, 0)
          love.graphics.polygon('line', v)
      end
    end

-- love.graphics.setColor(0, 255, 255)
-- love.graphics.line(self.points[4].x, self.points[4].y, self.points[max].x+5, self.points[4].y)
    -- for k,v in pairs(self.polygons) do
    --   for i=1,#v,2 do
    --     print(v[i], self.points[min].x)
    --     if v[i] == self.points[min].x and v[i+1] == self.points[min].y then
    --       love.graphics.setColor(0, 0, 255)
    --       love.graphics.polygon('fill', v)
    --       love.graphics.setColor(0, 255, 0)
    --       love.graphics.polygon('line', v)
    --       break
    --     end
    --   end
    -- end

-- if self.drawPoints == nil then
-- love.graphics.setColor(255, 0, 0)
--     love.graphics.polygon('fill', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y)
--     love.graphics.polygon('fill', self.points[5].x, self.points[5].y, self.points[6].x, self.points[6].y, self.points[7].x, self.points[7].y, self.points[8].x, self.points[8].y)
--     love.graphics.polygon('fill', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[6].x, self.points[6].y, self.points[5].x, self.points[5].y)
--     love.graphics.polygon('fill', self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[7].x, self.points[7].y, self.points[6].x, self.points[6].y)
--     love.graphics.polygon('fill', self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y, self.points[8].x, self.points[8].y, self.points[7].x, self.points[7].y)
--     love.graphics.polygon('fill', self.points[4].x, self.points[4].y, self.points[1].x, self.points[1].y, self.points[5].x, self.points[5].y, self.points[8].x, self.points[8].y)
--     love.graphics.setColor(0, 255, 0)
--     love.graphics.polygon('line', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y)
--     love.graphics.polygon('line', self.points[5].x, self.points[5].y, self.points[6].x, self.points[6].y, self.points[7].x, self.points[7].y, self.points[8].x, self.points[8].y)
--     love.graphics.polygon('line', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[6].x, self.points[6].y, self.points[5].x, self.points[5].y)
--     love.graphics.polygon('line', self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[7].x, self.points[7].y, self.points[6].x, self.points[6].y)
--     love.graphics.polygon('line', self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y, self.points[8].x, self.points[8].y, self.points[7].x, self.points[7].y)
--     love.graphics.polygon('line', self.points[4].x, self.points[4].y, self.points[1].x, self.points[1].y, self.points[5].x, self.points[5].y, self.points[8].x, self.points[8].y)
--   end
--
--   if self.line then
--     love.graphics.setColor(255, 0, 0)
--     love.graphics.line(self.line)
--   end
    --love.graphics.line(points)
	end,
}

sphere = {
  new = function(self, x, y, z, r, h)
    local h = h or 1
		local tabl = {}
		setmetatable(tabl, self)
		self.__index = self
    tabl.x, tabl.y, tabl.z, tabl.r, tabl.h = x, y, z, r, h

    tabl.points = {}
    table.insert(tabl.points, {x = x, y = y - r, z = z, h = h})
    for i=-r, r, 5 do
      local Ox = i
      local Oy = math.sqrt(r^2-Ox^2)
      table.insert(tabl.points, {x = Ox+x, y = -Oy+y, z = z, h = h})
      table.insert(tabl.points, {x = Ox+x, y = Oy+y, z = z, h = h})
    end
    local nPoints = math.floor(#tabl.points/2)-1
    for i=2,nPoints do
      local Or = x - tabl.points[i].x
      for j=-Or, Or, 5 do
        local Oz = j
        local Ox = math.sqrt(Or^2-Oz^2)
        table.insert(tabl.points, {x = -Ox+x, y = tabl.points[i].y, z = Oz+z, h = h})
        table.insert(tabl.points, {x = Ox+x, y = tabl.points[i].y, z = Oz+z, h = h})
      end
    end

    tabl.matr = {}
    for k,v in pairs(tabl.points) do
      tabl.matr[k] = {}
      tabl.matr[k][1], tabl.matr[k][2], tabl.matr[k][3], tabl.matr[k][4] = v.x, v.y, v.z, v.h
    end
    tabl.p = 0 -- координата плоскости, на которую производится проекция
    tabl.q = 0 -- 2 координата плоскости, на которую производится проекция
    tabl.r = 0 -- 3 координата плоскости, на которую производится проекция
    tabl.s = 1 -- масштаб
		return tabl
	end,
  draw = function(self)
    -- копирование self.points в self.pointsZ, чтобы points не сортировалось по z, чтобы структура полигонов не нарушалась
    self.pointsZ = {}
    for k,v in pairs(self.points) do
      self.pointsZ[k] = {}
      for k2,v2 in pairs(v) do
        self.pointsZ[k][k2] = v2
      end
    end
    --сортировка self.pointsZ по z
    local n = 1
    for i=n,#self.pointsZ-1 do
      local max = math.maxInTabl(self.pointsZ, 'z', n)
      self.pointsZ = table.exchange(self.pointsZ, max, n)
      n = n + 1
    end
    --создание прорисовываемых точек
    self.drawPoints={}
    table.insert(self.drawPoints, self.pointsZ[1].x)
    table.insert(self.drawPoints, self.pointsZ[1].y)
    table.insert(self.drawPoints, self.pointsZ[2].x)
    table.insert(self.drawPoints, self.pointsZ[2].y)
    table.insert(self.drawPoints, self.pointsZ[3].x)
    table.insert(self.drawPoints, self.pointsZ[3].y)
    max = math.maxInTabl(self.pointsZ, 'x')

    --создание контура и проверка всех точек фигуры, принадлежат ли они этому контуру (если нет, то добавление их в контур)
    for i=4,#self.pointsZ do
    local painting = true
    for j=1,#self.drawPoints-2,2 do
      -- функция проверки перемечения отрезков.
      -- из точки проводится луч из искомой точки за пределы фигуры и проверяется, пересекает ли он какое-либо ребро контура (если пересекает четное кол-во раз - то точка не лежит в контуре)
      if geometry.lineVSline({x = self.pointsZ[i].x, y = self.pointsZ[i].y}, {x = self.pointsZ[max].x+5, y = self.pointsZ[i].y}, {x = self.drawPoints[j], y = self.drawPoints[j+1]}, {x = self.drawPoints[j+2], y = self.drawPoints[j+3]}) then
        painting = not painting
      end
    end
    -- проверка отрезка, соеденяющего последнюю точку и первую
    if geometry.lineVSline({x = self.pointsZ[i].x, y = self.pointsZ[i].y}, {x = self.pointsZ[max].x+5, y = self.pointsZ[i].y}, {x = self.drawPoints[#self.drawPoints-1], y = self.drawPoints[#self.drawPoints]}, {x = self.drawPoints[1], y = self.drawPoints[2]}) then
      painting = not painting
    end
    --добавление точки в "рисованные"
    if painting then
      table.insert(self.drawPoints, self.pointsZ[i].x)
      table.insert(self.drawPoints, self.pointsZ[i].y)
    end
    -- сортировка точек таким образом, чтобы они состовляли правильный контур
    self.drawPoints = geometry.pointsInFigure(self.drawPoints)
    end




    love.graphics.setColor(255, 255, 255)
    -- for k,v in pairs(self.points) do
    --   love.graphics.points(v.x, v.y)
    -- end
    love.graphics.points(self.drawPoints)
  end,
}
