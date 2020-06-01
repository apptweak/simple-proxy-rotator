# Simple Proxy Rotator

`Simple Proxy Rotator` - acts as an http(s) forward proxy rotator.

It uses [glider](https://github.com/nadoo/glider) to evenly requests to a list of configured proxies.

## Introduction

You have: a list of http(s) proxies bought from a provider

You need: to distribute http(s) requests amongst those proxies.

Solution: configure your clients to use `Simple Proxy Rotator` as the forward proxy, and it will distribute the requests in round robin mode amongst its configured proxies.

Additionally, `Simple Proxy Rotator` will check each proxy every 60 seconds and remove it from the pool in case of error.

## Setup

The forward proxy rotator is exposed on port `15000`.

The proxy list can be configured in two ways :

- Using an environment variable : `PROXY_LIST_URL`. The proxy list will be downloaded from the given URL.
- By mounting the list as a volume on `/app/proxy-list.txt`

The proxy list should have 1 proxy per line using the following format : `http://[username]:[password]@[host]:[port]`. Example

````
http://user1:password1@12.34.56.78:1111
http://user2:password2@98.76.54.32:2222
...
````

## Usage

### Start the container using a downloadable proxy list

````
docker run -p 1234:15000 -e PROXY_LIST_URL=https://gist.githubusercontent.com/you/private-gist-hash/raw/proxy-list.txt almathie/simple-proxy-rotator
````

### Start the container using a volume mounted proxy list

````
docker run -p 1234:15000 -v /path/to/proxy-list.txt:/app/proxy-list.txt almathie/simple-proxy-rotator
````

### Use the rotator

````
curl -x "http://127.0.0.1:1234" "https://google.com"
````