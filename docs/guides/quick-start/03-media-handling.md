---
stoplight-id: c042ae0cd330f
---

# Media Handling

A common task when performing product imports is the upload/creation of product images. 

In Shopware, this is handled in a two-step process, which allows for the separation between writing the associations between media objects and uploading the actual data.

1. Create a media entity associated with a product entity
2. Attach resource data to the media object
    1. Either reference an image resource via URL or
    2. Upload the resource directly

In the following, we will go through these steps in more detail. Before proceeding, ensure you have gone through the section on writing [Product Data](02-product-management.md).

## 1. Create a media entity associated with a product entity

The product media model is entirely relational and based on three elementary entities:

 * product
 * media
 * product_media

The `product` and `media` entities are connected by the `product_media` relation, which has the following shape:

**Product**

```json json_schema
{
  "type": "object",
  "description": "Product: Subset of the product object (not the entire object)",
  "properties": {
    "id": {
      "type": "string",
      "description": "Identifier of the Product object"
    },
    "media": {
      "type": "array",
      "description": "All ProductMedia items related to the product",
      "items": {
            "type": "ProductMedia"
        }
    },
    "cover": {
      "type": "object",
      "description": "Single ProductMedia item used as product cover"
    },
    "coverId": {
      "type": "string",
      "description": "Identifier of a ProductMedia item used as product cover"
    }
  }
}
```

**Media**

```json json_schema
{
  "type": "object",
  "description": "Media: Subset of the media object (not the entire object)",
  "properties": {
    "id": {
      "type": "string",
      "description": "Identifier of the Media object"
    }
  }
}
```

**ProductMedia**

```json json_schema
{
  "type": "object",
  "description": "ProductMedia: Object relating product and media entities",
  "properties": {
    "id": {
      "type": "string",
      "description": "Identifier of the ProductMedia object."
    },
    "productId": {
      "type": "string",
      "description": "Identifier of the related Product object."
    },
    "mediaId": {
      "type": "string",
      "description": "Identifier of the related Media object."
    },
    "position": {
      "type": "integer",
      "description": "Position of the displayed item in the list of product images"
    }
  }
}
```

Based on the guide on writing [Associations](../../concepts/endpoint-structure/writing-entities/associations.md), you will already know how to handle nested associations, e.g., write media and product_media using the product endpoint. Hence, we are showing the most straightforward way of creating media entities and associating them with a product:

**Try it out**

```sample http
{
  "method": "patch",
  "url": "http://localhost/api/product/a55ca50a2cef46d5b11a12c4b4614988",
  "headers": {
    "Content-Type": "application/json",
    "Authorization": "Bearer <your-bearer-token>"
  },
  "body": {
    "media": [{
      "id": "0fa91ce3e96a4bc2be4bd9ce752c3425",
      "media": {
        "id": "cfbd5018d38d41d8adca10d94fc8bdf0"
      }
    }]
  }
}
```

```json
// PATCH /api/product/a55ca50a2cef46d5b11a12c4b4614988

{
  "media": [{
    "id": "0fa91ce3e96a4bc2be4bd9ce752c3425",
    "media": {
      "id": "cfbd5018d38d41d8adca10d94fc8bdf0"
    }
  }]
}
```

This request updates a given product and creates an array of media items. Make sure you keep track of the IDs you have created because you will need them for the second step.

> A good idea is to generate `product_media` and `media` IDs based on a product identifier in combination with another property, like its position in the product image list and hashing it. This way, you don't have to perform any additional lookups.

Now that you have an idea of the structure of media items, we can start uploading resources.

## 2. Attach resource data to the media object

This step is about attaching the actual image data. This can be done in two ways - provide a link to a resource, and Shopware will download the file from there or provide the data within the request body. We will have a look at both ways:

### Provide a resource URL

This way, you provide the `mediaId` (id of the Media, not the ProductMedia) as a path parameter, the image `url` as a body parameter, and the image `extension` as a query parameter.

**Try it yourself** 

```sample http
{
  "method": "post",
  "url": "http://localhost/api/_action/media/0fa91ce3e96a4bc2be4bd9ce752c3425/upload?extension=jpg",
  "headers": {
    "Content-Type": "application/json",
    "Authorization": "Bearer <your-bearer-token>"
  },
  "body": {
    "url": "<url-to-your-image>"
  }
}
```

### Upload the resource directly

This way, you provide the binary file directly within the request body, set the content type header accordingly (e.g., `Content-Type: image/jpg`), and provide the `extension` as a query parameter.

```sample http
{
  "method": "post",
  "url": "http://localhost/api/_action/media/0fa91ce3e96a4bc2be4bd9ce752c3425/upload?extension=jpg",
  "headers": {
    "Content-Type": "image/jpg",
    "Authorization": "Bearer <your-bearer-token>"
  },
  "body": {
    // binary file body
  }
}
```
