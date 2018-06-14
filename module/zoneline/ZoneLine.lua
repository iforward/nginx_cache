district = require("module.zoneline.District");
uriMatch = require("module.zoneline.UriMatch");

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

	local uri = ngx.var.uri;
	local args = ngx.req.get_uri_args();

	--处理get参数
	local param = {};
	for k,v in pairs(args) do
		param[k] = v;
	end
	param["zoneline"] = 1;
	
	uriMatch = uriMatch:new();	
	ngx.say( uriMatch:match( uri ) );
	ngx.exit(200);

	--获取ip
	local userHostAddress = request:getUserHostAddress();

	--解析ip
	district = district:new();
	local province, city = district:parseUserAddress( userHostAddress );

	--获取派发规则
	local rule = district:match( province, city );

	--派发请求
	if( args.zoneline ~= "1" and rule == "on" ) then
		ngx.exec( config.zoneline.localtion.target, param );
	else
		if config.zoneline.localtion.default ~= "default" then
			ngx.exec( config.zoneline.localtion.default, param );
		end
	end

	return;
end

return zoneLine;
