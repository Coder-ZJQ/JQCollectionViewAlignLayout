//
//  JQCollectionViewAlignLayout.h
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2017/12/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_OS_TV

    #import <UIKit/UIKit.h>

    #define JQCollectionViewDelegateFlowLayout UICollectionViewDelegateFlowLayout
    #define JQCollectionElementCategoryItemCell UICollectionElementCategoryCell
    #define JQCollectionView UICollectionView
    typedef UICollectionViewLayoutAttributes JQCollectionViewLayoutAttributes;
    typedef UIEdgeInsets JQEdgeInsets;
    typedef UICollectionViewScrollDirection JQCollectionViewScrollDirection;
    typedef UICollectionViewFlowLayout JQCollectionViewFlowLayout;

#elif TARGET_OS_MAC

    #import <AppKit/AppKit.h>

    #define JQCollectionViewDelegateFlowLayout NSCollectionViewDelegateFlowLayout
    #define JQCollectionElementCategoryItemCell NSCollectionElementCategoryItem
    #define JQCollectionView NSCollectionView
    typedef NSCollectionViewLayoutAttributes JQCollectionViewLayoutAttributes;
    typedef NSEdgeInsets JQEdgeInsets;
    typedef NSCollectionViewScrollDirection JQCollectionViewScrollDirection;
    typedef NSCollectionViewFlowLayout JQCollectionViewFlowLayout;

#endif

typedef NS_ENUM(NSInteger, JQCollectionViewItemsHorizontalAlignment) {
    JQCollectionViewItemsHorizontalAlignmentFlow,   /**< 水平流式(水平方向效果与 UICollectionViewDelegateFlowLayout 一致) */
    JQCollectionViewItemsHorizontalAlignmentLeft,   /**< 水平居左 */
    JQCollectionViewItemsHorizontalAlignmentCenter, /**< 水平居中 */
    JQCollectionViewItemsHorizontalAlignmentRight   /**< 水平居右 */
};

typedef NS_ENUM(NSInteger, JQCollectionViewItemsVerticalAlignment) {
    JQCollectionViewItemsVerticalAlignmentCenter,   /**< 竖直方向居中 */
    JQCollectionViewItemsVerticalAlignmentTop,      /**< 竖直方向顶部对齐 */
    JQCollectionViewItemsVerticalAlignmentBottom    /**< 竖直方向底部对齐 */
};

typedef NS_ENUM(NSInteger, JQCollectionViewItemsDirection) {
    JQCollectionViewItemsDirectionLTR,              /**< 排布方向从左到右 */
    JQCollectionViewItemsDirectionRTL               /**< 排布方向从右到左 */
};

@class JQCollectionViewAlignLayout;

/// 扩展 UICollectionViewDelegateFlowLayout/NSCollectionViewDelegateFlowLayout 协议，
/// 添加设置水平、竖直方向的对齐方式以及 items 排布方向协议方法
@protocol JQCollectionViewAlignLayoutDelegate <JQCollectionViewDelegateFlowLayout>

@optional

/// 设置不同 section items 水平方向的对齐方式
/// @param collectionView UICollectionView/NSCollectionView 对象
/// @param layout 布局对象
/// @param section section
- (JQCollectionViewItemsHorizontalAlignment)collectionView:(JQCollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsHorizontalAlignmentInSection:(NSInteger)section;

/// 设置不同 section items 竖直方向的对齐方式
/// @param collectionView UICollectionView/NSCollectionView 对象
/// @param layout 布局对象
/// @param section section
- (JQCollectionViewItemsVerticalAlignment)collectionView:(JQCollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsVerticalAlignmentInSection:(NSInteger)section;

/// 设置不同 section items 的排布方向
/// @param collectionView UICollectionView/NSCollectionView 对象
/// @param layout 布局对象
/// @param section section
- (JQCollectionViewItemsDirection)collectionView:(JQCollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsDirectionInSection:(NSInteger)section;

@end

/// 在 UICollectionViewFlowLayout/NSCollectionViewFlowLayout 基础上，
/// 自定义 UICollectionView/NSCollectionView 对齐布局
///
/// 实现以下功能：
/// 1. 设置水平方向对齐方式：流式（默认）、居左、居中、居右、平铺；
/// 2. 设置竖直方向对齐方式：居中（默认）、置顶、置底；
/// 3. 设置显示条目排布方向：从左到右（默认）、从右到左。
@interface JQCollectionViewAlignLayout : JQCollectionViewFlowLayout

/// 水平方向对齐方式，默认为流式(JQCollectionViewItemsHorizontalAlignmentFlow)
@property (nonatomic) JQCollectionViewItemsHorizontalAlignment itemsHorizontalAlignment;
/// 竖直方向对齐方式，默认为居中(JQCollectionViewItemsVerticalAlignmentCenter)
@property (nonatomic) JQCollectionViewItemsVerticalAlignment itemsVerticalAlignment;
/// items 排布方向，默认为从左到右(JQCollectionViewItemsDirectionLTR)
@property (nonatomic) JQCollectionViewItemsDirection itemsDirection;

@end

@interface JQCollectionViewAlignLayout (unavailable)

// 禁用 setScrollDirection: 方法，不可设置滚动方向，默认为竖直滚动
- (void)setScrollDirection:(JQCollectionViewScrollDirection)scrollDirection NS_UNAVAILABLE;

@end
