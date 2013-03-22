--[[--
# V2 test
--]]--

require 'lubyk'
local should = test.Suite 'lug.V2'
local V2 = lug.V2

function should.autoload()
  assertType('table', V2)
end

function should.createUnitFromPolar()
end

function should.haveZeroConstant()
  local v = V2.zero()
  assertEqual(0, v[1])
  assertEqual(0, v[2])
end

function should.haveOxConstant()
  local v = V2.ox()
  assertEqual(1, v[1])
  assertEqual(0, v[2])
end

function should.haveOyConstant()
  local v = V2.oy()
  assertEqual(0, v[1])
  assertEqual(1, v[2])
end

function should.haveHugeConstant()
  local v = V2.huge()
  assertEqual(math.huge, v[1])
  assertEqual(math.huge, v[2])
end

function should.haveNegHugeConstant()
  local v = V2.negHuge()
  assertEqual(-math.huge, v[1])
  assertEqual(-math.huge, v[2])
end

function should.respondToNew()
  local u = V2(1, 2)
  local v = V2.new(1, 2)
  assertValueEqual(u, v)
  assertEqual('lug.V2', u.type)
  assertEqual('lug.V2', v.type)
end

function should.respondToPolarUnit()
  local a = math.pi / 3
  local v = V2.polarUnit(a)
  assertValueEqual({math.cos(a), math.sin(a)}, v)
end

function should.respondToX()
  local v = V2(1, 2)
  assertEqual(1, v:x())
end

function should.respondToY()
  local v = V2(1, 2)
  assertEqual(2, v:y())
end

function should.respondToArrayAccess()
  local v = V2(1, 2)
  assertEqual(1, v[1])
  assertEqual(2, v[2])
end

function should.respondToTuple()
  local v = V2(1, 2)
  local a, b = v:tuple()
  assertEqual(1, a)
  assertEqual(2, b)
end

function should.respondToTostring()
  local v = V2(1, 2)
  assertEqual('(1 2)', v:tostring())
end

function should.respondToNeg()
  local v = V2(1, 2)
  assertValueEqual({-1, -2}, V2.neg(v))
end

function should.respondToAdd()
  local u = V2(2, -1)
  local v = V2(1, 2)
  assertValueEqual({3, 1}, V2.add(u, v))
end

function should.respondToSub()
  local u = V2(2, -1)
  local v = V2(1, 2)
  assertValueEqual({1, -3}, V2.sub(u, v))
end

function should.respondToMul()
  local u = V2(2, -1)
  local v = V2(1, 2)
  assertValueEqual({2, -2}, V2.mul(u, v))
end

function should.respondToDiv()
  local u = V2(2, -1)
  local v = V2(1, 4)
  assertValueEqual({2, -0.25}, V2.div(u, v))
end

function should.respondToSmul()
  local v = V2(1, 2)
  assertValueEqual({5, 10}, V2.smul(v, 5))
end

function should.respondToHalf()
  local v = V2(1, 2)
  assertValueEqual({0.5, 1}, V2.half(v))
end

function should.respondToDot()
  local u = V2(1, 2)
  local v = V2(3, 5)
  assertEqual(13, V2.dot(u, v))
end

function should.respondToNorm()
  local v = V2(3, 4)
  assertEqual(5, v:norm())
end

function should.respondToNorm2()
  local v = V2(3, 4)
  assertEqual(25, v:norm2())
end

function should.respondToUnit()
  local v = V2(3, 4)
  assertValueEqual({3/5, 4/5}, V2.unit(v), 10e-14)
end

function should.respondToHomogene()
  local v = V2(1, 2)
  -- TODO
end

function should.respondToOrtho()
  local v = V2(1, 2)
  assertValueEqual({-2, 1}, V2.ortho(v))
end

function should.respondToMix()
  local u = V2(1, 1)
  local v = V2(1, 2)
  assertValueEqual({1, 5}, V2.mix(u, v, 4))
end

function should.respondToMap()
  local v = V2(1, 2)
  local r = {}
  assertValueEqual(r, V2.map(v, function(val)
    local s = math.random()
    table.insert(r, s + val)
    return s + val
  end))
end

function should.respondToMapi()
  local v = V2(1, 2)
  local r = {4, 7}
  assertValueEqual({5, 9}, V2.mapi(v, function(i, val)
    return val + r[i]
  end))
end

function should.respondToFold()
  local v = V2(1, 2)
  assertEqual(103, V2.fold(v, 100, function(acc, val)
    return acc + val
  end))
end

function should.respondToFoldi()
  local v = V2(10, 20)
  assertEqual(133, V2.foldi(v, 100, function(i, acc, val)
    return acc + i + val
  end))
end

function should.respondToIter()
  local v = V2(1, 2)
  local s = 0
  V2.iter(v, function(val)
    s = s + val
  end)
  assertEqual(3, s)

  -- "for" loop version
  s = 0
  for val in v:iter() do
    s = s + val
  end
  assertEqual(3, s)
end

function should.respondToIteri()
  local v = V2(1, 3)
  local s = 0
  V2.iteri(v, function(i, val)
    s = s + val * i
  end)
  assertEqual(7, s)

  -- "for" loop version
  s = 0
  for i, val in v:iteri() do
    s = s + val * i
  end
  assertEqual(7, s)
end

function should.respondToForAll()
  local v = V2(1, 2)
  assertTrue(v:forAll(function(val) return val >= 1 end))
  assertFalse(v:forAll(function(val) return val >= 2 end))
end

function should.respondToExists()
  local v = V2(1, 2)
  assertTrue(v:exists(function(val) return val > 1 end))
  assertFalse(v:exists(function(val) return val > 2 end))
end

function should.respondToEq()
  local v = V2(1, 2)
  local u = V2(1, 2)
  local w = V2(1, 1)
  assertTrue(V2.eq(u, v))
  assertFalse(V2.eq(u, w))
end

function should.respondToLt()
  local v = V2(1, 2)
  local u = V2(-1, 0.5)
  assertTrue(V2.lt(u, v))
  assertFalse(V2.lt(v, u))
  assertFalse(V2.lt(v, v))
end

function should.respondToLe()
  local v = V2(1, 2)
  local u = V2(-1, 0.5)
  assertTrue( V2.le(u, v))
  assertFalse(V2.le(v, u))
  assertTrue( V2.le(v, v))
end

function should.respondToCompare()
  assertEqual(-1, V2.compare(V2(0, 0), V2(1, 2)))
  assertEqual(-1, V2.compare(V2(0, 500), V2(1, 2)))
end

function should.respondTo__tostring()
  local v = V2(1, 2)
  assertEqual('(1 2)', tostring(v))
end

function should.respondTo__add()
  local u = V2(2, -1)
  local v = V2(1, 2)
  assertValueEqual({3, 1}, u + v)
end

function should.respondTo__sub()
  local u = V2(2, -1)
  local v = V2(1, 2)
  assertValueEqual({1, -3}, u - v)
end

function should.respondTo__mul()
  local v = V2(1, 2)
  assertValueEqual({5, 10}, 5 * v)
  assertValueEqual({5, 10}, v * 5)
end

function should.respondTo__lt()
  local v = V2(1, 2)
  local u = V2(-1, 0.5)
  assertTrue(u < v)
  assertFalse(u > v)
  assertFalse(v < v)
end

function should.respondTo__le()
  local v = V2(1, 2)
  local u = V2(-1, 0.5)
  assertTrue(u <= v)
  assertFalse(u >= v)
  assertTrue(v <= v)
end

function should.respondTo__eq()
  local v = V2(1, 2)
  local u = V2(1, 2)
  local w = V2(1, 1)
  assertTrue(u == v)
  assertFalse(w == v)
end

function should.respondTo__unm()
  local v = V2(1, 2)
  assertValueEqual({-1, -2}, -v)
end

test.all()
