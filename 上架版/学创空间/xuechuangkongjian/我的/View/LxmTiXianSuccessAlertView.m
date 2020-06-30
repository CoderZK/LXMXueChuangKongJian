//
//  LxmTiXianSuccessAlertView.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTiXianSuccessAlertView.h"
@interface LxmTiXianSuccessAlertView()
@property (nonatomic , strong) UIView * contentView;
@property (nonatomic , strong) UIImageView * iconImgView;
@property (nonatomic , strong) UILabel * textLab;
@end
@implementation LxmTiXianSuccessAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(40, (self.bounds.size.height-150)*0.5, ScreenW-80, 150)];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [bgBtn addSubview:self.contentView];
        
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.textLab];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(40);
            make.width.height.equalTo(@40);
            make.centerX.equalTo(self.contentView);
        }];
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-40);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"tijiao"];
    }
    return _iconImgView;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [UIFont systemFontOfSize:15];
        _textLab.text = @"提现申请已提交";
        _textLab.textColor = CharacterDarkColor;
    }
    return _textLab;
}

-(void)show{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
