local target = require("module.cache.Target");

fileTarget = target:new();

function fileTarget:new()
	local o = target:new{ cachePath=nil };
	local parent_mt = getmetatable(o);

	-- 当方法在子类中查询不到时，再去父类中去查找。
	setmetatable(self, parent_mt);

	-- 这样设置后，可以通过self.parent.method(self, ...) 调用父类的已被覆盖的方法。
	o.parent = setmetatable({}, parent_mt);
	setmetatable( o, {__index = self} );
	self:init();
	return o;
end

function fileTarget:init() 
	self.cachePath = config.module.cache.path;
	return true;
end

function fileTarget:read( uri )
	local filename = files:getFileName( uri ) ~= nil and files:getFileName( uri ) or 'index';
	local filePath = files:getFilePath(uri) ~= nil and files:getFilePath(uri) or uri;
	filename = filename .. '.cache';
	filePath = self.cachePath .. filePath
	local file = helpers:rtrim( filePath, '/' ) .. '/' .. filename;
	if files:file_exists( file ) == false then
		return false;
	end
	return files:readFile( file );
end

function fileTarget:write( uri, content )
	local filename = files:getFileName( uri ) ~= nil and files:getFileName( uri ) or 'index';
	local filePath = files:getFilePath(uri) ~= nil and files:getFilePath(uri) or uri;
	filename = filename .. '.cache';
	filePath = self.cachePath .. filePath

	files:mkdirs( filePath );
	--ngx.say( helpers:rtrim( filePath, '/' ) .. '/' .. filename );
	files:write( helpers:rtrim( filePath, '/' ) .. '/' .. filename, content );
	return true;
end

return fileTarget;
