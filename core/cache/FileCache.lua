require "lfs";

local cache = require("core.cache.Cache");

fileCache = cache:new();

function fileCache:new()
	local o = cache:new{ cachePath=nil };
	local parent_mt = getmetatable(o);

	-- 当方法在子类中查询不到时，再去父类中去查找。
	setmetatable(self, parent_mt);

	-- 这样设置后，可以通过self.parent.method(self, ...) 调用父类的已被覆盖的方法。
	o.parent = setmetatable({}, parent_mt);
	setmetatable( o, {__index = self} );
	self:init();
	return o;
end

function fileCache:init() 
	self.cachePath = config.cache.path;
	return true;
end

function fileCache:read( uri )
	local file = self.cachePath .. uri .. '.cache';
	if files:file_exists( file ) == false then
		return false;
	end
	return files:readFile( file );
end

function fileCache:write( uri, content )
	local filename = files:getFileName( uri ) .. '.cache';
	local filePath = self.cachePath .. files:getFilePath(uri)
	files:mkdirs( filePath );
	--ngx.say( helpers:rtrim( filePath, '/' ) .. '/' .. filename );
	files:write( helpers:rtrim( filePath, '/' ) .. '/' .. filename, content );
	return true;
end

return fileCache;
