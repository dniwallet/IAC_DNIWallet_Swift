# IAC_DNIWallet_Swift
InterAppCommunication interface with DNI Wallet for Swift

Includes two libraries
* **IACCore** is copied from [Inter-App Communication (Swift)](https://github.com/tapsandswipes/Inter-AppCommunication.git) 
* **IAC_DNIWallet** currently supports the **x-callback-url** [1.0 DRAFT specification](http://x-callback-url.com/specifications/).

## Usage

### Call DNI Wallet

From anywhere in your app you can call DNI Wallet on the device with the following code

```swift
import IAC_DNIWallet

DNIWalletIACClient().runProcess(organizationID: organizationID, processID: processID, externalID: externalID, dni: dni)
```

### Receive callbacks from DNI Wallet

If you want to be called back from DNI Wallet you can specify success and failure handler blocks, for example:

```swift
import IAC_DNIWallet

DNIWalletIACClient().runProcess(
    organizationID: organizationID, 
    processID: processID, 
    externalID: externalID, 
    dni: dni, 
    parameters: ["param1": "value1", "param2": "value2"],
    handler: { result in 
        switch result {
        case .success(let data):
            print("OK: \(data)")
        case .cancelled:
            print("Cancelled")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
)
```
For the callbacks to work, your app must support the **x-callback-url** protocol. The easiest way is to let **IAC** manage that.

### Add x-callback-url support to your app

Follow these simple steps to add **x-callback-url** support to your app:

1. Define the url scheme that your app will respond to in the `Info.plist` of your app. See the section **Implementing Custom URL Schemes** in [this article](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app).
 
2. Assign this scheme to the IACManager instance with `IACManager.shared.callbackURLScheme = "myappscheme"`. I recommend doing this in the delegate method `application(_: , didFinishLaunchingWithOptions: )`

3. Call `handleOpenURL(_:)` from the URL handling method in the app's delegate. For example:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
    return IACManager.shared.handleOpenURL(url)
}
```

With these three steps your app will be available to call other apps and receive callbacks from them.

### Add an x-callback-url API to your app

If you want to add an external **API** to your app through the **x-callback-url** protocol you can use any of these two options or both:

- Add handler blocks for your actions directly to the `IACManager` instance calling `handleAction(_:, with:)` for each action.

- Implement the `IACDelegate` protocol in any of your classes and assign the delegate to the `IACManager` instance, preferably in the app delegate `application(_:, didFinishLaunchingWithOptions:)` method.

Action handlers take precedence over the delegate for the same action.

Explore the sample code to see all of these in place.


## Installation

#### Via [Swift Package Manager](https://github.com/apple/swift-package-manager)

1. Add `.Package(url: "https://github.com/dniwallet/IAC_DNIWallet_Swift.git", branch: "master")` to your `Package.swift` inside `dependencies`:
```swift
import PackageDescription

let package = Package(
    name: "yourapp",
    dependencies: [
        .Package(url: "https://github.com/dniwallet/IAC_DNIWallet_Swift.git", branch: "master")
    ]
)
```
2. Run `swift build`.
 

## Dependencies

### [JOSESwift](https://github.com/airsidemobile/JOSESwift.git) 
JOSESwift is a modular and extensible framework for the JOSE standards JWS, JWE, and JWK written in Swift.


## License

MIT License

Copyright (c) 2023 DNI Wallet

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
