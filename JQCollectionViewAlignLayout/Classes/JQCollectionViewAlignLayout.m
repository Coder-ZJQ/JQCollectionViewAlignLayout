//
//  JQCollectionViewAlignLayout.m
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2017/12/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JQCollectionViewAlignLayout.h"

@interface JQCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

/// next item space
@property (nonatomic) CGFloat nextItemSpece;

@end

@implementation JQCollectionViewLayoutAttributes

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

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}

@end

@implementation JQCollectionViewAlignLayout (alignment)

- (void)calculateItemAttributes:(NSArray<UICollectionViewLayoutAttributes*> *)array success:(void (^)(CGFloat itemLineStart, CGFloat itemLineSpace))success {
    if (array.count == 0) return;
    CGFloat totalWidth = 0.f;
    for (UICollectionViewLayoutAttributes *attr in array) {
        totalWidth += CGRectGetWidth(attr.frame);
    }
    JQCollectionViewItemAlignment alignment = [self itemAlignmentForSectionAtIndex:[array firstObject].indexPath.section];
    UIEdgeInsets insets = [self insetForSectionAtIndex:[array firstObject].indexPath.section];
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingForSectionAtIndex:[array firstObject].indexPath.section];
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
    !success ?: success(start, space);
}
@end
@implementation JQCollectionViewAlignLayout

+ (Class)layoutAttributesClass {
    return [JQCollectionViewLayoutAttributes class];
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
    JQCollectionViewItemAlignment alignment = [self itemAlignmentForSectionAtIndex:indexPath.section];
    if (alignment == JQCollectionViewItemAlignmentFlow) {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    
    NSIndexPath *currentIndexPath = indexPath;
    NSIndexPath *previousIndexPath = indexPath.item == 0 ? nil : [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    
    // This is likely occurring because the flow layout subclass JQCollectionViewAlignLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them
    JQCollectionViewLayoutAttributes *currentAttributes = [[super layoutAttributesForItemAtIndexPath:currentIndexPath] copy];
    UICollectionViewLayoutAttributes *previousAttributes = previousIndexPath ? [super layoutAttributesForItemAtIndexPath:previousIndexPath] : nil;
    
    CGRect currentFrame = currentAttributes.frame;
    CGRect previousFrame = previousAttributes ? previousAttributes.frame : CGRectZero;
    
    UIEdgeInsets insets = [self insetForSectionAtIndex:currentIndexPath.section];
    CGRect currentLineFrame = CGRectMake(insets.left, currentFrame.origin.y, CGRectGetWidth(self.collectionView.frame), currentFrame.size.height);
    CGRect previousLineFrame = CGRectMake(insets.left, previousFrame.origin.y, CGRectGetWidth(self.collectionView.frame), previousFrame.size.height);
    
    BOOL isLineStart = !CGRectIntersectsRect(currentLineFrame, previousLineFrame);
    __block CGFloat start = 0.f, space = 0.f;
    if (isLineStart) {
        NSMutableArray *lineAttributesArray = [[NSMutableArray alloc] init];
        [lineAttributesArray addObject:currentAttributes];
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:currentIndexPath.section];
        NSInteger index = currentIndexPath.item;
        BOOL isLineEnd = currentIndexPath.item == itemCount - 1;
        while (!isLineEnd) {
            index++;
            if (index == itemCount) break;
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index inSection:currentIndexPath.section];
            UICollectionViewLayoutAttributes *nextAttributes = [super layoutAttributesForItemAtIndexPath:nextIndexPath];
            CGRect nextLineFrame = CGRectMake(insets.left, nextAttributes.frame.origin.y, CGRectGetWidth(self.collectionView.frame), nextAttributes.frame.size.height);
            isLineEnd = !CGRectIntersectsRect(currentLineFrame, nextLineFrame);
            if (isLineEnd) break;
            [lineAttributesArray addObject:nextAttributes];
        }
        [self calculateItemAttributes:lineAttributesArray success:^(CGFloat itemLineStart, CGFloat itemLineSpace) {
            start = itemLineStart;
            space = itemLineSpace;
        }];
        NSLog(@"---------");
        currentFrame.origin.x = alignment == JQCollectionViewItemAlignmentRight ? (CGRectGetWidth(self.collectionView.frame) - start - currentFrame.size.width) : start;
        currentAttributes.nextItemSpece = space;
    } else {
        JQCollectionViewLayoutAttributes *previous = (JQCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:previousIndexPath];
        if (alignment == JQCollectionViewItemAlignmentRight) {
            currentFrame.origin.x = previous.frame.origin.x - previous.nextItemSpece - currentFrame.size.width;
        } else {
            currentFrame.origin.x = CGRectGetMaxX(previous.frame) + previous.nextItemSpece;
        }
        currentAttributes.nextItemSpece = previous.nextItemSpece;
    }
    currentAttributes.frame = currentFrame;
    return currentAttributes;
}

@end

