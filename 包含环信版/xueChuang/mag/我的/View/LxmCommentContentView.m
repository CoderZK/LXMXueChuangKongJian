//
//  LxmCommentContentView.m
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmCommentContentView.h"


@interface LxmCommentContentView ()
@property (nonatomic , strong) UIView * contentView;
@property (nonatomic , strong)UIView * starView;
@property (nonatomic , strong) UIImageView * starImgView1;
@property (nonatomic , strong) UIImageView * starImgView2;
@property (nonatomic , strong) UIImageView * starImgView3;
@property (nonatomic , strong) UIImageView * starImgView4;
@property (nonatomic , strong) UIImageView * starImgView5;
@end

@implementation LxmCommentContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.bounds.size.height-250)*0.5, ScreenW-60, 220)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        
        UILabel * textlab = [[UILabel alloc] init];
        textlab.text = @"评价内容";
        textlab.textColor = CharacterDarkColor;
        textlab.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:textlab];
        [textlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.centerX.equalTo(self.contentView);
        }];
        
        self.starView = [[UIView alloc] init];
        [self.contentView addSubview:self.starView];
        [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textlab.mas_bottom).offset(20);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@200);
            make.height.equalTo(@30);
        }];
        for (int i=0; i<5; i++)
        {
            UIImageView *starImg=[[UIImageView alloc] init];
            starImg.frame = CGRectMake(40*i, 0, 30, 30);
            //            starImg.image = [UIImage imageNamed:@"star_1"];
            starImg.image = [UIImage imageNamed:@"star_3"];
            [self.starView addSubview:starImg];
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
        
        self.textView = [[IQTextView alloc] initWithFrame:CGRectMake(50, 90, ScreenW-60-100, 110)];
        self.textView.textColor = CharacterDarkColor;
        self.textView.textAlignment = NSTextAlignmentCenter;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.text = @"成年人每天的饮水量是根据身体的水液代谢情况,根据体重和体表面积决定的";
        [self.contentView addSubview:self.textView];
        
        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-30-30, (self.bounds.size.height-250)*0.5-45, 30, 30)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"cha1"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: closeBtn];
    }
    return self;
}
- (void)setStar:(NSNumber *)star{
    _star = star;
    switch (star.intValue) {
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
}


-(void)show
{
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
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
