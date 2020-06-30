//
//  BaoMingVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/11.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaoMingVC.h"
#import "IQKeyboardManagerConstants.h"
#import "PayVC.h"

@interface BaoMingVC ()<UITextFieldDelegate>
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong) UIView * footerView;
@property (nonatomic , strong) LxmTextTFView1 * nameView;
@property (nonatomic , strong) LxmTextTFView1 * phoneView;
@property (nonatomic , strong) LxmTextTFView1 * numView;
@property (nonatomic , strong) LxmTextTFView1 * noteView;
@property (nonatomic , strong) IQTextView *noteTextView;

@property (nonatomic , strong) UIView * numView1;
@property (nonatomic , strong) UIButton * desBtn;
@property (nonatomic , strong) UITextField * numTF;
@property (nonatomic , strong) UIButton * incBtn;

@end

@implementation BaoMingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    self.tableView.backgroundColor = UIColor.whiteColor;
    
    [self initBottomView];
    [self initFooterView];
    
}

- (void)initBottomView{
    UIView * bottomView = nil;
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34-50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34)];
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50)];
    }
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:@"提交报名" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}


//提交报名
- (void)bottomBtnClick{
    if (SESSION_TOKEN) {
        if (self.nameView.rightTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
            return;
        }
        if (self.phoneView.rightTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
            return;
        }
        if (self.phoneView.rightTF.text.length!=11) {
                  [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
                  return;
              }
        if (self.numTF.text.intValue == 0) {
            [SVProgressHUD showErrorWithStatus:@"报名人数不能为0"];
            return;
        }
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"token"] = SESSION_TOKEN;
        dic[@"articleId"] = self.articleID;
        dic[@"name"] = self.nameView.rightTF.text;
        dic[@"phone"] = self.phoneView.rightTF.text;
        dic[@"num"] = self.numTF.text;
        if (self.noteTextView.text.length!=0) {
            dic[@"remark"] = self.noteTextView.text;
        }
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:[LxmURLDefine user_insertTourOrder] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1) {
                PayVC * vc = [[PayVC alloc] initWithTableViewStyle:UITableViewStylePlain type:2];
                vc.orderID = responseObject[@"result"][@"orderId"];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
//                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
   
}

- (void)initFooterView{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 310.5)];
    self.tableView.tableFooterView = self.footerView;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    line.backgroundColor = LineColor;
    [self.footerView addSubview:line];
    
    self.nameView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 50)];
    self.nameView.textlab.text = @"姓名";
    self.nameView.rightTF.placeholder = @"请输入姓名";
    [self.footerView addSubview:self.nameView];
    
    self.phoneView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 60, ScreenW, 50)];
    self.phoneView.textlab.text = @"手机号";
    self.phoneView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneView.rightTF.placeholder = @"请输入手机号";
    [self.footerView addSubview:self.phoneView];
    
    self.numView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 110, ScreenW, 50)];
    self.numView.textlab.text = @"报名人数";
    self.numView.rightTF.userInteractionEnabled = NO;
    [self.footerView addSubview:self.numView];
    
    UILabel * peopleLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 30 - 15, 10, 30, 30)];
    peopleLab.text = @"人";
    peopleLab.textColor = CharacterDarkColor;
    peopleLab.font = [UIFont systemFontOfSize:17];
    [self.numView addSubview:peopleLab];
    
    self.numView1 = [[UIView alloc] init];
    self.numView1.layer.borderColor = LineColor.CGColor;
    self.numView1.layer.borderWidth = 0.5;
    self.numView1.layer.cornerRadius = 3;
    self.numView1.layer.masksToBounds = YES;
    [self.numView addSubview:self.numView1];
    
    self.desBtn = [[UIButton alloc] init];
    [self.desBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.desBtn addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.desBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    self.desBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.numView1 addSubview:self.desBtn];
    
    self.numTF = [[UITextField alloc] init];
    self.numTF.text = @"0";
    self.numTF.keyboardType = UIKeyboardTypeNumberPad;
    self.numTF.delegate = self;
    self.numTF.textAlignment = NSTextAlignmentCenter;
    [self.numView1 addSubview:self.numTF];
    
    self.incBtn = [[UIButton alloc] init];
    [self.incBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.incBtn addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.incBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    self.incBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.numView1 addSubview:self.incBtn];
    
    [self.numView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numView).offset(10);
        make.bottom.equalTo(self.numView).offset(-10);
        make.trailing.equalTo(self.numView).offset(-50);
        make.height.equalTo(@120);
    }];
    
    [self.desBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.numView1);
        make.width.equalTo(@30);
    }];
    [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.numView1);
        make.leading.equalTo(self.desBtn.mas_trailing);
        make.trailing.equalTo(self.incBtn.mas_leading);
    }];
    [self.incBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.numView1);
        make.width.equalTo(@30);
    }];
    
    
    self.noteView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 160, ScreenW, 50)];
    self.noteView.textlab.text = @"备注";
    self.noteView.rightTF.userInteractionEnabled = NO;
    self.noteView.lineView.hidden = YES;
    [self.footerView addSubview:self.noteView];
    
    self.noteTextView = [[IQTextView alloc] initWithFrame:CGRectMake(10, 210, ScreenW-20, 100)];
    self.noteTextView.placeholder = @"输入内容";
    self.noteTextView.font = [UIFont systemFontOfSize:15];
    [self.footerView addSubview:self.noteTextView];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 310, ScreenW, 0.5)];
    line1.backgroundColor = BGGrayColor;
    [self.footerView addSubview:line1];
    
}

- (void)numClick:(UIButton *)btn{
    if (btn == self.desBtn) {
        //减
        NSNumber * num = @(self.numTF.text.intValue);
        if (num.intValue>1) {
            num = @(num.intValue-1);
            self.numTF.text = [NSString stringWithFormat:@"%@",num];
        }else if (num.intValue==1){
            self.numTF.text = [NSString stringWithFormat:@"%@",@1];
            [SVProgressHUD showErrorWithStatus:@"不能再减少了!"];
            return;
        }
       
    }else{
        //加
        NSNumber * num = @(self.numTF.text.intValue);
        num = @(num.intValue+1);
        self.numTF.text = [NSString stringWithFormat:@"%@",num];
    }
    CGFloat w = [self.numTF.text getSizeWithMaxSize:CGSizeMake(ScreenW-180, 50) withFontSize:15].width;
    w = (w+60)>90?(w+60):90;
    [self.numView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(w));
    }];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.numTF) {
        if (textField.text.intValue == 0) {
            self.numTF.text = @"1";
        }
        CGFloat w = [self.numTF.text getSizeWithMaxSize:CGSizeMake(ScreenW-180, 50) withFontSize:15].width;
        w = (w+60)>90?(w+60):90;
        [self.numView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(w));
        }];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmBaoMingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmBaoMingCell"];
    if (!cell)
    {
        cell = [[LxmBaoMingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmBaoMingCell"];
    }
    cell.model = self.model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end


@interface LxmBaoMingCell ()
@property (nonatomic , strong) UIImageView * picView;
@property (nonatomic , strong) UILabel * titlelab;
@property (nonatomic , strong) UILabel * baomingLab;
@property (nonatomic , strong) UILabel  * moneylab;
@end

@implementation LxmBaoMingCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.picView];
        [self addSubview:self.titlelab];
        [self addSubview:self.baomingLab];
        [self addSubview:self.moneylab];
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@100);
    }];
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picView);
        make.leading.equalTo(self.picView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.baomingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.picView.mas_trailing).offset(15);
        make.bottom.equalTo(self.picView.mas_bottom);
        make.height.equalTo(@20);
    }];
    [self.moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.baomingLab.mas_trailing).offset(10);
        make.centerY.equalTo(self.baomingLab);
    }];
    
}

- (UIImageView *)picView{
    if (!_picView) {
        _picView = [[UIImageView alloc] init];
        _picView.image = [UIImage imageNamed:@"whequemoren"];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.layer.masksToBounds = YES;
    }
    return _picView;
}
- (UILabel *)titlelab{
    if (!_titlelab) {
        _titlelab = [[UILabel alloc] init];
        _titlelab.textColor = CharacterDarkColor;
        _titlelab.font = [UIFont systemFontOfSize:18];
        _titlelab.text = @"国庆德国+法国+瑞士+意大利12日游";
        _titlelab.numberOfLines = 2;
    }
    return _titlelab;
}
- (UILabel *)baomingLab{
    if (!_baomingLab) {
        _baomingLab = [[UILabel alloc] init];
        _baomingLab.textColor = CharacterDarkColor;
        _baomingLab.font = [UIFont systemFontOfSize:14];
        _baomingLab.text = @"报名费:";
    }
    return _baomingLab;
}
- (UILabel *)moneylab{
    if (!_moneylab) {
        _moneylab = [[UILabel alloc] init];
        _moneylab.textColor = [UIColor colorWithRed:239/255.0 green:134/255.0 blue:46/255.0 alpha:1];
        _moneylab.font = [UIFont systemFontOfSize:18];
        _moneylab.text = @"￥50";
    }
    return _moneylab;
}

- (void)setModel:(LxmArticleDetailModel *)model{
    _model = model;
    if (model.pic&&![model.pic isEqualToString:@""]) {
        NSArray * arr = [model.pic componentsSeparatedByString:@","];
        if (arr.count>=1) {
            [self.picView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:arr.firstObject]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
        }
    }
    self.titlelab.text = model.title;
    self.moneylab.text = [NSString stringWithFormat:@"￥%0.2f",model.money.floatValue];
}

- (void)setDetailModel:(LxmMyTourListModel *)detailModel{
    _detailModel = detailModel;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:detailModel.pic]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
    self.titlelab.text = detailModel.title;
    self.moneylab.text = [NSString stringWithFormat:@"￥%0.2f",detailModel.money.floatValue];
    NSString * str  = detailModel.createTime;
    if (detailModel.createTime.length>9) {
        str = [detailModel.createTime substringToIndex:detailModel.createTime.length - 9];
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
}


@end

@implementation LxmTextTFView1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textlab];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(self.textlab.mas_trailing);
            make.centerY.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
            
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

@end
