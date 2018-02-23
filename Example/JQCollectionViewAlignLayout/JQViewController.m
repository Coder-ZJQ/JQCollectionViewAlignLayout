//
//  JQViewController.m
//  JQCollectionViewAlignLayout
//
//  Created by coder-zjq on 01/02/2018.
//  Copyright (c) 2018 coder-zjq. All rights reserved.
//

#import "JQViewController.h"
#import "JQCollectionViewAlignLayout.h"
#import "AlignmentCollectionHeaderView.h"

@interface JQViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, JQCollectionViewAlignLayoutDelegate>

/** data */
@property (nonatomic, copy) NSArray *data;

@end

static NSString * const kCellReuseIdentifier = @"kCellReuseIdentifier";
static NSString * const kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
@implementation JQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    JQCollectionViewAlignLayout *layout = [[JQCollectionViewAlignLayout alloc] init];
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    [collectionView registerClass:[AlignmentCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = self.data[section][@"items"];
    return arr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    NSArray *arr = self.data[indexPath.section][@"items"];
    cell.backgroundColor = arr[indexPath.item][@"color"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0.f, 50.f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AlignmentCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseIdentifier forIndexPath:indexPath];
    JQCollectionViewItemAlignment alignment = [self.data[indexPath.section][@"alignment"] integerValue];
    headerView.alignment = alignment;
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.data[indexPath.section][@"items"];
    return [arr[indexPath.item][@"size"] CGSizeValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = self.data[indexPath.section][@"items"];
    [arr removeObjectAtIndex:indexPath.item];
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (JQCollectionViewItemAlignment)layout:(JQCollectionViewAlignLayout *)layout itemAlignmentInSection:(NSInteger)section
{
    JQCollectionViewItemAlignment alignment = [self.data[section][@"alignment"] integerValue];
    return alignment;
}

- (NSArray *)data
{
    if (!_data)
    {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSArray *alignments = @[@(JQCollectionViewItemAlignmentLeft), @(JQCollectionViewItemAlignmentRight), @(JQCollectionViewItemAlignmentCenter), @(JQCollectionViewItemAlignmentTile), @(JQCollectionViewItemAlignmentFlow)];
        for (NSNumber *alignment in alignments)
        {
            int count = 40;
            NSMutableArray *items = [[NSMutableArray alloc] init];
            for (int j = 0; j < count; j++)
            {
                UIColor *color = [UIColor colorWithRed:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f blue:arc4random() % 255 / 255.f alpha:1.f];
                NSValue *size = [NSValue valueWithCGSize:CGSizeMake((arc4random() % 5 + 5) * 8, (arc4random() % 5 + 5) * 3)];
                [items addObject:@{ @"size": size, @"color": color }];
            }
            [data addObject:@{ @"alignment": alignment, @"items": items }];
        }
        _data = data;
    }
    return _data;
}

@end

