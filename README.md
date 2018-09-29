# JQCollectionViewAlignLayout


[![Version](https://img.shields.io/cocoapods/v/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)
[![License](https://img.shields.io/cocoapods/l/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)
[![Platform](https://img.shields.io/cocoapods/p/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
![Example](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/demo.gif?raw=true)

## Alignment

|                alignment                 |                demo image                |
| :--------------------------------------: | :--------------------------------------: |
| JQCollectionViewItemAlignmentFlow(default) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/flow.png?raw=true) |
|    JQCollectionViewItemAlignmentLeft     | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/align-left.png?raw=true) |
|    JQCollectionViewItemAlignmentRight    | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/align-right.png?raw=true) |
|   JQCollectionViewItemAlignmentCenter    | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/align-center.png?raw=true) |
|    JQCollectionViewItemAlignmentTile     | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/tile.png?raw=true) |


## Requirements
iOS 6.0 +
## Installation

JQCollectionViewAlignLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JQCollectionViewAlignLayout'
```

## Usage

1. init the collectionView with JQCollectionViewAlignLayout

``` objective-c
JQCollectionViewAlignLayout *layout = [[JQCollectionViewAlignLayout alloc] init];
UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
```
2. setup the itemAlignment
``` objective-c
// you can set the itemAlignment for all sections by this:
layout.itemAlignment = JQCollectionViewItemAlignmentLeft;

// if you want set different itemAlignment for sections, you can do like this:
// 1. conforms to protocol JQCollectionViewAlignLayoutDelegate
@interface JQViewController () < UICollectionViewDataSource, JQCollectionViewAlignLayoutDelegate>
    
// 2. implement the protocol method
- (JQCollectionViewItemAlignment)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemAlignmentInSection:(NSInteger)section {
  // return the JQCollectionViewItemAlignment in section.
}
```

3. the rest is the same as `UICollectionViewFlowLayout`.

## Author

coder-zjq, zjq_joker@163.com

## License

JQCollectionViewAlignLayout is available under the MIT license. See the LICENSE file for more info.
