# Authentication

The Admin API uses the [OAuth 2.0](https://oauth.net/2/) standard to authenticate users. In short, OAuth 2.0 requires you to obtain an access token which you will have to include in every subsequent request so the server can confirm your identity.

## Grant Types

OAuth 2.0 defines various ways that users can authenticate, so-called **application grant types**. The Admin API supports two grant types or -flows:

* Client Credentials Grant
* Resource Owner Password Grant
* \(Refresh Token Grant\)

Not sure which grant type to use? Read on below.

### Client Credentials

Per standard, the client credentials grant type should be used for machine-to-machine communications, such as CLI jobs or automated services. Once an access token has been obtained, it remains valid for 10 minutes.

> It requires the setup of an [integration](https://docs.shopware.com/en/shopware-6-en/settings/system/integrationen?category=shopware-6-en/settings/system) and two credentials - an **Access key ID** and a **Secret access key**.

### Resource Owner Password

The resource owner password credentials grant is used by our admin panel. It identifies the API user based on a **username** and a **password** in exchange for an access token with a lifetime of 10 minutes and a refresh token. We recommend to only use this grant flow for client applications that should perform administrative actions and require a user-based authentication.

> It requires an [admin user](https://docs.shopware.com/en/shopware-6-en/settings/system/user?category=shopware-6-en/settings/system#new-user) to be set up.


### Refresh Token

This grant is only available, when a preceding authentication with the resource owner password grant type has been performed. The **refresh token** obtained during the initial authentication can be exchanged for another short-lived \(10 minutes\) access token.

## Obtain an access token

In order to obtain an access token, perform one of the following requests, depending on your setup and grant type.

### Integration (Client Credentials Grant Type)
```sample http
{
  "method": "POST",
  "url": "http://localhost/api/oauth/token",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
  },
  "body": {
    "grant_type": "client_credentials",
    "client_id": "<client-id>",
    "client_secret": "<client-secret>"
  }
}
```

which will return

```javascript
{
  "token_type": "Bearer",
  "expires_in": 600,
  "access_token": "xxxxxxxxxxxxxx"
}
```

### Username and Password (Password Grant Type)
```sample http
{
  "method": "POST",
  "url": "http://localhost/api/oauth/token",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
  },
  "body": {
    "client_id": "administration",
    "grant_type": "password",
    "scopes": "write",
    "username": "<user-username>",
    "password": "<user-password>"
  }
}
```

which will return

```javascript
{
  "token_type": "Bearer",
  "expires_in": 600,
  "access_token": "xxxxxxxxxxxxxx",
  "refresh_token": "token"
}
```

Make sure to also persist the `refresh_token` for subsequent authentications using the refresh token grant.

### Refresh Token
```sample http
{
  "method": "POST",
  "url": "http://localhost/api/oauth/token",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
  },
  "body": {
    "grant_type": "refresh_token",
    "client_id": "<client-id>",
    "refresh_token": "<refresh-token>"
  }
}
```

which will return

```javascript
{
  "token_type": "Bearer",
  "expires_in": 600,
  "access_token": "xxxxxxxxxxxxxx",
  "refresh_token": "token"
}
```

## Use the access token

Once you've obtained an access token, simply provide it in your requests `Authorization` header as a Bearer token and you're ready to go.

```yaml
// GET /api/product/b7d2554b0ce847cd82f3ac9bd1c0dfad

Host: shop.example.com
Content-Type: application/json
Authorization: Bearer eyJ0.... <- this is where your access token goes
```

## Configure OAuth in a REST client

Many REST clients, such as Postman or Insomnia come with built-in functionality to support the OAuth grant flows.

In Insomnia, just select **OAuth 2** in the *Authentication* tab of your request and enter the following configuration:

| Config               | Value                                             |
|--------------------- | ------------------------------------------------- |
| **Grant Type**       | Resource Owner Password Credentials               |
| **Username**         | Admin user name                                   |
| **Password**         | Admin user password                               |
| **Access Token URL** | `https://replace-with-your-host/api/oauth/token`  |
| **Client ID**        | `administration`                                  |
