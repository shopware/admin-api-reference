# Bulk Payloads

The Sync API is an add-on to the Admin API that allows you to perform multiple write operations \(creating/updating and deleting\) simultaneously. All entities that can be written via the Admin API can also be written via the Sync API.

The endpoint is located at

```text
/api/_action/sync
```

and expects payloads via `POST` and `Content-Type: application/json`.

## Operations

In contrast to the Admin API, the Sync API does not differ between **create** and **update** operations, but always performs an **upsert** operation. During an **upsert**, the system checks whether the entity already exists in the system and updates it if an ID has been passed, otherwise a new entity is created with this ID.

A request always contains a **list of operations**. An operation defines the `action` to be executed \(`upsert` or `delete`\), an associated `entity` and the `payload` which is an array of multiple records \(for `upsert`\) or multiple IDs \(for `delete`\). Within a request, different entities can therefore be written in batch. For easier debugging, each operation can be given a key. The key is then used in the response to define which entities are written in which operation.

**Format of an operation**

| Field       | Values                                               |
|:------------|:-----------------------------------------------------|
| **entity**  | Any entity in Shopware, e.g. `category`or `customer` |
| **action**  | The type of operation - either `upsert` or `delete`  |
| **payload** | A list containing objects or a list of IDs           |

### Writing entities

Writing entities is performed with `upsert` operation. This operation is used to insert or update an array of multiple records with their data. The records in the payload for a bulk upsert operation typically represent individual entities (such as products, customers, or orders) with their corresponding data. The specific fields and data within each record depend on the entity you are working with. Here are examples for three different entities: tax, category and country.

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/sync",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "write-tax": {
        "entity": "tax",
        "action": "upsert",
        "payload": [
            { "name": "tax-1", "taxRate": 16 },
            { "name": "tax-2", "taxRate": 15 }    
        ]
    },
    "write-category": {
        "entity": "category",
        "action": "upsert",
        "payload": [
            { "name": "category-1" },
            { "name": "category-2" }
        ]
    },
    "write-country": {
        "entity": "country",
        "action": "upsert",
        "payload": [
            { "name": "country-1" },
            { "name": "country-2" }
        ]
    }
  }
}
```

#### Response

```javascript
{
    "extensions": [],
        "data": {
        "category": [
            "0189bf2a627a7296adbc83527ba9ac29",
            "0189bf2a627b719999a9bf3afdc5c5ac"
        ],
            "category_translation": [
            {
                "categoryId": "0189bf2a627a7296adbc83527ba9ac29",
                "languageId": "2fbb5fe2e29a4d70aa5854ce7ce3e20b"
            },
            {
                "categoryId": "0189bf2a627b719999a9bf3afdc5c5ac",
                "languageId": "2fbb5fe2e29a4d70aa5854ce7ce3e20b"
            }
        ],
            "country": [
            "0189bf2a627e723dbf691bd638113c02",
            "0189bf2a627e723dbf691bd638ca0a34"
        ],
            "country_translation": [
            {
                "countryId": "0189bf2a627e723dbf691bd638113c02",
                "languageId": "2fbb5fe2e29a4d70aa5854ce7ce3e20b"
            },
            {
                "countryId": "0189bf2a627e723dbf691bd638ca0a34",
                "languageId": "2fbb5fe2e29a4d70aa5854ce7ce3e20b"
            }
        ],
            "tax": [
            "0189bf2a627971fcb6de1311115ee7fe",
            "0189bf2a627971fcb6de131111ad13cd"
        ]
    },
    "notFound": [],
    "deleted": []
}
```

### Foreign key resolvers

When importing data from an external system, you usually don't have Shopware's UUIDs at hand but you do have stable human-readable keys (SKUs, ISO codes, technical names). Foreign key resolvers let you reference an entity by such a key inside a Sync payload, and the API resolves it to the UUID before writing.

Anywhere a UUID is expected, you can pass an object with `resolver` and `value`:

```json
{
  "productId": { "resolver": "product.number", "value": "SW10001" }
}
```

If the value cannot be resolved, the request fails with `FRAMEWORK__API_INVALID_SYNC_RESOLVERS`. To allow missing references to fall back to `null` instead, add `"nullOnMissing": true`:

```json
{ "currencyId": { "resolver": "currency.iso_code", "value": "XYZ", "nullOnMissing": true } }
```

#### Built-in resolvers

| Resolver name                   | Entity            | Looked up by                                                                |
|:--------------------------------|:------------------|:----------------------------------------------------------------------------|
| `product.number`                | `product`         | `productNumber` (unique per live version)                                   |
| `currency.iso_code`             | `currency`        | `isoCode` (e.g. `EUR`, `USD`)                                               |
| `locale.code`                   | `locale`          | `code` (e.g. `en-GB`, `de-DE`)                                              |
| `payment_method.technical_name` | `payment_method`  | `technicalName`                                                             |
| `shipping_method.technical_name`| `shipping_method` | `technicalName`                                                             |
| `document_type.technical_name`  | `document_type`   | `technicalName`                                                             |
| `salutation.salutation_key`     | `salutation`      | `salutationKey` (e.g. `mr`, `mrs`)                                          |
| `tax.tax_rate`                  | `tax`             | `taxRate` — only resolves when **exactly one** tax record has the given rate |

<!-- theme: warning -->
> The `tax.tax_rate` resolver targets a non-unique column. If multiple tax records share the same rate (e.g. two 19% taxes), the resolver intentionally leaves the reference unresolved rather than picking one arbitrarily. Combine it with `nullOnMissing: true` or fall back to a `taxId` if your data model allows ambiguous rates.

#### Example

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/sync",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "import-products": {
      "entity": "product",
      "action": "upsert",
      "payload": [
        {
          "productNumber": "SW10001",
          "name": "Imported product",
          "stock": 10,
          "price": [
            {
              "gross": 19.99,
              "net": 16.80,
              "linked": false,
              "currencyId": { "resolver": "currency.iso_code", "value": "EUR" }
            }
          ],
          "taxId": { "resolver": "tax.tax_rate", "value": 19 }
        }
      ]
    }
  }
}
```

### Deleting entities

To delete entities, the `payload` of an operation contains the IDs. If the entity is a `MappingEntityDefinition` \(e.g. `product_category`\) the foreign keys, which are the primary keys of the corresponding entities, must be passed.

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/sync",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "delete-tax": {
        "entity": "category",
        "action": "delete",
        "payload": [
            { "id": "1d0943f296a94b06b785dfb4b017c18b" },
            { "id": "046e9574bdae4478b854f49a8f22c275" },
            { "id": "0a5bff83cbdf45968d37d30c31beac69" }
        ]
    },
    "delete-product-category": {
        "entity": "product_category",
        "action": "delete",
        "payload": [
            {
                "productId": "000bba26e2044b98a3ee4a84b03f9551",
                "categoryId": "0446a1eb394c4e729178699a7bc2833f"
            },
            { 
                "productId": "5deed0c33b2a4866a6b2c88fa215561c",
                "categoryId": "0446a1eb394c4e729178699a7bc2833f"
            }
        ]
    }
  }
}
```

### Deleting Relations

You can't delete relations by updating the owning entity. Instead you have to delete the relation on the relation entity `MappingEntityDefinition` \(e.g. `product_property`\). The corresponding entries in the main entity \(here `product`\) will be updated with an [indexer](#performance) that will immediately run after the delete.

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/sync",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "delete-product-property": {
        "entity": "product_property",
        "action": "delete",
        "payload": [
            { "productId": "000bba26e2044b98a3ee4a84b03f9551", "optionId": "0446a1eb394c4e729178699a7bc2833f" },
            { "productId": "5deed0c33b2a4866a6b2c88fa215561c", "optionId": "0446a1eb394c4e729178699a7bc2833f" }
        ]
    }
  }
}
```

### Deleting mapping entities via criteria

When you want to clear a many-to-many association of an entity, or want to delete multiple mappings in a single request without passing all combined foreign keys, you can also use a criteria syntax in the sync operation.

```sample http
[
  {
    "action": "delete",
    "entity": "product_category",
    "criteria": [
        {"type": "equals", "field": "productId", "value": "2fbb5fe2e29a4d70aa5854ce7ce3e20b"}
    ]
  }
]
```

The api resolves the criteria for the mapping entity and uses the detected primary keys for the delete operation. The criteria parameter is not combinable with the payload parameter in a single operation.

You can also use a `equalsAny` to enforce that only the exact match for a value of the given list of categories is deleted.

```sample http
[
  {
    "action": "delete",
    "entity": "product_category",
    "criteria": [
        {"type": "equalsAny", "field": "categoryId", "value": "2fbb5fe2e29a4d70aa5854ce7ce3e20b", "2fbb5fe2e29a4d70aa5854ce7ce3e20c", "2fbb5fe2e29a4d81aa5854ce7ce3e50c"}
    ]
  }
]
```

For more operations you can take a look at the [filter references](https://developer.shopware.com/docs/resources/references/core-reference/dal-reference/filters-reference.html)

## Performance

Various indexing processes are triggered in the background, depending on which data was written.

This leads to a high load on the server and can be a problem with large imports. Therefore, it is possible that the indexing is moved to an asynchronous process in the background.

You can control the behavior using the following headers:

| Header            | Value                                                                       | Description                                        |
|:------------------|:----------------------------------------------------------------------------|:---------------------------------------------------|
| indexing-behavior | `null (default)`                                                            | Data will be indexed synchronously                 |
|                   | `use-queue-indexing`                                                        | Data will be indexed asynchronously                |
|                   | `disable-indexing`                                                          | Data indexing is completely disabled               |
| indexing-skip     | Comma-separated indexer names (e.g. `product.search-keyword,product.stock`) | Skip the specified indexer(s) for this request     |
| indexing-only     | Indexer name (e.g. `product.stock`)                                         | Run only the specified indexer(s) for this request |

A list of all available indexes can be found [here](https://docs.shopware.com/en/shopware-6-en/configuration/caches-indexes#manage-caches-indexes).

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/sync",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "write-tax": {
        "entity": "tax",
        "action": "upsert",
        "payload": [
            { "name": "tax-1", "taxRate": 16 },
            { "name": "tax-2", "taxRate": 15 }    
        ]
    },
    "write-category": {
        "entity": "category",
        "action": "upsert",
        "payload": [
            { "name": "category-1" },
            { "name": "category-2" }
        ]
    },
    "write-country": {
        "entity": "country",
        "action": "upsert",
        "payload": [
            { "name": "country-1" },
            { "name": "country-2" }
        ]
    }
  }
}
```

## Flows

To stop flows from being triggered use the `sw-skip-trigger-flow` header. See also [Request Headers](https://developer.shopware.com/docs/guides/integrations-api/general-concepts/request-headers.html#sw-skip-trigger-flow)

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/sync",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
    "sw-skip-trigger-flow": 1
  },
  "body": {    
    "write-customer": {
        "entity": "customer",
        "action": "upsert",
        "payload": [
            { }
        ]
    }
  }
}
```


## Examples

### Update product stocks

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/sync",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "stock-updates": { // Name of the transaction, choose freely 
		"entity": "product", // Name of the entity you would like to update
		"action": "upsert", // Available actions are upsert and delete,
		"payload": [ // A list of objects, each representing a subset of the entity scheme referenced in `entity`. `id` is required for upsert operations.
			{
				"id": "<uuid-of-the-product>",
				"stock": 42
			},
			{
				"id": "<uuid-of-the-product>",
				"stock": 42
			},
			{
				"id": "<uuid-of-the-product>",
				"stock": 42
			}
		]
	}
  }
}
```
