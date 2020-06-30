//
//  AdScrollViewItem.m
//  testAdScroolView
//
//  Created by lxm on 15/7/6.
//  Copyright (c) 2015年 lxm. All rights reserved.
//

#import "SNY_AdScrollViewItem.h"
#import "UIImageView+WebCache.h"
@interface SNY_AdScrollViewItem ()
{
    UIImageView * _imgView;
}
@end

@implementation SNY_AdScrollViewItem
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self initImgView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        [self initImgView];
    }
    return self;
}
-(instancetype)init
{
    if (self=[super init])
    {
        [self initImgView];
    }
    return self;
}
-(void)initImgView
{
    if (!_imgView)
    {
        _imgView=[[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.userInteractionEnabled = NO;
        _imgView.contentMode = UIViewContentModeScaleToFill;
        _imgView.layer.cornerRadius = 10;
        _imgView.layer.masksToBounds = YES;
        _imgView.image=[UIImage imageNamed:@"bannermoren.jpg"];
        [self addSubview:_imgView];
    }
}
-(void)setImg:(id)img
{
    _img=img;
    if ([_img isKindOfClass:[UIImage class]])
    {
        _imgView.image=img;
    }
    else if ([_img isKindOfClass:[NSURL class]])
    {
         [_imgView sd_setImageWithURL:_img placeholderImage:[UIImage imageNamed:@"bannermoren"]];
    }
    else if ([_img isKindOfClass:[NSString class]])
    {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_img] placeholderImage:[UIImage imageNamed:@"bannermoren"]];
    }
    else
    {
        NSAssert(0, @"AdScrollViewItem-------数据类型不对");
    }
}
@end
