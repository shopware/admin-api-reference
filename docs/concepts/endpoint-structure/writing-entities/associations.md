# Associations

The Admin API allows you to create several data records simultaneously within one request. This is possible by using associations. For example, when a product is written, the prices can be written at the same time. This is not limited to entities that are directly related to the main entity but can be continued for as long as you wish and another association is defined.

> When writing association via API the following applies: Only data is written, not deleted. So writing a `OneToMany` or `ManyToMany` association only adds new data, the existing data will not be deleted.
>
> In general, when writing a field or association, the API expects the format that it returns when reading the record.
>
> In general, if no ID is given for an association, the API creates a new record

## ManyToMany Associations

`ManyToMany` Associations is an association which is supposed to link two independent entities. The table that serves as the mapping table for the relationship contains only the foreign keys for the entities to be linked. An example:

* The `ProductEntity` has a `ManyToMany` association with the `CategoryEntity`
* The association is available under the property `categories`
* The data for this association is stored in the `product_category` table.

There are three ways in which `ManyToMany` associations can be used in the API

**1: The entity to be linked should be created in the same request.**

In this case all required fields are sent with the entity.

```javascript
// PATCH /api/product/b7d2554b0ce847cd82f3ac9bd1c0dfca

{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "categories": [
        { "name": "First category" },
        { "name": "Second category" },
        { "name": "Third category" }
    ]
}
```

**2: The entity to be linked should be updated in the same request.**

In this case, the entity already exists in the system, but it can be updated in the same request like all other associations. For this purpose, the corresponding ID of the entity is sent with the request. If the ID does not exist in the system, the API creates a new entity with this id.

```javascript
// PATCH /api/product/b7d2554b0ce847cd82f3ac9bd1c0dfca
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "categories": [
        { "id": "98432def39fc4624b33213a56b8c944d", "name": "First category" },
        { "id": "2fbb5fe2e29a4d70aa5854ce7ce3e20b", "name": "Second category" },
        { "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca", "name": "Third category" }
    ]
}
```

**3: Records should only be linked** _**\(performant\)**_

If both data records already exist in the system and are to be linked to the PATCH request exclusively, it is recommended that you send only the ID of the entity. This has the advantage that there is no update of the linked entity, which means less load on the system:

```javascript
// PATCH /api/product/b7d2554b0ce847cd82f3ac9bd1c0dfca
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "categories": [
        { "id": "98432def39fc4624b33213a56b8c944d" },
        { "id": "2fbb5fe2e29a4d70aa5854ce7ce3e20b" },
        { "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca" }
    ]
}
```

## ManyToOne Associations

`ManyToOne` associations are associations where the foreign key is stored in the root entity. An example:

* The `ProductEntity` has a `ManyToOneAssociation` to `ProductManufacturerEntity`
* The association is available under the property `manufacturer`
* The foreign key is stored in the property `manufacturerId`.

There are three ways in which `ManyToOne` associations can be used in the API

**1: The entity to be linked is to be created directly with**

In this case all required fields of the entity must be given:

```javascript
// PATCH {{host}}/api/product/b7d2554b0ce847cd82f3ac9bd1c0dfca
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "manufacturer": { 
        "name": "My manufcaturer" 
    }
}
```

With the above payload, the system creates a new manufacturer in the system and links it to the product `b7d2554b0ce847cd82f3ac9bd1c0dfca`.

**2: The entity to be linked should be updated in the same request.**

In this case it is necessary to send the ID of the existing entity.

```javascript
// PATCH {{host}}/api/product/b7d2554b0ce847cd82f3ac9bd1c0dfca
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "manufacturer": { 
        "id": "98432def39fc4624b33213a56b8c944d", 
        "name": "My manufcaturer" 
    }
}
```

With the above payload, the system first checks whether a manufacturer with the id `98432def39fc4624b33213a56b8c944d` exists. If this is not the case, a new manufacturer with this ID is created. If the manufacturer already exists, the name of the manufacturer is updated. Then the manufacturer will be linked to the product.

**3: The entity should be linked exclusively** _\(performant\)_

With this option, the manufacturer already exists and should only be linked with the product. For this, either only the `id` can be sent, or the foreign key can be specified directly:

```javascript
// PATCH {{host}}/api/product/b7d2554b0ce847cd82f3ac9bd1c0dfca
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "manufacturer": { 
        "id": "98432def39fc4624b33213a56b8c944d" 
    }
}
```

```javascript
// PATCH {{host}}/api/product/b7d2554b0ce847cd82f3ac9bd1c0dfca
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "manufacturerId": "98432def39fc4624b33213a56b8c944d"
}
```

Both payloads lead to the same result. This type of use is preferable because only the product entity is updated and not the manufacturer entity with every product update, which leads to less load on the server.

## OneToMany Associations

Unlike the `ManyToOne` and `ManyToMany` association, data in a `OneToMany` association is usually not data that should be linked, but data that belongs to the main entity. This association is the counterpart of the `ManyToOne` association. The foreign key is therefore located in the table of the entity to which the association refers.

For example:

* The `CountryEntity` has a `OneToMany` association with the `CountryStateEntity`
* The association is available under the `states` property
* The foreign key is located in the `CountryStateEntity::countryId` property.

There are two ways to use `OneToMany` associations in the API.

**1: A new record should be created in the association.**

In this case all fields marked as required must be given. An ID can also be given here if it is not to be generated on server side:

```javascript
// POST /api/country
{
    "name" : "new country",
    "states": [
        { "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca", "name": "state-a", "shortCode": "A" },
        { "name": "state-b", "shortCode": "B" },
        { "name": "state-c", "shortCode": "C" }
    ]    

}
```

**2: An already existing entity of the association has to be updated**

In this case, it is necessary that the ID of the entity is also given. If this is not done, the system tries to create a new entity:

```javascript
// PATCH /api/country
{
    "id": "98432def39fc4624b33213a56b8c944d",
    "name" : "new country",
    "states": [
        { "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca", "name": "new name" }
    ]    
}
```

If an error occurs while writing the data, the API returns a `400 Bad Request` response in which all errors are listed. The affected records and fields can be identified via `source.pointer`:

```javascript
// POST /api/country

{
    "name" : "new country",
    "states": [
        { "name": "state-a", "shortCode": "A" },
        { "name": "state-b", "shortCode": 1 },
        { "name": "state-c" }
    ]    

}

{
    "errors": [
        {
            "status": "400",
            "detail": "This value should be of type string.",
            "source": {
                "pointer": "/0/states/1/shortCode"
            }
        },
        {
            "status": "400",
            "detail": "This value should not be blank.",
            "source": {
                "pointer": "/0/states/2/shortCode"
            }
        }
    ]
}
```

## Translated Fields

In Shopware 6 translatable fields of an entity can be written directly at the entity itself. For example, the `name` of a product is a translatable field. If no other language is set per header, the default language of the system is used for reading and writing. When an entity object is created in the system, it must have a translation in the default language of the system. This translation is used as a fallback if the entity is displayed in another language for which there is no translation. When writing an entity, it is possible to write several languages at the same time. This is done via the `translations` association:

```javascript
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "translations": {
        "2fbb5fe2e29a4d70aa5854ce7ce3e20b": {
            "name": "english name",
            "description": "english description"
        },
        "6d7b97a0f3504824bd0e77b021312c33": {
            "name": "german name",
            "description": "german description"
        }
    }
}
```

Within the `translations` property the language id, for which this translation is used, is then passed as key. All translatable fields can be specified within the object. If the language id is not known, the locale code can be used instead of the id:

```javascript
{
    "id": "b7d2554b0ce847cd82f3ac9bd1c0dfca",
    "translations": {
        "en-GB": {
            "name": "english name by code",
            "description": "english description by code"
        },
        "de-DE": {
            "name": "german name by code",
            "description": "german description by code"
        }
    }
}
```

Unlike the other types of associations, an update of a translation does not require an ID of the translation entity to be provided. This entities are an exception in the system and are uniquely identified by the language ID.
