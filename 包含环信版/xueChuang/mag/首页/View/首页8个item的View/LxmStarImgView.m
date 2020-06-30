//
//  LxmStarImgView.m
//  mag
//
//  Created by 李晓满 on 2018/7/28.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmStarImgView.h"
@interface LxmStarImgView()
@property (nonatomic , strong) UIImageView * starImgView1;
@property (nonatomic , strong) UIImageView * starImgView2;
@property (nonatomic , strong) UIImageView * starImgView3;
@property (nonatomic , strong) UIImageView * starImgView4;
@property (nonatomic , strong) UIImageView * starImgView5;
@end
@implementation LxmStarImgView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i=0; i<5; i++)
        {
            UIImageView *starImg=[[UIImageView alloc] init];
            starImg.frame = CGRectMake(17*i, 0, 15, 15);
            starImg.image = [UIImage imageNamed:@"star_4"];
            [self addSubview:starImg];
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
    }
    return self;
}
- (void)setStarNum:(NSInteger)starNum{
    _starNum = starNum;
    switch (starNum) {
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
        case 0 :
        {
            self.starImgView1.image = self.starImgView2.image = self.starImgView3.image = self.starImgView4.image = [UIImage imageNamed:@"star_3"];
            self.starImgView5.image = [UIImage imageNamed:@"star_4"];
        }
            break;
        default:
            break;
    }
}


@end
