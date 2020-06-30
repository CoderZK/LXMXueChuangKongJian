//
//  LxmPingJiaCell.m
//  mag
//
//  Created by 李晓满 on 2018/7/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPingJiaCell.h"
#import "LxmStarImgView.h"
#import "LxmImgCollectionView.h"
@interface LxmPingJiaCell()
/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;
@property (nonatomic , strong) UILabel * timeLab;
/**
 发布内容模块
 */
@property (nonatomic , strong) UILabel * contentLab;
/**
 图片内容模块
 */
@property (nonatomic , strong) LxmImgCollectionView * contentImgView;


@end

@implementation LxmPingJiaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.timeLab];
        
        [self addSubview:self.contentLab];
        
        [self addSubview:self.contentImgView];
       
        
        [self setConstrains];
        
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
    }
    return self;
}
- (void)setConstrains{
    [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
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
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.trailing.equalTo(self.publicInfoView).offset(-15);
        make.leading.equalTo(self.nameLab.mas_trailing);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicInfoView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        
    }];
    
    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@((ScreenW-30-20)/3));
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
- (LxmStarImgView *)startView{
    if (!_startView) {
        _startView = [[LxmStarImgView alloc] init];
    }
    return _startView;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.text = @"2018-02-21";
        _timeLab.textColor = CharacterLightGrayColor;
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
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

- (LxmImgCollectionView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[LxmImgCollectionView alloc] init];
    }
    return _contentImgView;
}

- (void)setModel:(LxmAroundCommentModel *)model{
    _model = model;
    self.startView.starNum = model.goodRate.intValue;
    //60
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.userHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.sex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.nickname;
    NSString * timeStr = @"";
    if (model.createTime.length>19) {
        timeStr = [model.createTime substringToIndex:model.createTime.length-9];
    }else{
        timeStr = model.createTime;
    }
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    self.timeLab.text = timeStr;
    
    self.contentLab.text = model.content;
    CGFloat connectHeight = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW-30, 999) withFontSize:18].height+10;
    
    
    CGFloat imgViewHeight = 0;
    if (!model.img||[model.img isEqualToString:@""]) {
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        imgViewHeight = 0;
    }else{
        NSArray * imgs = [model.img componentsSeparatedByString:@","];
        if (imgs.count>3) {
            NSMutableArray * tempArr = [NSMutableArray arrayWithArray:imgs];
            self.contentImgView.titleArr = [tempArr subarrayWithRange:NSMakeRange(0, 3)];
        }else{
            self.contentImgView.titleArr = imgs;
        }
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@((ScreenW-30-20)/3));
        }];
        imgViewHeight = (ScreenW-30-20)/3;
    }
    model.height = 60+connectHeight+10+imgViewHeight+15;
}

@end
