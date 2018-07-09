//
//  MultilevelMenuCell.m
//  MultilevelMenuDemo
//
//  Created by YZY on 2018/7/6.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

#import "MultilevelMenuCell.h"

@interface MultilevelMenuCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MultilevelMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        [self loadSubview];
    }
    return self;
}

- (void)loadSubview {
    [self.contentView addSubview: self.titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    self.titleLabel.attributedText = attributedTitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame: UIEdgeInsetsInsetRect(self.contentView.bounds, UIEdgeInsetsMake(0, 20, 0, 0))];
    }
    return _titleLabel;
}

@end
