BASE_PATH = ngx.var.LUA_BASE_PATH;
package.path = '/usr/local/lib/lua/5.1/?.lua;'..BASE_PATH..'/?.lua' 
config = require("conf.Config");
helpers = require("core.Helpers");
files = require("core.Files");
request = require("core.Request");
cacheDispatch = require("core.cache.Dispatch");

local cacheDispatch = cacheDispatch:new();
cache = cacheDispatch:getCache();

local uri = ngx.var.uri;
local args = ngx.req.get_uri_args();

--判断请求是否走缓存
if ( cache:isopen() == false ) then
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
	local resp = request:get( uri, param );	
	if( resp ~= nil ) then
		cache:write( uri, resp );
		ngx.say(resp);
		return ngx.exit(ngx.OK);
	end
end

if ( args.nocache ~= "1" ) then
	local res = cache:read( uri )
	if( res ~= false ) then
		ngx.header["Web-Cache"] = "Yes";
		ngx.say(res);
		return ngx.exit(ngx.HTTP_OK);
	else
		local resp = request:get( uri, param );	
		if( resp ~= nil ) then
			cache:write( uri, resp );
			ngx.say(resp);
			return ngx.exit(ngx.OK);
		end
	end
end

return ngx.exit(ngx.OK);
