//
//  CollectionViewItem.h
//  AlignCollectionview
//
//  Created by ZJQ on 2020/4/29.
//  Copyright © 2020 www.sunnada.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JQSectionItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewItem : NSCollectionViewItem

@property (nonatomic, strong) JQSectionItemModel *model;

@end

NS_ASSUME_NONNULL_END
