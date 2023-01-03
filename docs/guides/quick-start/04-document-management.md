---
stoplight-id: 3be386a26c0f9
---

# Overview

One can use documents to send invoive, delivery note, packing slips, etc. Already defined document types can be fetched from :

``` markdown
GET /api/document-type
```

## Creating a document type

You can create a document by its purpose - for example, a note for returned items by using a simple payload.

```sample http
{
  "method": "post",
  "url": "http://localhost/api/document-type",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "name": "return note",
    "technicalName": "return-note"
  }
}
```

If documents are assigned to `global` then they can be used on any sales channel. This can be defined in `document_base_config` entity as shown below: 

```sample http
{
  "method": "post",
  "url": "http://localhost/api/document-base-config",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "documentTypeId": "9cc669c406b441e1b7af035552db138f",
    "name": "return note",
    "global": true
}
  }
```

These documents are associated to order events. The below endpoint creates a document of invoice type for a particular order.

```sample http
{
  "method": "post",
  "url": "http://localhost/api/_action/order/d84bbaaa3423495e8c98eef1444db7d0/document/invoice",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
}
```

## Download a document

The below route allows you to download a document as PDF. The document is followed by its ID and deeplink code.

```sample http
{
  "method": "post",
  "url": "http://localhost/api/_action/document/d01c4e3cc8ef49abbdb094a0d8c0547b/XdcfdoQITWimRreZFf6yMIcXfe3gl1op",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
}
```
