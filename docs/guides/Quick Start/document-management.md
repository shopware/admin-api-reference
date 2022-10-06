# Overview

One can use documents to send invoive, delivery note, packing slips, etc. Already defined document types can be fetched from `/api/document-type` endpoint. 

## Creating a document type

You can create a document by its purpose - for example, a note for returned items by using a simple payload.

```json http
{
  "method": "post",
  "url": "http://localhost/api/document-type",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    {
    "name": "return note",
    "technicalName": "return-note"
}
    }
  }
```

Reponse `204`

These documents can further be defined for particular orders.

The above mentioned documents are global types and have predefined format. These can further be customised to use as per the requirement.

The below endpoint creates a document of invoice type for a particular order.

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/order/d84bbaaa3423495e8c98eef1444db7d0/document/invoice",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    
    }
  }
```
## Download a document

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/document/d01c4e3cc8ef49abbdb094a0d8c0547b/XdcfdoQITWimRreZFf6yMIcXfe3gl1op",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    
    }
  }

  Path Parameters
deepLinkCode
string
required
A unique hash code which was generated when the document was created.

documentId
string
required
Identifier of the document to be downloaded.

Match pattern: `^[0-9a-f]{32}$`
Query Parameters
download
boolean
This parameter controls the Content-Disposition header. If set to true the header will be set to attachment else inline.

Default:
false