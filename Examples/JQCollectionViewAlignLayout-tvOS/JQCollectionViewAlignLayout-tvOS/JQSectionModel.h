//
//  JQSectionModel.h
//  JQCollectionViewAlignLayout_Example
//
//  Created by ZJQ on 2019/10/11.
//  Copyright © 2019 coder-zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQCollectionViewAlignLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface JQSectionItemModel : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) NSUInteger index;

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size index:(NSUInteger)index;

@end

@interface JQSectionModel : NSObject
 
@property (nonatomic, assign) JQCollectionViewItemsHorizontalAlignment horizontalAlignment;
@property (nonatomic, assign) JQCollectionViewItemsVerticalAlignment verticalAlignment;
@property (nonatomic, assign) JQCollectionViewItemsDirection direction;
@property (nonatomic, strong) NSMutableArray<JQSectionItemModel *> *items;
@property (nonatomic, copy, readonly) NSString *alignmentDescription;

@end

NS_ASSUME_NONNULL_END
