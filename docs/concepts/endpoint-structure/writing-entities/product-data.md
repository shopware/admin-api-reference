# Product Data

Refer to [Product Management](../../../guides/quick-start/02-product-management.md) section of this guide to get an overview of how the product data is handled. 

Next, let us understand more about how media, variants etc. are handled for the product entity.

## Media Management

> **Upload media resources**
>
> Please go to our guide on [Media Management](../media-handling.md) to get detailed information on uploading media. The section below only deals with the data model e.g. setting covers or ordering images.

Media of products are maintained via the association `product.media` and `product.cover`. The `product.media` association is a `one-to-many` association on the `product_media` entity. To assign a media to a product, a new `product_media` entity must be created, in which the foreign key for the corresponding `media` entity is defined. In addition to the foreign key, a `position` can be specified, which defines the display order.

```javascript
{
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "5f78f2d4b19f49648eb1b38881463da0",
    "price": [
        { "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", "gross": 15, "net": 10, "linked" : false }
    ],
    "media": [
        {
            "id": "5f78f2d4b19f49648eb1b38881463da0",
            "mediaId": "00a9742db2e643ccb9d969f5a30c2758",
            "position": 1
        }
    ]
}
```

To delete a media assignment, the ID of the `product_media` entity is required. In the above case this is the `5f78f2d4b19f49648eb1b38881463da0`. The corresponding route `DELETE /api/product/{productId}/media/{productMediaId}` can be used for this. To delete multiple assignments, the `/_action/sync` route can also be used here:

```javascript
{
    // This key can be defined individually
    "unassign-media": {
        "entity": "product_media",
        "action": "delete",
        "payload": [
            { "id": "5f78f2d4b19f49648eb1b38881463da0" },
            { "id": "18ada8e085d240369d06bb4b11eed3b5" }
        ]
    }
}
```

### Setting the cover

The `cover` of a product is controlled via `coverId` and the `cover` association. This contains a direct reference to a `product_media` entity. To set the cover of a product the following payload can be used:

```javascript
{
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "5f78f2d4b19f49648eb1b38881463da0",
    "price": [
        { "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", "gross": 15, "net": 10, "linked" : false }
    ],
    "coverId": "00a9742db2e643ccb9d969f5a30c2758"
}
```

To reset the cover, the value `null` can be passed instead of a UUID.

## Visibility handling

The `visibilities` control in which sales channel the product should be visible. This association is a `one-to-many` association.

Instead of just assigning a sales channel, the data structure allows a specification where the product should be displayed inside the sales channel using the `visibility` property.

This can be set to three different values:

| **Visibility** | **Behaviour**                                                                                         |
| :--- |:------------------------------------------------------------------------------------------------------|
| 10 | The product is only available via a direct link. It does **not** appear in listings or searches.          |
| 20 | The product is only available via a direct link and search. The product is **not** displayed in listings. |
| 30 | The product is displayed **everywhere**.                                                                  |

Since visibility can be configured per sales channel, the entity also has its own ID. This is needed to delete or update the assignment later. To assign a product to several sales channels, the following payload can be used:

```javascript
{
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "5f78f2d4b19f49648eb1b38881463da0",
    "price": [
        { "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", "gross": 15, "net": 10, "linked" : false }
    ],
    "visibilities": [
        { "id": "5f78f2d4b19f49648eb1b38881463da0", "salesChannelId": "98432def39fc4624b33213a56b8c944d", "visibility": 20 },
        { "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca", "salesChannelId": "ddcb57c32d6e4b598d8b6082a9ca7b42", "visibility": 30 }
    ]
}
```

Deleting a sales channel assignment is done via the route `/api/product/{productId}/visibilities/{visibilityId}`. To delete several assignments at once, the `/_action/sync` route can be used:

```javascript
{
    // This key can be defined individually
    "unassign-sales-channel-visibilities": {
        "entity": "product_visibility",
        "action": "delete",
        "payload": [
            { "id": "5f78f2d4b19f49648eb1b38881463da0" },
            { "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca" }
        ]
    }
}
```

## Variant handling

Variants are child elements of a product. As soon as a product is configured with variants, the parent product is only a kind of container. To create a variant, the following properties are required:

* `parentId` \[string\]      - Defines for which product the variant should be created
* `stock` \[int\]            - Defines the stock of the variant
* `productNumber` \[string\] - Defines the unique product number
* `options` \[array\]        - Defines the characteristic of the variant.

```javascript
{
    "id": "0d0adf2a3aa1488eb177288cfac9d47e",
    "parentId": "17f255e0a12848c38b7ec6767a6d6adf",
    "productNumber": "child.1",
    "stock": 10,
    "options": [
        {"id": "0584efb5f86142aaac44cc3beeeeb84f"},    // red
        {"id": "0a30f132eb1b4f34a05dcb1c6493ced7"}  // xl
    ]
}
```

## Inheritance

Data that is not defined in a variant, is inherited from the parent product. If the variants have not defined their own `price`, the `price` of the parent product is displayed. This logic applies to different fields, but also to associations like `product.prices`, `product.categories` and many more.

To define a separate `price` for a variant, the same payload can be used as for a non-variant products:

```javascript
{
    "id": "0d0adf2a3aa1488eb177288cfac9d47e",
    "parentId": "17f255e0a12848c38b7ec6767a6d6adf",
    "productNumber": "child.1",
    "stock": 10,
    "options": [
        {"id": "0584efb5f86142aaac44cc3beeeeb84f"},    // red
        {"id": "0a30f132eb1b4f34a05dcb1c6493ced7"}  // xl
    ],
    "price": [
        { "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", "gross": 15, "net": 10, "linked" : false }
    ]
}
```

To restore inheritance, the value `null` can be passed for simple data fields:

```javascript
// PATCH /api/product/0d0adf2a3aa1488eb177288cfac9d47e
{
    "price": null
}
```

In order to have an association such as `product.prices` inherited again from the parent product, the corresponding entities must be deleted.

If a variant is read via `/api`, only the not inherited data is returned. The data of the parent is not loaded here. In the `store-api`, however, the variant is always read with the inheritance, so that all information is already available to display the variant in a shop.

However, it is also possible to resolve the inheritance in the `/api` by providing the `sw-inheritance` header.

## Configurator handling

To create a complete product with variants, not only the variants have to be created but also the corresponding `options` have to be configured. For the variants this is done via the `options` association. This association defines the characteristics of the variant, i.e. whether it is the yellow or red t-shirt. For the parent product, the `configuratorSettings` association must be defined. This defines which options are generally available. The Admin UI and the Storefront UI are built using this data. The following payload can be used to generate a product with the variants: red-xl, red-l, yellow-xl, yellow-l.

```javascript
{
    "stock": 10,
    "productNumber": "random",
    "name": "random",
    "taxId": "9d4a11eeaf3a41bea44fdfb599d57058",
    "price": [
        {
            "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
            "net": 1,
            "gross": 1,
            "linked": true
        }
    ],
    "configuratorGroupConfig": [
        {
            "id": "d1f3079ffea34441b0b3e3096ac4821a",       //group id for "color"
            "representation": "box",
            "expressionForListings": true                   // display all colors in listings
        },
        {
            "id": "e2d24e55b56b4a4a8f808478fbd30333",       // group id for "size"
            "representation": "box",
            "expressionForListings": false
        }
    ],
    "children": [
        {
            "productNumber": "random.4",
            "stock": 10,
            // own pricing
            "price": [
                {
                    "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
                    "net": 1,
                    "gross": 1,
                    "linked": true
                }
            ],
            "options": [
                { "id": "4053fb11b4114d2cac7381c904651b6b" },   // size:  L
                { "id": "ae821a4395f34b22b6dea9963c7406f2" }    // color: yellow
            ]
        },
        {
            "productNumber": "random.3",
            "stock": 10,
            "options": [
                { "id": "ea14a701771148d6b04045f99c502829" },   // size:  XL
                { "id": "ae821a4395f34b22b6dea9963c7406f2" }    // color: yellow
            ]
        },
        {
            "productNumber": "random.1",
            "stock": 10,
            "options": [
                { "id": "ea14a701771148d6b04045f99c502829" },   // size:  XL
                { "id": "0b9627a94fc2446498ec6abac0f03581" }    // color: red
            ]
        },
        {
            "productNumber": "random.2",
            "stock": 10,
            "options": [
                { "id": "4053fb11b4114d2cac7381c904651b6b" },   // size:  L
                { "id": "0b9627a94fc2446498ec6abac0f03581" }    // color: red
            ]
        }
    ],
    "configuratorSettings": [
        { "optionId": "0b9627a94fc2446498ec6abac0f03581" },     // color: red
        { "optionId": "4053fb11b4114d2cac7381c904651b6b" },     // size:  L
        { "optionId": "ae821a4395f34b22b6dea9963c7406f2" },     // color: yellow
        { "optionId": "ea14a701771148d6b04045f99c502829" }      // size:  XL
    ]
}
```
