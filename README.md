# swift-sendgrid

SendgridSwift SDK for Swift programming language working on  Linux and macOS.

[<img src="http://img.shields.io/badge/swift-5.0-brightgreen.svg" alt="Swift 5.0" />](https://swift.org)

## Installation

### Swift Package Manager

SendgridSwift uses the Swift Package Manager to manage its code dependencies. To use SendgridSwift in your codebase it is recommended you do the same. Add a dependency to the package in your own Package.swift dependencies.
```swift
    dependencies: [
        .package(url: "https://github.com/swift-aws/aws-sdk-swift.git", from: "4.0.0")
    ],
```
Then add target dependencies for each of the AWSSDKSwift targets you want to use.
```swift
    targets: [
      .target(name: "MyAWSApp", dependencies: ["S3", "SES", "CloudFront", "ELBV2", "IAM", "Kinesis"]),
    ]
)
```

# License
swift-sendgrid iis released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See LICENSE for details.
