local redis = require("components.Redis");
local cache = require("core.cache.Cache");

redisCache = {};

function redisCache:new()
	local o = cache:new{ red=nil, host=nil, port=nil, timeout=0 };
	local parent_mt = getmetatable(o);

	-- 当方法在子类中查询不到时，再去父类中去查找。
	setmetatable(self, parent_mt);

	-- 这样设置后，可以通过self.parent.method(self, ...) 调用父类的已被覆盖的方法。
	o.parent = setmetatable({}, parent_mt);
	setmetatable( o, {__index = self} );
	self:init();
	return o;
end

function redisCache:init()
	self.host = config.redis.host;
	self.port = config.redis.port;
	self.timeout = config.redis.timeout;
end

function redisCache:connect()
	self.red = redis:new();
	--ngx.say( self.red )
	local ok, err = self.red:connect( self.host, self.port );
	if not ok then
		ngx.say("failed to connect: ", err);
		return;
	end
end

function redisCache:read( uri )
	self:connect();
	--ngx.say( "cache:"..ngx.md5(uri) );
	return self:get( "cache:"..ngx.md5(uri) );
end

function redisCache:write( uri, content )
	self:connect();
	return self:set( "cache:"..ngx.md5(uri), content );
end

function redisCache:get( key )
	res, err = self.red:get( key );
	if( res ~= ngx.null ) then
		return res;
	end
	return false
end

function redisCache:set( key, string )
	local ok, err = self.red:set( key, string, "EX", self.timeout );
	if not ok then
		return false;
	end
	return true;
end

return redisCache;
