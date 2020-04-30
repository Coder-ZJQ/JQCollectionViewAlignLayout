//
//  JQCollectionViewAlignLayout.m
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2017/12/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JQCollectionViewAlignLayout.h"

@interface JQCollectionViewAlignLayout ()

@property (nonatomic, strong) NSMutableDictionary *cachedOrigin;

@end

@implementation JQCollectionViewAlignLayout (attributes)

- (CGFloat)jq_minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<JQCollectionViewAlignLayoutDelegate> delegate = (id<JQCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (JQEdgeInsets)jq_insetForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<JQCollectionViewAlignLayoutDelegate> delegate = (id<JQCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        return self.sectionInset;
    }
}

- (JQCollectionViewItemsHorizontalAlignment)jq_itemsHorizontalAlignmentForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:itemsHorizontalAlignmentInSection:)]) {
        id<JQCollectionViewAlignLayoutDelegate> delegate = (id<JQCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self itemsHorizontalAlignmentInSection:section];
    } else {
        return self.itemsHorizontalAlignment;
    }
}

- (JQCollectionViewItemsVerticalAlignment)jq_itemsVerticalAlignmentForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:itemsVerticalAlignmentInSection:)]) {
        id<JQCollectionViewAlignLayoutDelegate> delegate = (id<JQCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self itemsVerticalAlignmentInSection:section];
    } else {
        return self.itemsVerticalAlignment;
    }
}

- (JQCollectionViewItemsDirection)jq_itemsDirectionForSectionAtIndex:(NSInteger)section {
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:itemsDirectionInSection:)]) {
        id<JQCollectionViewAlignLayoutDelegate> delegate = (id<JQCollectionViewAlignLayoutDelegate>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self itemsDirectionInSection:section];
    } else {
        return self.itemsDirection;
    }
}

@end

@implementation JQCollectionViewAlignLayout (line)

- (BOOL)jq_isLineStartAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        return YES;
    }
    NSIndexPath *currentIndexPath = indexPath;
    NSIndexPath *previousIndexPath = indexPath.item == 0 ? nil : [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];

    JQCollectionViewLayoutAttributes *currentAttributes = [super layoutAttributesForItemAtIndexPath:currentIndexPath];
    JQCollectionViewLayoutAttributes *previousAttributes = previousIndexPath ? [super layoutAttributesForItemAtIndexPath:previousIndexPath] : nil;
    CGRect currentFrame = currentAttributes.frame;
    CGRect previousFrame = previousAttributes ? previousAttributes.frame : CGRectZero;

    JQEdgeInsets insets = [self jq_insetForSectionAtIndex:currentIndexPath.section];
    CGRect currentLineFrame = CGRectMake(insets.left, currentFrame.origin.y, CGRectGetWidth(self.collectionView.frame), currentFrame.size.height);
    CGRect previousLineFrame = CGRectMake(insets.left, previousFrame.origin.y, CGRectGetWidth(self.collectionView.frame), previousFrame.size.height);

    return !CGRectIntersectsRect(currentLineFrame, previousLineFrame);
}

- (NSArray *)jq_lineAttributesArrayWithStartAttributes:(JQCollectionViewLayoutAttributes *)startAttributes {
    NSMutableArray *lineAttributesArray = [[NSMutableArray alloc] init];
    [lineAttributesArray addObject:startAttributes];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:startAttributes.indexPath.section];
    JQEdgeInsets insets = [self jq_insetForSectionAtIndex:startAttributes.indexPath.section];
    NSInteger index = startAttributes.indexPath.item;
    BOOL isLineEnd = index == itemCount - 1;
    while (!isLineEnd) {
        index++;
        if (index == itemCount)
            break;
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index inSection:startAttributes.indexPath.section];
        JQCollectionViewLayoutAttributes *nextAttributes = [super layoutAttributesForItemAtIndexPath:nextIndexPath];
        CGRect nextLineFrame = CGRectMake(insets.left, nextAttributes.frame.origin.y, CGRectGetWidth(self.collectionView.frame), nextAttributes.frame.size.height);
        isLineEnd = !CGRectIntersectsRect(startAttributes.frame, nextLineFrame);
        if (isLineEnd)
            break;
        [lineAttributesArray addObject:nextAttributes];
    }
    return lineAttributesArray;
}

@end

@implementation NSValue (JQ)

- (CGRect)jq_rectValue {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    return self.CGRectValue;
#elif TARGET_OS_MAC
    return self.rectValue;
#endif
}

- (CGPoint)jq_pointValue {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    return self.CGPointValue;
#elif TARGET_OS_MAC
    return self.pointValue;
#endif
}

@end

@implementation JQCollectionViewAlignLayout (alignment)

- (void)jq_cacheTheItemOrigin:(CGPoint)origin forIndexPath:(NSIndexPath *)indexPath {
    self.cachedOrigin[indexPath] = @(origin);
}

- (NSValue *)jq_cachedItemOriginAtIndexPath:(NSIndexPath *)indexPath {
    return self.cachedOrigin[indexPath];
}

- (void)jq_calculateAndCacheOriginForItemAttributesArray:(NSArray<JQCollectionViewLayoutAttributes *> *)array {
    NSInteger section = [array firstObject].indexPath.section;

    //******************** 相关布局属性 ********************//
    JQCollectionViewItemsHorizontalAlignment horizontalAlignment = [self jq_itemsHorizontalAlignmentForSectionAtIndex:section];
    JQCollectionViewItemsVerticalAlignment verticalAlignment = [self jq_itemsVerticalAlignmentForSectionAtIndex:section];
    JQCollectionViewItemsDirection direction = [self jq_itemsDirectionForSectionAtIndex:section];
    BOOL isR2L = direction == JQCollectionViewItemsDirectionRTL;
    JQEdgeInsets sectionInsets = [self jq_insetForSectionAtIndex:section];
    CGFloat minimumInteritemSpacing = [self jq_minimumInteritemSpacingForSectionAtIndex:section];

#if TARGET_OS_IPHONE || TARGET_OS_TV
    JQEdgeInsets contentInsets = self.collectionView.contentInset;
#elif TARGET_OS_MAC
    JQEdgeInsets contentInsets = NSEdgeInsetsZero;
#endif

    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    
    //******************** 竖直方向位置(origin.y)，用于竖直方向对齐方式计算 ********************//
    CGFloat tempOriginY = 0.f;
    NSArray *frameValues = [array valueForKeyPath:@"frame"];
    if (verticalAlignment == JQCollectionViewItemsVerticalAlignmentTop) {
        tempOriginY = CGFLOAT_MAX;
        for (NSValue *frameValue in frameValues) {
            tempOriginY = MIN(tempOriginY, CGRectGetMinY([frameValue jq_rectValue]));
        }
    } else if (verticalAlignment == JQCollectionViewItemsVerticalAlignmentBottom) {
        tempOriginY = CGFLOAT_MIN;
        for (NSValue *frameValue in frameValues) {
            tempOriginY = MAX(tempOriginY, CGRectGetMaxY([frameValue jq_rectValue]));
        }
    }
    
    //******************** 计算起点及间距 ********************//
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    for (JQCollectionViewLayoutAttributes *attr in array) {
        [widthArray addObject:@(CGRectGetWidth(attr.frame))];
    }
    CGFloat totalWidth = [[widthArray valueForKeyPath:@"@sum.self"] floatValue];
    CGFloat start = 0.f, space = 0.f;
    NSInteger totalCount = array.count;
    switch (horizontalAlignment) {
        case JQCollectionViewItemsHorizontalAlignmentLeft: {
            start = isR2L ? (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.left - minimumInteritemSpacing * (totalCount - 1)) : sectionInsets.left;
            space = minimumInteritemSpacing;
        } break;

        case JQCollectionViewItemsHorizontalAlignmentCenter: {
            CGFloat rest = (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.left - sectionInsets.right - minimumInteritemSpacing * (totalCount - 1)) / 2.f;
            start = isR2L ? sectionInsets.right + rest : sectionInsets.left + rest;
            space = minimumInteritemSpacing;
        } break;

        case JQCollectionViewItemsHorizontalAlignmentRight: {
            start = isR2L ? sectionInsets.right : (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.right - minimumInteritemSpacing * (totalCount - 1));
            space = minimumInteritemSpacing;
        } break;

        case JQCollectionViewItemsHorizontalAlignmentFlow: {
            BOOL isEnd = array.lastObject.indexPath.item == [self.collectionView numberOfItemsInSection:section] - 1;
            start = isR2L ? sectionInsets.right : sectionInsets.left;
            space = isEnd ? minimumInteritemSpacing : (collectionViewWidth - totalWidth - contentInsets.left - contentInsets.right - sectionInsets.left - sectionInsets.right) / (totalCount - 1);
        } break;

        default:
            break;
    }
    
    //******************** 计算并缓存位置 ********************//
    CGFloat lastMaxX = 0.f;
    for (int i = 0; i < widthArray.count; i++) {
        JQCollectionViewLayoutAttributes *attr = array[i];
        CGFloat width = [widthArray[i] floatValue];
        CGFloat originX = 0.f;
        if (isR2L) {
            originX = i == 0 ? collectionViewWidth - start - contentInsets.right - contentInsets.left - width : lastMaxX - space - width;
            lastMaxX = originX;
        } else {
            originX = i == 0 ? start : lastMaxX + space;
            lastMaxX = originX + width;
        }
        CGFloat originY;
        if (verticalAlignment == JQCollectionViewItemsVerticalAlignmentBottom) {
            originY = tempOriginY - CGRectGetHeight(attr.frame);
        } else if (verticalAlignment == JQCollectionViewItemsVerticalAlignmentCenter) {
            originY = attr.frame.origin.y;
        } else {
            originY = tempOriginY;
        }
        [self jq_cacheTheItemOrigin:CGPointMake(originX, originY) forIndexPath:attr.indexPath];
    }
}

@end


@implementation JQCollectionViewAlignLayout


- (void)prepareLayout {
    [super prepareLayout];
    self.cachedOrigin = @{}.mutableCopy;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = originalAttributes.mutableCopy;
    for (JQCollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind || attributes.representedElementCategory == JQCollectionElementCategoryItemCell) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    return updatedAttributes;
}

- (JQCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // This is likely occurring because the flow layout subclass JQCollectionViewAlignLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them
    JQCollectionViewLayoutAttributes *currentAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];

    // 获取缓存的当前 indexPath 的 item origin value
    NSValue *originValue = [self jq_cachedItemOriginAtIndexPath:indexPath];
    CGPoint origin;
    // 如果没有缓存的 item origin value，则计算并缓存然后获取
    if (!originValue) {
        // 判断是否为一行中的首个
        BOOL isLineStart = [self jq_isLineStartAtIndexPath:indexPath];
        // 如果是一行中的首个
        if (isLineStart) {
            // 获取当前行的所有 UICollectionViewLayoutAttributes
            NSArray *line = [self jq_lineAttributesArrayWithStartAttributes:currentAttributes];
            if (line.count) {
                // 计算并缓存当前行的所有 UICollectionViewLayoutAttributes origin
                [self jq_calculateAndCacheOriginForItemAttributesArray:line];
            }
        }
        // 获取位于当前 indexPath 的 item origin
        originValue = [self jq_cachedItemOriginAtIndexPath:indexPath];
    }
    if (originValue) {
        // 设置缓存的当前 indexPath 的 item origin
        origin = [originValue jq_pointValue];
        CGRect currentFrame = currentAttributes.frame;
        // 获取当前 indexPath 的 item origin 后修改当前 layoutAttributes.frame.origin
        currentFrame.origin = origin;
        currentAttributes.frame = currentFrame;
    }
    
    return currentAttributes;
}

@end
