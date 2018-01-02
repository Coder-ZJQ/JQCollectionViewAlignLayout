//
//  AlignmentCollectionHeaderView.m
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2018/1/2.
//  Copyright © 2018年 Joker. All rights reserved.
//

#import "AlignmentCollectionHeaderView.h"
#import "JQCollectionViewAlignLayout.h"

@interface AlignmentCollectionHeaderView ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation AlignmentCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label.frame = self.bounds;
    }
    return self;
}

- (void)setAlignment:(NSInteger)alignment {
    _alignment = alignment;
    switch (alignment) {
        case JQCollectionViewItemAlignmentLeft:
            self.label.text = @"Align Left";
            break;
            
        case JQCollectionViewItemAlignmentCenter:
            self.label.text = @"Align Center";
            break;
            
        case JQCollectionViewItemAlignmentRight:
            self.label.text = @"Align Right";
            break;
            
        case JQCollectionViewItemAlignmentTile:
            self.label.text = @"Tile";
            break;
            
        case JQCollectionViewItemAlignmentFlow:
            self.label.text = @"Flow";
            break;
            
        default:
            break;
    }
}

-(UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16.f];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

@end
