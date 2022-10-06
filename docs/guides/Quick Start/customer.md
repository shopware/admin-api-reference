# Customer Data

One can obtain a list of customers using `/api/search/customer`. Individual customer details can be obtained using `GET` method from the following endpoints :

| Scenario | Endpoint |
| :--- | :--- |
| Individual customer profile| `/api/customer/{customer_id}` |
| Customer address | `/api/customer/{customer_id}/{default _billing/shipping_address}` |
| Customer orders | `/api/customer/{customer_id}/order-customers` |
| Group | `/api/customer/{customer_id}/group` |
| Payment method | `/api/customer/{customer_id}/default-payment-method` |
| Payment method | `/api/customer/{customer_id}/sales-channel` |
| Payment method | `/api/customer/{customer_id}/language` |

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
    {
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
}
```
You can all create customers with all the essential details. Look at the [customer schema](https://shopware.stoplight.io/docs/admin-api/c2NoOjE0MzUxMjI0-customer) for rest of the details.

## Create customer groups

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
    {
        "name": "premium"
}
  }
}
```

## CustomerGroupRegistrationSalesChannels

## Customer Recovery

Deleted customers can be recovered using `/api/customer-recovery` endpoint. This endpoint accepts only `GET` and `POST` methods.

```json http
{
  "method": "post",
  "url": "http://localhost/api/customer-recovery",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    {
    "hash": "null",
    "customerId": "1749398c90654000af6877ccd691e3c8"
}
  }
}
```

