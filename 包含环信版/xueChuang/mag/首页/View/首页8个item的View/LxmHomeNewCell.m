//
//  LxmHomeNewCell.m
//  mag
//
//  Created by 李晓满 on 2018/11/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmHomeNewCell.h"
#import "LxmHomeStateBtn.h"
#import "LxmHeaderImgView.h"
#import "LxmStarImgView.h"

@interface LxmHomeNewCell()

@property (nonatomic, strong) UIView *topLine;//分割线

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
 发布图片模块
 */
@property (nonatomic , strong) UIImageView * contentImgView;

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

@implementation LxmHomeNewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isMine:(BOOL)isMine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.topLine];
        [self addSubview:self.contentImgView];
        
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.headerImgBgBtn];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        
        [self addSubview:self.contentLab];
        
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
        
    }
    return self;
}

- (void)setConstrains {
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@10);
    }];
    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@130);
    }];
    [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView);
        make.leading.equalTo(self.contentImgView.mas_trailing);
        make.trailing.equalTo(self);
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
        make.trailing.lessThanOrEqualTo(self.dianImgView.mas_leading);
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
        make.leading.equalTo(self.contentImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];

    [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentImgView).offset(12);
        make.leading.equalTo(self.contentImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.peopleinfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentImgView).offset(12);
        make.leading.equalTo(self.contentImgView.mas_trailing).offset(15);
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
        make.top.equalTo(self.contentImgView.mas_bottom).offset(15);
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
    //15+130+15+60
    
    //表示当前的Label的内容不想被收缩
    [self.typeLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = BGGrayColor;
    }
    return _topLine;
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
        _typeLab.textAlignment = NSTextAlignmentRight;
    }
    return _typeLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:16];
        _contentLab.numberOfLines = 2;
    }
    return _contentLab;
}

- (UIImageView *)contentImgView {
    if (!_contentImgView) {
        _contentImgView = [[UIImageView alloc] init];
        _contentImgView.image = [UIImage imageNamed:@"whequemoren"];
        _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgView.layer.cornerRadius = 5;
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
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [_stateView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.stateView);
            make.height.equalTo(@1);
        }];
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
    
    if (!model.img||[model.img isEqualToString:@""]) {
        self.contentImgView.image = [UIImage imageNamed:@"whequemoren"];
    }else{
        NSArray * imgs = [model.img componentsSeparatedByString:@","];
        [self.contentImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgs.firstObject]] placeholderImage:[UIImage imageNamed:@"whequemoren"]];
    }
    
    if (model.robList.count == 0) {
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        self.peopleView.items = model.robList;
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
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
    model.height = 10 + 15 + 130 + 15 + 60;
}

- (void)zanClick{
    if ([self.delegate respondsToSelector:@selector(LxmHomeNewCellZanClick:)]) {
        [self.delegate LxmHomeNewCellZanClick:self];
    }
}

- (void)peopleHeadClick{
    if (self.pageToDetail) {
        self.pageToDetail();
    }
}


- (void)headerClick{
    if ([self.delegate respondsToSelector:@selector(headerImgViewClick:)]) {
        [self.delegate headerImgViewClick:self];
    }
}

@end
