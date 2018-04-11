cache = {};

function cache:new()
	local o = {};
	return setmetatable( o, {__index = self} );
end

function cache:init() 
	ngx.say("this is cache init");
end

function cache:isopen()
	--缓存是否正针对get请求
	local request_method = ngx.var.request_method;
	if( config.cache.get == 1 and request_method ~= "GET" ) then
		return false;
	end

	local directory = files:readFile( BASE_PATH .. '/conf/Directory.conf' );
	local uri = ngx.var.uri;

	match = {};
	for k,v in pairs( directory ) do
		local val = helpers:split( helpers:trim( v ), " " )
		local m = ngx.re.match( uri, val[1], "aisJ" )
		if m then
			local len = string.len( m[0] );
			match[k] = { len, m[0], val[2] };
		end
	end

	local mn = { nil, nil, nil };
	for k, v in pairs(match) do
		if(mn[1]==nil) then
			mn=v
		end
		if mn[1] < v[1] then
			mn = v
		end
	end
	if( mn[3] == "on" ) then
		return true;
	end

	return false;
end

return cache;
