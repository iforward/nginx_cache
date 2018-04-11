local redisFactory = require("core.cache.RedisFactory");
local fileFactory = require("core.cache.FileFactory");

dispatch = {};

function dispatch:new()
	local o = {};
	o = setmetatable( o, {__index = self} );
	self:init();
	return o;
end

function dispatch:init()
	return true;
end

function dispatch:getCache()
	if ( config.cache.mode == "redis" ) then
		local factory = redisFactory:new();
		return factory:create();
	elseif( config.cache.mode == "file" ) then
		local factory = fileFactory:new();
		return factory:create();
	end
	return false;
end

return dispatch;
