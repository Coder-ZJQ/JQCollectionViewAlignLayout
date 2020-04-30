//
//  CollectionViewItem.m
//  AlignCollectionview
//
//  Created by ZJQ on 2020/4/29.
//  Copyright © 2020 www.sunnada.com. All rights reserved.
//

#import "CollectionViewItem.h"
#import "JQSectionModel.h"

@interface CollectionViewItem ()
@property (weak) IBOutlet NSTextField *label;

@end

@implementation CollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
}

- (void)setModel:(JQSectionItemModel *)model {
    _model = model;
    if (self.isViewLoaded) {
        self.label.stringValue = [NSString stringWithFormat:@"%zd", model.index];
        self.view.layer.backgroundColor = model.color.CGColor;
    }
}
@end
