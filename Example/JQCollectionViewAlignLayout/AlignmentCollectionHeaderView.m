//
//  AlignmentCollectionHeaderView.m
//  JQCollectionViewAlignLayout-Demo
//
//  Created by Joker on 2018/1/2.
//  Copyright © 2018年 Joker. All rights reserved.
//

#import "AlignmentCollectionHeaderView.h"
#import "JQCollectionViewAlignLayout.h"

@implementation AlignmentCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:.9f alpha:1.f];
        self.label.frame = self.bounds;
    }
    return self;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16.f];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

@end
