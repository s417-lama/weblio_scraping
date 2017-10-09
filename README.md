# weblio_scraping

An api server for scraping [Weblio](http://ejje.weblio.jp) English-Japanese / Japanese-English dictionary.
The server is written in [Phoenix](http://phoenixframework.org) / [Elixir](https://elixir-lang.org).

## To run

```bash
$ mix deps.get
$ mix compile
$ mix ecto.create
$ mix phx.server
```

## Usage

First, run the phoenix server as noted above.
The URL to send POST requests will be
```
http://(hostname):(port)/api/translate
```
And the format of requests and responses is json.

Request format:
```js
{
  "query": "search words"
}
```

Response format:
```js
{
  "found": true or false
  "explanation": "The explanation of the words you searched"
  "suggestions": [{"word": "word1", "explanation": "explanation1"}, ...]
  "error": default is {}.
}
```
If the search words are not found, similar words will be listed in "suggestions".

## Example

### Case 1

To search the meaning of the word "apple",
```bash
$ curl localhost:4000/api/translate -X POST -H 'Content-Type: application/json' -d '{"query": "apple"}'
```
and the response will be
```js
{
  "found": true,
  "explanation": "リンゴ",
  "suggestions": [],
  "error": {}
}
```

### Case 2

In the case of typo "applee",
```bash
$ curl localhost:4000/api/translate -X POST -H 'Content-Type: application/json' -d '{"query": "applee"}'
```
and the response will be
```js
{
  "found": false,
  "explanation": "",
  "suggestions": [
    {"word": "apple", "explanation": "リンゴ"},
    {"word": "apples", "explanation": "appleの複数形。リンゴ"},
    {"word": "applet", "explanation": "アプレット"},
    {"word": "appro", "explanation": "承認の非公式の英国の略語"},
    {"word": "puree", "explanation": "ピューレ"}
  ],
  "error": {}
}
```

## Client

The client bash script is `script/client.sh`.
It parses the response and makes it formatted properly.
This will require `jq` package.

To run:
```bash
$ script/client.sh (hostname):(port) "search words"
```
## Deploy

```bash
$ export MIX_ENV=prod
$ mix deps.get --only prod
$ mix compile
$ mix release
```
and `rel/weblio_scraping/releases/0.0.1/weblio_scraping.tar.gz` will be generated.
Copy this tarball to your server machine and extract it.

If you extract it to the directory `/path/to/weblio_scraping`, run the command below to start the server.
```bash
$ PORT=8080 /path/to/weblio_scraping/bin/weblio_scraping foreground
```

If it's ok, setup the service as a daemon.

### Systemd

Edit the new file `/etc/systemd/system/weblio_scraping.service` like the following.
```
[Unit]
Description = weblio_scraping daemon

[Service]
RemainAfterExit = yes
Environment = "HOME=/home/<username>"
Environment = "PORT=8080"
ExecStart = /path/to/weblio_scraping/bin/weblio_scraping start
ExecStop = /path/to/weblio_scraping/bin/weblio_scraping stop

[Install]
WantedBy = multi-user.target
```
after that,
```bash
$ sudo systemctl enable weblio_scraping
$ sudo systemctl start weblio_scraping
```
If you want to check the state, run
```bash
$ sudo systemctl status weblio_scraping
```
