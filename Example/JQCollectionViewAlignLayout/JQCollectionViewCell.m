//
//  JQCollectionViewCell.m
//  JQCollectionViewAlignLayout_Example
//
//  Created by ZJQ on 2019/10/25.
//  Copyright © 2019 coder-zjq. All rights reserved.
//

#import "JQCollectionViewCell.h"

@interface JQCollectionViewCell ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation JQCollectionViewCell

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
    [self.contentView layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.contentView.bounds;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:11.f];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
    }
    return _label;
}

@end
