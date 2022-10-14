---
stoplight-id: cd9ace3c97fe2
---

# Customer Data

One can obtain a list of customers using `/api/search/customer`. Individual customer details can be obtained using `GET` method from the following endpoints :

| Scenario | Endpoint |
| :--- | :--- |
| Individual customer profile| `/api/customer/{customer_id}` |
| Customer address | `/api/customer/{customer_id}/{default _billing/shipping_address}` |
| Customer orders | `/api/customer/{customer_id}/order-customers` |
| Group | `/api/customer/{customer_id}/group` |
| Customer payment method | `/api/customer/{customer_id}/default-payment-method` |
| Customer sales channel | `/api/customer/{customer_id}/sales-channel` |
| Customer language | `/api/customer/{customer_id}/language` |

## Customer creation with simple payload

```json http
{
  "method": "post",
  "url": "http://localhost/api/customer",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "groupId": "cfbd5018d38d41d8adca10d94fc8bdd6",
    "defaultPaymentMethodId": "754b5604da514b6d9845385aafd1ed19",
    "salesChannelId": "98432def39fc4624b33213a56b8c944d",
    "defaultBillingAddressId": "0bf9d426f1de469995f7721f49184aab",
    "defaultShippingAddressId": "0bf9d426f1de469995f7721f49184aab",
    "customerNumber": "SW20025",
    "firstName": "Dennis",
    "lastName": "Rock",
    "email": "SW20025@example.com"
  }
}
```

```json json_schema
{
  "type": "object",
  "description": "Parameters for customer creation",
  "properties": {
    "groupId": {
      "description": "ID of the customer group",
      "type": "string"
    },
    "defaultPaymentMethodId": {
      "description": "ID of defauly payment method",
      "type": "string"
    },
    "salesChannelId": {
      "description": "Unique ID of defined sales channel",
      "type": "string"
    },
    "defaultBillingAddressId": {
      "description": "ID of default billing address.",
      "type": "string"
    },
    "defaultShippingAddressId": {
      "description": "ID of default shipping address",
      "type": "string"
    },
    "customerNumber": {
      "description": "Unique number assigned to the customer",
      "type": "string"
      },
      "firstName": {
      "description": "First name of customer",
      "type": "string"
    },
    "lastName": {
      "description": "Lat name of customer",
      "type": "string"
    },
    "email": {
      "description": "email address of customer",
      "type": "string"
    }
  }
}
```
You can create customers with all the essential details. Look at the [customer schema](../../../adminapi.json/components/schemas/Customer) for rest of the details.

## Create customer groups

Create customer group to create a completely new customer group

```json http
{
  "method": "post",
  "url": "http://localhost/api/customer-group",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
        "name": "premium"
  }
}
```

## CustomerGroupRegistrationSalesChannels

You can create customer group and assign it to the standard Customer Group of the sales channel. 

```json http
{
  "method": "post",
  "url": "http://localhost/api/customer-group",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
      "name": "Regular Grp",
      "displayGross": true,
      "registrationActive": true,
      "registrationTitle": "Common customer base",
      "registrationIntroduction": "xyz",
      "registrationOnlyCompanyRegistration": false,
      "registrationSeoMetaDescription": "../settings/merchants",
    }
}
```
