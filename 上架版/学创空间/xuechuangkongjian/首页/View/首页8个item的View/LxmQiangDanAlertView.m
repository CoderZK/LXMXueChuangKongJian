//
//  LxmQiangDanAlertView.m
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmQiangDanAlertView.h"
@interface LxmQiangDanAlertView()<UITextFieldDelegate>
@property (nonatomic , strong) UIView * contentView;
/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UIView * startView;
@property (nonatomic , strong) UIImageView * starImgView1;
@property (nonatomic , strong) UIImageView * starImgView2;
@property (nonatomic , strong) UIImageView * starImgView3;
@property (nonatomic , strong) UIImageView * starImgView4;
@property (nonatomic , strong) UIImageView * starImgView5;

@property (nonatomic , strong) UIImageView * dianImgView;
@property (nonatomic , strong) UILabel * typeLab;
/**
 发布内容模块
 */
@property (nonatomic , strong) UILabel * contentLab;
@property (nonatomic , strong) UIView * lineView;
@property (nonatomic , strong) UILabel * baochouLab;
@property (nonatomic , strong) UILabel * moneyLab;
@property (nonatomic , strong) UILabel * phoneLab;

@property (nonatomic , strong) UIButton * bottomBtn;

@property (nonatomic , assign) CGFloat contentHeight;
@end
@implementation LxmQiangDanAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.bounds.size.height-310)*0.5, ScreenW-60, 260)];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [bgBtn addSubview:self.contentView];
        
        [self.contentView addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.lineView];
        
        [self.contentView addSubview:self.baochouLab];
        [self.contentView addSubview:self.moneyLab];
        [self.contentView addSubview:self.phoneLab];
        [self.contentView addSubview:self.phoneTF];
        [self.contentView addSubview:self.bottomBtn];
        
        self.contentHeight = 280;
        
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.publicInfoView).offset(15);
        make.width.height.equalTo(@30);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
    }];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sexImgView);
        make.bottom.equalTo(self.headerImgView).offset(2);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
    [self.dianImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.width.height.equalTo(@6);
        make.trailing.equalTo(self.typeLab.mas_leading).offset(-3);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.trailing.equalTo(self.contentView).offset(-15);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicInfoView.mas_bottom);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.contentLab);
    }];
    
    [self.baochouLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.equalTo(self.contentLab);
        make.width.equalTo(@100);
        make.height.equalTo(@44);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baochouLab);
        make.trailing.equalTo(self.contentLab);
    }];
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baochouLab.mas_bottom);
        make.leading.equalTo(self.contentLab);
        make.width.equalTo(@100);
        make.height.equalTo(@44);
    }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneLab);
        make.trailing.equalTo(self.contentLab);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    
}

- (UIView *)publicInfoView{
    if (!_publicInfoView) {
        _publicInfoView = [[UIView alloc] init];
    }
    return _publicInfoView;
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 15;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}
- (UIImageView *)sexImgView{
    if (!_sexImgView) {
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.image = [UIImage imageNamed:@"female"];
    }
    return _sexImgView;
}
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.text = @"巴啦啦小魔仙";
        _nameLab.textColor = CharacterDarkColor;
    }
    return _nameLab;
}
- (UIView *)startView{
    if (!_startView) {
        _startView = [[UIView alloc] init];
        for (int i=0; i<5; i++)
        {
            UIImageView *starImg=[[UIImageView alloc] init];
            starImg.frame = CGRectMake(17*i, 0, 15, 15);
            //            starImg.image = [UIImage imageNamed:@"star_1"];
            starImg.image = [UIImage imageNamed:@"star_3"];
            [_startView addSubview:starImg];
            if (i == 0) {
                self.starImgView1 = starImg;
            }else if (i == 1){
                self.starImgView2 = starImg;
            }else if (i == 2){
                self.starImgView3 = starImg;
            }else if (i == 3){
                self.starImgView4 = starImg;
            }else if (i == 4){
                self.starImgView5 = starImg;
            }
        }
        _startView.layer.masksToBounds = YES;
    }
    return _startView;
}
- (UIImageView *)dianImgView{
    if (!_dianImgView) {
        _dianImgView = [[UIImageView alloc] init];
        _dianImgView.backgroundColor = [UIColor colorWithRed:81/255.0 green:224/255.0 blue:245/255.0 alpha:1];
        _dianImgView.layer.cornerRadius = 3;
        _dianImgView.layer.masksToBounds = YES;
    }
    return _dianImgView;
}
- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:15];
        _typeLab.text = @"跑腿";
        _typeLab.textColor = CharacterLightGrayColor;
    }
    return _typeLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont boldSystemFontOfSize:18];
        _contentLab.numberOfLines = 0;
        _contentLab.text = @"北门圆通,收件人冯全,送至2-231,中午前送达哦";
    }
    return _contentLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}

- (UILabel *)baochouLab{
    if (!_baochouLab) {
        _baochouLab = [[UILabel alloc] init];
        _baochouLab.font = [UIFont systemFontOfSize:14];
        _baochouLab.textColor = CharacterDarkColor;
        _baochouLab.text = @"任务报酬";
    }
    return _baochouLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont systemFontOfSize:14];
        _moneyLab.textColor = CharacterDarkColor;
        _moneyLab.text = @"3";
    }
    return _moneyLab;
}
- (UILabel *)phoneLab{
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.font = [UIFont systemFontOfSize:14];
        _phoneLab.textColor = CharacterDarkColor;
        _phoneLab.text = @"联系方式";
    }
    return _phoneLab;
}
- (UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.placeholder = @"选填";
        _phoneTF.delegate = self;
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.font = [UIFont systemFontOfSize:14];
    }
    return _phoneTF;
}
- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"确认报名抢单" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)btnClick{
    if ([self.delegate respondsToSelector:@selector(LxmQiangDanAlertViewBottomClick:)]) {
        [self.delegate LxmQiangDanAlertViewBottomClick:self];
    }
}

-(void)showWithContent:(NSString *)content {
    self.contentLab.text = content;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
-(void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat space = 20;
    _contentView.frame =  CGRectMake(30, height-space-self.contentHeight, ScreenW-60, self.contentHeight);
}
-(void)keyboardWillHide:(NSNotification *)noti {
    _contentView.frame = CGRectMake(30, (self.bounds.size.height-self.contentHeight)*0.5, ScreenW-60, self.contentHeight);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)setModel:(LxmHomeModel *)model{
    _model = model;
    switch (model.relRate.intValue) {
        case 1:
        {
            self.starImgView1.image = [UIImage imageNamed:@"star_3"];
            self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 2:
        {
            self.starImgView1.image = self.starImgView2.image = [UIImage imageNamed:@"star_3"];
            self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 3:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = [UIImage imageNamed:@"star_3"];
            self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 4:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = [UIImage imageNamed:@"star_3"];
            self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        case 5:
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = self.starImgView5.image = [UIImage imageNamed:@"star_3"];
        }
            break;
        default:
            break;
    }
    //60
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.relUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.relSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.relNickname;
    self.typeLab.text = model.typeName;
    self.moneyLab.text = model.money;
}

#pragma mark - UITextFeildDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确"];
        return;
    }
}

@end
