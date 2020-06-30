//
//  LxmMyFaDanCell.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyFaDanCell.h"
#import "LxmImgCollectionView.h"
#import "LxmHomeStateBtn.h"
#import "LxmHeaderImgView.h"

@interface LxmMyFaDanCell()<LxmImgCollectionViewDelegate>
/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UILabel * orderInfolab;

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
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UILabel * totalLab;
@property (nonatomic , strong) UIButton * peopleinfoBtn;


/**
 订单状态模块
 */
@property (nonatomic , strong) UIView * stateView;

@property (nonatomic , strong) LxmHomeStateBtn * stateBtn;
@property (nonatomic , strong) UIButton * cancelBtn;
@property (nonatomic , strong) UIButton * selectBtn;

@end

@implementation LxmMyFaDanCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.orderInfolab];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        
        [self addSubview:self.contentLab];
        [self addSubview:self.contentImgView];
      
        [self addSubview:self.peopleView];
        [self addSubview:self.totalLab];
        [self.peopleView addSubview:self.peopleinfoBtn];
        
        [self addSubview:self.stateView];
        [self.stateView addSubview:self.nameLab];
        [self.stateView addSubview:self.sexImgView];
        [self.stateView addSubview:self.stateBtn];
        [self.stateView addSubview:self.cancelBtn];
        [self.stateView addSubview:self.selectBtn];
        
        [self setConstrains];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        UIView * centerline = [UIView new];
        centerline.backgroundColor = LineColor;
        [self addSubview:centerline];
        [centerline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-60);
            make.height.mas_equalTo(0.5);
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

    [self.orderInfolab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.leading.equalTo(self.publicInfoView).offset(15);
        make.trailing.equalTo(self.dianImgView.mas_trailing);
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
        make.top.equalTo(self.contentImgView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(210);
        make.height.equalTo(@50);
    }];
    
    
    [self.peopleinfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.peopleView);
        make.left.equalTo(self.peopleView.mas_right).offset(35);
        make.width.height.equalTo(@15);
        make.width.mas_equalTo(0);
    }];
    
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.peopleView);
        make.right.mas_equalTo(-15);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.peopleView);
        make.left.equalTo(self.peopleView.mas_right);
        make.right.equalTo(self.totalLab.mas_left);
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.peopleView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@60);
    }];
    
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.leading.equalTo(self.stateView);
        make.width.equalTo(self.selectBtn);
        make.height.equalTo(@40);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.leading.equalTo(self.stateBtn.mas_trailing).offset(15);
        make.width.equalTo(self.selectBtn);
        make.height.equalTo(@40);
        
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.leading.equalTo(self.cancelBtn.mas_trailing).offset(15);
        make.trailing.equalTo(self.stateView);
        make.width.equalTo(self.cancelBtn);
        make.height.equalTo(@40);
    }];
    
}

- (UIView *)publicInfoView{
    if (!_publicInfoView) {
        _publicInfoView = [[UIView alloc] init];
    }
    return _publicInfoView;
}

- (UILabel *)orderInfolab{
    if (!_orderInfolab) {
        _orderInfolab = [[UILabel alloc] init];
        _orderInfolab.font = [UIFont systemFontOfSize:15];
        _orderInfolab.text = @"订单编号:43070215545";
        _orderInfolab.textColor = CharacterGrayColor;
    }
    return _orderInfolab;
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
        [_peopleView addSubview:self.sexImgView];
        [_peopleView addSubview:self.nameLab];
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


- (UIImageView *)sexImgView{
    if (!_sexImgView) {
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.image = [UIImage imageNamed:@"female"];
        _sexImgView.hidden = YES;
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


- (UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [[UILabel alloc] init];
        _totalLab.font = [UIFont systemFontOfSize:13];
        _totalLab.textColor = CharacterLightGrayColor;
        _totalLab.text = @"0人已抢单";
    }
    return _totalLab;
}

- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
    }
    return _stateView;
}
- (LxmHomeStateBtn *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [[LxmHomeStateBtn alloc] init];
        [_stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        _stateBtn.layer.cornerRadius = 5;
        _stateBtn.layer.masksToBounds = YES;
        _stateBtn.tag = 15;
        [_stateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"deletepic"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.layer.cornerRadius = 8;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.tag = 16;
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_selectBtn setTitle:@"选择抢单人" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _selectBtn.layer.cornerRadius = 8;
        _selectBtn.layer.masksToBounds = YES;
        _selectBtn.tag = 17;
        [_selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(lxmMyFaDanCell:btnAtIndex:)]) {
        [self.delegate lxmMyFaDanCell:self btnAtIndex:btn.tag];
    }
}

- (void)setModel:(LxmHomeModel *)model{
    _model = model;
    self.orderInfolab.text = [NSString stringWithFormat:@"订单编号:  %@",model.orderNo];
    self.typeLab.text = model.typeName;
    self.contentLab.text = model.content;
    
    CGFloat peopleHeight = 0;
    if (model.robList.count == 0) {
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        self.sexImgView.hidden = self.nameLab.hidden = YES;
        self.totalLab.hidden = YES;
    }else{
        self.totalLab.hidden = NO;
        self.sexImgView.hidden = self.nameLab.hidden = NO;
        self.peopleView.items = model.robList;
        LxmHeadImgModel * headerModel = model.robList.firstObject;
        self.sexImgView.image = [UIImage imageNamed:headerModel.robUserSex.intValue == 1?@"male":@"female"];
        if (model.robList.count == 1) {
            self.nameLab.text = headerModel.robUserName;
        }else{
            self.nameLab.text = [NSString stringWithFormat:@"%@ 等%ld人",headerModel.robUserName,model.robList.count];
        }
        CGFloat peopleViewWidth = model.robList.count * 35;
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.width.mas_equalTo(peopleViewWidth);
        }];
        peopleHeight = 50;
        
        if (model.state.intValue == 1) {
            self.totalLab.text = [NSString stringWithFormat:@"%d人已抢单",model.robNum.intValue];
        }else if (model.state.intValue == 2){
            self.totalLab.text = @"完成中";
        }else{
            self.totalLab.text = @"已完成";
        }
    }
    
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
    self.stateBtn.stateMoneyLab.text = model.money;
    if (model.state.intValue == 1) {
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        self.cancelBtn.hidden = NO;
        self.stateBtn.stateLab.text = @"进行中";
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self.selectBtn setTitle:@"选择抢单人" forState:UIControlStateNormal];
        
    }else if (model.state.intValue == 2){
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        self.cancelBtn.hidden = YES;
        self.stateBtn.stateLab.text = @"完成中";
        [self.selectBtn setTitle:@"已完成" forState:UIControlStateNormal];
        
    }else if (model.state.intValue == 3){
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        self.cancelBtn.hidden = YES;
        self.stateBtn.stateLab.text = @"已完成";
        [self.selectBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
    
    CGFloat connectHeight = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW-30, 999) withFontSize:18].height;
    model.height = 60+connectHeight+10+imgViewHeight+10+peopleHeight+60;
}


- (void)LxmImgCollectionViewClick{
    if ([self.delegate respondsToSelector:@selector(imgCollectionClick:)]) {
        [self.delegate imgCollectionClick:self];
    }
}

//完成中 跳转承接人列表
- (void)peopleHeadClick{
    if ([self.delegate respondsToSelector:@selector(peopleFinishDanClick:)]) {
        [self.delegate peopleFinishDanClick:self];
    }
}


@end
