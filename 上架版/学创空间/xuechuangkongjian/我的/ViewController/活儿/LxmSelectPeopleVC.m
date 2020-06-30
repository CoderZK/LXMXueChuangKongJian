//
//  LxmSelectPeopleVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSelectPeopleVC.h"
#import "LxmSureSelectPeopleAlertView.h"

@interface LxmSelectPeopleVC ()<LxmSureSelectPeopleAlertViewDelegate>
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , strong) NSArray * dataArr;

@property (nonatomic , strong) NSString * ids;

@property (assign, nonatomic) int peopleNumber;

@property (strong, nonatomic) NSMutableArray *didSelectedBoolArray;

@end

@implementation LxmSelectPeopleVC
- (UILabel *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _noneDataView.text = @"没有数据!";
        _noneDataView.font = [UIFont systemFontOfSize:16];
        _noneDataView.textAlignment = NSTextAlignmentCenter;
        _noneDataView.textColor = [UIColor blackColor];
        _noneDataView.hidden = YES;
    }
    return _noneDataView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择抢单人";
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    self.didSelectedBoolArray = [NSMutableArray new];
    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setTitle:@"下一步" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    [self loadPeopleList];
}

- (void)loadPeopleList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"billId":self.billId,
                                };
        NSString * str = [LxmURLDefine user_findRobHelpUserList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyQingDanPeopleRootModel class] success:^(NSURLSessionDataTask *task, LxmMyQingDanPeopleRootModel * responseObject) {
            [SVProgressHUD dismiss];
            if (responseObject.key.intValue == 1) {
                LxmMyQingDanPeopleModel1 * model = responseObject.result;
                self.dataArr = model.list;
                [self.tableView reloadData];
                if (model.list.count> 0) {
                    self.peopleNumber = [[model.list[0] valueForKeyPath:@"needNum"] intValue];
                    for (int i = 0 ; i < model.list.count; i++){
                        [self.didSelectedBoolArray lxm_add1Object:[NSNumber numberWithBool:NO]];
                    }
                }
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

- (void)next{
    //下一步
    NSMutableArray * selectIDs = [NSMutableArray array];
    NSMutableArray * names = [NSMutableArray array];
    for (LxmMyQingDanPeopleModel *model in self.dataArr) {
        if (model.isSelect) {
            [selectIDs lxm_add1Object:model.allotId];
            [names lxm_add1Object:model.robUserNick];
        }
    }
    if (selectIDs.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择抢单人!"];
        return;
    }
    NSString *nameStr = [names componentsJoinedByString:@"、"];
    nameStr = [nameStr stringByAppendingString:@"?"];
    self.ids = [selectIDs componentsJoinedByString:@","];
    LxmSureSelectPeopleAlertView * alertView = [[LxmSureSelectPeopleAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.delegate = self;
    [alertView showWithContent:nameStr];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmSelectPeopleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSelectPeopleCell"];
    if (!cell)
    {
        cell = [[LxmSelectPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSelectPeopleCell"];
    }
    LxmMyQingDanPeopleModel * model = self.dataArr[indexPath.row];
    cell.model = model;
    [cell setChatButtonHandle:nil];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int didSelectNmuber = 0;
    for (NSNumber *number in self.didSelectedBoolArray) {
        if ([number boolValue] == YES) {
            didSelectNmuber = didSelectNmuber + 1;
        }
    }
    
    if ([self.didSelectedBoolArray[indexPath.row] boolValue] == NO && didSelectNmuber < self.peopleNumber) {
        [self.didSelectedBoolArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        LxmMyQingDanPeopleModel * model = self.dataArr[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadData];
        return;
    }
    
    if ([self.didSelectedBoolArray[indexPath.row] boolValue] == YES) {
        [self.didSelectedBoolArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        LxmMyQingDanPeopleModel * model = self.dataArr[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadData];
        return;
    }
    
    if ([self.didSelectedBoolArray[indexPath.row] boolValue] == NO && didSelectNmuber >= self.peopleNumber) {
        [SVProgressHUD showErrorWithStatus:@"超过指定抢单人数了"];
        return;
    }
    
}
//下一步
- (void)LxmSureSelectPeopleAlertViewNext:(LxmSureSelectPeopleAlertView *)view{
    [view dismiss];
    NSDictionary * dic = @{
                           @"token":SESSION_TOKEN,
                           @"billId":self.billId,
                           @"allotIds":self.ids
                           };
    [LxmNetworking networkingPOST:[LxmURLDefine user_choiceHelpUser] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"已选定抢单人!"];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshPreBlock) {
                self.refreshPreBlock();
            }
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end


@interface LxmSelectPeopleCell()
@property (nonatomic , strong) UIImageView * selectImgView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UIView * startView;
@property (nonatomic , strong) UIImageView * starImgView1;
@property (nonatomic , strong) UIImageView * starImgView2;
@property (nonatomic , strong) UIImageView * starImgView3;
@property (nonatomic , strong) UIImageView * starImgView4;
@property (nonatomic , strong) UIImageView * starImgView5;
@property (nonatomic , strong) UILabel * phoneLab;
@property (nonatomic , strong) UILabel * moneyLab;
@property (nonatomic , strong) UIButton * chatBtn;
@end

@implementation LxmSelectPeopleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.selectImgView];
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.startView];
        [self addSubview:self.phoneLab];
        [self addSubview:self.moneyLab];
//        [self addSubview:self.chatBtn];
        
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.selectImgView.mas_trailing).offset(20);
        make.width.height.equalTo(@60);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(8);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
        make.trailing.equalTo(self.moneyLab.mas_leading);
    }];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.sexImgView);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sexImgView);
        make.bottom.equalTo(self.headerImgView.mas_bottom);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.trailing.equalTo(self).offset(-15);
    }];
//    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.moneyLab.mas_bottom).offset(5);
//        make.trailing.equalTo(self).offset(-15);
//        make.width.equalTo(@60);
//        make.height.equalTo(@30);
//    }];
}
- (UIImageView *)selectImgView{
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
        _selectImgView.image = [UIImage imageNamed:@"xuanze"];
    }
    return _selectImgView;
}

- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 30;
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
        _nameLab.font = [UIFont systemFontOfSize:18];
        _nameLab.text = @"巴啦啦小魔仙";
        _nameLab.textColor = CharacterDarkColor;
    }
    return _nameLab;
}
- (UIView *)startView{
    if (!_startView) {
        _startView = [[UIView alloc] init];
        for (int i=0; i<5; i++)
        {
            UIImageView *starImg=[[UIImageView alloc] init];
            starImg.frame = CGRectMake(17*i, 0, 15, 15);
            //            starImg.image = [UIImage imageNamed:@"star_1"];
            starImg.image = [UIImage imageNamed:@"star_3"];
            [_startView addSubview:starImg];
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
        _startView.layer.masksToBounds = YES;
    }
    return _startView;
}
- (UILabel *)phoneLab{
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.font = [UIFont systemFontOfSize:12];
        _phoneLab.text = @"17625498387";
        _phoneLab.textColor = CharacterDarkColor;
    }
    return _phoneLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont boldSystemFontOfSize:18];
        _moneyLab.text = @"￥6.00";
        _moneyLab.textColor = YellowColor;
    }
    return _moneyLab;
}
- (UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [[UIButton alloc] init];
        [_chatBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_chatBtn setTitle:@"私信" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _chatBtn.layer.cornerRadius = 8;
        _chatBtn.layer.masksToBounds = YES;
        [_chatBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}
- (void)setModel:(LxmMyQingDanPeopleModel *)model{
    _model = model;
    switch (model.robUserRate.intValue) {
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
            
        default:
            break;
    }
    
    //60
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.robUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.robUserSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.robUserNick;
    self.phoneLab.text = model.robUserPhone;
    self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",model.money.floatValue];
    self.selectImgView.image = [UIImage imageNamed:model.isSelect == YES?@"tijiao":@"xuanze"];
}

- (void)btnClick{
    self.chatButtonHandle ? self.chatButtonHandle() : nil;
}

@end
