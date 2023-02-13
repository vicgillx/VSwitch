# VSwitch


[![Platform](https://img.shields.io/cocoapods/p/ios)](https://cocoapods.org/pods/VSwitch)

![Preview 1](https://github.com/vicgillx/VSwitch/blob/main/preview.gif)


## Requirements
* Xcode 13 or higher
* iOS 11.0 or higher
* Swift 5.0

## Example
```
        let switch2 = VSwitch(items: item2,itemInsetSpacing: 2,padding: 4)
        switch2.backgroundColor = UIColor(hex: 0xF6F7F9)
        switch2.offColor = UIColor(hex: 0xB7B7B7)
        switch2.onColor = UIColor.white
        switch2.reloadCornerRadius(radius: 30)
        view.addSubview(switch2)
        NSLayoutConstraint.activate([
            switch2.topAnchor.constraint(equalTo: switch1.bottomAnchor,constant: 20),
            switch2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switch2.heightAnchor.constraint(equalToConstant: 60),
            switch2.widthAnchor.constraint(equalToConstant: 300)
        ])
```

## Installation

VSwitch is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VSwitch'
```

## Author

vicgillx, johnvoid64@gmail.com

## License

VSwitch is available under the MIT license. See the LICENSE file for more info.
