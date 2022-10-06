# Quick Start Guide

## Overview

Shopware Admin API allows web services to perform administrative tasks. This guide is designed to help you understand the Admin API, its endpoints, and its usage. You will get to learn everything about this API.

* Authentication as API user

* Products 

    * Reviews

    * Categories

    * Dynamic product groups

    * Cross-selling

    * Price

* Orders & shipping

    * Order transaction

    * Delivery & Delivery position

    * Line item

    * Shipping (method, shipping price, tags)

* Customer

    * Customer creation & recovery

* Content

    * CMS PAGES (sec, blocks, slots)

    * CMS Extension plugin (Scroll navigation, Block visibility, Quick view)

    * Media

* Themes

  * landing page
  
  * Media
  
  * Sales channel

* Marketing

    * Document types

    * Promotion

* Extension

    * Apps

    * Plugins

* Sales channels

* Cache and indexer management

* SEO

It is useful to use an API client like Postman or Insomnia to follow this guide.

## General

The Admin API has a base route that is always relative to your Shopware instance host. Note that it might differ from your sales channel domain. Let us assume your Shopware host is

https://shop.example.com/

then your Admin API base route will be

https://shop.example.com/api/

The Admin API offers a variety of functionalities referred to as endpoints or nodes, where each has its own route. Refer to [endpoint structure](https://shopware.stoplight.io/docs/admin-api/ZG9jOjEyMzA1ODA5-endpoint-structure) for more details. The endpoints mentioned subsequently are always relative to the API base route.

## Authentication and Setup 

All REST Admin API queries require a valid Shopware access token.The Admin API uses the OAuth 2.0 standard to authenticate users. OAuth 2.0 requires you to obtain an access token to confirm your identity for every server request.

OAuth 2.0 defines various user authentication types called application grant types. We recommend you to only use Password credentials grant type for all client integrations. This grants client applications to perform administrative actions.

### Configure OAuth in a REST client

A typical Admin API request, including headers, will look as shown below:

```json http
{
  "method": "post",
  "url": "http://localhost/api/auth/token",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json"
  },
  "body":{
    "client_id": "administration",
    "grant_type": "password",
    "scopes": "write",
    "username": "your.username@shopware.com",
    "password": "your.password@123"
}
}
```
Once you have obtained the access token, simply add it to `Authorization` header as a Bearer token.

Many REST clients, also come with built-in functionality to support the OAuth grant flows.

In Insomnia or Postman, just select **OAuth 2.0** in the *Authorization* tab of your request and enter the following configuration:

| Config              | Value                                             |
|-------------------- | ------------------------------------------------- |
| **Grant Type**      | Password Credentials               |
| **Username**        | Admin user name                                   |
| **Password**        | Admin user password                               |
| **Acess Token URL** | `https://replace-with-your-host/api/oauth/token`  |
| **Client ID**       | `administration`                                  |

Now that you have authenticated, you can perform your first request to obtain Shopware version.

```json http
{
  "method": "get",
  "url": "http://localhost/api/_info/version",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
}
```

Below is the reponse:

```
{
    "version": "6.4.16.0"
}
```

Depending on your setup, integration type differs and hence the process of [obtaining the access the access token](https://shopware.stoplight.io/docs/admin-api/ZG9jOjEwODA3NjQx-authentication#obtain-an-access-token).
