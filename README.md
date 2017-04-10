# example-nginx-with-embedded-perl

> Example nginx with Embedded Perl

「詳解 お蔵入り」の Embedded Perl for nginx で
作成したサンプルコードです。

https://ocreilly.meiji-ncc.tech/TBF02/

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [License](#license)

## Install

```bash
$ git clone https://github.com/3846masa/example-nginx-with-embedded-perl
$ cd ./example-nginx-with-embedded-perl
$ docker build . -t 3846masa/example-proxy
```

## Usage

```bash
$ docker run -d -P -v /var/run/docker.sock:/var/run/docker.sock 3846masa/example-proxy
$ docker run -d -e PROXY_PORT=80 --name test.example.com nginx:alpine
$ curl -H "Host: test.example.com" http://localhost
```

## License

MIT © 3846masa
