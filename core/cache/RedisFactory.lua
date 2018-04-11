local factory = require("core.cache.factory");
local redisCache = require("core.cache.redisCache");

redisFactory = {};

function redisFactory:new()
	local o = factory:new{};
	local parent_mt = getmetatable(o);

	-- 当方法在子类中查询不到时，再去父类中去查找。
	setmetatable(self, parent_mt);

	-- 这样设置后，可以通过self.parent.method(self, ...) 调用父类的已被覆盖的方法。
	o.parent = setmetatable({}, parent_mt);
	return setmetatable( o, {__index = self} );
end

function redisFactory:create()
	local cache = redisCache:new();
	return cache;
end

return redisFactory;
