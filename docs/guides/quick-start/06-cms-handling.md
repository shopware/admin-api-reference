---
stoplight-id: s92t5mvj387wz
---

# CMS Management

Shopware's built-in CMS system is referred to as "Shopping Experiences". It is built upon layouts that can be reused and dynamically hydrated based on their assignments to categories or other entities.

Using CMS REST API, you can perform CRUD operations on section, slot, block, and page templates.

To fetch a list of existing CMS layouts, 

```
POST /api/search/cms-page
```


## Create a layout/page

```sample http
{
  "method": "post",
  "url": "https://localhost/api/cms-page0",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "name": "Summer BBQ",
    "type": "landingpage",
    "sections":{
        "position": 1,
        "type": "default",
        "sizingMode": "boxed",
        "backgroundColor": "#c9e4e6ff",
        "pageId": "f565491912994bcca19657c40b646836",
        "blocks":
        {
            "position": 0,
            "type": "image-text",
            "sectionPosition": "main",
            "marginTop": "169px",
            "marginBottom": "169px",
            "marginLeft": "20px",
            "marginRight": "20px",
            "backgroundColor": "#c9e4e6ff",
            "sectionId": "034982027a3f41f99981ba6886dc38f4",
            "slots":
            {
                "type": "text",
                "slot": "right",
                "config": {
                    "content": {
                        "value": "S U M M E R&nbsp; &nbsp;T R E N D S<h2>Be prepared for the best? <br>party this summer</h2><div>Summer is finally here and lures us outside with its warm rays of sunshine. The heat is better tolerated with cool snacks, drinks and fresh treats.</div><div><br></div><div><a target=\"_self\" href=\"/navigation/da5db02a783e467cae47e8d64c9f09a1\">Check out Summer Trends</a><br></div>",
                        "source": "static"
                    }
                },
                "blockId": "99a324f2f2dd4f76a36700bae20977f5"
            }
        }
    }
}
}
}
```

```section_description json_schema
{
  "type": "object",
  "description": "Parameters for CMS page.",
  "properties": {
    "sizingMode": {
      "description": "Accepts two values `boxed` and `full-width`. ",
      "type": "string"
    },
    "backgroundColor": {
      "description": "Hex code of a color to be used as background.",
      "type": "string"
    },
    "pageId": {
      "description": "Unique ID of page.",
      "type": "string"
    },
    "position": {
      "description": "The order in which sections are to be represented when many instances of each are defined.",
      "type": "integer"
    },
    "type": {
      "description": "Default type.",
      "type": "string"
    }
  }
}
```

```block_description json_schema
{
  "type": "object",
  "description": "Parameters for CMS block.",
  "properties": {
    "position": {
      "description": "The order in which sections are to be represented when many instances of each are defined.",
      "type": "string"
    },
    "backgroundColor": {
      "description": "Hex code of a color to be used as background.",
      "type": "string"
    },
    "pageId": {
      "description": "Unique ID of page.",
      "type": "string"
    },
    "sectionPosition": {
      "description": "Accepts `main` and `side-bar` values.",
      "type": "integer"
    },
    "type": {
      "description": "Accepts `product-listing` and `sidebar-filter` values. ",
      "type": "string"
    },
    "marginTop": {
      "description": "Size of the bottom margin of a block defined. ",
      "type": "string"
    },
    "marginBottom": {
      "description": "Size of the bottom margin of a block defined.",
      "type": "string"
    },
    "marginRight": {
      "description": "Size of the right margin of a block defined. ",
      "type": "string"
    },
    "marginLeft": {
      "description": "Size of the left margin of a block defined. ",
      "type": "string"
    }
  }
}
```

```slot_description json_schema
{
  "type": "object",
  "description": "Parameters for CMS page.",
  "properties": {
    "type": {
      "description": "Accepts `image-text`, `text`, `image`, `form`, `video`, `commerce`, `category-navigation`.",
      "type": "string"
    },
    "slot": {
      "description": "The position of slot `right`, `left`.",
      "type": "string"
    },
    "config": {
      "description": "Allows to add any customized information with styling.",
      "type": "string"
    },
    "blockId": {
      "description": "Unique ID of the block.",
      "type": "integer"
    }
  }
}
```

## Assignment of layout/page to a category

Now that we have defined a layout, you can use it to assign it to any category or entity. Let us here assign the "Summer BBQ" layout to the "Summer Collection" category.

```sample http
{
  "method": "post",
  "url": "https://localhost/api/cms-page/1017542d756d4c87a9df5a35a8e18f84/categories",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer YOUR_ACCESS_TOKEN"
  },
  "body": {
    "parentId": "bda4b60e845240b2b9d6b60e71196e14",
    "afterCategoryId": "ca15f1e906204da49afe666bbcca7825",
    "displayNestedProducts": true,
    "type": "page",
    "productAssignmentType": "product",
    "active": true,
    "name": "Summer Collection"
  }
}
```

```description json_schema
{
  "type": "object",
  "description": "Parameters for assigning cms layout to category.",
  "properties": {
    "parentId": {
      "description": "Unique identity of the parent category.",
      "type": "string"
    },
    "afterCategoryId": {
      "description": "Unique identity of a category after which the specific category needs to be added. ",
      "type": "string"
    },
    "displayNestedProducts": {
      "description": "When set to true, it shows all the products.",
      "type": "string"
    },
    "type": {
      "description": "Accepts `page`, `folder` and `link` type of categories.",
      "type": "string"
    },
    "productAssignmentType": {
      "description": "Takes values `product` and `product-stream`. ",
      "type": "string"
    },
    "active": {
      "description": "The active category is shown and used in the frontend. If switched to inactive, it's not in use and won't be shown in the frontend.",
      "type": "boolean"
      },
    "name": {
      "description": "Name of the category.",
      "type": "string"
    }
  }
}
```
