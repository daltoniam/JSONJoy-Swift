JSONJoy
=============

Convert JSON to Swift objects. The Objective-C counterpart can be found here: [JSONJoy](https://github.com/daltoniam/JSONJoy).

Parsing JSON in Swift has be likened to a trip through Mordor, then JSONJoy would be using eagles for that trip.

First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift
import JSONJoy
```

## Example

First here is some example JSON we have to parse.

```javascript
{
    "id" : 1,
    "first_name": "John",
    "last_name": "Smith",
    "age": 25,
    "address": {
        "id": 1,
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
    let objID: Int?
    let streetAddress: String?
    let city: String?
    let state: String?
    let postalCode: String?
    init() {

    }
}

struct User {
    let objID: Int?
    let firstName: String?
    let lastName: String?
    let age: Int?
    let address = Address()
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
    let objID: Int
    let streetAddress: String
    let city: String
    let state: String
    let postalCode: String
    let streetTwo: String?

    init(_ decoder: JSONDecoder) throws {
        objID = try decoder["id"].get()
        streetAddress = try decoder["street_address"].get()
        city = try decoder["city"].get()
        state = try decoder["state"].get()
        postalCode = try decoder["postal_code"].get()
        streetTwo = decoder["street_two"].getOptional()
        
        //just an example of "checking" for a property. 
        if let meta: String = decoder["meta"].getOptional() {
            print("found some meta info: \(meta)")
        }
    }
}

struct User : JSONJoy {
    let objID: Int
    let firstName: String
    let lastName: String
    let age: Int
    let address: Address
    let addresses: [Address]

    init(_ decoder: JSONDecoder) throws {
        objID = try decoder["id"].get()
        firstName = try decoder["first_name"].get()
        lastName = try decoder["last_name"].get()
        age = try decoder["age"].get()
        address = try Address(decoder["address"])
        addresses = try decoder["addresses"].get() //infers the type and returns a valid array
    }
}
```

Then when we get the JSON back:

```swift
do {
	var user = try User(JSONDecoder(data))
	println("city is: \(user.address.city)")
	//That's it! The object has all the appropriate properties mapped.
} catch {
	print("unable to parse the JSON")
}
```

This also has automatic optional validation like most Swift JSON libraries.

```swift
//some randomly incorrect key. This will work fine and the property will just be nil.
firstName = decoder[5]["wrongKey"]["MoreWrong"].getOptional()
//firstName is nil, but no crashing!
```

## Custom Types

If you to extend a standard Foundation type (you probably won't need to though)

```swift
extension UInt64:   JSONBasicType {}
```

## SwiftHTTP

This can be combined with SwiftHTTP to make API interaction really clean and easy.

https://github.com/daltoniam/SwiftHTTP#clientserver-example

## Requirements

JSONJoy requires at least iOS 7/OSX 10.10 or above.

## Installation

### Swift Package Manager

Add the project as a dependency to your Package.swift:
```swift
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .Package(url: "https://github.com/daltoniam/JSONJoy-Swift", majorVersion: 3)
    ]
)
```

### CocoaPods

Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/).

To use JSONJoy-Swift in your project add the following 'Podfile' to your project

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'
	use_frameworks!

	pod 'JSONJoy-Swift', '~> 3.0.0'

Then run:

    pod install


### Carthage

Check out the [Carthage](https://github.com/Carthage/Carthage) docs on how to add a install. The `JSONJoy` framework is already setup with shared schemes.

[Carthage Install](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate JSONJoy into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "daltoniam/JSONJoy-Swift" >= 3.0.0
```

### Rogue

First see the [installation docs](https://github.com/acmacalister/Rogue) for how to install Rogue.

To install JSONJoy run the command below in the directory you created the rogue file.

```
rogue add https://github.com/daltoniam/JSONJoy-Swift
```

Next open the `libs` folder and add the `JSONJoy.xcodeproj` to your Xcode project. Once that is complete, in your "Build Phases" add the `JSONJoy.framework` to your "Link Binary with Libraries" phase. Make sure to add the `libs` folder to your `.gitignore` file.

### Other

Simply grab the framework (either via git submodule or another package manager).

Add the `JSONJoy.xcodeproj` to your Xcode project. Once that is complete, in your "Build Phases" add the `JSONJoy.framework` to your "Link Binary with Libraries" phase.

### Add Copy Frameworks Phase

If you are running this in an OSX app or on a physical iOS device you will need to make sure you add the `JSONJoy.framework` included in your app bundle. To do this, in Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar. In the tab bar at the top of that window, open the "Build Phases" panel. Expand the "Link Binary with Libraries" group, and add `JSONJoy.framework`. Click on the + button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add `JSONJoy.framework`.

## TODOs

- [ ] Add Unit Tests

## License

JSONJoy is licensed under the Apache v2 License.

## Contact

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam
* http://daltoniam.com
