//
//  LxmCanListImgCell.m
//  mag
//
//  Created by 李晓满 on 2018/8/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmCanListImgCell.h"
@interface LxmCanListImgCell()
@property (nonatomic , strong) UIImageView * imgView;
@end
@implementation LxmCanListImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.layer.masksToBounds = YES;
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}
- (void)setImgStr:(NSString *)imgStr{
    _imgStr = imgStr;
    if ([imgStr containsString:@"|"]) {
        NSArray * arr = [imgStr componentsSeparatedByString:@"|"];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:arr[0]]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
        if (arr.count == 3) {
            NSString * w = arr[1];
            NSString * h = arr[2];
            CGFloat height  = ((ScreenW - 30)*h.intValue)/(w.intValue);
            [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
        }else{
            [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(200));
            }];
        }
    }else{
         [self.imgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgStr]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(200));
        }];
    }
}

@end
