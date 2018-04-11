factory = {};

function factory:new()
	local o = {};
	return setmetatable( o, {__index = self} );
end

function factory:create()
	ngx.say( "this is create action" );
end

return factory;
