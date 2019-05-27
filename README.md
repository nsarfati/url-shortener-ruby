# URL Shortener

## Converts a long url into a six friendly smaller one.

### Requirements:
- Ruby >=2.3.0
- Docker
- Redis

### Considerations:
- I am not versioning the endpoints. Why? Since it's supposed to be an url shortener, I decided to make the endpoints as small as possible
- I am using Redis as storage
- I am storing the shortened urls for 1 week.

### How to run it locally?
- Run `make start-devenv` and it will start the storage (Redis) using docker for it.
- Run `make run-locally` in order to start the application.
- You can find in (`env/dev/request`) some request examples
- You can find in (`env/dev/config.yml`) the redis properties (in case that you want to run in production environment)
- You can find the `docker-compose.yml` inside env/dev/
- In case that you run it in an IDE, you need to configure the `CONFIG_DIR` environment variable pointing to the `config.yml` file

### Endpoints:

#### Shortening an url:

Request:
```
curl -v -H 'Content-Type: application/json' -X POST -d\
'{
    "url": "http://www.google.com"
}' localhost:9292/
```

Success response:

```
{
    "shortenedKey": "y5obhg",
    "status": "success"
}
```

Error responses:

* 400 (Bad Request): Invalid JSON Request
* 500 (Internal Server Error): Couldn't generate a valid shortened url / Any unexpected internal error

```
{
    "error": "Invalid request",
    "status": "failure"
}
```

#### Following a shortened link:

Request:
```
curl -v -X GET localhost:9292/y5obhg
```

Success response:

```
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 9292 (#0)
> GET /y5obhg HTTP/1.1
> Host: localhost:9292
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
< Content-Type: text/html;charset=utf-8
< Location: http://www.google.com
< Content-Length: 0
< X-Xss-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-Frame-Options: SAMEORIGIN
< Server: WEBrick/1.4.2 (Ruby/2.6.3/2019-04-16)
< Date: Mon, 27 May 2019 04:39:50 GMT
< Connection: Keep-Alive
<
* Connection #0 to host localhost left intact
```

In case that the shorten url doesn't exist anymore, by the fault, it will be redirect to http://properati.com

* Error responses:
 
500 (Internal Server Error): Any unexpected internal error
