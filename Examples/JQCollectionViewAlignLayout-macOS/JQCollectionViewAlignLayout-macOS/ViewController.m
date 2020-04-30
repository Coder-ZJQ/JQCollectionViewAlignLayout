//
//  ViewController.m
//  JQCollectionViewAlignLayout-macOS
//
//  Created by ZJQ on 2020/4/30.
//  Copyright © 2020 www.sunnada.com. All rights reserved.
//

#import "ViewController.h"
#import "JQCollectionViewAlignLayout.h"
#import "JQSectionModel.h"
#import "CollectionViewItem.h"

@interface ViewController ()<JQCollectionViewAlignLayoutDelegate, NSCollectionViewDataSource>

@property (nonatomic, copy) NSArray<JQSectionModel *> *data;
@property (weak) IBOutlet NSCollectionView *collectionView;

@end

static NSString *const kItemReuseIdentifier = @"kItemReuseIdentifier";
static NSString *const kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
static NSString *const kFooterReuseIdentifier = @"kFooterReuseIdentifier";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.wantsLayer = YES;
    self.collectionView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self.collectionView registerClass:[NSView class] forSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withIdentifier:kHeaderReuseIdentifier];
    [self.collectionView registerClass:[NSView class] forSupplementaryViewOfKind:NSCollectionElementKindSectionFooter withIdentifier:kFooterReuseIdentifier];
    [self.collectionView registerNib:[[NSNib alloc] initWithNibNamed:@"CollectionViewItem" bundle:nil] forItemWithIdentifier:kItemReuseIdentifier];
}

#pragma mark - JQCollectionViewAlignLayoutDelegate, NSCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return self.data.count;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data[section].items.count;
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.section].items[indexPath.item].size;
}

- (NSEdgeInsets)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return NSEdgeInsetsMake(20, 20, 20, 20);
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewItem *item = [collectionView makeItemWithIdentifier:kItemReuseIdentifier forIndexPath:indexPath];
    item.model = self.data[indexPath.section].items[indexPath.item];
    return item;
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return NSMakeSize(0, 50.f);
}


- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return NSMakeSize(0, 50.f);
}

- (NSView *)collectionView:(NSCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:NSCollectionElementKindSectionHeader]) {
        NSView *header = [collectionView makeSupplementaryViewOfKind:kind withIdentifier:kHeaderReuseIdentifier forIndexPath:indexPath];
        header.wantsLayer = YES;
        header.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
        return header;
    } else {
        NSView *footer = [collectionView makeSupplementaryViewOfKind:kind withIdentifier:kFooterReuseIdentifier forIndexPath:indexPath];
        footer.wantsLayer = YES;
        footer.layer.backgroundColor = [NSColor darkGrayColor].CGColor;
        return footer;
    }
}

- (JQCollectionViewItemsVerticalAlignment)collectionView:(NSCollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsVerticalAlignmentInSection:(NSInteger)section {
    return self.data[section].verticalAlignment;
}

- (JQCollectionViewItemsHorizontalAlignment)collectionView:(NSCollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsHorizontalAlignmentInSection:(NSInteger)section {
    return self.data[section].horizontalAlignment;
}

- (JQCollectionViewItemsDirection)collectionView:(NSCollectionView *)collectionView layout:(JQCollectionViewAlignLayout *)layout itemsDirectionInSection:(NSInteger)section {
    return self.data[section].direction;
}

#pragma mark - getter

- (NSArray<JQSectionModel *> *)data {
    if (!_data) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        JQCollectionViewItemsVerticalAlignment verticalAlignments[] = {JQCollectionViewItemsVerticalAlignmentCenter, JQCollectionViewItemsVerticalAlignmentTop, JQCollectionViewItemsVerticalAlignmentBottom};
        JQCollectionViewItemsHorizontalAlignment horizontalAlignments[] = {JQCollectionViewItemsHorizontalAlignmentCenter, JQCollectionViewItemsHorizontalAlignmentLeft, JQCollectionViewItemsHorizontalAlignmentRight, JQCollectionViewItemsHorizontalAlignmentFlow};
        for (int i = 0; i < 3; i++) {
            JQCollectionViewItemsVerticalAlignment vertical = verticalAlignments[i];
            for (int j = 0; j < 4; j++) {
                JQCollectionViewItemsHorizontalAlignment horizontal = horizontalAlignments[j];
                int count = 40;
                NSMutableArray *items = [[NSMutableArray alloc] init];
                CGFloat viewWidth = self.view.frame.size.width;
                for (int j = 0; j < count; j++) {
                    NSColor *color = [NSColor colorWithRed:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f blue:arc4random() % 255 / 255.f alpha:1.f];
                    CGFloat width = viewWidth / (arc4random() % 3 + 3);
                    CGFloat height = viewWidth / (arc4random() % 6 + 6);
                    CGSize size = CGSizeMake(width, height);
                    JQSectionItemModel *item = [[JQSectionItemModel alloc] initWithColor:color size:size index:j];
                    [items addObject:item];
                }
                JQSectionModel *section = [[JQSectionModel alloc] init];
                section.verticalAlignment = vertical;
                section.horizontalAlignment = horizontal;
                section.items = items;
                [data addObject:section];
            }
            _data = data;
        }
    }
    return _data;
}

@end
