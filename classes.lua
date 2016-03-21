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
    -- local points = {}
    -- for k,v in pairs(self.points) do
    --   table.insert(points, v.x)
    --   table.insert(points, v.y)
    -- end
    love.graphics.setColor(0, 0, 255)
    love.graphics.polygon('fill', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y)
    love.graphics.polygon('fill', self.points[5].x, self.points[5].y, self.points[6].x, self.points[6].y, self.points[7].x, self.points[7].y, self.points[8].x, self.points[8].y)
    love.graphics.polygon('fill', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[6].x, self.points[6].y, self.points[5].x, self.points[5].y)
    love.graphics.polygon('fill', self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[7].x, self.points[7].y, self.points[6].x, self.points[6].y)
    love.graphics.polygon('fill', self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y, self.points[8].x, self.points[8].y, self.points[7].x, self.points[7].y)
    love.graphics.polygon('fill', self.points[4].x, self.points[4].y, self.points[1].x, self.points[1].y, self.points[5].x, self.points[5].y, self.points[8].x, self.points[8].y)
    love.graphics.setColor(0, 255, 0)
    love.graphics.polygon('line', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y)
    love.graphics.polygon('line', self.points[5].x, self.points[5].y, self.points[6].x, self.points[6].y, self.points[7].x, self.points[7].y, self.points[8].x, self.points[8].y)
    love.graphics.polygon('line', self.points[1].x, self.points[1].y, self.points[2].x, self.points[2].y, self.points[6].x, self.points[6].y, self.points[5].x, self.points[5].y)
    love.graphics.polygon('line', self.points[2].x, self.points[2].y, self.points[3].x, self.points[3].y, self.points[7].x, self.points[7].y, self.points[6].x, self.points[6].y)
    love.graphics.polygon('line', self.points[3].x, self.points[3].y, self.points[4].x, self.points[4].y, self.points[8].x, self.points[8].y, self.points[7].x, self.points[7].y)
    love.graphics.polygon('line', self.points[4].x, self.points[4].y, self.points[1].x, self.points[1].y, self.points[5].x, self.points[5].y, self.points[8].x, self.points[8].y)
    --love.graphics.line(points)
	end,
}
