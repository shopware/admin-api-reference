---
stoplight-id: 3be386a26c0f9
---

# Document Management

One can use documents to send the invoice, delivery notes, packing slips, etc. Already defined document types can be fetched from :

``` markdown
GET /api/document-type
```

## Creating a document type

You can create a document by its purpose - for example, a note for returned items using a simple payload.

```sample http
{
  "method": "post",
  "url": "http://localhost/api/document-type",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "name": "return note",
    "technicalName": "return-note"
  }
}
```

If documents are assigned to `global,` they can be used on any sales channel. This can be defined in the `document_base_config` entity as shown below: 

```sample http
{
  "method": "post",
  "url": "http://localhost/api/document-base-config",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "documentTypeId": "9cc669c406b441e1b7af035552db138f",
    "name": "return note",
    "global": true
}
  }
```

These documents are associated with order events. The below endpoint creates a document of invoice type for a particular order.

```sample http
{
  "method": "post",
  "url": "http://localhost/api/_action/order/document/invoice/create",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "orderId": "d84bbaaa3423495e8c98eef1444db7d0",
    "type": "string",
    "fileType": "pdf",
    "static": false,
    "referencedDocumentId": null,
    "config": {},
    "sent": true
  }
}
```

While placing an order, during order transaction or order delivery, you have the option to set the `sent` parameter to `true`. It is a boolean flag that determines whether to skip the creation of documents that have already been marked as sent while processing orders.

## Download a document

The below route allows you to download a document as a PDF. The document is followed by its ID and deeplink code.

```sample http
{
  "method": "post",
  "url": "http://localhost/api/_action/document/d01c4e3cc8ef49abbdb094a0d8c0547b/XdcfdoQITWimRreZFf6yMIcXfe3gl1op",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  }
}
```
