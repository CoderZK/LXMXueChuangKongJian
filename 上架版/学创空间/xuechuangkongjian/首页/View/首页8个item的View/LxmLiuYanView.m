//
//  LxmLiuYanView.m
//  mag
//
//  Created by 李晓满 on 2018/7/11.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmLiuYanView.h"

@implementation LxmLiuYanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenW-30, 0.5)];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
        UIImageView * imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"blue"];
        [self addSubview:imgView];
        
        self.liuYanLab = [[UILabel alloc] init];
        self.liuYanLab.font = [UIFont boldSystemFontOfSize:15];
        self.liuYanLab.textColor = CharacterDarkColor;
        [self addSubview:self.liuYanLab];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.height.equalTo(@25);
            make.width.equalTo(@3);
        }];
        [self.liuYanLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(imgView.mas_trailing).offset(10);
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
        }];
    }
    return self;
}


@end
