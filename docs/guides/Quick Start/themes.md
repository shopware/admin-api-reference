# Theme

A Theme gives you the ability to change the visual appearance of the storefront via styling the SCSS/CSS and adjusting twig templates. 

One can fetch the available themes by posting `/api/search/themes` endpoint.

To undestand the entire structure of a theme then fetch `/api/_action/theme/fc485aa38de24fa8be890acf50aa9ddc/structured-fields`

## Update schema

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/theme/fc485aa38de24fa8be890acf50aa9ddc",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "a5da76b447db4d0aba62e6512dadf45b",
    "price": [
        {
            "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
            "gross": 15, 
            "net": 10, 
            "linked" : false
        }
    ]
      }
    }
  }
```

```json http
{
  "method": "post",
  "url": "http://localhost/api/_action/theme/fc485aa38de24fa8be890acf50aa9ddc/assign/98432def39fc4624b33213a56b8c944d",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer Your_API_Key"
  },
  "body": {
    "name": "test",
    "productNumber": "random",
    "stock": 10,
    "taxId": "a5da76b447db4d0aba62e6512dadf45b",
    "price": [
        {
            "currencyId" : "b7d2554b0ce847cd82f3ac9bd1c0dfca", 
            "gross": 15, 
            "net": 10, 
            "linked" : false
        }
    ]
      }
    }
  }
```