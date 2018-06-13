zoneLine = {};

function zoneLine:new()
	local o = {};
	local m = setmetatable( o, {__index = self} );
	self:init();
	return m;
end

function zoneLine:init() 
	self:main();
	return true;
end

function zoneLine:main()
end

return zoneLine;
