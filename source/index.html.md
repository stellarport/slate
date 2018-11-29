---
title: Stellarport A3S Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - javascript
  - shell

toc_footers:
  - <a href='https://stellarport.io'>A Service By Stellarport</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the Stellarport Anchor As A Service (A3S). You can use our service to connect arbitrary assets to the Stellar network.

We have language bindings in Shell and JavaScript. You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

# How It Works

A3S is a central hub that connects arbitrary assets to the Stellar network. Its job is to faithfully execute deposits and withdrawals for an arbitrary asset. To do this it communicates with a set of Relay Servers. Each asset that A3S manages is associated with a Relay Server that runs the logic specific to that asset. A3S, and a Relay Server, are the connection between the Stellar network and an asset. The responsibilities are split like so:

A3S:

* Issue tokens on the Stellar network.
* Generate withdrawal destinations (for users to send their tokens to).
* Sense withdrawals on the Stellar network and communicate them to the relay server.

Relay Server:

* Generate deposit destinations (for users to send asset to).
* Sense deposits externally and communicate them to A3S.
* Execute withdrawals of asset as instructed by A3S.

The full deposit/withdrawal flow is as follows:

1. User/Client Application would like to deposit asset ABC to Stellar account XYZ. It requests deposit destination from A3S.
2. A3S provides deposit destination if it has been previously used for a deposit, or it makes a request from relay server to generate a new one.
3. User/Client Application sends deposit to provided deposit destination.
4. Relay server observes deposit has been made, and notifies A3S of deposit destination and amount.
5. A3S issues appropriate amount of tokens to Stellar account XYZ. 

<aside class="notice">
This is a simple case, describing a 1-to-1 issuance. A3S features certain flexibilites, too. A3S may remove deposit fees (depending on the asset settings). A3S may create the receiving Stellar account by selling some of the deposited asset on the open market to initially fund the account with the acquired XLM. A3S will also wait and sense for a trustline to be set up, and then issue the balance of the asset due the account.
</aside>

6. User/Client Application would like to withdraw asset ABC to external account GHI. User/Client Application requests withdrawal destination from A3S.
7. A3S generates withdrawal destination and provides it to User/Client Application.
8. User/Client Application sends ABC tokens on the Stellar network to withdrawal destination provided by A3S.
9. A3S automatically registers incoming withdrawal, and notifies relay server to execute withdrawal to external account GHI.
10. Relay server executes withdrawal to external account GHI.

# Rate Limiting
A3S's APIs are rate limited to ensure fair access for all developers. We expect that most use cases will not genuinely exceed the standard allowed rate, but if your use cases required a higher volume of requests to be serviced then please send your request to listings@stellarport.io.

Requests throttled by the rate limiter will be returned with a 429 Too Many Requests response. Information regarding your rate limiter quote is present on responses through the X-Ratelimit-* headers.

# Security

# Response Signing

> To verify an arbitrary response from A3S or a Relay Server:

```shell
# With shell, you will have to write a script to do this.
```

```javascript
const {A3S} = require('a3s');
const a3s = new A3S();

let verified = a3s.verifyPayload(signature, payload, pubKey);
```

> To produce a signature using an arbitrary payload:

```shell
# With shell, you will have to write a script to do this.
```

```javascript
const {RequestSigner} = require('a3s');
const requrestSigner = new RequestSigner('SC3WN7VGIAVBAX4XTBJCNHWU74Z4OAWNSEJPWSTDT5IANPZXH2BBUW6R');

let response = a3s.sign(payload, response);
```

> `response` is an express Response object. DO NOT use secret key above. Instead replace it with a secret key of your own.

A3S uses a signature scheme for verifying responses between A3S and its relay servers. Every response returned from any server should include a header like so:

`Signature: xxxx`

<aside class="notice">
In a real response, <code>xxxx</code> will be the base64 encoded signature of the payload by the server's secret key.
</aside>

When either A3S or a relay server receives a response from its counterpart, it should verify the response before beliving it.

<aside class="success">
In practice, if you use the A3S sdk, all methods have the message verification built in. You do not need to manually implement this verification unless you are making requests to A3S or a relay server not using the A3S sdk.
</aside>

# Notification Confirmation
A3S confirms all notifications it receives with the relay servers. For example, if A3S receives a notification to issue a deposit, it confirms this deposit with the relay server before continuing. Relay servers should implement similar rules. Never believe a message coming in over the wire, always confirm.

# Idempotency
A3S implements idempotency. Essentially, the timing of requests should not affect the actions of A3S. Relay servers should also implement idempotency. For example, if an attacker quickly sends two requests to a relay server to execute a withdrawal, only one withdrawal should actually be executed.

# A3S API

The A3S API is a superset of [SEP0006](https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0006.md). You should find all the endpoints in the SEP available in A3S as well as few additional endpoints.

# Getting Started

```javascript
npm install a3s

const {A3S} = require('a3s');
const a3s = new A3S();
```

# Sandbox Environment

> To use the sandbox with the a3s sdk:

```javascript
const {A3S} = require('a3s');
const a3s = new A3S();
a3s.useSandbox();
```

> When you a ready for production:

```javascript
const {A3S} = require('a3s');
const a3s = new A3S();
a3s.useProd();
```

The A3S sandbox environment is available at `a3s-sandbox.api.stellarport.io`.

The A3S production environment is available at `a3s.api.stellarport.io`.

Before getting started developing agains A3S, you might want to play around with A3S to get used to how it works. To enable you to do that, we have deployed a Testnet Ripple asset for you to play with. To access this asset, you can make calls to the A3S sandbox server while replacing all the `asset_issuer` parameters in the A3S endpoints with `GC6OWX3B4NSVUNKHHR6NDCBTFF7IPF6PPVCHXCD5TDTFWSB3LKB7QY55` and `asset_code` with `TXRP`.

You can get yourself some Testnet Ripple at the [testnet ripple faucet](https://developers.ripple.com/xrp-test-net-faucet.html) and manage your testnet wallet from [this handy ripple wallet](https://ripplerm.github.io/ripple-wallet/) (just make sure you select the testnet network).

Tokens will be sent to and from the Stellar mainnet (the A3S sandbox uses the Stellar mainnet due to the cheap transaction fees). You can use the [stellarport client](https://stellarport.io) to manage your mainnet stellar wallet.

Once you are ready to start developing against A3S, if you are using javascript, download the `a3s` package from npm and import it into your project.


# Info

## Get Info

```shell
curl "https://a3s.api.stellarport.io/v2/GBVOL67TMUQBGL4TZYNMY3ZQ5WGQYFPFD5VJRWXR72VA33VFNL225PL5/Info"
```

```javascript
const {A3S} = require('a3s');
const a3s = new A3S();
let info = await a3s.info(assetIssuer);
```

> The above command returns JSON structured like this:

```json
{
  "deposit": {
    "XRP": {
      "fields": {},
      "fee_fixed": 0,
      "min_amount": 5,
      "fee_percent": 0,
      "enabled": true
    },
    ...
  },
  "withdraw": {
    "XRP": {
      "types": {
        "default": {
          "fields": {
            "dest": {
              "optional": false,
              "description": "Ripple Address"
            },
            "dest_extra": {
              "optional": true,
              "description": "Tag (Optional)"
            }
          }
        }
      },
      "fee_fixed": 0.25,
      "min_amount": 25,
      "fee_percent": 0.5,
      "enabled": true
    },
    ...
  },
  "transactions": {
    "enabled": true
  }
}
```

Retrieves basic info relating to the assets available via A3S for a specific issuing account.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Info`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

# Transactions

## Get Transactions

```shell
curl "https://a3s.api.stellarport.io/v2/GBVOL67TMUQBGL4TZYNMY3ZQ5WGQYFPFD5VJRWXR72VA33VFNL225PL5/Transactions?asset_code=XRP&account=GCAANVYGJHG43WGHCM435FEJJZ3M4CYQ5JIYCNAR5ARIYAS3KRPEPZ4I"
```

```javascript
const options = {
  paging_id: "234",
  no_older_than: new Date('December 17, 1995 03:24:00'),
  limit: 25
};
let transactions = a3s.transactions(asset_code, asset_issuer, account, options);
```

> The above command returns JSON structured like this:

```json
{
  "transactions": [
    {
      "id": "32",
      "kind": "deposit",
      "status": "completed",
      "asset_code": "XRP",
      "amount_in": "5",
      "amount_out": "5",
      "amount_fee": "0",
      "started_at": "2018-11-13T16:34:10.000Z",
      "completed_at": "2018-11-13T17:46:21.316Z",
      "stellar_transaction_id": "9d489efe74c46f8d3e87765d8b30056b54472a743f0541fb189ed22920bab825",
      "external_transaction_id": "EC433768C3E7F1058852362B8E1D9F7F8E746326C38242F34E973AAFE3B88980",
      "from": "rPFFGozFRSjbGTq8DwEWptTjGFRPqDtTtb?dt=5",
      "to": "GCQLYUE2DJT3N57BKHKW5DUOELDSEHNGIVHVHFBS5YMDBZX55RTSR6FM",
      "message": "Deposit successfully completed."
    },
    ...
  ]
}
```

Returns a list of transactions.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Transactions`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC).
account | The id of the account to fetch transactions for.
paging_id (optional) | Id of the last transaction to exclude.
no_older_than (optional) | Only return transactions newer than.
limit (optional) | Number of transactions to return.

## Get One Transaction

```shell
curl "https://a3s.api.stellarport.io/v2/GBVOL67TMUQBGL4TZYNMY3ZQ5WGQYFPFD5VJRWXR72VA33VFNL225PL5/Transaction?id=32"
```

```javascript
const options = {
  id: 32
}
let instructions = await a3s.transaction(options);
```

> The above command returns JSON structured like this:

```json
{
  "transaction": {
    "id": "32",
    "kind": "deposit",
    "status": "completed",
    "asset_code": "XRP",
    "amount_in": "5",
    "amount_out": "5",
    "amount_fee": "0",
    "started_at": "2018-11-13T16:34:10.000Z",
    "completed_at": "2018-11-13T17:46:21.316Z",
    "stellar_transaction_id": "9d489efe74c46f8d3e87765d8b30056b54472a743f0541fb189ed22920bab825",
    "external_transaction_id": "EC433768C3E7F1058852362B8E1D9F7F8E746326C38242F34E973AAFE3B88980",
    "from": "rPFFGozFRSjbGTq8DwEWptTjGFRPqDtTtb?dt=5",
    "to": "GCQLYUE2DJT3N57BKHKW5DUOELDSEHNGIVHVHFBS5YMDBZX55RTSR6FM",
    "message": "Deposit successfully completed."
  }
}
```

Returns a specific transaction.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Transaction`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

### Query Parameters

Parameter | Description
--------- | -----------
id | The id of the transaction
stellar_transaction_id | The Stellar transaction hash of the transactions
external_transaction_id | The external transaction id

# Deposit

## Get Deposit Instructions

```shell
curl "https://a3s.api.stellarport.io/v2/GBVOL67TMUQBGL4TZYNMY3ZQ5WGQYFPFD5VJRWXR72VA33VFNL225PL5/Deposit?asset_code=BTC&account=GCQLYUE2DJT3N57BKHKW5DUOELDSEHNGIVHVHFBS5YMDBZX55RTSR6FM&memo_type=text&memo=memostring"
```

```javascript
let instructions = await a3s.depositInstructions(asset_code, asset_issuer, account, options);
```

> The above command returns JSON structured like this:

```json
{
  "how": "rPFFGozFRSjbGTq8DwEWptTjGFRPqDtTtb?dt=5",
  "min_amount": 5,
  "max_amount": null,
  "fee_fixed": 0,
  "fee_percent": 0,
  "eta": 60,
  "extra_info": {
    "message": "Send XRP to ripple address rPFFGozFRSjbGTq8DwEWptTjGFRPqDtTtb. You MUST INCLUDE THE REQUIRED TAG 5 with the deposit"
  }
}
```

Retrieves instructions on how to complete a deposit for a specific asset to a specific Stellar account.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Deposit`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
account | The destination Stellar account to send credit to.
memo (optional) | Memo to attach to the crediting transaction.
memo_type (optional) | Required if memo is specified.

## Notify Deposit Received

```shell
curl "https://a3s.api.stellarport.io/v2/GBVOL67TMUQBGL4TZYNMY3ZQ5WGQYFPFD5VJRWXR72VA33VFNL225PL5/Deposit/Sent?asset_code=XRP&reference=relayserverreference"
```

```javascript
let depositTransaction = await depositSent(reference, asset_code, asset_issuer);
```

> The above command returns JSON structured like this:

```json
{
  "id": "34",
  "kind": "deposit",
  "status": "pending_external",
  "asset_code": "BTC",
  "amount_in": "5",
  "amount_out": "0",
  "amount_fee": "0",
  "started_at": "2018-11-14T22:53:51.000Z",
  "completed_at": null,
  "stellar_transaction_id": null,
  "external_transaction_id": "bf29d0ee54e02287ec10823f97db2eb7566e28fe48940d6abf512e146573d24e",
  "from": "1CK6KHY6MHgYvmRQ4PAafKYDrg1ejbH1cE",
  "to": "GCQLYUE2DJT3N57BKHKW5DUOELDSEHNGIVHVHFBS5YMDBZX55RTSR6FM",
  "message": "Waiting for external BTC deposit.",
  "extra_info": {}
}
```

Notifies A3S of an incoming deposit. This is almost always called by the relay server. The deposit does not yet need to be confirmed in order to make this call. It is best for a relay server to make this call as soon as it has spotted in incoming deposit.

If a deposit is not yet confirmed, A3S will store it as pending and will wait on confirmation before issuing any tokens on Stellar.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Deposit/Sent`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
reference | Unique relay server reference

## Notify Deposit Confirmed

```shell
curl "https://a3s.api.stellarport.io/v2/GBVOL67TMUQBGL4TZYNMY3ZQ5WGQYFPFD5VJRWXR72VA33VFNL225PL5/Deposit/Confirmed?asset_code=XRP&reference=44"
```

```javascript
let depositTransaction = await depositConfirmed(reference, asset_code, asset_issuer);
```

> The above command returns JSON structured like this:

```json
{
  "id": "34",
  "kind": "deposit",
  "status": "completed",
  "asset_code": "XRP",
  "amount_in": "5",
  "amount_out": "5",
  "amount_fee": "0",
  "started_at": "2018-11-14T22:53:51.000Z",
  "completed_at": "2018-11-15T17:07:45.338Z",
  "stellar_transaction_id": "e0f3a31292c805d2f7aa2540f64d92cd5159fb8d7df9404d4c5b3fd9faa4813b",
  "external_transaction_id": "EB8A04D87FB6C767A76B0F2C07848BB522529EED48BDC38144EE3CCF3730502F",
  "from": "rPFFGozFRSjbGTq8DwEWptTjGFRPqDtTtb?dt=5",
  "to": "GCQLYUE2DJT3N57BKHKW5DUOELDSEHNGIVHVHFBS5YMDBZX55RTSR6FM",
  "message": "Deposit successfully completed.",
  "extra_info": {}
}
```

Notifies A3S that a deposit has confirmed. Usually this is called by the relay server. Only use this after the [Notify Deposit Sent](#notify-deposit-sent) endpoint.

In other words, this endpoint is only for a situation where a relay server has a deposit that it already notified A3S about that has now gone to `SUCCESS` from `PENDING`.

In cases where a relay server has a new deposit (that A3S does not yet know about), it can just call [Notify Deposit Sent](#notify-deposit-sent) and A3S will issue tokens. In that case, there is no need to use this endpoint at all.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Deposit/Confirmed`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
reference | Unique relay server reference

# Withdrawal

## Get Withdrawal Instructions

```shell
curl "https://a3s.api.stellarport.io/v2/GBZNK6EFN3F5ZUS7BV53E2FZLYVYNNJXPR3DSZNOUD6C5W6N2QXV3PFN/Withdraw?asset_code=XRP&dest=rNXEkKCxvfLcM1h4HJkaj2FtmYuAWrHGbf&dest_extra=55"
```

```javascript
const options = {
  dest_extra: 'other_param'
};
let instructions = await a3s.withdrawalInstructions(asset_code, asset_issuer, dest, options);
```

> The above command returns JSON structured like this:

```json
{
  "account_id": "GCAANVYGJHG43WGHCM435FEJJZ3M4CYQ5JIYCNAR5ARIYAS3KRPEPZ4I",
  "memo_type": "text",
  "memo": "QytnaQ3iCZayKjTS0EKOznqBoEIM",
  "min_amount": 25,
  "fee_fixed": 0.25,
  "fee_percent": 0.5,
  "eta": 60,
  "extra_info": {}
}
```

Returns a set of instructions for the execution of a withdrawal.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Withdraw`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
dest  | The desired withdrawal destination
dest_extra (optional) | Another parameter to identify the withdrawal destination as required by [info](#get-info)

## Notify Withdrawal Sent

```shell
curl "https://a3s.api.stellarport.io/v2/Withdraw/Sent?tx_hash=2fe974224fd3cb323dfc02cb62dcd7797ca9975ecf3c80b80f1c9a6fe60430b6&op_order=1"
```

```javascript
let depositTransaction = await withdrawalSent(tx_hash, op_order);
```

> The above command returns JSON structured like this:

```json
{
  "id": "35",
  "kind": "withdrawal",
  "status": "pending_external",
  "asset_code": "XRP",
  "amount_in": "5.0000000",
  "amount_out": "4.72502625",
  "amount_fee": "0.27497375",
  "started_at": "2018-11-15T18:13:28.000Z",
  "completed_at": null,
  "stellar_transaction_id": "a34a69973e254c032061b4d2c85b47093738f7f13f9afdd4b3a5517919303472",
  "from": "QytnaQ3iCZayKjTS0EKOznqBoEIM",
  "to": "rNXEkKCxvfLcM1h4HJkaj2FtmYuAWrHGbf",
  "message": "Waiting for external XRP withdrawal.",
  "extra_info": {}
}
```

Notifies A3S of an incoming withdrawal. This endpoint does not usually need to be called by anyone (as A3S autosenses incoming withdrawals).

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/Withdraw/Sent`

### Query Parameters

Parameter | Description
--------- | -----------
tx_hash | The Stellar transaction hash of the withdrawal.
op_order | The operation order of the payment transaction.

## Notify Withdrawal Confirmed

```shell
curl "https://a3s.api.stellarport.io/v2/GBVOL67TMUQBGL4TZYNMY3ZQ5WGQYFPFD5VJRWXR72VA33VFNL225PL5/Withdraw/Confirmed?asset_code=XRP&reference=44"
```

```javascript
let depositTransaction = await withdrawalConfirmed(reference, asset_code, asset_issuer);
```

> The above command returns JSON structured like this:

```json
{
  "id": "34",
  "kind": "deposit",
  "status": "completed",
  "asset_code": "XRP",
  "amount_in": "5",
  "amount_out": "5",
  "amount_fee": "0",
  "started_at": "2018-11-14T22:53:51.000Z",
  "completed_at": "2018-11-15T17:07:45.338Z",
  "stellar_transaction_id": "e0f3a31292c805d2f7aa2540f64d92cd5159fb8d7df9404d4c5b3fd9faa4813b",
  "external_transaction_id": "EB8A04D87FB6C767A76B0F2C07848BB522529EED48BDC38144EE3CCF3730502F",
  "from": "rPFFGozFRSjbGTq8DwEWptTjGFRPqDtTtb?dt=5",
  "to": "GCQLYUE2DJT3N57BKHKW5DUOELDSEHNGIVHVHFBS5YMDBZX55RTSR6FM",
  "message": "Deposit successfully completed.",
  "extra_info": {}
}
```

Notifies A3S that a withdrawal has confirmed. Usually this is called by the relay server.

Often, after A3S notifies the relay server to execute a withdrawal via [Send Withdrawal](#send-withdrawal), it will get a `PENDING` response.

Once the withdrwaal successfully completes, the relay server should use this endpoint to notify A3S that a withdrawal is now confirmed.

### HTTP Request

`GET https://a3s.api.stellarport.io/v2/<asset_issuer>/Withdraw/Confirmed`

### URL Parameters

Parameter | Description
--------- | -----------
asset_issuer | The public key of the issuing account on Stellar.

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
reference | Unique relay server reference to the withdrawal

# Relay Server API

# Getting Started
If you are simply trying to interact with A3S and not actually run a relay server, you should never have to communicate with a relay server directly. This section is only for integrators who would like to run a relay server and interact with A3S so that they can bridge an asset to Stellar.

To get started building a relay server, you can check out our [relay-server-skeleton](https://github.com/stellarport/relay-server-skeleton)

# Deposit

## Deposit Destination

> Returns JSON structured like this:

```json
{
  "reference": "unique_destination_reference"
}
```

Generates a new unique deposit destination and returns the reference. The reference should be a string that a user will recognize as identifying a particular destination.

### HTTP Request

`GET https://your.relay.server/Deposit/Destination`

## Deposit Instructions

> Returns JSON structured like this:

```json
{
  "min_amount": 5,
  "fee_fixed": 0,
  "fee_percent": 0,
  "eta": 60, //seconds,
  "how": "rNXEkKCxvfLcM1h4HJkaj2FtmYuAWrHGbf?dt=88", //concise deposit destination
  "message": "Send XRP to ripple address rNXEkKCxvfLcM1h4HJkaj2FtmYuAWrHGbf. You MUST INCLUDE THE REQUIRED TAG 88 with the deposit" //expanded deposit details
}
```

Returns a set of corresponding instructions for a specific deposit destination.

### HTTP Request

`GET https://your.relay.server/Deposit/Instructions`

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
reference | The deposit destination string generated by [deposit destination](#deposit-destination).

## Get Deposit

> Returns JSON structured like this:

```json
{
  "id": "EB8A04D87FB6C767A76B0F2C07848BB522529EED48BDC38144EE3CCF3730502F", // can be null on an incomplete transaction
  "reference": "44",
  "code": "XRP",
  "status": "PENDING", //PENDING, SUCCESS or ERROR
  "type": "DEPOSIT",
  "to": "rPFFGozFRSjbGTq8DwEWptTjGFRPqDtTtb?dt=5",
  "amt": "5"
}
```

Returns a specific deposit. This endpoint is used by A3S to confirm an incoming deposit.

<aside class="notice">
There are two identifying properties on a deposit and withdrawal from a relay server,namely <code>id</code> and <code>reference</code>. <code>id</code> is the property that is viewable in the external system (e.g. a bitcoin transaction hash). Sometimes, an id may be null on an icomplete transaction. A reference MUST be specified. It is the relay server's reference to the transaction.
</aside>

### HTTP Request

`GET https://your.relay.server/Deposit`

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)

# Withdrawal

## Withdrawal Destination

> Returns JSON structured like this:

```json
{
  "reference": "unique_destination_reference"
}
```

Returns a withdrawal reference for a withdrawal destination. Should return a `200` status code if the destination is valid, otherwise a `400` status code if the destination parameters are invalid, incomplete or missing with a `message` field as to what is incorrect.

### HTTP Request

`GET https://your.relay.server/Withdraw/Destination`

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
dest | The dest as specified in [info](#get-info)
other parameters | Other variable parameters as specified in [info](#get-info)

## Withdrawal Instructions

> Returns JSON structured like this:

```json
{
  "min_amount": 5,
  "fee_fixed": 0,
  "fee_percent": 0,
  "eta": 60, //seconds,
  "message": "Some details about your upcoming withdrawal"
}
```

Returns withdrawal instructions for a withdrawal destination references as generated by [withdrawal destination](#withdrawal-destination).

### HTTP Request

`GET https://your.relay.server/Withdraw/Instructions`

### Query Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
reference | The deposit destination string generated by [deposit destination](#deposit-destination).

## Get Withdrawal

> Returns JSON structured like this:

```json
{
  "id": "0x2d746897195119a308d7c840f75c0a0f2c54ceb00cb78a0661516ba93ee29ad4",
  "reference": "33",
  "code": "ETH",
  "status": "SUCCESS",
  "type": "WITHDRAWAL",
  "to": "0xec0a404aaa8ca1746b5c1cbe7c99e553f96463f0",
  "anchorTransactionId": "27",
  "amt": "0.00397502625",
  "createdTms": "2018-06-11T21:35:09.184Z"
}
```

Returns a withdrawal.

### HTTP Request

`GET https://your.relay.server/Withdrawal`

### URL Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)

## Send Withdrawal

> Returns JSON structured like this:

```json
{
  "id": null, // can be null on a incomplete transaction
  "reference": "46",
  "code": "XRP",
  "status": "PENDING", //PENDING, SUCCESS or ERROR
  "type": "WITHDRAWAL",
  "to": "rNXEkKCxvfLcM1h4HJkaj2FtmYuAWrHGbf",
  "amt": "5.720032"
}
```

Sends a withdrawal.

### HTTP Request

`GET https://your.relay.server/Withdraw/Send`

### URL Parameters

Parameter | Description
--------- | -----------
asset_code | The code of the asset being deposited (e.g. BTC)
transaction_id | The transaction_id on A3S that should be executed by the relay server

<aside class="info">
Only the transaction id is passed to this endpoint on purpose. The relay server is expected to go back and fetch the transaction from A3S and confirm its authenticity before proceeding with the withdrawal.
</aside>
