--[[--
  # 2D vector

  The vector is immutable when used through this API. It is highly discouraged
  to change a vector in place as this may break future code.

  Simple usage example:

    local v = lug.V2(3, 4)
    print(v:norm())
    --> 5

    -- Access x component can be done with #x method or `[1]`.
    print(v[1], v:x())
    --> 2  2

    -- Add two vectors
    print(v + lug.V2(2, 1))
    --> (5 5)

--]]--
local lib = class 'lug.V2'

-- # Constructor

-- Create a vector with the corresponding components.
--
--   -- Create new vector from two numbers.
--   local v = lug.V2(0.5, 12)
-- 
-- ## Conversion
--
-- With a single argument, `lug.V2` returns a vector by copying the first
-- two values of the argument (`[]` accessor). This enables easy transformation
-- from other vectors such as lug.V3 or lug.V4.
--
--   -- Copy x and y values from a lug.V3.
--   local v2 = lug.V2(v3)
function lib.new(x, y) 
  local self
  if y then
    self = {x, y}  
  else
    self = {x[1], x[2]}
  end
  return setmetatable(self, lib)
end
local new = lib.new

-- A unit vector with [math]\theta[/math] polar coordinate.
function lib.polarUnit(theta) return new(math.cos(theta), math.sin(theta)) end

-- # Constants 

-- Vector `(0, 0)`.
function lib.zero() return new(0, 0) end

-- Unit vector `(1, 0)`.
function lib.ox() return new(1, 0) end

-- Unit vector `(0, 1)`.
function lib.oy() return new(0, 1) end

-- A vector whose components are `math.huge`.
function lib.huge() return new(math.huge, math.huge) end

-- A vector whose components are `-math.huge`.
function lib.negHuge() return new(-math.huge, -math.huge) end

-- # Accessors

-- Get `x` component. Also supported as `v[1]` which is faster.
function lib:x() return self[1] end

-- Get `y` component. Also supported as `v[2]` which is faster.
function lib:y() return self[2] end

-- Get `x, y` components as tuple.
function lib:tuple() return self[1], self[2] end

-- A textual representation of the vector.
function lib:tostring() return string.format("(%g %g)", self[1], self[2]) end

-- # Functions
--
-- Functions #neg, #add, #sub and #smul are also accessible through operators:
--
--   local v  = lug.V2(1,2)
--   local nv = -v
--   local w  = v + nv
--   local n  = 4 * v
--   local m  = v * 3

-- Inverse vector [math]-\mathbf{v}[/math].
function lib.neg(v) return new(-v[1], -v[2]) end

-- Add two vectors: [math]\mathbf{u} + \mathbf{v}[/math].
function lib.add(u, v) return new(u[1] + v[1], u[2] + v[2]) end

-- Subtract two vectors: [math]\mathbf{u} - \mathbf{v}[/math].
function lib.sub(u, v) return new(u[1] - v[1], u[2] - v[2]) end

-- Component wise multiplication: [math](\ \mathbf{u}_x \mathbf{v}_x,\ \ \mathbf{u}_y \mathbf{v}_y\ )[/math].
function lib.mul(u, v) return new(u[1] * v[1], u[2] * v[2]) end

-- Component wise division: [math](\ \mathbf{u}_x / \mathbf{v}_x,\ \ \mathbf{u}_y / \mathbf{v}_y\ )[/math].
function lib.div(u, v) return new(u[1] / v[1], u[2] / v[2]) end

-- Scalar multiplication: [math]s\mathbf{v}[/math].
function lib.smul(s, v)
  if type(v) == 'number' then
    return new(v * s[1], v * s[2])
  else
    return new(s * v[1], s * v[2])
  end
end

-- Half vector: [math]\mathbf{v} / 2[/math].
function lib.half(v) return new(0.5 * v[1], 0.5 * v[2]) end

-- Dot product: [math]\mathbf{u}\cdot\mathbf{v}[/math].
function lib.dot(u, v) return u[1] * v[1] + u[2] * v[2] end

-- Norm: [math]|\mathbf{v}|[/math].
function lib.norm(v) return math.sqrt (v[1] * v[1] + v[2] * v[2]) end

-- Squared norm: [math]|\mathbf{v}|^2[/math].
function lib.norm2(v) return v[1] * v[1] + v[2] * v[2] end

-- Unit vector: [math]\mathbf{v}/|\mathbf{v}|[/math].
function lib.unit(v) return lib.smul(1 / lib.norm(v), v) end

-- Rotated vector by [math]\pi/2[/math].
function lib.ortho(v) return  new(-v[2], v[1]) end

-- Linear interpolation [math]\mathbf{u} + t(\mathbf{v}-\mathbf{u})[/math].
function lib.mix(u, v, t) 
  return new(u[1] + t * (v[1] - u[1]), u[2] + t * (v[2] - u[2]))
end


-- # Taversal

-- Map coordinates wifh `f` function: [math](\ f(\mathbf{v}_x),\ \ f(\mathbf{v}_y)\ )[/math].
function lib.map(v, f) return new(f(v[1]), f(v[2])) end

-- Map coordinates with `f` function passing i: [math](\ f(1,\mathbf{v}_x),\ \ f(2,\mathbf{v}_y)\ )[/math].
function lib.mapi(v, f) return new(f(1, v[1]), f(2, v[2])) end

-- Fold vector coordinates with accumulator `acc`: [math]f(f(acc, \mathbf{v}_x), \mathbf{v}_y)[/math].
function lib.fold(v, acc, f)  return f(f(acc, v[1]), v[2]) end

-- Fold vector coordinates with accumulator `acc` and index: [math]f(f(acc, 1, \mathbf{v}_x), 2, \mathbf{v}_y)[/math].
function lib.foldi(v, acc, f) return f(f(acc, 1, v[1]), 2, v[2]) end

-- Iterator against coordinate values: [math]f(\mathbf{v}_x);\ f(\mathbf{v}_y)[/math].
-- If no `f` function is passed, the iterator is expected to be used in a
-- *for* loop:
--
--   for c in v:iter() do
--     -- do something with coordinate value c
--   end
function lib.iter(v, f)
  if f then
    f(v[1]); f(v[2])
  else
    local i = 0
    return function()
      i = i + 1
      if i <= 2 then return v[i] end
    end
  end
end

-- Iterator against coordinate values with index: [math]f(1, \mathbf{v}_x);\ f(1, \mathbf{v}_y)[/math].
-- If no `f` function is passed, the iterator is expected to be used in a
-- *for* loop:
--
--   for i, c in v:iteri() do
--     -- do something with index i and coordinate value c
--   end
function lib.iteri(v, f)
  if f then
    f(1, v[1]); f(2, v[2])
  else
    local i = 0
    return function()
      i = i + 1
      if i <= 2 then return i, v[i] end
    end
  end
end


-- # Predicates

-- True if all [math]p(v_i)[/math] are true: [math]p(\mathbf{v}_x) \land p(\mathbf{v}_y)[/math].
function lib.forAll(v, p) return p(v[1]) and p(v[2]) end

-- True if any [math]p(v_i)[/math] is true: [math]p(\mathbf{v}_x) \lor p(\mathbf{v}_y)[/math]
function lib.exists(v, p) return p(v[1]) or p(v[2]) end

-- True if `u` and `v` are equal component wise: [math]\mathbf{u}_x = \mathbf{v}_x \land \mathbf{u}_y = \mathbf{v}_y[/math]
--
-- If `eq` function is provided, it is used to evaluate equality.
function lib.eq(u, v, eq) 
  if eq then return eq(u[1], v[1]) and eq(u[2], v[2])
  else return u[1] == v[1] and u[2] == v[2] end
end

-- True if `u` is lower then `v` component wise: [math]\mathbf{u}_x < \mathbf{v}_x \land \mathbf{u}_y < \mathbf{v}_y[/math]
--
-- If `lt` function is provided, it is used as comparison function.
function lib.lt(u, v, lt) 
  if lt then return lt(u[1], v[1]) and lt(u[2], v[2])
  else return u[1] < v[1] and u[2] < v[2] end
end

-- True if `u` is lower or equal to `v` component wise: [math]\mathbf{u}_x \leq \mathbf{v}_x \land \mathbf{u}_y \leq \mathbf{v}_y[/math]
--
-- If `le` function is provided, it is used as comparison function.
function lib.le(u, v, le) 
  if le then return le(u[1], v[1]) and le(u[2], v[2])
  else return u[1] <= v[1] and u[2] <= v[2] end
end

-- Compare two vectors and return:
--
-- + `-1`: if [math]\mathbf{u}_x < \mathbf{v}_x \lor (\mathbf{u}_x = \mathbf{v}_x \land \mathbf{u}_y < \mathbf{v}_y)[/math]
-- + `0`: if [math]\mathbf{u}_x = \mathbf{v}_x \land \mathbf{u}_y = \mathbf{v}_y[/math]
-- + `1`: if [math]\mathbf{u}_x > \mathbf{v}_x \lor (\mathbf{u}_x = \mathbf{v}_x \land \mathbf{u}_y > \mathbf{v}_y)[/math]
--
-- If `cmp` function is provided, it is used as comparison function (should return -1, 0, 1).
function lib.compare(u, v, cmp)
  local cmp = cmp or function (a, b) if a < b then return -1 
                                     elseif a > b then return 1 
                                     else return 0 end
                     end
  local c 
  c = cmp(u[1], v[1]) if c ~= 0 then return c end
  -- u[1] == v[1]
  c = cmp(u[2], v[2]) return c
end


-- # Operators

-- Inverse vector [math]-\mathbf{v}[/math].
lib.__unm = lib.neg

-- Add two vectors: [math]\mathbf{u} + \mathbf{v}[/math].
lib.__add = lib.add

-- Subtract two vectors: [math]\mathbf{u} - \mathbf{v}[/math].
lib.__sub = lib.sub

-- Scalar multiplication: [math]s\mathbf{v}[/math].
lib.__mul = lib.smul

-- A textual representation of the vector. Used in `print(v)` for example.
lib.__tostring = lib.tostring

-- Component wise equality
lib.__eq = lib.eq

-- Same as #lt.
lib.__lt = lib.lt

-- Same as #le.
lib.__le = lib.le

