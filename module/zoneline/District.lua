city = require("components.ip.City");
local district = {};

function district:new()
	local o = {};
	o = setmetatable( o, {__index = self} );
	self:init();
	return o;
end

function district:init()
	self.district = config.zoneline.rule.district;
	return true;
end

function district:parseUserAddress( userHostAddress )
	local city = city:new( BASE_PATH .. "/components/ip/ipip.datx");
	local districtData = city:find("202.103.10.102")
	return districtData[2],districtData[3];
end

function district:match( province, city )
	rule = self:matchCity( city );
	if rule then
		return rule;
	end
	return self:matchProvince( province );
end

--匹配城市,返回派发规则
function district:matchCity( city )
	if self.district.city and city then
		for key, value in pairs( self.district.city ) do
			for k, v in pairs( helpers:split( value[1], ',' ) ) do
				if string.find( city, v) then 
					return value[2];
				end
			end
		end
	end
	return false;
end

--匹配省份,返回派发规则
function district:matchProvince( province )
	if self.district.province and province then
		for key, value in pairs( self.district.province ) do
			for k, v in pairs( helpers:split( value[1], ',' ) ) do
				if string.find( province, v) then 
					return value[2];
				end
			end
		end
	end
	return false;
end

return district;
