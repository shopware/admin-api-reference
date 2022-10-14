# CMS

CMS system is referred to as "Shopping Experiences" built upon pages or layouts which can be reused and dynamically hydrated based on their assignments to categories or other entities.

To fetch a list of existing CMS layout post the `/api/search/cms-page` endpoint.

Also, to create a new layout, fetch `/api/app-system/cms/blocks` to know the layout types.

```json http
{
  "method": "post",
  "url": "https://localhost/api/cms-page",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "name": "sample_page",
    "type": "landingpage",
    "sections": [
        {
            "position": 0,
            "type": "sidebar",
            "sizingMode": "boxed",
            "pageId": "541ab372de904c8aa96a5a50501c6370"
        }
    ]
      }
    }
  }
```

```json json_schema
{
  "type": "object",
  "description": "Parameters for product creation",
  "properties": {
    "name": {
      "description": "Name of the layout",
      "type": "string"
    },
    "type": {
      "description": " Possible types are `listing page`, `shop page`, `Static page`, `Product page`",
      "type": "string"
    },
    "sections": {
      "position":{
      "description": "The position of the section",
      "type": "integer"
    },
    "type": {
      "description": "ID of [tax](../../../adminapi.json/components/schemas/Tax)",
      "type": "string"
    },
      "sizingMode": {
      "description": "Id of [currency](../../../adminapi.json/components/schemas/Currency)",
      "type": "string"
      },
      "pageId": {
      "description": "Unique Id of the page",
      "type": "string"
      }
    }
  }
}
```

## Add a block

```json http
{
  "method": "post",
  "url": "https://localhost/api/cms-page/541ab372de904c8aa96a5a50501c6370",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "id": "541ab372de904c8aa96a5a50501c6370",
    "versionId": "0fa91ce3e96a4bc2be4bd9ce752c3425",
    "sections": [
        {
            "id": "989b62ae90734098b0f9012a05451a91",
            "versionId": "0fa91ce3e96a4bc2be4bd9ce752c3425",
            "blocks": [
                {
                    "id": "94be42acc7e04060a15c04a24193121a",
                    "versionId": "0fa91ce3e96a4bc2be4bd9ce752c3425",
                    "name": "prod_preview",
                    "swagCmsExtensionsBlockRule": {
                        "id": "de5849ee1ef7488d95eb220df1cd9e22",
                        "inverted": false
                    }
                }
            ]
        }
    ]
}
    }
  }
```



