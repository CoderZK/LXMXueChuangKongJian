//
//  LxmMyPageHeaderView.m
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyPageHeaderView.h"
@interface LxmMyPageHeaderView()
@property (nonatomic , strong)UIImageView * lineImgView;
@property (nonatomic , strong)NSMutableArray * btnArr;
@property (nonatomic , strong)NSArray * array;
@end
@implementation LxmMyPageHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withTitleArr:(NSArray *)titleArr{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.lineImgView = [[UIImageView alloc] init];
        [self addSubview:self.lineImgView];
        [self.lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        _array = titleArr;
        
        _btnArr = [NSMutableArray array];
        for (int i=0; i<titleArr.count; i++)
        {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(ScreenW/titleArr.count*i, 0, ScreenW/titleArr.count,50)];
            [btn setTitle:[titleArr lxm_object1AtIndex:i] forState:UIControlStateNormal];
            btn.tag=i;
            [btn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
            [btn setTitleColor:BlueColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font=[UIFont systemFontOfSize:16];
            [self addSubview:btn];
            [_btnArr lxm_add1Object:btn];
            
            if (btn.tag==0)
            {
                btn.selected = YES;
                self.lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width*0.5-30, 50-1.5, 60, 2)];
                self.lineImgView.backgroundColor = BlueColor;
                self.lineImgView.layer.cornerRadius = 1;
                self.lineImgView.layer.masksToBounds = YES;
                [self addSubview:self.lineImgView];
            }
        }
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@10);
        }];
        
    }
    return self;
}
-(void)lxmMyPageHeaderViewWithTag:(NSInteger)btnTag{
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr lxm_object1AtIndex:i];
        if (btn1.tag == btnTag)
        {
            btn1.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect=self.lineImgView.frame;
                rect.origin.x= btn1.tag*btn1.frame.size.width+(btn1.frame.size.width*0.5-30);
                self.lineImgView.frame=rect;
            }];
            
        }
        else
        {
            btn1.selected = NO;
        }
    }
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(lxmMyPageHeaderView:btnAtIndex:)])
    {
        [self.delegate lxmMyPageHeaderView:self btnAtIndex:btn.tag];
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=self.lineImgView.frame;
        rect.origin.x= btn.tag*btn.frame.size.width+(btn.frame.size.width*0.5-30);
        self.lineImgView.frame=rect;
    }];
    
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr lxm_object1AtIndex:i];
        if (btn1==btn)
        {
            btn1.selected = YES;
        }
        else
        {
            btn1.selected = NO;
        }
    }
}
@end
