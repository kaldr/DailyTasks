# This is a folder for basic data types.
Files in this folder can import data into mongodb.

## Basic Classes

### information.coffee
The basic class for collection coffee files.
This class will load cson config and connect to  mongodb.

### BasicData.coffee
The file used to import basic data into mongodb.

Usage
```coffeescript
{BasicData} = require './BasicData'

importDBData = new BasicData() # the arguments could be 'localhost' or 'dbserver', empty for default 'localhost'
importDBData.generateBasicData true#true means close database connection after operations

```
## Collection Classes
### Domain.coffee
### Industry.coffee
### Profession.coffee
### ProfessionDomain.coffee
### CollectionDictionary.coffee

## Configs
### config.cson
Database connector config.

### database.cson
Basic data used in each collection. Such as 'collectionDictionary' and so on.
