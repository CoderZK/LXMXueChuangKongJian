//
//  LxmHomeCell.m
//  mag
//
//  Created by 李晓满 on 2018/7/4.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmHomeCell.h"
#import "LxmHomeStateBtn.h"
#import "LxmImgCollectionView.h"
#import "LxmHeaderImgView.h"
#import "LxmStarImgView.h"

@interface LxmHomeCell()<LxmImgCollectionViewDelegate>

/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIButton * headerImgBgBtn;

@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;


@property (nonatomic , strong) UIImageView * dianImgView;
@property (nonatomic , strong) UILabel * typeLab;

/**
 发布内容模块
 */
@property (nonatomic , strong) UILabel * contentLab;

/**
 图片内容模块
 */
@property (nonatomic , strong) LxmImgCollectionView * contentImgView;

/**
 抢单人信息模块
 */
@property (nonatomic , strong) LxmHeaderImgView * peopleView;
@property (nonatomic , strong) UIButton * peopleinfoBtn;
@property (nonatomic , strong) UIImageView * sexImgView1;
@property (nonatomic , strong) UILabel * nameLab1;
@property (nonatomic , strong) UILabel * totalLab;


/**
 订单状态模块
 */
@property (nonatomic , strong) UIView * stateView;
@property (nonatomic , strong) UIButton * dianzanBtn;
@property (nonatomic , strong) LxmHomeStateBtn * stateBtn;

@end

@implementation LxmHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isMine:(BOOL)isMine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.headerImgBgBtn];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        
        [self addSubview:self.contentLab];
        
        [self addSubview:self.contentImgView];
        
        [self addSubview:self.peopleView];
        [self.peopleView addSubview:self.sexImgView1];
        [self.peopleView addSubview:self.nameLab1];
        [self.peopleView addSubview:self.totalLab];
        [self.peopleView addSubview:self.peopleinfoBtn];
        
        [self addSubview:self.stateView];
        [self.stateView addSubview:self.dianzanBtn];
        [self.stateView addSubview:self.commentBtn];
        [self.stateView addSubview:self.stateBtn];
        
        [self setConstrains];
        
        
        UIView * line = [[UIView alloc] init];
        if (isMine) {
            line.backgroundColor = BGGrayColor;
        }else{
            line.backgroundColor = LineColor;
        }
        
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        __weak typeof(self)safe_self = self;
        self.contentImgView.selectItemBlock = ^(NSInteger index) {
            if (safe_self.selectImgBlock) {
                safe_self.selectImgBlock(index);
            }
        };
        
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
    [self.headerImgBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.publicInfoView);
        make.width.equalTo(@50);
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
        make.trailing.equalTo(self.publicInfoView).offset(-15);
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
    [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.peopleinfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    
    [self.sexImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.peopleView);
        make.leading.equalTo(self.peopleView).offset(35);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.peopleView);
        make.leading.equalTo(self.sexImgView1.mas_trailing).offset(3);
    }];
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.equalTo(self.peopleView);
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.peopleView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@60);
    }];
    
    [self.dianzanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self.stateView);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dianzanBtn.mas_trailing).offset(10);
        make.centerY.equalTo(self.stateView);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.equalTo(self.stateView);
        make.height.equalTo(@40);
        make.width.equalTo(@130);
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
- (UIButton *)headerImgBgBtn{
    if (!_headerImgBgBtn) {
        _headerImgBgBtn = [[UIButton alloc] init];
        [_headerImgBgBtn addTarget:self action:@selector(headerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerImgBgBtn;
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

- (LxmImgCollectionView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[LxmImgCollectionView alloc] init];
        _contentImgView.delegate = self;
        _contentImgView.layer.masksToBounds = YES;
    }
    return _contentImgView;
}

- (LxmHeaderImgView *)peopleView{
    if (!_peopleView) {
        _peopleView = [[LxmHeaderImgView alloc] init];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW - 30, 0.5)];
        line.backgroundColor = LineColor;
        [_peopleView addSubview:line];
        _peopleView.layer.masksToBounds = YES;
    }
    return _peopleView;
}

- (UIButton *)peopleinfoBtn{
    if (!_peopleinfoBtn) {
        _peopleinfoBtn = [[UIButton alloc] init];
        [_peopleinfoBtn addTarget:self action:@selector(peopleHeadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _peopleinfoBtn;
}

- (UIImageView *)sexImgView1{
    if (!_sexImgView1) {
        _sexImgView1 = [[UIImageView alloc] init];
        _sexImgView1.image = [UIImage imageNamed:@"female"];
    }
    return _sexImgView1;
}
- (UILabel *)nameLab1{
    if (!_nameLab1) {
        _nameLab1 = [[UILabel alloc] init];
        _nameLab1.font = [UIFont systemFontOfSize:15];
        _nameLab1.text = @"巴啦啦小魔仙 等3人";
        _nameLab1.textColor = CharacterDarkColor;
    }
    return _nameLab1;
}

- (UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [[UILabel alloc] init];
        _totalLab.font = [UIFont systemFontOfSize:13];
        _totalLab.textColor = CharacterLightGrayColor;
        _totalLab.text = @"5人已抢单";
    }
    return _totalLab;
}

- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
    }
    return _stateView;
}


- (UIButton *)dianzanBtn{
    if (!_dianzanBtn) {
        _dianzanBtn = [[UIButton alloc] init];
        [_dianzanBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_dianzanBtn setTitle:@"11" forState:UIControlStateNormal];
        [_dianzanBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _dianzanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _dianzanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_dianzanBtn addTarget:self action:@selector(zanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianzanBtn;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"8" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _commentBtn.userInteractionEnabled = NO;
    }
    return _commentBtn;
}

- (LxmHomeStateBtn *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [[LxmHomeStateBtn alloc] init];
        [_stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        _stateBtn.userInteractionEnabled = NO;
        _stateBtn.layer.cornerRadius = 5;
        _stateBtn.layer.masksToBounds = YES;
    }
    return _stateBtn;
}

- (void)setModel:(LxmHomeModel *)model{
    _model = model;
    self.startView.starNum = model.relRate.intValue;
    //60
    if (model.isAnonymity.intValue == 1) {
        //匿名
        self.headerImgView.image = [UIImage imageNamed:@"niming"];
        self.sexImgView.image = [UIImage imageNamed:@"female"];
        self.nameLab.text = @"匿名";
    }else{
        //显示名字
        [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.relUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
        self.sexImgView.image = [UIImage imageNamed:model.relSex.intValue == 1?@"male":@"female"];
        self.nameLab.text = model.relNickname;
    }
    
    self.typeLab.text = model.typeName;
    
    self.contentLab.text = model.content;
    CGFloat connectHeight = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW-30, 999) withFontSize:18].height+10;
    if (model.isDetail) {
        connectHeight = connectHeight;
    }else{
        connectHeight = (connectHeight>54?54:connectHeight);
    }
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(connectHeight));
    }];
    
    CGFloat imgViewHeight = 0;
    if (!model.img||[model.img isEqualToString:@""]) {
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        imgViewHeight = 0;
    }else{
        NSArray * imgs = [model.img componentsSeparatedByString:@","];
        if (model.isDetail) {
            self.contentImgView.titleArr = imgs;
            [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(ceil(imgs.count/3.0)*(((ScreenW-30-20)/3)+10)-10));
            }];
            imgViewHeight = ceil(imgs.count/3.0)*(((ScreenW-30-20)/3)+10)-10;
        }else{
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
    }
    
    CGFloat peopleHeight = 0;
    
    if (model.robList.count == 0) {
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        self.nameLab1.hidden = YES;
        self.sexImgView1.hidden = YES;
        self.peopleView.items = model.robList;
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        peopleHeight = 50;
    }
    self.stateBtn.stateMoneyLab.text = model.money;
    if (model.state.intValue == 1||model.state.intValue == 2) {
        self.stateBtn.stateLab.text = model.state.intValue == 1?@"进行中":@"完成中";
        
        if (model.pageType == 1||model.pageType == 2) {
            self.sexImgView1.hidden = YES;
            self.nameLab1.hidden = YES;
        }
    }else{
        self.stateBtn.stateLab.text = @"已完成";
        if (model.pageType == 1||model.pageType == 2) {
            self.sexImgView1.hidden = YES;
            self.nameLab1.hidden = YES;
        }
    }
    
    [self.dianzanBtn setTitle:[NSString stringWithFormat:@"%@ ",model.likeNum.intValue > 100 ? @"100+" : [NSString stringWithFormat:@"%d",model.likeNum.intValue] ] forState:UIControlStateNormal];
    
    [self.dianzanBtn setImage:[UIImage imageNamed:model.likeStatus.intValue == 1?@"like":@"dislike"] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@ ",model.commentNum.intValue > 100 ? @"100+" : [NSString stringWithFormat:@"%d",model.commentNum.intValue]] forState:UIControlStateNormal];
    self.totalLab.text = [NSString stringWithFormat:@"%d人已抢单",model.robNum.intValue];
    [self layoutIfNeeded];
    model.height = 60+connectHeight+imgViewHeight+peopleHeight+60+10;
}

- (void)zanClick{
    if ([self.delegate respondsToSelector:@selector(LxmHomeCellZanClick:)]) {
        [self.delegate LxmHomeCellZanClick:self];
    }
}
- (void)LxmImgCollectionViewClick{
    if ([self.delegate respondsToSelector:@selector(imgCollectionClick:)]) {
        [self.delegate imgCollectionClick:self];
    }
}

- (void)peopleHeadClick{
    if ([self.delegate respondsToSelector:@selector(imgCollectionClick:)]) {
        [self.delegate imgCollectionClick:self];
    }
}


- (void)headerClick{
    if ([self.delegate respondsToSelector:@selector(headerImgViewClick:)]) {
        [self.delegate headerImgViewClick:self];
    }
}


@end






