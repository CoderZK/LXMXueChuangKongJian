//
//  LxmMineNewNavItemView.m
//  mag
//
//  Created by 李晓满 on 2018/11/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMineNewNavItemView.h"
@interface LxmMineNewNavItemView()

@property (nonatomic , strong)UIImageView * lineImgView;

@property (nonatomic , strong)NSMutableArray * btnArr;

@property (nonatomic , strong)NSArray * array;

@end

@implementation LxmMineNewNavItemView

- (instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        _array = titleArr;
        
        _btnArr = [NSMutableArray array];
        for (int i=0; i<titleArr.count; i++)
        {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/titleArr.count*i, 0, frame.size.width/titleArr.count,50)];
            [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
            btn.tag=i;
            [btn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
            [btn setTitleColor:BlueColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font=[UIFont systemFontOfSize:16];
            [self addSubview:btn];
            [_btnArr addObject:btn];
            
            if (btn.tag==0)
            {
                btn.selected = YES;
                self.lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width*0.5-30, frame.size.height-2, 60, 2)];
                self.lineImgView.backgroundColor = BlueColor;
                self.lineImgView.layer.cornerRadius = 1;
                self.lineImgView.layer.masksToBounds = YES;
                [self addSubview:self.lineImgView];
            }
        }
        
    }
    return self;
}
-(void)LxmMineNewNavItemViewWithTag:(NSInteger)btnTag{
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr objectAtIndex:i];
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
    if ([self.delegate respondsToSelector:@selector(LxmMineNewNavItemView:btnAtIndex:)])
    {
        [self.delegate LxmMineNewNavItemView:self btnAtIndex:btn.tag];
    }
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect=self.lineImgView.frame;
            rect.origin.x= btn.tag*btn.frame.size.width+(btn.frame.size.width*0.5-30);
            self.lineImgView.frame=rect;
        }];
    
    for (int i=0; i<_btnArr.count; i++)
    {
        UIButton * btn1 = [_btnArr objectAtIndex:i];
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
