# Product

To start easy, below is a sample request to create a product with simple data from its complex API schema.

## Create new product with simple payload

```json http
{
  "method": "post",
  "url": "http://localhost/api/product",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "a5da76b447db4d0aba62e6512dadf45b",
    "price": [
        {
            "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
            "gross": 15, 
            "net": 10, 
            "linked" : false
        }
    ]
      }
    }
  }
```

```json json_schema
{
  "type": "object",
  "description": "Parameters for category creation",
    "name": {
      "description": "Name of the product",
      "type": "string",
      "Example": " `product`, `category` "
    },
    "productAssignmentType": {
      "description": "Accepts values `product`, `product-stream` for products added explicitly and added via   Dynamic product group respectively",
      "type": "string"
    },
    "name": {
      "description": "Name of the category to be created",
      "type": "string"
    }
  }
}
```

## Category

All products are categoried in the catelog. Below is a sample request to create a category entry.

```json http
{
  "method": "post",
  "url": "http://localhost/api/category/bda4b60e845240b2b9d6b60e71196e14/products",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "displayNestedProducts": true,
    "type": "product",
    "productAssignmentType": "product",
    "name": "Main navigation"
    }
    }
  }
```

```json json_schema
{
  "type": "object",
  "description": "Parameters for category creation",
  "properties": {
    "displayNestedProducts": {
      "description": "Specify `true` to display nested products else `false` ",
      "type": "boolean"
    },
    "type": {
      "description": "Types of category - `folder`, `link`, `page` ",
      "type": "string",
      "Example": " `product`, `category` "
    },
    "productAssignmentType": {
      "description": "Accepts values `product`, `product-stream` for products added explicitly and added via   Dynamic product group respectively",
      "type": "string"
    },
    "name": {
      "description": "Name of the category to be created",
      "type": "string"
    }
  }
}
```

## Product assignment

Every product must be assigned to a category for its display. It can be explicitly assiged or can be assigned as Dynamic Product Group to a category.

```json http
{
  "method": "PATCH",
  "url": "https://localhost/api/category/a11d11c732d54debad6da3b38ad07b11",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "id": "a11d11c732d54debad6da3b38ad07b11",
    "versionId": "0fa91ce3e96a4bc2be4bd9ce752c3425",
    "productAssignmentType": "product_stream",
    "productStreamId": "89a367082c0d48c88f59424a8bb0265b"
}
    }
  }
```

```json json_schema
{
  "type": "object",
  "description": "Parameters for product assignment",
  "properties": {
    "id": {
      "description": "Unique ID of category",
      "type": "string"
    },
    "versionId": {
      "description": "",
      "type": "string",
    },
    "productAssignmentType": {
      "description": "Accepts values `product`, `product-stream` for products added explicitly and added via Dynamic product group respectively",
      "type": "string"
    },
    "productStreamId": {
      "description": "Unique ID of the Dynamic product group",
      "type": "string"
    }
  }
}
```

## Product reviews

Reviews are comments that stands as a means to evaluate products by buyers. This below API adds a product review against a particular product as shown below:

```json http
{
  "method": "post",
  "url": "http://localhost/api/product-review",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "productId": "a55ca50a2cef46d5b11a12c4b4614988",
    "salesChannelId": "98432def39fc4624b33213a56b8c944d",
    "languageId": "2fbb5fe2e29a4d70aa5854ce7ce3e20b",
    "title": "Ice Cream Scoop",
    "content": "Very Good"
}
    }
  }
```

```json json_schema
{
  "type": "object",
  "description": "Parameters for product reviews",
  "properties": {
    "productId": {
      "description": "Unique ID of a product",
      "type": "string"
    },
    "salesChannelId": {
      "description": " Unique ID of a sales channel defined",
      "type": "string",
    },
    "languageId": {
      "description": "Unique ID of language",
      "type": "string"
    },
    "title": {
      "description": "Heading of the review comments",
      "type": "string"
    },
    "content": {
      "description": "Review description",
      "type": "string"
    }
  }
}
```

## Cross selling

Cross-selling features product recommendations and interesting contents to achieve an optimal shopping experience in the shop.

```json http
{
  "method": "post",
  "url": "https://localhost/api/product/04d0107ac065458da3a0fe0b9f9bc58c/cross-sellings",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
        "name": "testcase1",
        "position": 1,
        "sortBy": "name",
        "sortDirection": "ASC",
        "type": "productList",
        "active": true,
        "limit": 24,
        "productId": "a55ca50a2cef46d5b11a12c4b4614988"
    }
  }
```

//To add the parameters if the above mentioned way is right

## Price

A particular products's price can be updated or a [price rule can also be created](https://shopware.stoplight.io/docs/admin-api/ZG9jOjEyMzA4NTUy-product-data#quantity-and-rule-price-structure).

To update price for a particular product, use the below endpoint:

```json http
{
  "method": "patch",
  "url": "https://localhost/api/product/04d0107ac065458da3a0fe0b9f9bc58c",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "price": [
        {
            "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
            "net": 164,
            "gross": 180,
            "linked": false
        }
    ]
}
}

//To add the parameters if the above mentioned way is right
