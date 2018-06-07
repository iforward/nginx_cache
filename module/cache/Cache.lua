cacheDispatch = require("module.cache.Dispatch");
cache = {};

function cache:new()
	local o = {};
	local m = setmetatable( o, {__index = self} );
	self:init();
	return m;
end

function cache:init() 
	self:main();
	return true;
end

function cache:main()
	local cacheDispatch = cacheDispatch:new();
	target = cacheDispatch:getCache();

	local uri = ngx.var.uri;
	local args = ngx.req.get_uri_args();

	--判断请求是否走缓存
	if ( target:isopen() == false ) then
		return ngx.exit(ngx.OK);
	end;

	--处理get参数
	param = {};
	for k,v in pairs(args) do
		if ( k ~= "clean" ) then
			param[k] = v;
		end
	end
	param["nocache"] = 1;

	if ( args.clean == "1" ) then
		--ngx.say(args.nocache)
		local resp = request:subRequest( uri, param );	
		if( resp ~= nil ) then
			target:write( uri, resp );
			ngx.say(resp);
			return ngx.exit(ngx.HTTP_OK);
		end
	end

	if ( args.nocache ~= "1" ) then
		local res = target:read( uri )
		if( res ~= false ) then
			ngx.header["Web-Cache"] = "Yes";
			ngx.say(res);
			return ngx.exit(ngx.HTTP_OK);
		else
			local resp = request:subRequest( uri, param );	
			if( resp ~= nil ) then
				target:write( uri, resp );
				ngx.say(resp);
				return ngx.exit(ngx.HTTP_OK);
			end
		end
	end

	return ngx.exit(ngx.OK);
end

return cache;
