return {

	base = {
		--redis
		redis = {
			host = "127.0.0.1",
			port = 6379,
			timeout = 3600 * 2, -- 0为永久生效
		},
	},

	module = {
		--cache
		cache = {
			service = 'on', --服务是否开启; on, off
			get = 1, --静态化仅开启get请求
			mode = "redis",
			--mode = "file",
			path = BASE_PATH .. "/runtime/cache",
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
			service = 'on', --服务是否开启; on, off
			localtion = { 
				default ="default",
				target ="/api.php",
			},
			rule = {
				uri = {
					{ [[/]], 'match' },
					{ [[^\/[\w]+\/]], 'on' },
				},
				district = {
					province = {	
						{ [[北京,上海]], 'off' },
						{ [[北京,上海]], 'on' },
					},
					city = {
						{ [[武汉]], 'on' },
						{ [[广州,深圳]], 'on' },
					},
				},
			},
		},
	}
};
