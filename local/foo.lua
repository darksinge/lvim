local _ = require('neodash')

local addThreeNumbers = function(a, b, c)
  return a + b + c
end

local curriedSum = _.curryN(addThreeNumbers, 3)
-- print(curriedSum(1)(2)(3))
--

P(_.table_pack('a', 'b', 'c').n)
