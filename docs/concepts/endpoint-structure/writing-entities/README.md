# Writing entities

Analogous to the reading endpoints, the API also provides endpoints for all entities to be written in the same way. Once an entity is registered in the system, it can also be written via API. The appropriate routes for the entity are generated automatically and follow the REST pattern.

A list of all entities available for these operations can be found in the [Entity Reference](../../../resources/entity-reference.md).

**Example:** The entity `customer_group` is available under the endpoint `api/customer-group`. For an entity, the system automatically generates the following routes where the entity can be written

| Name                       | Method | Route                    | Usage                                  |
|:---------------------------|:-------|:-------------------------|:---------------------------------------|
| api.customer\_group.update | PATCH  | /api/customer-group/{id} | Update the entity with the provided ID |
| api.customer\_group.delete | DELETE | /api/customer-group/{id} | Delete the entity                      |
| api.customer\_group.create | POST   | /api/customer-group      | Create a new entity                    |

<!-- theme: warning -->
> **PATCH** method only adds properties and does not delete old references. To perform both operations, use [Sync API](bulk-payloads.md) endpoints.

## Payload

The payload for writing entities is dictated by the API scheme, which in turn is generated from entity definitions which are part of the Shopware core \(unless they are custom entities\).

See the [Entity Reference](../../../resources/entity-reference.md) section of this documentation to inspect the scheme of all entities.

> If it is not clear how the data has to be sent despite the scheme, it is also possible to open the administration and to have a look at the corresponding requests. To do this, simply open the network tab in the developer tools of your browser, which lists all requests and payloads sent by the administration.

### Primary Keys

Shopware 6 uses 128-bit client-generated identifiers as primary keys instead of auto-increments. In API payloads, these appear as **32 lowercase hexadecimal characters without hyphens** (for example, `01bd7e70a50443ec96a01fd34890dcc5`). See the [Request body](../request-response-structure.md#request-body) section for examples.

This is not the hyphenated string format defined by [RFC 4122](https://datatracker.ietf.org/doc/html/rfc4122). Passing UUIDs with hyphens returns a `FRAMEWORK__INVALID_UUID` error. See [shopware/shopware#274](https://github.com/shopware/shopware/issues/274#issuecomment-549374502) for a background.

We have opted for this approach for the following reasons:

* IDs can be provided (client-generated) when creating an entity
* Minuscule likelihood of generating ID collisions
* Data integrations become easier because existing primary keys can be hashed to generate UUIDs

Shopware typically generates time-ordered or random UUIDs internally, but the API accepts any valid 32-character hex value — it does not enforce RFC version bits.

#### Deterministic IDs for imports

When importing data from an external system, you often want a stable Shopware ID derived from a key you already have (such as a SKU or legacy primary key). Shopware validates the **format** (32 hex characters) but not RFC version semantics, so deterministic hashes are valid for imports.

**Pragmatic approach: `md5()`**

`md5()` is a simple choice because it produces exactly 32 hexadecimal characters, matching the API format with no conversion:

```php
$payload[] = [
    'id' => md5($product->getUniqueIdentifier()),
];
```

**Standard-based alternative: UUID v3/v5**

[RFC 4122](https://datatracker.ietf.org/doc/html/rfc4122#section-4.3) defines name-based UUIDs for exactly this use case:

| Approach                  | Hash                        | RFC UUID version                                         | Fits API format directly?            |
|:--------------------------|:----------------------------|:---------------------------------------------------------|:-------------------------------------|
| `md5($name)`              | MD5 (full 128 bits as hex)  | Similar spirit to v3, but without namespace/version bits | Yes                                  |
| `Uuid::uuid3($ns, $name)` | MD5 with namespace          | UUID v3                                                  | No — strip hyphens                   |
| `Uuid::uuid5($ns, $name)` | SHA-1 truncated to 128 bits | UUID v5                                                  | No — strip hyphens                   |
| `sha1($name)`             | SHA-1 (160 bits)            | N/A                                                      | **No** — 40 hex characters, too long |

Using a UUID library makes the intent explicit and lets you scope IDs with a namespace:

```php
use Ramsey\Uuid\Uuid;

$payload[] = [
    'id' => str_replace('-', '', Uuid::uuid5(
        Uuid::NAMESPACE_DNS,
        (string) $product->getUniqueIdentifier()
    )->toString()),
];
```

Most UUID libraries (including `ramsey/uuid`) output the canonical 36-character hyphenated form. Shopware requires the 32-character dashless form, so `str_replace('-', '', ...)` is needed. The same applies to `Uuid::uuid3()`. Plain `sha1()` does not work because it produces 40 hexadecimal characters, which exceeds Shopware's 16-byte (128-bit) ID length.

For imports, pick a stable namespace per entity type (for example, `Uuid::NAMESPACE_DNS` or a project-specific namespace UUID generated once) and use the external system's stable key as the name.

Whichever approach you choose, you can later reuse the same derived ID to push updates to the same record. The same pattern applies to related entities.

### **Bulk Payloads**

If you intend to write multiple entities of a different type or perform various operations \(update, delete\) within a single request, take a look at the [sync endpoint or Sync API](bulk-payloads.md).

## Creating entities

When creating an entity, all `required` fields must be provided in the request body. If one or more fields have not been passed or contain incorrect data, the API outputs all errors for an entity:

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/product",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "name" : "test"
  }
}
```

### Response

```javascript
{
    "errors": [
        {
            "code": "c1051bb4-d103-4f74-8988-acbcafc7fdc3",
            "status": "400",
            "detail": "This value should not be blank.",
            "source": {
                "pointer": "/0/taxId"
            }
        },
        {
            "code": "c1051bb4-d103-4f74-8988-acbcafc7fdc3",
            "status": "400",
            "detail": "This value should not be blank.",
            "source": {
                "pointer": "/0/stock"
            }
        },
        {
            "code": "c1051bb4-d103-4f74-8988-acbcafc7fdc3",
            "status": "400",
            "detail": "This value should not be blank.",
            "source": {
                "pointer": "/0/price"
            }
        },
        {
            "code": "c1051bb4-d103-4f74-8988-acbcafc7fdc3",
            "status": "400",
            "detail": "This value should not be blank.",
            "source": {
                "pointer": "/0/productNumber"
            }
        }
    ]
}
```

If the entity has been successfully created, the API responds with a `204 No Content` status code.
```sample http
{
  "method": "POST",
  "url": "http://localhost/api/product",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "name" : "test",
    "productNumber" : "random",
    "stock" : 10,
    "price" : [
        {
            "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
            "gross": 15, 
            "net": 10, 
            "linked" : false
        }
    ],
    "tax" : {
        "name": "test", 
        "taxRate": 15
    }
  }
}
```

## Updating entities

Updating an entity can, and should, be done partially. This means that only the fields to be updated should be sent in the request. This is recommended because the system reacts differently in the background to certain field changes.

For example, to update the stock of a product and update the price at the same time, we recommend the following partial payload:

```sample http
{
  "method": "PATCH",
  "url": "http://localhost/api/product/021523dde52d42c9a0b005c22ac85043",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "stock": 10,
    "price": [
        {
            "currencyId": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
            "gross": 99.99,
            "net": 89.99,
            "linked": false
        }    
    ]
  }
}
```

## Deleting entities

To delete an entity the route `DELETE /api/product/{id}` can be used. If the entity has been successfully deleted, the API returns a `204 - No Content` response.

When deleting data, it can happen that this is prevented by foreign key restrictions. This happens if the entity is still linked to another entity which requires the relation. For example, if you try to delete a tax record which is marked as required for a product, the delete request will be prevented with a `409 - Conflict.` Make sure to resolve these cascading conflicts before deleting a referenced entity.

```sample http
{
  "method": "DELETE",
  "url": "http://localhost/api/tax/5840ff0975ac428ebf7838359e47737f",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  }
}
```
### Response

```javascript
{
    "errors": [
        {
            "status": "409",
            "code": "FRAMEWORK__DELETE_RESTRICTED",
            "title": "Conflict",
            "detail": "The delete request for tax was denied due to a conflict. The entity is currently in use by: product (32)"
        }
    ]
}
```

## Cloning an entity

To clone an entity the route `POST /api/_action/clone/{entity}/{id}` can be used. The API clones all associations which are marked with `CascadeDelete`.

The behaviour can be disabled explicitly by setting the constructor argument for `CascadeDelete` to false in the entity definition

```php
(new OneToManyAssociationField('productReviews', /* ... */))
    ->addFlags(new CascadeDelete(false)),
```

Some entities have a `ChildrenAssociationField`. The children are also considered in a clone request. However, since this results in large amounts of data, the parameter `cloneChildren: false` can be sent in the payload so that they are no longer duplicated. It is also possible to overwrite fields in the clone using the payload parameter 'overwrites'. This is especially helpful if the entity has a unique constraint in the database. As response, the API returns the new id of the entity:

```sample http
{
  "method": "POST",
  "url": "http://localhost/api/_action/clone/product/53be6fb93e4b44ed877736cbe01a47b8",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "overwrites": {
        "name" : "New name",
        "productNumber" : "new number"
    },
    "cloneChildren": false
  }
}
```

### Response

```javascript
{
    "id": "cddde8ad9f81497b9a280c7eb5c6bd2e"
}
```
