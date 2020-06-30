//
//  LxmTextTFView.m
//  recordnote
//
//  Created by 李晓满 on 2018/1/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTextTFView.h"
@interface LxmTextTFView()
@property (nonatomic,strong) UIView * lineView;
@end
@implementation LxmTextTFView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textlab];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self addSubview:self.rightImgView];
        [self.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-40);
            make.leading.equalTo(self.textlab.mas_trailing);
            make.centerY.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
            
        }];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}
- (UILabel *)textlab{
    if (!_textlab) {
        _textlab = [[UILabel alloc] init];
        _textlab.font = [UIFont systemFontOfSize:15];
        _textlab.textColor = CharacterDarkColor;
    }return _textlab;
}
- (UITextField *)rightTF{
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.font = [UIFont systemFontOfSize:15];
        _rightTF.textAlignment = NSTextAlignmentRight;
    }return _rightTF;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }return _lineView;
}
- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.image = [UIImage imageNamed:@"cellrow"];
    }
    return _rightImgView;
}
@end
