-- Copyright 2023-2024 Mitchell. See LICENSE.

local re = require('regex')

local function assert_equal(v1, v2)
	if v1 == v2 then return end
	if type(v1) == 'table' and type(v2) == 'table' then
		if #v1 == #v2 then
			for k, v in pairs(v1) do if v2[k] ~= v then goto continue end end
			for k, v in pairs(v2) do if v1[k] ~= v then goto continue end end
			return
		end
		::continue::
		v1 = string.format('{%s}', table.concat(v1, ', '))
		v2 = string.format('{%s}', table.concat(v2, ', '))
	end
	error(string.format('%s ~= %s', v1, v2), 2)
end

local function assert_raises(f, expected_err)
	local ok, err = pcall(f)
	if ok then error('error expected', 2) end
	if expected_err ~= err and not tostring(err):find(expected_err, 1, true) then
		error(string.format('error message %q expected, was %q', expected_err, err), 2)
	end
end

local find = {{'foo', 'o'}, {'foo', 'o', 2}, {'foo', 'o(o)', 2}, {'foo', '(.)(.)(.)'}, {'foo', 'b'}}
for i, args in ipairs(find) do
	assert_equal({re.find(table.unpack(args))}, {string.find(table.unpack(args))})
end

assert_raises(function() re.find(true) end, 'string expected')
assert_raises(function() re.find('foo', true) end, 'string expected')
assert_raises(function() re.find('foo', '(') end, 'invalid regex')
assert_raises(function() re.find('foo', 'o', true) end, 'number expected')

local gmatch = {{'foo', '.'}, {'foo', '.(o)'}, {'foo', '.', 2}}
for i, args in ipairs(gmatch) do
	local v1, v2 = {}, {}
	for v in re.gmatch(table.unpack(args)) do v1[#v1 + 1] = v end
	for v in string.gmatch(table.unpack(args)) do v2[#v2 + 1] = v end
	assert_equal(v1, v2)
end

assert_equal({select(3, re.gmatch('foo', '(.)(.)'))}, {select(3, string.gmatch('foo', '(.)(.)'))})

assert_raises(function() re.gmatch('foo', '.')() end, 'regex_gmatch expected')

local gsub = {
	{'foo', 'o', 'a'}, {'foo', 'o', 'a', 1}, {'foo', '.', {o = 'a'}}, {'foo', '.', string.upper},
	{'foo', 'b', ''}
}
for i, args in ipairs(gsub) do
	assert_equal({re.gsub(table.unpack(args))}, {string.gsub(table.unpack(args))})
end

assert_equal(re.gsub('foo', '(.)', '[$1]'), '[f][o][o]')
-- assert_equal(re.gsub('foo', '(o)+', '$0'), 'fo')

assert_raises(function() re.gsub('foo', '.', true) end, 'string/function/table expected')
assert_raises(function() re.gsub('foo', '.', {o = true}) end, 'invalid replacement value')

for i = -4, 4 do assert_equal({re.match('bar', '.', i)}, {string.match('bar', '.', i)}) end

print('All tests passed.')
