//
//  YueDanPayVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/16.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "YueDanPayVC.h"
#import "LxmLiuYanView.h"
#import "PayVC.h"
#import "IQKeyboardManagerConstants.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GoodsDetailVC.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "zkPickView.h"

@interface YueDanPayVC ()<UITextFieldDelegate,WXApiManagerDelegate,zkPickViewDelelgate>
@property (nonatomic , strong)LxmLeftAndRightTextView *nameView;
@property (nonatomic , strong)LxmLeftAndRightTextView *priceView;
@property (nonatomic , strong)LxmLeftAndRightTextView *numView;
@property (nonatomic , strong)LxmLeftAndRightTextView *userNameView;
@property (nonatomic , strong)LxmLeftAndRightTextView *phoneView;
@property (nonatomic , strong)LxmLeftAndRightTextView *timeView;
@property (nonatomic , strong) UIView * numView1;
@property (nonatomic , strong) UIButton * desBtn;
@property (nonatomic , strong) UITextField * numTF;
@property (nonatomic , strong) UIButton * incBtn;
@property (nonatomic , strong) IQTextView * addressView;

@property (nonatomic , strong)LxmLeftAndRightTextView *totalMoneyView;
@property (nonatomic , strong)LxmLiuYanView *payStyleView;

@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , assign) NSInteger  selectRow;
@property (nonatomic , strong)LxmGoodsDetailModel * detailModel;
@property (nonatomic , strong) NSString * money;
@property (nonatomic , strong) NSString * orderMoney;
/** <#注释#> */
@property(nonatomic , strong)NSString *sendTime;
@end

@implementation YueDanPayVC
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style detailModel:(LxmGoodsDetailModel *)detailModel{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.detailModel = detailModel;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFuBaoNoti:) name:@"ZhiFuBaoPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayNoti:) name:@"WXPAY" object:nil];
}

- (void)zhiFuBaoNoti:(NSNotification *)noti{
    NSDictionary *resultDic = noti.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        //用户取消支付
        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
        
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"约单成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshPreVC) {
                self.refreshPreVC();
            }
            
        });
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
    
}
- (void)wechatPayNoti:(NSNotification *)noti{
    BaseResp * resp = noti.object;
    if (resp.errCode==WXSuccess){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"约单成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshPreVC) {
                self.refreshPreVC();
            }
            
        });
    }else if(resp.errCode==WXErrCodeUserCancel){
        [SVProgressHUD showErrorWithStatus:@"用户取消了支付"];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付订单";
    [self initTableViewHeader];
    [WXApiManager sharedManager].delegate = self;
}

- (void)initTableViewHeader{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250+100 + 150)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    self.nameView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.nameView.textlab.text = @"约单名称:";
    self.nameView.rightlab.text = self.detailModel.title;
    [headerView addSubview:self.nameView];
    
    self.priceView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 50)];
    self.priceView.textlab.text = @"单价:";
    self.priceView.rightlab.text = [NSString stringWithFormat:@"%0.2f元/%@",self.detailModel.money.floatValue,self.detailModel.unit];
    [headerView addSubview:self.priceView];
    
    self.numView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0, 100, ScreenW, 50)];
    self.numView.textlab.text = @"数量:";
    self.numView.rightlab.hidden = YES;
    [headerView addSubview:self.numView];
    
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
    self.numTF.text = @"1";
    self.numTF.delegate = self;
    self.numTF.keyboardType = UIKeyboardTypeNumberPad;
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
        make.trailing.equalTo(self.numView).offset(-15);
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
        make.width.equalTo(@30);
    }];
    [self.incBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.numView1);
        make.width.equalTo(@30);
    }];
    
    self.totalMoneyView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0, 150, ScreenW, 50)];
    self.totalMoneyView.textlab.text = @"总金额:";
    self.totalMoneyView.rightlab.text = [NSString stringWithFormat:@"￥%.2f",self.detailModel.money.floatValue];
    self.orderMoney = [NSString stringWithFormat:@"%@",self.detailModel.money];
    self.totalMoneyView.rightlab.textColor = YellowColor;
    self.totalMoneyView.rightlab.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:self.totalMoneyView];
    
    
    
    self.userNameView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0, 200, ScreenW, 50)];
    self.userNameView.textlab.text = @"姓名:";
    self.userNameView.rightTF.placeholder = @"请输入姓氏";
    self.userNameView.rightTF.hidden = NO;
    self.userNameView.rightTF.text = [LxmTool ShareTool].xiaDanName;
    self.userNameView.rightlab.text = @"同学";
    self.userNameView.isSSS = YES;
    self.userNameView.rightBt.hidden =YES;
   
    [headerView addSubview:self.userNameView];
    
    self.phoneView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0, 250, ScreenW, 50)];
    self.phoneView.textlab.text = @"电话:";
    self.phoneView.rightTF.placeholder = @"请输入";
    self.phoneView.rightTF.text = [LxmTool ShareTool].xiaDanPhone;
    self.phoneView.rightTF.hidden = NO;
    self.phoneView.rightTF.keyboardType = UIKeyboardTypePhonePad;
    self.phoneView.rightlab.hidden = self.phoneView.rightBt.hidden = YES;
    [headerView addSubview:self.phoneView];
    
    
    
    
    
    
    LxmLeftAndRightTextView  *addView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0, 300, ScreenW, 50)];
    addView.textlab.text = @"收货地址:";
    [headerView addSubview:addView];
    
    self.addressView = [[IQTextView alloc] initWithFrame:CGRectMake(100, 8, ScreenW - 115, 80)];
    if (self.detailModel.sendType.intValue == 1) {
        self.addressView.placeholder = @"请填写详细的收货地址";
    }else{
        self.addressView.placeholder = @"如需寄送请填写详细的姓名，电话，收货地址。";
    }
    self.addressView.text = [LxmTool ShareTool].xiaDanAddress;
    self.addressView.font = [UIFont systemFontOfSize:15];
    [addView addSubview:self.addressView];
    
    
    self.timeView = [[LxmLeftAndRightTextView alloc] initWithFrame:CGRectMake(0,400, ScreenW, 50)];
    self.timeView.textlab.text = @"配送时间:";
    self.timeView.rightTF.placeholder = @"请选择(非必选)";
    self.timeView.rightlab.hidden = YES;
    self.timeView.rightTF.hidden = NO;
    self.timeView.rightTF.userInteractionEnabled = self.timeView.rightBt.hidden =  NO;
    [headerView addSubview:self.timeView];
    [self.timeView.rightBt addTarget:self action:@selector(chooseTime) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.payStyleView = [[LxmLiuYanView alloc] initWithFrame:CGRectMake(0, 300+150, ScreenW, 50)];
    self.payStyleView.liuYanLab.text = @"选择支付方式";
    self.payStyleView.liuYanLab.font = [UIFont boldSystemFontOfSize:15];
    [headerView addSubview:self.payStyleView];
    
    self.tableView.tableHeaderView = headerView;
    [self initBottomView];
    [self getMyAssetsInfo];
}


- (void)chooseTime {
    
    NSMutableArray * arrOne = @[].mutableCopy;
    for (int i = 0 ; i < 24; i++) {
        [arrOne addObject: [NSString stringWithFormat:@"%02d",i]];
    }
    NSMutableArray * arrTwo = @[].mutableCopy;
    for (int i = 0 ; i < 60; i++) {
        [arrTwo addObject: [NSString stringWithFormat:@"%02d",i]];
    }
    
    zkPickView * picker = [[zkPickView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    picker.delegate = self;
    picker.arrayType = titleArrWithArr;
    picker.array = @[@[@"今天",@"明天"],arrOne,arrTwo].mutableCopy;
    picker.selectLb.text = @"";
    [picker show];
    
    
}

- (void)didSelectLeftIndex:(NSInteger)leftIndex centerIndex:(NSInteger)centerIndex rightIndex:(NSInteger )rightIndex {
    
    NSMutableArray * arrOne = @[].mutableCopy;
    for (int i = 0 ; i < 24; i++) {
        [arrOne addObject: [NSString stringWithFormat:@"%02d",i]];
    }
    NSMutableArray * arrTwo = @[].mutableCopy;
    for (int i = 0 ; i < 60; i++) {
        [arrTwo addObject: [NSString stringWithFormat:@"%02d",i]];
    }
    
    NSMutableArray * allArr = @[@[@"今天",@"明天"],arrOne,arrTwo].mutableCopy;
    self.timeView.rightTF.text =  [NSString stringWithFormat:@"%@ %@:%@",allArr[0][leftIndex],allArr[1][centerIndex],allArr[2][rightIndex]];
    
    if (leftIndex == 0) {
        self.sendTime =  [NSString stringWithFormat:@"%@ %@:%@",[self getCurrentTime],allArr[1][centerIndex],allArr[2][rightIndex]];
    }else {
        self.sendTime =  [NSString stringWithFormat:@"%@ %@:%@",[self GetTomorrowDay:[NSDate date]],allArr[1][centerIndex],allArr[2][rightIndex]];
    }
    
    
    
    
}


//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    dateday.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}




- (void)getMyAssetsInfo{
    
    [LxmNetworking networkingPOST:[LxmURLDefine user_getMyAssetsInfo] parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            self.money = responseObject[@"result"][@"money"];
            [self.tableView reloadData];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)initBottomView{
    UIView * bottomView = nil;
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34-50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34)];
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50)];
    }
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}

//去支付
- (void)bottomBtnClick{
   
    if (self.detailModel.sendType.intValue == 1) {
        if (self.addressView.text.length == 0 || self.addressView.text.length >50) {
            [SVProgressHUD showErrorWithStatus:@"请填写1~50字的收货地址!"];
            return;
        }
    }else{
        if (![self.addressView.text isEqualToString:@""]||![self.addressView.text stringByReplacingOccurrencesOfString:@"" withString:@" "]) {
            if (self.addressView.text.length >50) {
                [SVProgressHUD showErrorWithStatus:@"请填写1~50字的收货地址!"];
                return;
            }
        }
    }
    if (self.userNameView.rightTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if (self.phoneView.rightTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位手机号"];
        return;
    }
    
    if (self.orderMoney.floatValue>self.money.floatValue&&self.selectRow == 0) {
           [SVProgressHUD showErrorWithStatus:@"账户余额不足,请选择其他支付方式!"];
           return;
       }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"token"] = SESSION_TOKEN;
    NSString * str =  @"";

    if (self.billId) {
        dic[@"billId"] = self.billId;
        str = [LxmURLDefine user_insertCanOrder];
    }
    if (self.ecId) {
        dic[@"ecId"] = self.ecId;
        str = [LxmURLDefine user_insertECOrder];
    }
    dic[@"number"] = self.numTF.text;
    if (self.addressView.text.length!=0) {
        dic[@"sendAddr"] = self.addressView.text;
    }
    dic[@"name"] = self.userNameView.rightTF.text;
    dic[@"phone"] = self.phoneView.rightTF.text;
    dic[@"sendTime"] = self.sendTime;
    dic[@"payType"] = @(self.selectRow+1);
    [SVProgressHUD show];
    self.bottomBtn.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:str parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.bottomBtn.userInteractionEnabled = YES;
        if ([responseObject[@"key"] intValue] == 1) {
            
            [LxmTool ShareTool].xiaDanName = self.userNameView.rightTF.text;
            [LxmTool ShareTool].xiaDanPhone = self.phoneView.rightTF.text;
            [LxmTool ShareTool].xiaDanAddress=self.addressView.text;
            
            [self payWithOrderID:responseObject[@"result"][@"orderId"] type:self.selectRow+1];
        }else{
            
            if ([responseObject[@"key"] intValue] == 40002) {
                [SVProgressHUD showErrorWithStatus:@"商品已经下架"];
            }else {
//                [UIAlertController showAlertWithKey:[NSNumber numberWithInt:[responseObject[@"key"] intValue]] message:responseObject[@"message"]];
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         self.bottomBtn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
    
}

- (void)payWithOrderID:(NSNumber *)orderId type:(NSInteger)type{
    
    NSDictionary * dic = @{
                           @"token":SESSION_TOKEN,
                           @"orderId":orderId,
                           @"payType":@(type)
                           };
    NSString * str = @"";
    if (self.ecId) {
        str = [LxmURLDefine user_payECOrder];
    }else{
        str = [LxmURLDefine user_payCanOrder];
    }
    
    [LxmNetworking networkingPOST:str parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            if (type == 1) {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                NSArray * vcs = self.navigationController.viewControllers;
                for (UIViewController * vc in vcs) {
                    if ([vc isKindOfClass:[GoodsDetailVC class]]) {
                        if (self.ecId) {
                            [self.navigationController popToViewController:vc animated:YES];
                            [LxmEventBus sendEvent:@"LxmPayMoneyAbleVC" data:nil];
                        } else {
                            [self.navigationController popToViewController:vc animated:YES];
                            [LxmEventBus sendEvent:@"LxmZaiShouVC" data:nil];
                        }
                    }
                }
                if (self.refreshPreVC) {
                    self.refreshPreVC();
                }
            }else if (type == 2){
                //支付宝支付
                NSString *orderString = responseObject[@"result"][@"orderString"];
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"com.biuwork.xckj.safepay" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }else{
                //微信支付
                NSDictionary * dict = responseObject[@"result"];
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"paySign"];
                [WXApi sendReq:req];
            }
        }else{
//            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPayCell"];
    if (!cell)
    {
        cell = [[LxmPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPayCell"];
    }
    if (indexPath.row == 0) {
        if (self.orderMoney.floatValue>self.money.floatValue) {
            cell.userInteractionEnabled = NO;
            cell.titleLab.text = @"账户余额不足";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BGGrayColor;
            cell.accImgView.image = [UIImage imageNamed:@"xuanze"];
        }else{
            cell.userInteractionEnabled = YES;
            cell.backgroundColor = UIColor.whiteColor;
            cell.titleLab.text = [NSString stringWithFormat:@"账户余额 ￥%0.2f",self.money.floatValue];
            cell.accImgView.image = [UIImage imageNamed:indexPath.row == self.selectRow?@"tijiao":@"xuanze"];
        }
        cell.iconImgView.image = [UIImage imageNamed:@"zhanghu"];
        cell.titleLab.text = [NSString stringWithFormat:@"账户余额 ￥%0.2f",self.money.floatValue];
    }else if (indexPath.row == 1){
        cell.iconImgView.image = [UIImage imageNamed:@"zhifubao2"];
        cell.titleLab.text = @"支付宝支付";
    }else{
        cell.iconImgView.image = [UIImage imageNamed:@"wechat2"];
        cell.titleLab.text = @"微信支付";
    }
    cell.accImgView.image = [UIImage imageNamed:indexPath.row == self.selectRow?@"tijiao":@"xuanze"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectRow = indexPath.row;
    [self.tableView reloadData];
}


- (void)numClick:(UIButton *)btn{
    if (btn == self.desBtn) {
        //减
        NSNumber * num = @(self.numTF.text.intValue);
        if (num.intValue>1) {
            num = @(num.intValue-1);
            self.numTF.text = [NSString stringWithFormat:@"%@",num];
        }else if (num.intValue== 1){
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
    w = w>30?w+30:30;
    [self.numTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(w));
    }];
    [self.numView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(w+60));
    }];
    
    self.orderMoney = [NSString stringWithFormat:@"%lf",self.detailModel.money.floatValue*self.numTF.text.intValue];
    self.totalMoneyView.rightlab.text = [NSString stringWithFormat:@"￥%.2f",self.detailModel.money.floatValue*self.numTF.text.intValue];
    [self.tableView reloadData];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.numTF) {
        if (self.numTF.text.length == 0) {
            self.numTF.text = @"1";
        }
        CGFloat w = [self.numTF.text getSizeWithMaxSize:CGSizeMake(ScreenW-180, 50) withFontSize:15].width;
        w = w>30?w+30:30;
        [self.numTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(w));
        }];
        [self.numView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(w+60));
        }];
    }
     self.orderMoney = [NSString stringWithFormat:@"%lf",self.detailModel.money.floatValue*self.numTF.text.intValue];
    self.totalMoneyView.rightlab.text = [NSString stringWithFormat:@"￥%.2f",self.detailModel.money.floatValue*self.numTF.text.intValue];
    [self.tableView reloadData];
}

@end

@implementation LxmLeftAndRightTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textlab];
        [self addSubview:self.rightlab];
        [self addSubview:self.lineView];
        [self addSubview:self.rightTF];
        [self addSubview:self.rightBt];
        
        [self.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];
        [self.rightlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(self.textlab.mas_trailing);
            make.centerY.equalTo(self);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(self.textlab.mas_trailing);
            make.centerY.equalTo(self);
        }];
        [self.rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(self.textlab.mas_trailing);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setIsSSS:(BOOL)isSSS {
    _isSSS = isSSS;
    if (self.isSSS) {
        [self.rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-60);
        }];
    }
}

- (UILabel *)textlab{
    if (!_textlab) {
        _textlab = [[UILabel alloc] init];
        _textlab.font = [UIFont systemFontOfSize:15];
        _textlab.textColor = CharacterDarkColor;
    }return _textlab;
}
- (UILabel *)rightlab{
    if (!_rightlab) {
        _rightlab = [[UILabel alloc] init];
        _rightlab.font = [UIFont systemFontOfSize:15];
        _rightlab.textColor = CharacterDarkColor;
        _rightlab.textAlignment = NSTextAlignmentRight;
    }return _rightlab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }return _lineView;
}


-(UITextField *)rightTF {
    if (_rightTF == nil) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.font = [UIFont systemFontOfSize:14];
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.hidden = YES;
        _rightTF.textAlignment = NSTextAlignmentRight;
    }
    return _rightTF;
}

-(UIButton *)rightBt {
    if (_rightBt == nil) {
        _rightBt = [[UIButton alloc] init];
    }
    return _rightBt;
}





@end
