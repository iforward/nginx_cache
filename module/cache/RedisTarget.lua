local redis = require("components.Redis");
local target = require("module.cache.Target");

redisTarget = target:new();

function redisTarget:new()
	local o = target:new{ red=nil, host=nil, port=nil, timeout=0 };
	local parent_mt = getmetatable(o);

	-- 当方法在子类中查询不到时，再去父类中去查找。
	setmetatable(self, parent_mt);

	-- 这样设置后，可以通过self.parent.method(self, ...) 调用父类的已被覆盖的方法。
	o.parent = setmetatable({}, parent_mt);
	setmetatable( o, {__index = self} );
	self:init();
	return o;
end

function redisTarget:init()
	self.host = config.base.redis.host;
	self.port = config.base.redis.port;
	self.timeout = config.base.redis.timeout;
end

function redisTarget:connect()
	self.red = redis:new();
	--ngx.say( self.red )
	local ok, err = self.red:connect( self.host, self.port );
	if not ok then
		ngx.say("failed to connect: ", err);
		return;
	end
end

function redisTarget:read( uri )
	self:connect();
	--ngx.say( "cache:"..ngx.md5(uri) );
	return self:get( "PageCache:"..ngx.md5(uri) );
end

function redisTarget:write( uri, content )
	self:connect();
	return self:set( "PageCache:"..ngx.md5(uri), content );
end

function redisTarget:get( key )
	res, err = self.red:get( key );
	if( res ~= ngx.null ) then
		return res;
	end
	return false
end

function redisTarget:set( key, string )
	local ok, err = self.red:set( key, string, "EX", self.timeout );
	if not ok then
		return false;
	end
	return true;
end

return redisTarget;
