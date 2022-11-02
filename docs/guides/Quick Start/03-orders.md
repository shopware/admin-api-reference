# Order Overview

A list of all customer orders are obtained using the route:

``` markdown
POST /api/search/order
```
## Create order

You can create orders manually in admin panel to record orders that are made outside of Shopware or to send customer invoices.

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

```json json_schema
{
  "type": "object",
  "description": "Parameters for order creation",
  "properties": {
    "billingAddressId": {
      "description": "ID of the billing address",
      "type": "string"
    },
    "currencyId": {
      "description": "ID of the currency to which the price belongs",
      "type": "string"
    },
    "languageId": {
      "description": "Unique ID of language",
      "type": "string"
    },
    "salesChannelId": {
      "description": "Unique ID of defined sales channel",
      "type": "string"
    },
    "orderDateTime": {
      "description": "Timestamp of the order placed",
      "type": "string"
    },
    "currencyFactor": {
      "description": "Rate factor for currencies",
      "type": "string"
    },
    "stateId": {
      "description": "Unique ID of transition state as defined by state machine",
      "type": "string"
      }
  }
}
```

## Order line item

An order can be have more other items or child items of `type` : `product`, `promotion`, `credit` or `custom`. To fetch line items for a particular order, try the below API request:

```json http
{
  "method": "get",
  "url": "http://localhost/api/order/558efc15fe604829b4d0607df75187e0/line-item",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
  }
```

Every order created is associted with order, payment, and delivery transitions. More details are mentioned below:

## Order state handling

Every order in Shopware has three state machines `order.state`, `order_delivery.state`, `order_transaction.state` that holds the status of order, delivery and payment status respectively. The `state_machine_transition` is a collection of all defined transitioned defined.

The `transition` method handles the order transition from one state to another.

### Order

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
```
A cancelled order cannot change to in-progress state unless it is reopened again.

### Order delivery

The order delivery state represents the state of the delivery. `reopen`, `ship`, `ship_partially`, `cancel`, `retour`,
`retour_partially` are the states associated with order delivery.

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/order_delivery/558efc15fe604829b4d0607df75187e0/state/fail",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
}
```

### Order transaction

The order transaction state represents the state of the payment. `open`, `fail`, `authorize`, `refund_partially`, `refund`, `do_pay`, `paid`, `paid_partially`, `remind`, `cancel` are the states associated with order transaction.

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/order_transaction/558efc15fe604829b4d0607df75187e0/state/open",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
  }
```  

## Refund Payment

[Initiating and capturing payment is handled by store-api](https://shopware.stoplight.io/docs/store-api/8218801e50fe5-handling-the-payment), whereas payment refund is dealt by the admin-api.

Refund payment method can be called only for transactions that are claimed to be successful. The payment can either be completely or partially refunded.

Generally, refunds are linked to a specific transaction ID or order ID. A refund can have multiple positions, with different order line items and amounts. To allow easy refund handling, have your payment handler implement the `RefundPaymentHandlerInterface`. This validates the legitimacy of the refund and call the PSP to refund the given transaction.

Use the Refund API `/api/_action/order_transaction_capture_refund/{refundId}` endpoint to refund payments. You usually need the `refundId` and `context`. The refundId is the id of the `OrderTransactionCaptureRefund` entity, which the payment plugin has created before.

When you refund a payment, the Refunds API creates an object that provides refund details — the information on the amount, the referenced capture and, if provided, a reason and specific positions which items are being refunded. Once the refund is successfull, the `stateHandler` changes the state to *complete*.

In case of refund failures, `RefundException` will handle it.

  










