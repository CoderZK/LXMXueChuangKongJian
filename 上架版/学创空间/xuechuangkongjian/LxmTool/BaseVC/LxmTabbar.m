//
//  LxmTabbar.m
//  mag
//
//  Created by 李晓满 on 2018/10/8.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTabbar.h"

@implementation LxmTabbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //自定义按钮
        self.centerButton = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - 84*0.88)/2, -35, 84*0.88, 76*0.88)];
        self.centerButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.centerButton setImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
        [self addSubview:self.centerButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.centerButton];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        if (CGRectContainsPoint(self.centerButton.frame, point) && !self.isHidden) {
            return self.centerButton;
        } else {
            return nil;
        }
    }
    return view;
}

@end
