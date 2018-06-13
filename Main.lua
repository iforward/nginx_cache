BASE_PATH = ngx.var.LUA_BASE_PATH;
package.path = '/usr/local/share/lua/5.1/?.lua;'..BASE_PATH..'/?.lua' 

config = dofile(BASE_PATH.."/conf/Config.lua");
helpers = require("core.Helpers");
files = require("core.Files");
request = require("core.Request");

--for k,v in ipairs(config.cache.rule) do
--	ngx.say(v[2])
--end
--ngx.exit(200);
require("Run"):new();
