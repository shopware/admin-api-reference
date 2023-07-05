---
stoplight-id: e51cf55ab14a4
---

# Product Management

This section explains the handling of the product data structure.

To start easy, below is a sample request to create a product with simple data from its complex API schema.

## Create a new product with a simple payload

A product has only a handful of required fields:

* name [string]
* productNumber [string]
* taxId [string]
* price [object]
* stock [int]

The smallest required payload for a product can therefore be as follows:

```sample http
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

```description json_schema
{
  "type": "object",
  "title": "MinimalProductPayload",
  "description": "Parameters for product creation.",
  "properties": {
    "name": {
      "description": "Name of the product.",
      "type": "string"
    },
    "productNumber": {
      "description": "Any random number given to product.",
      "type": "string"
    },
    "stock": {
      "description": "Availability of stock.",
      "type": "string"
    },
    "taxId": {
      "description": "ID of [tax](../../../adminapi.json/components/schemas/Tax)",
      "type": "string"
    },
    "price": []
      "currencyId": {
      "description": "ID of [currency](../../../adminapi.json/components/schemas/Currency).",
      "type": "string"
      },
      "gross": {
      "description": "Gross price of a product.",
      "type": "string"
      },
      "net": {
      "description": "Net price of a product.",
      "type": "string"
      },
      "linked": {
      "description": "If set to true, net price is automatically calculated based on gross price and stored tax rate.",
      "type": "boolean"
      }
  }
}
```

The following payload examples contain UUIDs for various entities such as currencies, tax rates, manufacturers, or properties. These IDs are different on each system and must be adjusted accordingly.

## Category

Products are organized into categories within the catalog.

Below is a sample request to create a category:

```sample http
{
  "method": "post",
  "url": "http://localhost/api/category",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "displayNestedProducts": true,
    "type": "page",
    "productAssignmentType": "product",
    "name": "Home"
    }
  }
```

```description json_schema
{
  "type": "object",
  "description": "Parameters for category creation.",
  "properties": {
    "displayNestedProducts": {
      "description": "Specify `true` to display nested products else `false`.",
      "type": "boolean"
    },
    "type": {
      "description": "Types of category - `folder`, `link`, `page` ",
      "type": "string",
      "Example": " `product`, `category` "
    },
    "productAssignmentType": {
      "description": "Accepts values `product`, and `product-stream` for products added explicitly and added via Dynamic product group, respectively.",
      "type": "string"
    },
    "name": {
      "description": "Name of the category",
      "type": "string"
    }
  }
}
```

## Product assignment

Every product must be assigned to a category for its display. It can be explicitly set or can be assigned as a [dynamic product group](../../../adminapi.json/components/schemas/ProductStream) to a category.

Let us assign the test product to the *Home* category created earlier:

```sample http
{
  "method": "PATCH",
  "url": "https://localhost/api/category/a11d11c732d54debad6da3b38ad07b11",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "productAssignmentType": "product_stream",
    "productStreamId": "bca25935854b4a0181681c81bcacd7ba"
  }
}
```

```description json_schema
{
  "type": "object",
  "description": "Parameters for product assignment.",
  "properties": {
    "id": {
      "description": "Unique ID of category.",
      "type": "string"
    },
  "productAssignmentType": {
      "description": "Accepts values `product`, and `product-stream` for products added explicitly and added via Dynamic product group, respectively.",
      "type": "string"
    },
  "productStreamId": {
      "description": "Unique ID Dynamic product group.",
      "type": "string"
    }
  }
}
```

### Assigning of properties and categories

The product has various `many-to-many` associations. This type of association is a link between the records. Examples are the `properties` and `categories` of a product.

For assigning several `properties` and `categories`, this is an exemplary payload:

```javascript
{
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "db6f3ed762d14b0395a3fd2dc460db42",
    "properties": [
        { "id": "b6dd111fff0f4e3abebb88d02fe2021e"},
        { "id": "b9f4908785ef4902b8d9e64260f565ae"}
    ],
    "categories": [
        { "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca" },
        { "id": "cdea94b4f9452254a20b91ec1cd538b9" }
    ]
}
```

To remove these `properties` and `categories`, the corresponding routes can be used for the mapping entities:

* `DELETE /api/product/{productId}/properties/{optionId}`
* `DELETE /api/product/{productId}/categories/{categoryId}`

To delete several assignments at once, the `/_action/sync` route can be used:

```javascript
{
    // This key can be defined individually
    "unassign-categories": {
        "entity": "product_category",
        "action": "delete",
        "payload": [
            { "productId": "069d109b9b484f9d992ec5f478f9c2a1", "categoryId": "1f3cf89039e44e67aa74cccd90efb905" },
            { "productId": "073db754b4d14ecdb3aa6cefa2ba98a7", "categoryId": "a6d1212c774546db9b54f05d355376c1" }
        ]
    },

    // This key can be defined individually
    "unassign-properties": {
        "entity": "product_property",
        "action": "delete",
        "payload": [
            { "productId": "069d109b9b484f9d992ec5f478f9c2a1", "optionId": "2d858284d5864fe68de046affadb1fc3" },
            { "productId": "069d109b9b484f9d992ec5f478f9c2a1", "optionId": "17eb3eb8f77f4d87835abb355e41758e" },
            { "productId": "073db754b4d14ecdb3aa6cefa2ba98a7", "optionId": "297b6bd763c94210b5f8ee5e700fadde" }
        ]
    }
}
```

### `CategoriesRo` Association

The `product.categories` association contains the assignment of products and their categories. This table is not queried in the storefront because all products of subcategories should be displayed in listings as well. Therefore there is another association: `product.categoriesRo`. This association is read-only and is filled automatically by the system. This table contains all assigned categories of the product as well as all parent categories.

## Product reviews

Reviews are comments that stand as a means to evaluate products by buyers. This below API adds a product review against a particular product as shown below:

```sample http
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
```

```description json_schema
{
  "type": "object",
  "description": "Parameters for product reviews.",
  "properties": {
    "productId": {
      "description": "Unique ID of a product.",
      "type": "string"
    },
    "salesChannelId": {
      "description": " Unique ID of defined sales channel.",
      "type": "string",
    },
    "languageId": {
      "description": "Unique ID of language.",
      "type": "string"
    },
    "title": {
      "description": "Caption for the review.",
      "type": "string"
    },
    "content": {
      "description": "Review description.",
      "type": "string"
    }
  }
}
```

## Cross-selling

Cross-selling features product recommendations and interesting content to achieve an optimal shopping experience in the shop.

```sample http
{
  "method": "post",
  "url": "https://localhost/api/product/a55ca50a2cef46d5b11a12c4b4614988/cross-sellings",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "name": "sample_review",
    "type": "productStream",
    "position": 1,
    "sortBy": "name",
    "sortDirection": "ASC",
    "active": true,
    "limit": 24,
    "productId": "bca25935854b4a0181681c81bcacd7ba"
  }
}
```

```description json_schema
{
  "type": "object",
  "description": "Parameters for product reviews.",
  "properties": {
    "name": {
      "description": "Name of the cross-selling.",
      "type": "string"
    },
    "type": {
      "description": "Accepts `productList` or `productStream` type.",
      "type": "string"
    },
    "position": {
      "description": "Position of the product to be displayed in the list. It accepts values greater than 1. When only one product list is to be displayed, the default position taken is 1.",
      "type": "integer",
    },    
    "sortBy": {
      "description": "Sort criteria by `name`, `price`.",
      "type": "string"
    },
    "sortDirection": {
      "description": "Sorting can be `ASC` or `DESC`.",
      "type": "string"
    },    
    "active": {
      "description": "When active is `true`, product recommendation is visible.",
      "type": "boolean"
    },
    "limit": {
      "description": "Maximum number of products displayed in a row.",
      "type": "string"
    },
    "productId": {
      "description": "Unique ID of product.",
      "type": "string"
    }
  }
}
```

## Price

A particular product's price can be fetched, updated or a [price rule can be created](https://shopware.stoplight.io/docs/admin-api/ZG9jOjEyMzA4NTUy-product-data#quantity-and-rule-price-structure).

Price handling is one of the edge cases in the product data structure. There are three different prices for a product, which can be queried via API:

* `product.price`
* `product.prices`
* `product.listingPrices`

Only the first two can be written via API \(`product.price`, `product.prices`\). The `product.price` is the "simple" price of a product. It does not contain quantity information, nor is it bound to any `rule`.

To update the price for a particular product, use the below endpoint:

```text
PATCH /api/product/{product-id}
```

```sample http
{
  "method": "patch",
  "url": "https://localhost/api/product/a55ca50a2cef46d5b11a12c4b4614988",
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
```

```description json_schema
{
  "type": "object",
  "description": "Parameters for price updation",
  "properties": {
    "price": []
      "currencyId": {
      "description": "ID of the currency to which the price belongs.",
      "type": "string"
      },
      "gross": {
      "description": "This price is displayed to customers who see gross prices in the shop.",
      "type": "string"
      },
      "net": {
      "description": "This price is shown to customers who see net prices in the shop.",
      "type": "string"
      },
      "linked": {
      "description": "If set to true, net price is automatically calculated based on gross price and stored tax rate.",
      "type": "boolean"
      }
  }
}
```

### Currency price structure

Within the price, different currency prices are available. Each currency price includes properties `currencyId`, `gross`, `net`, `linked`.

To define prices for a product in different currencies, this is an exemplary payload:

```javascript
{
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "db6f3ed762d14b0395a3fd2dc460db42",
    "price": [
        {
            // euro price
            "currencyId" : "db6f3ed762d14b0395a3fd2dc460db42", 
            "gross": 15, 
            "net": 10, 
            "linked" : false
        },
        {
            // dollar price
            "currencyId" : "16a190bd85b741c08873cfeaeb0ad8e1", 
            "gross": 120, 
            "net": 100.84, 
            "linked" : true
        },
        {
            // pound price
            "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
            "gross": 66, 
            "net": 55.46, 
            "linked" : true
        }
    ]
}
```

### Quantity and rule price structure

As an extension to the `product.price`, there is `product.prices`. These are prices that are bound to a `rule`. Rules \(`rule` entity\) are prioritized. If there are several rules for a customer, the customer will see the rule price with the highest priority. In addition to the dependency on a rule, a quantity discount can be defined using these prices.

Each price in `product.prices` has the following properties:

* `quantityStart` \[int\]     - Indicates the quantity from which this price applies.
* `quantityEnd` \[int\|null\]  - Specifies the quantity until this price is valid. 
* `ruleId` \[string\]         - Id of the rule to which the price applies.
* `price` \[object\[\]\]        - Includes currency prices \(same structure as `product.price`\).

To define prices for a rule including a quantity discount, this is an exemplary payload:

```javascript
{
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "db6f3ed762d14b0395a3fd2dc460db42",
    "price": [
        { 
            "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
            "gross": 15, 
            "net": 10, 
            "linked": false 
        }
    ],
    "prices": [
        { 
            "id": "9fa35118fe7c4502947986849379d564",
            "quantityStart": 1,
            "quantityEnd": 10,
            "ruleId": "43be477b241448ecacd7ea2a266f8ec7",
            "price": [
                { 
                    "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
                    "gross": 20, 
                    "net": 16.81, 
                    "linked": true 
                }
            ]

        },
        { 
            "id": "db6f3ed762d14b0395a3fd2dc460db42",
            "quantityStart": 11,
            "quantityEnd": null,
            "ruleId": "43be477b241448ecacd7ea2a266f8ec7",
            "price": [
                { 
                    "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
                    "gross": 19, 
                    "net": 15.97, 
                    "linked": true 
                }
            ]
        }
    ]
}
```

### Listing price handling

The third price property available on the product is the `product.listingPrices`. These prices are determined automatically by the system. The price range for the corresponding products is available here. Prices are determined based on all variants of prices that could be displayed to the customer in the shop.

Each price within this object contains the following properties:

* `currencyId` \[string\] - The currency to which this price applies.
* `ruleId` \[string\]     - The rule to which this price applies.
* `from` \[price-obj\]    - The lowest price possible for the product in this currency.
* `to` \[price-obj\]      - The highest price that is possible for the product in this currency.
