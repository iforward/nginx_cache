request = {}

function request:get( url, param )
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
