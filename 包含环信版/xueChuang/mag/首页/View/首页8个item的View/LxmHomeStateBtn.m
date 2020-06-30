//
//  LxmHomeStateBtn.m
//  mag
//
//  Created by 李晓满 on 2018/7/25.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmHomeStateBtn.h"
@interface LxmHomeStateBtn()
@property (nonatomic , strong) UIImageView * stateMoneyImgView;
@property (nonatomic , strong) UIView * stateMoneyLine;
@end
@implementation LxmHomeStateBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.stateMoneyImgView];
        [self addSubview:self.stateMoneyLab];
        [self addSubview:self.stateMoneyLine];
        [self addSubview:self.stateLab];
        //130*40
        [self setConstrains];
    }
    return self;
}

- (void)setConstrains{
    [self.stateMoneyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(8);
        make.width.height.equalTo(@20);
    }];
     [self.stateMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self);
         make.leading.equalTo(self.stateMoneyImgView.mas_trailing);
         make.trailing.equalTo(self.stateMoneyLine.mas_leading);
    }];
    [self.stateMoneyLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.stateLab.mas_leading).offset(-3);
        make.height.equalTo(@15);
        make.width.equalTo(@0.5);
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.mas_trailing).offset(-8);
    }];
    
}
- (UIImageView *)stateMoneyImgView{
    if (!_stateMoneyImgView) {
        _stateMoneyImgView = [[UIImageView alloc] init];
        _stateMoneyImgView.image = [UIImage imageNamed:@"yuan"];
    }
    return _stateMoneyImgView;
}
- (UILabel *)stateMoneyLab{
    if (!_stateMoneyLab) {
        _stateMoneyLab = [[UILabel alloc] init];
        _stateMoneyLab.font = [UIFont systemFontOfSize:15];
        _stateMoneyLab.textColor = UIColor.whiteColor;
        _stateMoneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _stateMoneyLab;
}
- (UIView *)stateMoneyLine{
    if (!_stateMoneyLine) {
        _stateMoneyLine = [[UIView alloc] init];
        _stateMoneyLine.backgroundColor = UIColor.whiteColor;
    }
    return _stateMoneyLine;
}
- (UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.font = [UIFont systemFontOfSize:15];
        _stateLab.textColor = UIColor.whiteColor;
        _stateLab.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLab;
}


@end
