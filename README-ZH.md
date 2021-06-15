[English](./README.md) | 中文说明

# JQCollectionViewAlignLayout

[![Version](https://img.shields.io/cocoapods/v/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)
[![License](https://img.shields.io/cocoapods/l/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)
[![Platform](https://img.shields.io/cocoapods/p/JQCollectionViewAlignLayout.svg?style=flat)](http://cocoapods.org/pods/JQCollectionViewAlignLayout)

一个基于流式布局 (flow layout) 的自定义布局对象。支持设置 `NS&UICollectionView` 水平及竖直方向的对齐方式，以及从右到左及从左到右的排列顺序。



## 示例

可以通过 `git clone` 仓库，并在 `Examples` 文件夹下执行 `pod install`，然后用 Xcode 打开 `JQCollectionViewAlignLayout.xcworkspace` 并选择下列中的一个 scheme 运行对应的示例项目。

<img src="https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/schemes.png?raw=true" style="zoom:50%;" />

### iOS

![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/eg-ios.png?raw=true)

### macOS

![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/eg-osx.png?raw=true)

### tvOS

![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/eg-tvos.png?raw=true)



## 对齐方式及排列方向

|                           水平方向                           |                           示例图片                           |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| 默认流式<br />(`JQCollectionViewItemsHorizontalAlignmentFlow`) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-flow.png?raw=true) |
|  居左<br />(`JQCollectionViewItemsHorizontalAlignmentLeft`)  | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-left.png?raw=true) |
| 居中<br />(`JQCollectionViewItemsHorizontalAlignmentCenter`) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-center.png?raw=true) |
| 居右<br />(`JQCollectionViewItemsHorizontalAlignmentRight`)  | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-right.png?raw=true) |
| 平铺填充<br />(`JQCollectionViewItemsHorizontalAlignmentFlowFilled`) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/h-flowfilled.png?raw=true) |

|                           竖直方向                           |                           示例图片                           |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| 默认居中<br />(`JQCollectionViewItemsVerticalAlignmentCenter`) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/v-center.png?raw=true) |
| 顶部对齐<br />(`JQCollectionViewItemsVerticalAlignmentTop`)  | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/v-top.png?raw=true) |
| 底部对齐<br />(`JQCollectionViewItemsVerticalAlignmentBottom`) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/v-bottom.png?raw=true) |

|                        排列方向                         |                           示例图片                           |
| :-----------------------------------------------------: | :----------------------------------------------------------: |
| 默认从左到右<br />(`JQCollectionViewItemsDirectionLTR`) | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/d-ltr.png?raw=true) |
|   从右到左<br />(`JQCollectionViewItemsDirectionRTL`)   | ![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/d-rtl.png?raw=true) |



## 系统要求

iOS 6.0 +

macOS 10.11 +

tvOS 9.0 +



## 安装

`JQCollectionViewAlignLayout ` 可以通过 [CocoaPods](http://cocoapods.org) 安装，只需在你的 Podfile 里加上下面这行：

```ruby
pod 'JQCollectionViewAlignLayout'
```



## 使用

#### 第一步：使用 `JQCollectionViewAlignLayout` 初始化 collection view

- 可以像下面通过代码的方式:

``` objective-c
// UICollectionView
JQCollectionViewAlignLayout *layout = [[JQCollectionViewAlignLayout alloc] init];
UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];

// NSCollectionView
JQCollectionViewAlignLayout *layout = [[JQCollectionViewAlignLayout alloc] init];
NSCollectionView *collectionView = ...;
collectionView.layout = layout;
```
- 也可以像下面通过在 Interface Builder 中设置:

![](https://github.com/Coder-ZJQ/JQCollectionViewAlignLayout/blob/master/images/ib-setup.png?raw=true)

#### 第二步：设置对齐方式及排列方向

- 可以像下面通过 property 为所有 section 设置:

```objective-c
layout.itemsHorizontalAlignment = JQCollectionViewItemsHorizontalAlignmentLeft;
layout.itemsVerticalAlignment = JQCollectionViewItemsVerticalAlignmentCenter;
layout.itemsDirection = JQCollectionViewItemsDirectionLTR;
```

- 也可以像下面通过 protocol 为每个 section设置:

```objective-c
// 1. 遵循 JQCollectionViewAlignLayoutDelegate 协议
@interface JQViewController () < UICollectionViewDataSource, JQCollectionViewAlignLayoutDelegate>

@end

@implementation JQViewController
// 2. 实现对应协议方法
- (JQCollectionViewItemsHorizontalAlignment)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsHorizontalAlignmentInSection:(NSInteger)section {
  // 返回 JQCollectionViewItemsHorizontalAlignment 枚举以设置水平对齐方式
}

- (JQCollectionViewItemsVerticalAlignment)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsVerticalAlignmentInSection:(NSInteger)section {
  // 返回 JQCollectionViewItemsVerticalAlignment 枚举以设置竖直对齐方式
}

- (JQCollectionViewItemsDirection)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsDirectionInSection:(NSInteger)section {
  // 返回 JQCollectionViewItemsDirection 枚举以设置排列方向
}

@end
```

*(剩下的使用与 `NS&UICollectionViewFlowLayout` 一致，也可打开[示例项目](./Examples)查看更多细节)*



## 作者

coder-zjq, zjq_joker@163.com



## 协议

JQCollectionViewAlignLayout 遵循 MIT 协议，可以查看 LICENSE 文件获取更多信息。