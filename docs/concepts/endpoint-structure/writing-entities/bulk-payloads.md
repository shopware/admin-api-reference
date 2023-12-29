# Bulk Payloads

The Sync API is an add-on to the Admin API that allows you to perform multiple write operations \(creating/updating and deleting\) simultaneously. All entities that can be written via the Admin API can also be written via the Sync API.

The endpoint is located at

```text
/api/_action/sync
```

and expects payloads via `POST` and `Content-Type: application/json`.

## Operations

In contrast to the Admin API, the Sync API does not differ between **create** and **update** operations, but always performs an **upsert** operation. During an **upsert**, the system checks whether the entity already exists in the system and updates it if an ID has been passed, otherwise a new entity is created with this ID.

A request always contains a **list of operations**. An operation defines the `action` to be executed \(`upsert` or `delete`\), the `entity` it is and the `payload` which is an array of multiple records \(for `upsert`\) or multiple IDs \(for `delete`\). Within a request, different entities can therefore be written in batch. For easier debugging, each operation can be given a key. The key is then used in the response to define which entities are written in which operation.

**Format of an operation**

| Field | Values |
| :--- | :--- |
| **entity** | Any entity in Shopware, e.g. `category`or `customer` |
| **action** | The type of operation - either `upsert` or `delete` |
| **payload** | A list, containing objects \(upsert\) OR a list of IDs \(delete\) |

### Writing entities

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

### Deleting entities

To delete entities, the `payload` of an operation contains the IDs. If the entity is a `MappingEntityDefinition` \(e.g. `product_category`\) the foreign keys, which are the primary keys of the corresponding entities, must be passed:


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

You can not delete relations by updating the owning entity. Instead you have to delete the relation on the relation entity `MappingEntityDefinition` \(e.g. `product_property`\). The corresponding entries in the main entity \(here `product`\) will be updated with an indexer that will immediately run after the delete \(for details on indexers, see the next section\).

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

When you want to clear a many to many association of an entity, or want to delete multiple mappings in a single request without passing all combined foreign keys, you can also use a criteria syntax for the sync operation.

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

The api resolves the criteria for the mapping entity and uses the detected primary keys for the delete operation.

The criteria parameter is not combinable with the payload parameter in a single operation.

## Performance

Various indexing processes are triggered in the background, depending on which data was written.

This leads to a high load on the server and can be a problem with large imports. Therefore, it is possible that the indexing is moved to an asynchronous process in the background.

You can control the behaviour using the following headers:

| Header | Value | Description |
| :--- | :--- | :--- |
| indexing-behavior | `null (default)` | Data will be indexed synchronously |
|  | `use-queue-indexing` | Data will be indexed asynchronously |
|  | `disable-indexing` | Data indexing is completely disabled |


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
