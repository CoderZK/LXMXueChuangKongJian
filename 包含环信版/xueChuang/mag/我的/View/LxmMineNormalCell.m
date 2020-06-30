//
//  LxmMineNormalCell.m
//  mag
//
//  Created by 宋乃银 on 2018/7/7.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMineNormalCell.h"

@interface LxmMineNormalCell()

@property (nonatomic, strong) UIView *topLineView;
@end

@implementation LxmMineNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.topLineView];
    }
    return self;
}

- (void)setShowTopLine:(BOOL)showTopLine {
    _showTopLine = showTopLine;
    self.topLineView.hidden = !_showTopLine;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
        _topLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _topLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _topLineView;
}

@end
