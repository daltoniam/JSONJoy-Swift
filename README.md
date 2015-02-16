JSONJoy
=============

Convert JSON to Swift objects. The Objective-C counterpart can be found here: [JSONJoy](https://github.com/daltoniam/JSONJoy).

Parsing JSON in Swift has be likened to a trip through Mordor, then JSONJoy would be using eagles for that trip.

Also check out this [article](http://vluxe.io/jsonjoy.html) for more information and examples.

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

## Array and Dictionary support

There is two ways to access Arrays and Dictionary. The first is the convenience methods.

```javascript
{
    "scopes" : ["Bakersfield", "California", "USA"]
}
```

Now for the Swift object.
```swift
struct Scopes : JSONJoy {
    var scopes: Array<String>?
    init() {
    }
    init(_ decoder: JSONDecoder) {
         decoder.getArray(&scopes) //pass the optional array by reference, it will be allocated if it is not and filled
    }
}
```

The second option is useful for embedded objects.

```javascript
{
	"addresses": [
	{
        "id": 1
        "street_address": "2nd Street",
        "city": "Bakersfield",
        "state": "CA",
        "postal_code": 93309
     },
     {
        "id": 2
        "street_address": "2nd Street",
        "city": "Dallas",
        "state": "TX",
        "postal_code": 12345
     }]
}
```

```swift
struct Addresses : JSONJoy {
    var addresses: Array<Address>?
    init() {
    }
    init(_ decoder: JSONDecoder) {
		//we check if the array is valid then alloc our array and loop through it, creating the new address objects.
		if let addrs = decoder["addresses"].array {
			addresses = Array<Address>()
			for addrDecoder in addrs {
				addresses.append(Address(addrDecoder))
			}
		}
    }
}
```

## SwiftHTTP

This can be combined with JSONJoy to make API interaction really clean and easy.

https://github.com/daltoniam/SwiftHTTP#clientserver-example

## Requirements

JSONJoy requires at least iOS 7/OSX 10.10 or above.

## Installation

### Cocoapods

### [CocoaPods](http://cocoapods.org/)
At this time, Cocoapods support for Swift frameworks is supported in a [pre-release](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/).

To use JSONJoy in your project add the following 'Podfile' to your project

    source 'https://github.com/CocoaPods/Specs.git'

    xcodeproj 'YourProjectName.xcodeproj'
    platform :ios, '8.0'

    pod 'JSONJoy-Swift', :git => "https://github.com/daltoniam/JSONJoy-Swift.git", :tag => "0.9.1"

    target 'YourProjectNameTests' do
        pod 'JSONJoy-Swift', :git => "https://github.com/daltoniam/JSONJoy-Swift.git", :tag => "0.9.1"
    end

Then run:

    pod install

#### Updating the Cocoapod
You can validate JSONJoy-Swift.podspec using:

    pod spec lint JSONJoy-Swift.podspec

This should be tested with a sample project before releasing it. This can be done by adding the following line to a ```Podfile```:

    pod 'JSONJoy-Swift', :git => 'https://github.com/username/JSONJoy-Swift.git'

Then run:

    pod install

If all goes well you are ready to release. First, create a tag and push:

    git tag 'version'
    git push --tags

Once the tag is available you can send the library to the Specs repo. For this you'll have to follow the instructions in [Getting Setup with Trunk](http://guides.cocoapods.org/making/getting-setup-with-trunk.html).

    pod trunk push JSONJoy-Swift.podspec

### Carthage

Check out the [Carthage](https://github.com/Carthage/Carthage) docs on how to add a install. The `JSONJoy` framework is already setup with shared schemes.

[Carthage Install](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)

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

If you are running this in an OSX app or on a physical iOS device you will need to make sure you add the `JSONJoy.framework` or `JSONJoyOSX.framework` to be included in your app bundle. To do this, in Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar. In the tab bar at the top of that window, open the "Build Phases" panel. Expand the "Link Binary with Libraries" group, and add `JSONJoy.framework` or `JSONJoyOSX.framework` depending on if you are building an iOS or OSX app. Click on the + button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add `JSONJoy.framework` or `JSONJoyOSX.framework` respectively.

## TODOs

- [ ] Complete Docs
- [ ] Add Unit Tests
- [ ] Add Example Project

## License

JSONJoy is licensed under the Apache v2 License.

## Contact

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam
* http://daltoniam.com
