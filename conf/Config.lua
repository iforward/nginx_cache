return {

	--redis
	redis = {
		host = "127.0.0.1";
		port = 6379;
		timeout = 3600 * 2; -- 0为永久生效
	},

	--cache
	cache = {
		get = 1; --静态化仅开启get请求
		mode = "redis";
		--mode = "file";
		path = BASE_PATH .. "/runtime/cache";
		rule = { 
			{ [[/]], 'on' },
			{ [[^\/[\w]+\/]], 'on' },
			{ [[/wp-admin]], 'off' },
			{ [[/admin]], 'off' },
			{ [[/wp-]], 'off' },
		},
	},

	--zoneline
	zoneline = {
		localtion = { 
			default ="default",
			default ="/api.php",
		},
		rule = {
			uri = {
				{ [[/]], 'match' },
				{ [[^\/[\w]+\/]], 'match' },
			},
			district = {
				{ [[湖北,北京,上海]], 'off' },
				{ [[湖北,北京,上海]], 'on' },
			},
		},
	},
};
