# Reading entities

The Admin API is designed in such a way that all entities of the system can be read in the same way. Once an entity is registered in the system, it can be written and read via API - this also applies to your custom entities. The appropriate routes for the entity are generated automatically and follow the REST pattern.

A list of all entities available for read operations can be found in the [Entity Reference](../../resources/entity-reference.md).

> **Example**
>
> * The `ManufacturerEntity` is registered as `product_manufacturer` in the system and can be read through `api/product-manufacturer`.
> * The `ProductEntity` has an association with the property name `manufacturer`, which refers to the `ManufacturerEntity`.
> * The manufacturer of a product can then be read over `api/product/{productId}/manufacturer`.

If you are unsure what the name of your entity is, see the definition of the entity:

`final public const ENTITY_NAME = 'product_manufacturer';`

## Generated Endpoints

For an entity object, the system automatically creates the following routes through which the entity object can be read:

| Name | Method | Route | Usage |
| :--- | :--- | :--- | :--- |
| api.customer\_group.list | GET | /api/customer-group | Fetch a list of entities |
| api.customer\_group.detail | GET | /api/customer-group/{id} | Fetch a single entity |
| api.customer\_group.search | POST | /api/search/customer-group | Perform a search using a [search criteria](#search-endpoint) |
| api.customer\_group.search-ids | POST | /api/search-ids/customer-group | Perform a search using a [search criteria](#search-endpoint), but fetch only matching ids |

## Search Endpoint

The Admin API supports a wide range of filtering, aggregation and sorting capabilities. However, according to the REST definition, data should only be read via GET, we have provided the `/api/search/*` route for this.

These endpoints accept a search criteria input:

```json json_schema
{
  "$ref": "../../../adminapi.json#/components/schemas/Criteria"
}
```
