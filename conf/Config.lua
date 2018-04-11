config = {};

--base
config.cache = {}
config.cache.get = 1 --静态化仅开启get请求
--config.cache.mode = "redis"
config.cache.mode = "file"
config.cache.path = BASE_PATH .. "/runtime/cache"

--redis
config.redis = {};
config.redis.host = "127.0.0.1";
config.redis.port = 6379;
config.redis.timeout = 3600 * 2 -- 0为永久生效


return config;
