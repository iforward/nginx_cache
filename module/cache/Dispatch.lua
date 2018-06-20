local Factory = require("module.cache.Factory");

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
	return Factory:create( config.module.cache.mode );
end

return dispatch;
