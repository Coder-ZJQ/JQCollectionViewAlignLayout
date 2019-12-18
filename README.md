# JQCollectionViewAlignLayout


[![Version](https://img.shields.io/cocoapods/v/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)
[![License](https://img.shields.io/cocoapods/l/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)
[![Platform](https://img.shields.io/cocoapods/p/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Alignment

|                      Horizontal                       |                          Demo Image                          |
| :---------------------------------------------------: | :----------------------------------------------------------: |
| JQCollectionViewItemsHorizontalAlignmentFlow(default) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-flow.png?raw=true) |
|     JQCollectionViewItemsHorizontalAlignmentLeft      | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-left.png?raw=true) |
|    JQCollectionViewItemsHorizontalAlignmentCenter     | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-center.png?raw=true) |
|     JQCollectionViewItemsHorizontalAlignmentRight     | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-right.png?raw=true) |

|                       Vertical                        |                          Demo Image                          |
| :---------------------------------------------------: | :----------------------------------------------------------: |
| JQCollectionViewItemsVerticalAlignmentCenter(default) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/v-center.png?raw=true) |
|       JQCollectionViewItemsVerticalAlignmentTop       | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/v-top.png?raw=true) |
|     JQCollectionViewItemsVerticalAlignmentBottom      | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/v-bottom.png?raw=true) |

|                 Direction                  |                          Demo Image                          |
| :----------------------------------------: | :----------------------------------------------------------: |
| JQCollectionViewItemsDirectionLTR(default) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/d-ltr.png?raw=true) |
|     JQCollectionViewItemsDirectionRTL      | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/d-rtl.png?raw=true) |

## Requirements

iOS 6.0 +
## Installation

JQCollectionViewAlignLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JQCollectionViewAlignLayout'
```

## Usage

**Init the collectionView with `JQCollectionViewAlignLayout`:**

- Code:

``` objective-c
JQCollectionViewAlignLayout *layout = [[JQCollectionViewAlignLayout alloc] init];
UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
```
- Interface Builder:

![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/ib-setup.png?raw=true)

**Set the alignment and direction:**

- Property:

```objective-c
layout.itemsHorizontalAlignment = JQCollectionViewItemsHorizontalAlignmentLeft;
layout.itemsVerticalAlignment = JQCollectionViewItemsVerticalAlignmentCenter;
layout.itemsDirection = JQCollectionViewItemsDirectionLTR;
```

- Protocol:

```objective-c
// (if you want set different alignment and direction each section, you can do like this.)
// 1. conforms to protocol JQCollectionViewAlignLayoutDelegate
@interface JQViewController () < UICollectionViewDataSource, JQCollectionViewAlignLayoutDelegate>

@end

@implementation JQViewController
// 2. implement the protocol method
- (JQCollectionViewItemsHorizontalAlignment)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsHorizontalAlignmentInSection:(NSInteger)section {
  // return the JQCollectionViewItemsHorizontalAlignment in section.
}

- (JQCollectionViewItemsVerticalAlignment)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsVerticalAlignmentInSection:(NSInteger)section {
  // return the JQCollectionViewItemsVerticalAlignment in section.
}

- (JQCollectionViewItemsDirection)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsDirectionInSection:(NSInteger)section {
  // return the JQCollectionViewItemsDirection in section.
}

@end
```

**The rest is same as `UICollectionViewFlowLayout`.**

## Author

coder-zjq, zjq_joker@163.com

## License

JQCollectionViewAlignLayout is available under the MIT license. See the LICENSE file for more info.
