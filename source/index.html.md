---
title: Stellarport A3S Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - ruby
  - python
  - javascript

toc_footers:
  - <a href='https://stellarport.io'>A Service By Stellarport</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the Stellarport Anchor As A Service (A3S)! You can use our service to connect arbitrary assets to the Stellar network.

We have language bindings in Shell, Ruby, Python, and JavaScript! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

# How It Works

A3S is a central hub that connects arbitraty assets to the Stellar network. Its job is to faithfully execute deposits and withdrawals for an arbitrary asset. To do this it communicates with a set of Relay Servers. Each asset that A3S manages is associated with a relay server. It is within the relay server, that asset specific logic is housed. Between A3S and a relay server, the full scope of connecting an asset to the Stellar network is achieved. The responsibilities are split like so:

A3S:

* Issue tokens on the Stellar network.
* Generate withdrawal destinations (for users to send their tokens to).
* Sense withdrawals on the Stellar network and communicate them to the relay server.

Relay Server:

* Generate deposit destinations (for users to send asset to).
* Sense deposits externally and communicate them to A3S.
* Execute withdrawals of asset as instructed by A3S.

The full deposit/withdrawal flow is as follows:

1. User/Client Application would like to deposit asset ABC to Stellar account XYZ and request a deposit destination from A3S.
2. A3S will provide the destination if it has already been deposited to or ask the relay server to generate a new one if it does not yet exist.
3. User/Client Application sends deposit to provided destination.
4. Relay server observes that a deposit has been made and notifies A3S of the deposit amount and destination.
5. A3S issues the appropriate amount of tokens to the corresponding Stellar wallet. 

<aside class="notice">
The token issuance complexity varies from simply 1-1 issuance to a more complex process whereby A3S may remove deposit fees (depending on the asset settings), create the receiving Stellar account by selling some of the deposited asset on the open market and funding the account with the acquired XLM. A3S also waits for trustlines to be setup, it will automatically sense a trustline addition and issue any asset owed to that account at that time.
</aside>

6. User/CLient Application would like to withdraw tokens to external destination GHI and requests a withdrawal destination from A3S.
7. A3S generates a withdrawal destination and provides it to the User/Client Application.
8. User/Client Application sends the XYZ tokens on the Stellar network to the withdrawal destination provided by A3S.
9. A3S automatically registers the incoming withdrawal and notifies the relay server to execute a withdrawal to destination GHI.
10. Relay server executes the withdrawal.

# Security

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# A3S API

## Get All Kittens

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Max",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Max",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

## Delete a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -X DELETE
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "deleted" : ":("
}
```

This endpoint deletes a specific kitten.

### HTTP Request

`DELETE http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to delete

