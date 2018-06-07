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
	--静态化缓存
	cache:new();
end

return run;
