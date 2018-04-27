request = {}

--获取参数
function request:getParam( string )
	return helpers:table_merge( self:get(), self:post() )[string];
end

--获取get参数
function request:get()
	local args = ngx.req.get_uri_args();
	return args;
end

--获取post参数
function request:post()
	local jsonData = self:json()
	if jsonData then
		return jsonData;
	end

	ngx.req.read_body();
	local args = ngx.req.get_post_args();
	return args;
end

--解析json格式请求
function request:json()
	local contentType = ngx.var.content_type;
	if( contentType == "application/json" ) then
		ngx.req.read_body();
		strJson = ngx.req.get_body_data();
		return cjson.decode( strJson );
	end
	return nil;
end

function request:subRequest( url, param )
	if ( param == "" or param == nil ) then
		param = { nocache = 1 };
	end
	local resp = ngx.location.capture( url, {
		method = ngx.HTTP_GET,
		args = param
	})
	if not resp then
		ngx.say("request error :", err)
		return nil;
	end

	--响应体
	if resp.body and resp.status == 200 then
		return resp.body
	end
	return nil;
end

return request
