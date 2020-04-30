//
//  ViewController.m
//  JQCollectionViewAlignLayout-iOS
//
//  Created by ZJQ on 2020/4/30.
//  Copyright © 2020 www.sunnada.com. All rights reserved.
//

#import "ViewController.h"
#import "JQCollectionViewAlignLayout.h"
#import "AlignmentCollectionHeaderView.h"
#import "JQSectionModel.h"
#import "JQCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource, JQCollectionViewAlignLayoutDelegate>

@property (nonatomic, copy) NSArray<JQSectionModel *> *data;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString *const kCellReuseIdentifier = @"kCellReuseIdentifier";
static NSString *const kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
static NSString *const kFooterReuseIdentifier = @"kFooterReuseIdentifier";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.collectionView registerClass:[JQCollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    [self.collectionView registerClass:[AlignmentCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterReuseIdentifier];
}

#pragma mark - UICollectionViewDataSource, JQCollectionViewAlignLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data[section].items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.data[indexPath.section].items[indexPath.item].color;
    cell.title = [NSString stringWithFormat:@"%zd", self.data[indexPath.section].items[indexPath.item].index];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AlignmentCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseIdentifier forIndexPath:indexPath];
        headerView.label.text = self.data[indexPath.section].alignmentDescription;
        return headerView;
    }
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterReuseIdentifier forIndexPath:indexPath];
    footer.backgroundColor = [UIColor darkGrayColor];
    return footer;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0.f, 90.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 44.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.section].items[indexPath.item].size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arr = self.data[indexPath.section].items;
    [arr removeObjectAtIndex:indexPath.item];
    [collectionView deleteItemsAtIndexPaths:@[ indexPath ]];
}

- (JQCollectionViewItemsHorizontalAlignment)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsHorizontalAlignmentInSection:(NSInteger)section {
    return self.data[section].horizontalAlignment;
}

- (JQCollectionViewItemsVerticalAlignment)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsVerticalAlignmentInSection:(NSInteger)section {
    return self.data[section].verticalAlignment;
}

- (JQCollectionViewItemsDirection)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsDirectionInSection:(NSInteger)section {
    return self.data[section].direction;
}

#pragma mark - getter

- (NSArray<JQSectionModel *> *)data {
    if (!_data) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        JQCollectionViewItemsVerticalAlignment verticalAlignments[] = {JQCollectionViewItemsVerticalAlignmentCenter, JQCollectionViewItemsVerticalAlignmentTop, JQCollectionViewItemsVerticalAlignmentBottom};
        JQCollectionViewItemsHorizontalAlignment horizontalAlignments[] = {JQCollectionViewItemsHorizontalAlignmentCenter, JQCollectionViewItemsHorizontalAlignmentLeft, JQCollectionViewItemsHorizontalAlignmentRight, JQCollectionViewItemsHorizontalAlignmentFlow};
        JQCollectionViewItemsDirection directions[] = {JQCollectionViewItemsDirectionLTR, JQCollectionViewItemsDirectionRTL};
        for (int i = 0; i < 4; i++) {
            JQCollectionViewItemsHorizontalAlignment horizontal = horizontalAlignments[i];
            for (int j = 0; j < 3; j++) {
                JQCollectionViewItemsVerticalAlignment vertical = verticalAlignments[j];
                for (int k = 0; k < 2; k++) {
                    JQCollectionViewItemsDirection direction = directions[k];
                    int count = 40;
                    NSMutableArray *items = [[NSMutableArray alloc] init];
                    for (int j = 0; j < count; j++) {
                        UIColor *color = [UIColor colorWithRed:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f blue:arc4random() % 255 / 255.f alpha:1.f];
                        CGSize size = CGSizeMake((arc4random() % 5 + 5) * 10, (arc4random() % 5 + 5) * 5);
                        JQSectionItemModel *item = [[JQSectionItemModel alloc] initWithColor:color size:size index:j];
                        [items addObject:item];
                    }
                    JQSectionModel *section = [[JQSectionModel alloc] init];
                    section.verticalAlignment = vertical;
                    section.horizontalAlignment = horizontal;
                    section.direction = direction;
                    section.items = items;
                    [data addObject:section];
                }
            }
            _data = data;
        }
    }
    return _data;
}

@end
