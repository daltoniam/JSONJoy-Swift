JSONJoy-Swift
=============

Convert JSON to Swift objects. The Objective-C counterpart can be found here: [JSONJoy](https://github.com/daltoniam/JSONJoy). 

Parsing JSON in Swift has be likened to a trip through Mordor, then JSONJoy is the eagles to that trip. 

## Example ##

First here is some example JSON we have to parse.
```javascript
{
    "id" : 1
    "first_name": "John",
    "last_name": "Smith",
    "age": 25,
    "address": {
        "id": 1
        "street_address": "2nd Street",
        "city": "Bakersfield",
        "state": "CA",
        "postal_code": 93309
     }

}
```
We want to translate that JSON to these Swift objects:

```swift
struct Address {
    var objID: Int?
    var streetAddress: String?
    var city: String?
    var state: String?
    var postalCode: String?
    init() {
        
    }
}

struct User {
    var objID: Int?
    var firstName: String?
    var lastName: String?
    var age: Int?
    var address = Address()
    init() {
        
    }
}
```

Normally this would put us in a validation nightmare:

```
var user = User()
var error: NSError?
var response: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
if let userDict = response as? NSDictionary {
    if let addressDict = userDict["address"] as? NSDictionary {
        user.address.city = addressDict["city"] as? String
        user.address.streetAddress = addressDict["street_address"] as? String
        //etc, etc
    }
    user.firstName = userDict["first_name"] as? String
    user.lastName = userDict["last_name"] as? String
    //etc, etc
}
```

JSONJoy makes this much simpler. We have our Swift objects implement the JSONJoy protocol:

```swift
struct Address : JSONJoy {
    var objID: Int?
    var streetAddress: String?
    var city: String?
    var state: String?
    var postalCode: String?
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        objID = decoder["id"].integer
        streetAddress = decoder["street_address"].string
        city = decoder["city"].string
        state = decoder["state"].string
        postalCode = decoder["postal_code"].string
    }
}

struct User : JSONJoy {
    var objID: Int?
    var firstName: String?
    var lastName: String?
    var age: Int?
    var address: Address?
    init() {
    }
    init(_ decoder: JSONDecoder) {
        objID = decoder["id"].integer
        firstName = decoder["first_name"].string
        lastName = decoder["last_name"].string
        age = decoder["age"].integer
        address = Address(decoder["address"])
    }
}
```
Then when we get the JSON back:

```swift
var user = User(JSONDecoder(data))
println("city is: \(user.address!.city!)")
//That's it! The object has all the appropriate properties mapped.
```

This also has automatic optional validation like most Swift JSON libraries.

```swift
//some randomly incorrect key. This will work fine and the property will just be nil.
firstName = decoder[5]["wrongKey"]["MoreWrong"].string
//firstName is nil, but no crashing!
```

## SwiftHTTP 

This can be combined with SwiftHTTP to make API interaction really clean and easy.

```swift
//Finish serializer and example.
```

## Requirements ##

JSONJoy requires at least iOS 7/OSX 10.10 or above.


## License ##

JSONJoy is license under the Apache License.

## Contact ##

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam
* http://daltoniam.com