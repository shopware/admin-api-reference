# Order Overview

A list of all customer orders are obtained using the route:

```
POST /api/search/order
```
## Create order

You can create orders manually in admin panel o record orders that are made outside of Shopware or to send customer invoices.

```json http
{
  "method": "post",
  "url": "http://localhost/api/order",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
   {
    "billingAddressId": "c90e05c82c5a4457844cba7403c7ef96",
    "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "languageId": "2fbb5fe2e29a4d70aa5854ce7ce3e20b",
    "salesChannelId": "98432def39fc4624b33213a56b8c944d",
    "orderDateTime": "2021-05-31T14:13:14.866+00:00",
    "currencyFactor": 1.0,
    "stateId": "a75eb89b4abe41f9bade83b2f07d874e"
   }
  }
}
``` 

## order line item

To fetch line items for a particular order

```json http
{
  "method": "get",
  "url": "http://localhost/api/_action/order/558efc15fe604829b4d0607df75187e0/state/complete",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    }
  }
```

Once an order is created it status is associated with order, payment, and delivery.

## Order transitions

On creation of a new order, the order state by default is set to open. Order status can be transitioned among `cancel`, `complete`, `reopen`, `process` as shown below:

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/order/558efc15fe604829b4d0607df75187e0/state/complete",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    }
  }
```

The `state_machine_transition` is a collection of all defined transitioned defined.

A cancelled order cannot change to in-progress state unless it is reopened again.

## Order delivery & DELIVERY POSITION

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/order_delivery/558efc15fe604829b4d0607df75187e0/state/complete",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    }
  }

## Order transaction

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/order_transaction/558efc15fe604829b4d0607df75187e0/state/complete",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    }
  }
```  

  










