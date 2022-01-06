# Reading entities

The Admin API is designed in such a way that all entities of the system can be read in the same way. Once an entity is registered in the system, it can be written and read via API - this also applies to your custom entities. The appropriate routes for the entity are generated automatically and follow the REST pattern.

A list of all entities available for read operations can be found in the [Entity Reference](../resources/entity-reference.md).

> **Example**
>
> * The `ManufacturerEntity` is registered as `product_manufacturer` in the system and can be read through `api/product-manufacturer`.
> * The `ProductEntity` has an association with the property name `manufacturer`, which refers to the `ManufacturerEntity`.
> * The manufacturer of a product can then be read over `api/product/{productId}/manufacturer`.

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
        "type": "object",
        "description": "Search parameters. For more information, see our documentation on [Search Queries](https://shopware.stoplight.io/docs/store-api/docs/concepts/search-queries.md#structure)",
        "properties": {
          "page": {
            "description": "Search result page",
            "type": "integer"
          },
          "limit": {
            "description": "Number of items per result page",
            "type": "integer"
          },
          "filter": {
            "type": "array",
            "description": "List of filters to restrict the search result. For more information, see [Search Queries > Filter](https://shopware.stoplight.io/docs/store-api/docs/concepts/search-queries.md#filter)",
            "items": {
              "type": "object",
              "properties": {
                "type": {
                  "type": "string"
                },
                "field": {
                  "type": "string"
                },
                "value": {
                  "type": "string"
                }
              },
              "required": [
                "type",
                "field",
                "value"
              ]
            }
          },
          "sort": {
            "type": "array",
            "description": "Sorting in the search result.",
            "items": {
              "type": "object",
              "properties": {
                "field": {
                  "type": "string"
                },
                "order": {
                  "type": "string"
                },
                "naturalSorting": {
                  "type": "boolean"
                }
              },
              "required": [
                "field"
              ]
            }
          },
          "post-filter": {
            "type": "array",
            "description": "Filters that applied wihout affecting aggregations. For more information, see [Search Queries > Post Filter](https://shopware.stoplight.io/docs/store-api/docs/concepts/search-queries.md#post-filter)",
            "items": {
              "type": "object",
              "properties": {
                "type": {
                  "type": "string"
                },
                "field": {
                  "type": "string"
                },
                "value": {
                  "type": "string"
                }
              },
              "required": [
                "type",
                "field",
                "value"
              ]
            }
          },
          "associations": {
            "type": "object",
            "description": "Used to fetch associations which are not fetched by default."
          },
          "aggregations": {
            "type": "array",
            "description": "Used to perform aggregations on the search result. For more information, see [Search Queries > Aggregations](https://shopware.stoplight.io/docs/store-api/docs/concepts/search-queries.md#aggregations)",
            "items": {
              "type": "object",
              "properties": {
                "name": {
                  "description": "Give your aggregation an identifier, so you can find it easier",
                  "type": "string"
                },
                "type": {
                  "description": "The type of aggregation",
                  "type": "string"
                },
                "field": {
                  "description": "The field you want to aggregate over.",
                  "type": "string"
                }
              },
              "required": [
                "name",
                "type",
                "field"
              ]
            }
          },
          "grouping": {
            "type": "array",
            "description": "Perform groupings over certain fields",
            "items": {
              "type": "string",
              "description": "Name of a field"
            }
          }
        }
      }
```