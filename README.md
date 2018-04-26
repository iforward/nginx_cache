# nginx_cahce

<pre><code>
server {
	listen       80;
	server_name  www.domain.com;
	root   /xxxx/xxxx/xxx;

	......

	default_type 'text/html';
	set $LUA_BASE_PATH /xxx/xxx/xxx/your-lua-path;
	rewrite_by_lua_file $LUA_BASE_PATH/Router.lua;

	......

}
</code></pre>
