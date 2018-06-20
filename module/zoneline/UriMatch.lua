urimatch = {};

function urimatch:new()
	local o = {};
	o = setmetatable( o, {__index = self} );
	self:init();
	return o;
end

function urimatch:init()
	return true;
end

function urimatch:match( uri )
	match = {};
	for k,v in pairs( config.module.zoneline.rule.uri ) do
		local m = ngx.re.match( uri, v[1], "ais" );
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

	if mn[3] then
		return mn[3];
	end

	return false;
end

return urimatch;
