# nginx_cahce

<pre><code>
server {
	listen       80;
	server_name  www.domain.com;
	root   /xxxx/xxxx/xxx;

	......

	rewrite_by_lua_file /Users/iforward/www/www.lua.com/cache/router.lua;

	......

}
</code></pre>
