//
//  LxmSureSelectPeopleAlertView.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSureSelectPeopleAlertView.h"
@interface LxmSureSelectPeopleAlertView()
@property (nonatomic , strong) UIView * contentView;
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UILabel * namesLab;
@property (nonatomic , strong) UIView * lineView;
@property (nonatomic , strong) UIButton * cancelBtn;
@property (nonatomic , strong) UIButton * nextBtn;
@end
@implementation LxmSureSelectPeopleAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.bounds.size.height-200)*0.5, ScreenW-60, 200)];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [bgBtn addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.namesLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.cancelBtn];
        [self.contentView addSubview:self.nextBtn];
        [self setConstraints];
    }
    return self;
}
- (void)setConstraints{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(40);
        make.centerX.equalTo(self.contentView);
    }];
    [self.namesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(5);
        make.trailing.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-50);
        make.height.equalTo(@0.5);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self.contentView);
        make.trailing.equalTo(self.nextBtn.mas_leading);
        make.height.equalTo(@50);
        make.width.equalTo(self.nextBtn);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    
}


- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.text = @"确认选择";
    }
    return _titleLab;
}
- (UILabel *)namesLab{
    if (!_namesLab) {
        _namesLab = [[UILabel alloc] init];
        _namesLab.font = [UIFont systemFontOfSize:18];
        _namesLab.numberOfLines = 0;
        _namesLab.textColor = BlueColor;
        _namesLab.textAlignment = NSTextAlignmentCenter;
    }
    return _namesLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)next{
    if ([self.delegate respondsToSelector:@selector(LxmSureSelectPeopleAlertViewNext:)]) {
        [self.delegate LxmSureSelectPeopleAlertViewNext:self];
    }
}

- (void)btnClick{
    [self dismiss];
}

-(void)showWithContent:(NSString *)content
{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
    self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:content];
    [att addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:NSMakeRange(content.length-1, 1)];
    self.namesLab.attributedText = att;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
-(void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

@end
