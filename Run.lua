zoneLine = require("module.zoneline.ZoneLine");
cache = require("module.cache.Cache");
run = {};

function run:new()
	local o = {};
	local m = setmetatable( o, {__index = self} );
	self:init();
	return m;
end

function run:init() 
	self:main();
	return true;
end

function run:main()
	if config.module.zoneline.service == 'on' then
		ngx.header["zoneline"] = 'on';
		zoneLine:new(); --分区上线模块
	end
	if config.module.cache.service == 'on' then
		ngx.header["cache"] = 'on';
		cache:new(); --静态化缓存模块
	end
end

return run;
