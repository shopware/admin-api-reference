# Endpoint Structure

The Admin API can be separated into two general sets of endpoints

 * Generic entity endpoints
 * Specific interaction/configuration endpoints

Both fulfill specific cases which are outlined below.

## Generic entity endpoints

Provide CRUD functionalities on **all entities available** in Shopware. Go to the [Entity Reference](../resources/entity-reference.md) section to see a list of all available entities and their structure.

Furthermore, these endpoints can be divided into **read** and **write** operations. To learn more about those, please head to the corresponding guide on [Reading Entities](../guides/reading-entities.md) and [Writing Entities](../guides/writing-entities/README.md). These endpoints are generic, since they are entirely based on the entities definitions and contain no additional business logic besides data validation.

> The URL structure for *Generic entity endpoints* is:
> ```
> /api/{entity-name}(/{entity-id})
> ```

## Specific interaction or configuration endpoints

Provide interactions for more sophisticated operations which can change the state of the system but are not directly based on entities alone. We differ between more than 20 categories of about 140 specific endpoints, such as

 * Document Management
 * Order State Management
 * User Role Management
 * System Operations
 * Authorization & Authentication

which will let you automate every part of the store operation.

> The URL structure for *Specific interaction or configuration endpoints* roughly follows this schema:
> ```
> /api/_action/{interaction-name}
> ```