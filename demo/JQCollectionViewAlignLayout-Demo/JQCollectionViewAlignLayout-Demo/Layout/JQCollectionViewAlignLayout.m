//
//  JQCollectionViewAlignLayout.m
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2017/12/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JQCollectionViewAlignLayout.h"

@interface NSArray (UICollectionViewLayoutAttributes)

- (void)evaluateItemAttributesSuccess:(void (^)(CGFloat visibleWidth, NSInteger visibleCount))success;

@end

@implementation NSArray (UICollectionViewLayoutAttributes)

- (void)evaluateItemAttributesSuccess:(void (^)(CGFloat visibleWidth, NSInteger visibleCount))success
{
    CGFloat visibleWidth = 0.f;
    NSInteger visibleCount = 0;
    for (UICollectionViewLayoutAttributes *attr in self)
    {
        // 忽略无宽高的情况
        if (CGRectGetWidth(attr.frame) > 0 && CGRectGetHeight(attr.frame) > 0)
        {
            visibleWidth += CGRectGetWidth(attr.frame);
            visibleCount++;
        }
    }
    !success ?: success(visibleWidth, visibleCount);
}

@end

@interface JQCollectionViewAlignLayout (attributes)

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;
- (JQCollectionViewItemAlignment)itemAlignmentForSectionAtIndex:(NSInteger)section;

@end

@implementation JQCollectionViewAlignLayout (attributes)

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
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

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
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

- (JQCollectionViewItemAlignment)itemAlignmentForSectionAtIndex:(NSInteger)section
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

@interface JQCollectionViewAlignLayout (alignment)

- (void)alignTheItemAttributes:(NSArray<UICollectionViewLayoutAttributes *> *)itemAttributes;

@end

@implementation JQCollectionViewAlignLayout (alignment)

- (void)alignTheItemAttributes:(NSArray<UICollectionViewLayoutAttributes *> *)itemAttributes
{
    if (itemAttributes.count == 0) return;
    JQCollectionViewItemAlignment itemAlignment = [self itemAlignmentForSectionAtIndex:[itemAttributes firstObject].indexPath.section];
    if (itemAlignment == JQCollectionViewItemAlignmentFlow) return;
    UIEdgeInsets insets = [self insetForSectionAtIndex:[itemAttributes firstObject].indexPath.section];
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingForSectionAtIndex:[itemAttributes firstObject].indexPath.section];
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    __block NSInteger visibleCount = 0;
    __block CGFloat visibleWidth = 0.f;
    CGFloat start = 0.f, space = 0.f;
    [itemAttributes evaluateItemAttributesSuccess:^(CGFloat width, NSInteger count) {
        visibleCount = count;
        visibleWidth = width;
    }];
    switch (itemAlignment)
    {
        case JQCollectionViewItemAlignmentLeft:
        {
            start = insets.left;
            space = minimumInteritemSpacing;
        }
        break;

        case JQCollectionViewItemAlignmentCenter:
        {
            start = (collectionViewWidth - visibleWidth - minimumInteritemSpacing * (visibleCount - 1)) / 2.f;
            space = minimumInteritemSpacing;
        }
        break;

        case JQCollectionViewItemAlignmentRight:
        {
            start = collectionViewWidth - visibleWidth - minimumInteritemSpacing * (visibleCount - 1) - insets.right;
            space = minimumInteritemSpacing;
            itemAttributes = [itemAttributes reverseObjectEnumerator].allObjects;
        }
        break;

        case JQCollectionViewItemAlignmentTile:
        {
            start = (collectionViewWidth - visibleWidth) / (visibleCount + 1);
            space = start;
        }
        break;

        default:
            break;
    }
    CGRect preFrame = CGRectZero;
    for (UICollectionViewLayoutAttributes *attr in itemAttributes)
    {
        CGRect frame = attr.frame;
        frame.origin.x = CGRectGetMaxX(preFrame) + (CGRectIsEmpty(preFrame) ? start : space);
        attr.frame = frame;
        preFrame = frame;
    }
}

@end

@implementation JQCollectionViewAlignLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *originAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updateAttributes = [[NSMutableArray alloc] initWithArray:originAttributes];
    NSMutableArray *attrsPerLine = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attrs in originAttributes)
    {
        if (attrs.representedElementCategory != UICollectionElementCategoryCell) continue;
        NSInteger index = [originAttributes indexOfObject:attrs];
        updateAttributes[index] = [attrs copy];
        UICollectionViewLayoutAttributes *currentAttr = updateAttributes[index];
        NSIndexPath *currentIndexPath = currentAttr.indexPath;
        UIEdgeInsets insets = [self insetForSectionAtIndex:currentIndexPath.section];
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:currentIndexPath.section];
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item + 1 inSection:currentIndexPath.section];
        CGRect nextFrame = currentIndexPath.item == itemCount - 1 ? CGRectZero : [self layoutAttributesForItemAtIndexPath:nextIndexPath].frame;
        CGRect currentLine = CGRectMake(insets.left, currentAttr.frame.origin.y, CGRectGetWidth(self.collectionView.frame) - insets.left - insets.right, currentAttr.frame.size.height);
        BOOL isLineEnd = !CGRectIntersectsRect(nextFrame, currentLine);
        [attrsPerLine addObject:currentAttr];
        if (isLineEnd) {
            [self alignTheItemAttributes:attrsPerLine];
            [attrsPerLine removeAllObjects];
        }
    }
    return updateAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

@end
