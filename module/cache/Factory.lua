local redisTarget = require("module.cache.RedisTarget");
local fileTarget = require("module.cache.FileTarget");

factory = {};

function factory:new()
	local o = {};
	return setmetatable( o, {__index = self} );
end

function factory:create( mode )
	if mode == "redis" then
		return redisTarget:new();
	elseif mode == 'file' then
		return fileTarget:new();
	end
end

return factory;
