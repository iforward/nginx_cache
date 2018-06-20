target = {};

function target:new()
	local o = {};
	return setmetatable( o, {__index = self} );
end

function target:init() 
	ngx.say("this is target init");
end

function target:isopen()
	--缓存是否正针对get请求
	local request_method = ngx.var.request_method;
	if( config.module.cache.get == 1 and request_method ~= "GET" ) then
		return false;
	end

	local uri = ngx.var.uri;

	match = {};
	for k,v in pairs( config.module.cache.rule ) do
		local m = ngx.re.match( uri, v[1], "ais" )
		--local m = ngx.re.match( uri, val[1], "aisJ" )
		if m then
			local len = string.len( m[0] );
			match[k] = { len, m[0], v[2] };
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

return target;
