//
//  LxmMineNavItemView.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMineNavItemView.h"
@interface LxmMineNavItemView()
@property (nonatomic , strong)UIImageView * lineImgView;
@property (nonatomic , strong)NSMutableArray * btnArr;
@property (nonatomic , strong)NSArray * array;
@end

@implementation LxmMineNavItemView

- (instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.borderColor = BlueColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.whiteColor;
        _array = titleArr;
        
        _btnArr = [NSMutableArray array];
        for (int i=0; i<titleArr.count; i++)
        {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/titleArr.count*i, 0, frame.size.width/titleArr.count,30)];
            [btn setTitle:[titleArr lxm_object1AtIndex:i] forState:UIControlStateNormal];
            btn.tag=i;
            [btn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
            [btn setTitleColor:BlueColor forState:UIControlStateSelected];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font=[UIFont systemFontOfSize:16];
            [self addSubview:btn];
            [_btnArr lxm_add1Object:btn];
            
            if (btn.tag==0)
            {
                btn.selected = YES;
//                self.lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width*0.5-30, frame.size.height-2, 60, 2)];
//                self.lineImgView.image = [UIImage imageNamed:@"lineBg"];
//                [self addSubview:self.lineImgView];
            }
        }
        
    }
    return self;
}
-(void)LxmMineNavItemViewWithTag:(NSInteger)btnTag{
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr lxm_object1AtIndex:i];
        if (btn1.tag == btnTag)
        {
            btn1.selected = YES;
//            [UIView animateWithDuration:0.3 animations:^{
//                CGRect rect=self.lineImgView.frame;
//                rect.origin.x= btn1.tag*btn1.frame.size.width+(btn1.frame.size.width*0.5-30);
//                self.lineImgView.frame=rect;
//            }];
            
        }
        else
        {
            btn1.selected = NO;
        }
    }
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(LxmMineNavItemView:btnAtIndex:)])
    {
        [self.delegate LxmMineNavItemView:self btnAtIndex:btn.tag];
    }
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect rect=self.lineImgView.frame;
//        rect.origin.x= btn.tag*btn.frame.size.width+(btn.frame.size.width*0.5-30);
//        self.lineImgView.frame=rect;
//    }];
    
    for (int i=0; i<_btnArr.count; i++) {
        
        UIButton * btn1 = [_btnArr lxm_object1AtIndex:i];
        btn1.selected = btn1==btn;
    }
}

@end

