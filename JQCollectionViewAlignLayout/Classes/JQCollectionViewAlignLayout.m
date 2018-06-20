//
//  JQCollectionViewAlignLayout.m
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2017/12/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JQCollectionViewAlignLayout.h"

@interface JQCollectionViewAlignLayout ()

@property (nonatomic, strong) NSMutableDictionary *cachedOriginX;

@end

#define JQCacheKey(indexPath) [NSString stringWithFormat:@"[%ld-%ld]", (long)indexPath.section, (long)indexPath.item]

@implementation JQCollectionViewAlignLayout (attributes)

- (CGFloat)jq_minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    else
    {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)jq_insetForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    else
    {
        return self.sectionInset;
    }
}

- (JQCollectionViewItemAlignment)jq_itemAlignmentForSectionAtIndex:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(layout:itemAlignmentInSection:)])
    {
        return [self.delegate layout:self itemAlignmentInSection:section];
    }
    else
    {
        return self.itemAlignment;
    }
}

@end

@implementation JQCollectionViewAlignLayout (line)

- (BOOL)jq_isLineStartAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) return YES;
    NSIndexPath *currentIndexPath = indexPath;
    NSIndexPath *previousIndexPath = indexPath.item == 0 ? nil : [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *currentAttributes = [super layoutAttributesForItemAtIndexPath:currentIndexPath];
    UICollectionViewLayoutAttributes *previousAttributes = previousIndexPath ? [super layoutAttributesForItemAtIndexPath:previousIndexPath] : nil;
    CGRect currentFrame = currentAttributes.frame;
    CGRect previousFrame = previousAttributes ? previousAttributes.frame : CGRectZero;
    
    UIEdgeInsets insets = [self jq_insetForSectionAtIndex:currentIndexPath.section];
    CGRect currentLineFrame = CGRectMake(insets.left, currentFrame.origin.y, CGRectGetWidth(self.collectionView.frame), currentFrame.size.height);
    CGRect previousLineFrame = CGRectMake(insets.left, previousFrame.origin.y, CGRectGetWidth(self.collectionView.frame), previousFrame.size.height);
    
    return !CGRectIntersectsRect(currentLineFrame, previousLineFrame);
}

- (NSArray *)jq_lineAttributesArrayWithStartAttributes:(UICollectionViewLayoutAttributes *)startAttributes {
    NSMutableArray *lineAttributesArray = [[NSMutableArray alloc] init];
    [lineAttributesArray addObject:startAttributes];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:startAttributes.indexPath.section];
    UIEdgeInsets insets = [self jq_insetForSectionAtIndex:startAttributes.indexPath.section];
    NSInteger index = startAttributes.indexPath.item;
    BOOL isLineEnd = index == itemCount - 1;
    while (!isLineEnd) {
        index++;
        if (index == itemCount) break;
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index inSection:startAttributes.indexPath.section];
        UICollectionViewLayoutAttributes *nextAttributes = [super layoutAttributesForItemAtIndexPath:nextIndexPath];
        CGRect nextLineFrame = CGRectMake(insets.left, nextAttributes.frame.origin.y, CGRectGetWidth(self.collectionView.frame), nextAttributes.frame.size.height);
        isLineEnd = !CGRectIntersectsRect(startAttributes.frame, nextLineFrame);
        if (isLineEnd) break;
        [lineAttributesArray addObject:nextAttributes];
    }
    return lineAttributesArray;
}

@end

@implementation JQCollectionViewAlignLayout (calculation)

- (void)jq_calculateOriginXForItemAttributesArray:(NSArray<UICollectionViewLayoutAttributes*> *)array result:(void (^)(CGFloat x, NSIndexPath *indexPath))result{
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attr in array) {
        [widthArray addObject:@(CGRectGetWidth(attr.frame))];
    }
    CGFloat totalWidth = [[widthArray valueForKeyPath:@"@sum.self"] floatValue];
    JQCollectionViewItemAlignment alignment = [self jq_itemAlignmentForSectionAtIndex:[array firstObject].indexPath.section];
    UIEdgeInsets insets = [self jq_insetForSectionAtIndex:[array firstObject].indexPath.section];
    CGFloat minimumInteritemSpacing = [self jq_minimumInteritemSpacingForSectionAtIndex:[array firstObject].indexPath.section];
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat start = 0.f, space = 0.f;
    NSInteger totalCount = array.count;
    switch (alignment)
    {
        case JQCollectionViewItemAlignmentLeft:
        {
            start = insets.left;
            space = minimumInteritemSpacing;
        }
            break;
            
        case JQCollectionViewItemAlignmentCenter:
        {
            start = (collectionViewWidth - totalWidth - minimumInteritemSpacing * (totalCount - 1)) / 2.f;
            space = minimumInteritemSpacing;
        }
            break;
            
        case JQCollectionViewItemAlignmentRight:
        {
            start = insets.right;
            space = minimumInteritemSpacing;
        }
            break;
            
        case JQCollectionViewItemAlignmentTile:
        {
            start = (collectionViewWidth - totalWidth) / (totalCount + 1);
            space = start;
        }
            break;
            
        default:
            break;
    }
    CGFloat lastMaxX = 0.f;
    for (int i = 0; i < widthArray.count; i ++) {
        UICollectionViewLayoutAttributes *attr = array[i];
        CGFloat width = [widthArray[i] floatValue];
        CGFloat originX = 0.f;
        if (alignment == JQCollectionViewItemAlignmentRight) {
            originX = i == 0 ? collectionViewWidth - start - width : lastMaxX - space - width;
            lastMaxX = originX;
        } else {
            originX = i == 0 ? start : lastMaxX + space;
            lastMaxX = originX + width;
        }
        !result ? : result(originX, attr.indexPath);
    }
}

@end

@implementation JQCollectionViewAlignLayout (cache)

- (void)jq_cacheTheItemOriginX:(CGFloat)originX forIndexPath:(NSIndexPath *)indexPath {
    NSString *key = JQCacheKey(indexPath);
    self.cachedOriginX[key] = @(originX);
}

- (CGFloat)jq_cachedItemOriginXAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = JQCacheKey(indexPath);
    return [self.cachedOriginX[key] floatValue];
}


@end


//*********************** override ***********************//

@implementation JQCollectionViewAlignLayout

- (NSMutableDictionary *)cachedOriginX {
    if (!_cachedOriginX) {
        _cachedOriginX = [[NSMutableDictionary alloc] init];
    }
    return _cachedOriginX;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    return updatedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JQCollectionViewItemAlignment alignment = [self jq_itemAlignmentForSectionAtIndex:indexPath.section];
    if (alignment == JQCollectionViewItemAlignmentFlow) {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    // This is likely occurring because the flow layout subclass JQCollectionViewAlignLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them
    UICollectionViewLayoutAttributes *currentAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    
    // 0. if current item is the line start?
    BOOL isLineStart = [self jq_isLineStartAtIndexPath:indexPath];
    
    // 1. YES: collect the items in line and continue; NO: jump to the 4 step.
    if (isLineStart) {
        NSArray *line = [self jq_lineAttributesArrayWithStartAttributes:currentAttributes];
        
        // 2. calculate the items' origin x in line
        [self jq_calculateOriginXForItemAttributesArray:line result:^(CGFloat x, NSIndexPath *indexPath) {
            // 3. cached the item origin x to avoid recalculation
            [self jq_cacheTheItemOriginX:x forIndexPath:indexPath];
        }];
    }
    
    // 4. set the item oigin x with the cached item origin x
    CGFloat originX = [self jq_cachedItemOriginXAtIndexPath:indexPath];
    CGRect currentFrame = currentAttributes.frame;
    currentFrame.origin.x = originX;
    currentAttributes.frame = currentFrame;
    return currentAttributes;
}

@end

