//
//  JQSectionModel.m
//  JQCollectionViewAlignLayout_Example
//
//  Created by ZJQ on 2019/10/11.
//  Copyright © 2019 coder-zjq. All rights reserved.
//

#import "JQSectionModel.h"

@implementation JQSectionItemModel

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size index:(NSUInteger)index {
    if (self = [super init]) {
        self.color = color;
        self.size = size;
        self.index = index;
    }
    return self;
}

@end

@implementation JQSectionModel
@synthesize alignmentDescription = _alignmentDescription;

- (NSString *)alignmentDescription {
    if (!_alignmentDescription) {
        NSMutableString *desc = @"horizontal: ".mutableCopy;
        if (self.horizontalAlignment == JQCollectionViewItemsHorizontalAlignmentFlow) {
            [desc appendString:@"flow"];
        } else if (self.horizontalAlignment == JQCollectionViewItemsHorizontalAlignmentLeft) {
            [desc appendString:@"left"];
        } else if (self.horizontalAlignment == JQCollectionViewItemsHorizontalAlignmentRight) {
            [desc appendString:@"right"];
        } else if (self.horizontalAlignment == JQCollectionViewItemsHorizontalAlignmentCenter) {
            [desc appendString:@"center"];
        } else if (self.horizontalAlignment == JQCollectionViewItemsHorizontalAlignmentFlowFilled) {
            [desc appendString:@"flow filled"];
        }
        [desc appendString:@"\nvertical: "];
        if (self.verticalAlignment == JQCollectionViewItemsVerticalAlignmentCenter) {
            [desc appendString:@"center"];
        } else if (self.verticalAlignment == JQCollectionViewItemsVerticalAlignmentBottom) {
            [desc appendString:@"bottom"];
        } else if (self.verticalAlignment == JQCollectionViewItemsVerticalAlignmentTop) {
            [desc appendString:@"top"];
        }
        [desc appendString:@"\ndirection: "];
        if (self.direction == JQCollectionViewItemsDirectionRTL) {
            [desc appendString:@"right to left"];
        } else {
            [desc appendString:@"left to right"];
        }
        _alignmentDescription = desc;
    }
    return _alignmentDescription;
}

@end
