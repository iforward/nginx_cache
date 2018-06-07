BASE_PATH = ngx.var.LUA_BASE_PATH;
package.path = '/usr/local/share/lua/5.1/?.lua;'..BASE_PATH..'/?.lua' 

config = require("conf.Config");
helpers = require("core.Helpers");
files = require("core.Files");
request = require("core.Request");

require("Run"):new();
