district = require("module.zoneline.District");
uriMatch = require("module.zoneline.UriMatch");

zoneLine = { configZoneline = nil };

function zoneLine:new()
	local o = {};
	local m = setmetatable( o, {__index = self} );
	self.configZoneline = config.module.zoneline;
	if self.configZoneline == nil or self.configZoneline.service ~= 'on' then
		return;
	end
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
	local uriRule = uriMatch:match( uri );
	if ( args.zoneline ~= "1" and rule == "on" ) then
		ngx.exec( self.configZoneline.localtion.target, param );
	elseif ( args.zoneline ~= "1" and uriRule == "off" ) then
		if self.configZoneline.localtion.default ~= "default" then
			ngx.exec( self.configZoneline.localtion.default, param );
		end
		return;
	end

	--获取ip
	local userHostAddress = request:getUserHostAddress();

	--解析ip
	district = district:new();
	local province, city = district:parseUserAddress( userHostAddress );

	--获取派发规则
	local rule = district:match( province, city );

	--派发请求
	if( args.zoneline ~= "1" and rule == "on" ) then
		ngx.exec( self.configZoneline.localtion.target, param );
	else
		if self.configZoneline.localtion.default ~= "default" then
			ngx.exec( self.configZoneline.localtion.default, param );
		end
		return;
	end

end

return zoneLine;
