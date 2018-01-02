//
//  JQCollectionViewAlignLayout.h
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2017/12/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 对齐方式：
 */
typedef NS_ENUM(NSInteger, JQCollectionViewItemAlignment) {
    JQCollectionViewItemAlignmentFlow,      /**< 流水：|***    **    ****| */
    JQCollectionViewItemAlignmentLeft,      /**< 居左：|*** ** ****      | */
    JQCollectionViewItemAlignmentCenter,    /**< 居中：|   *** ** ****   | */
    JQCollectionViewItemAlignmentRight,     /**< 居右：|      *** ** ****| */
    JQCollectionViewItemAlignmentTile       /**< 平铺：|  ***  **  ****  | */
};

@class JQCollectionViewAlignLayout;
@protocol JQCollectionViewAlignLayoutDelegate <NSObject>
@optional
/**
 <#Description#>

 @param layout <#layout description#>
 @param section <#section description#>
 @return <#return value description#>
 */
- (JQCollectionViewItemAlignment)layout:(JQCollectionViewAlignLayout *)layout itemAlignmentInSection:(NSInteger)section;

@end

@interface JQCollectionViewAlignLayout : UICollectionViewFlowLayout

/// 对齐类型，默认为 JQCollectionViewItemAlignmentFlow
@property (nonatomic) JQCollectionViewItemAlignment itemAlignment;
/// 代理
@property (nonatomic, weak) id<JQCollectionViewAlignLayoutDelegate> delegate;

@end

@interface JQCollectionViewAlignLayout (unavailable)

// 禁用 setScrollDirection: 方法，默认为 UICollectionViewScrollDirectionVertical
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection NS_UNAVAILABLE;

@end
