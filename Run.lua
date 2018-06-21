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
	self:OpenModuleWriteToHeader();
	zoneLine:new(); --分区上线模块
	cache:new(); --静态化缓存模块
end

--启动的模块写入到header头当中
function run:OpenModuleWriteToHeader()
	local module = {};
	for k,v in pairs(config.module) do
		if v.service == 'on' then
			table.insert( module, k );
		end
	end
	ngx.header["Module"] = table.concat( module, ',' );
	return true;
end

return run;
