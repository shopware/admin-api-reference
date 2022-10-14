---
stoplight-id: 367bdf49aa59a
---

# Extensions

## Adding extensions

The store offers many extensions for your webshop. These extensions can be seamlessly integrated into your store without any programming knowledge. They can be apps that extend your store with additional functions such as payment methods and shipping methods, or themes that help you customize the design of your store.

The store itself is also an extension that is installed by default, but is initially deactivated. To use the store it is necessary to activate it first. 
This retrieves a list of all app extensions that can be added:

```json http
{
  "method": "get",
  "url": "http://localhost/api/_action/extension-store/list",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
}
```

To get a particular app then use the below endpoint: 

```json http
{
  "method": "get",
  "url": "http://localhost/api/_action/extension-store/detail/13782",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
}
```

To install a particular app:

```json http
{
  "method": "get",
  "url": "http://localhost/apii/_action/extension/install/app/ZmbGoogleCustomerReviews",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  }
}
```

