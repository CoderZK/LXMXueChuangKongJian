//
//  LxmBaomingDetailVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmBaomingDetailVC.h"
#import "BaoMingVC.h"
#import "IQKeyboardManagerConstants.h"
#import "PayVC.h"

@interface LxmBaomingDetailVC ()
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong) UIView * footerView;
@property (nonatomic , strong) LxmTextTFView1 * nameView;
@property (nonatomic , strong) LxmTextTFView1 * phoneView;
@property (nonatomic , strong) LxmTextTFView1 * numView;
@property (nonatomic , strong) LxmTextTFView1 * noteView;
@property (nonatomic , strong) IQTextView *noteTextView;

@property (nonatomic , strong) LxmTextTFView1 * moneyView;
@property (nonatomic , strong) LxmTextTFView1 * payStyleView;
@property (nonatomic , strong) LxmTextTFView1 * payTimeView;
@property (nonatomic , strong) UIButton * stateBtn;
@property (nonatomic , strong) LxmTextTFView1 * stateView;

@property (nonatomic , strong) LxmMyTourListModel * detailModel;

//倒计时
@property (nonatomic , strong)NSTimer * timer;
@property (nonatomic , assign)int time;


@end

@implementation LxmBaomingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;

    
    [self initFooterView];
    [self loadDetailData];
}

- (void)loadDetailData{
   
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"applyId":self.applyId
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_getMyTourInfo] parameters:dic returnClass:[LxmMyTourDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmMyTourDetailRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                self.detailModel = responseObject.result;
                [self.tableView reloadData];
                if (self.detailModel.status.intValue == 1) {
                    //未支付
                    double chaTime = [NSString chaWithCreateTime:self.detailModel.createTime];
                    if (chaTime>900) {
                        //已超过15分钟
                        //关闭订单
                        self.stateView.textlab.text = @"删除订单";
                        self.stateView.textlab.textColor = BlueColor;
                        self.payStyleView.frame = CGRectMake(0, 0, ScreenW, 0);
                        self.payTimeView.frame  = CGRectMake(0, 0, ScreenW, 0);
                        self.stateBtn.frame = CGRectMake(0, 370, ScreenW, 50);
                        self.footerView.frame = CGRectMake(0, 0, ScreenW, 420);
                        [self.bottomBtn removeFromSuperview];
                        if (kDevice_Is_iPhoneX) {
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34);
                        }else{
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
                        }
                        [self deleteOrder];
                        
                    }else if (chaTime<900){
                        [self.timer invalidate];
                        self.timer=nil;
                        self.time=chaTime;
                        self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
                    }else if (chaTime == 900){
                        //关闭订单
                        self.stateView.textlab.text = @"删除订单";
                        self.stateView.textlab.textColor = BlueColor;
                        self.payStyleView.frame = CGRectMake(0, 0, ScreenW, 0);
                        self.payTimeView.frame  = CGRectMake(0, 0, ScreenW, 0);
                        self.stateBtn.frame = CGRectMake(0, 370, ScreenW, 50);
                        self.footerView.frame = CGRectMake(0, 0, ScreenW, 420);
                        [self.bottomBtn removeFromSuperview];
                        if (kDevice_Is_iPhoneX) {
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34);
                        }else{
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
                        }
                        [self deleteOrder];
                        
                    }
                    
                    self.stateView.textlab.text = @"关闭订单";
                    self.stateView.textlab.textColor = BlueColor;
                    self.payStyleView.frame = CGRectMake(0, 0, ScreenW, 0);
                    self.payTimeView.frame  = CGRectMake(0, 0, ScreenW, 0);
                    self.stateBtn.frame = CGRectMake(0, 370, ScreenW, 50);
                    self.footerView.frame = CGRectMake(0, 0, ScreenW, 420);
                  
                    [self initBottomView];
                    
                }else if (self.detailModel.status.intValue == 2){
                    //支付成功
                    self.stateView.textlab.text = @"删除订单";
                    self.stateView.textlab.textColor = CharacterLightGrayColor;
                    
                    self.payStyleView.frame = CGRectMake(0, 370, ScreenW, 50);
                    self.payTimeView.frame  = CGRectMake(0, 420, ScreenW, 50);
                    self.stateBtn.frame = CGRectMake(0, 470, ScreenW, 50);
                    self.footerView.frame = CGRectMake(0, 0, ScreenW, 320+200);
                   
                    if (self.bottomBtn) {
                        [self.bottomBtn removeFromSuperview];
                        if (kDevice_Is_iPhoneX) {
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34);
                        }else{
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
                        }
                    }
                    
                }else if (self.detailModel.status.intValue == 4){
                    //关闭
                    self.stateView.textlab.text = @"删除订单";
                    self.stateView.textlab.textColor = BlueColor;
                    self.payStyleView.frame = CGRectMake(0, 0, ScreenW, 0);
                    self.payTimeView.frame  = CGRectMake(0, 0, ScreenW, 0);
                    self.stateBtn.frame = CGRectMake(0, 370, ScreenW, 50);
                    self.footerView.frame = CGRectMake(0, 0, ScreenW, 420);
                    if (self.bottomBtn) {
                        [self.bottomBtn removeFromSuperview];
                        if (kDevice_Is_iPhoneX) {
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34);
                        }else{
                            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
                        }
                    }
                }
                self.tableView.tableFooterView = self.footerView;
                self.nameView.rightTF.text = self.detailModel.name;
                self.phoneView.rightTF.text = self.detailModel.phone;
                self.numView.rightTF.text = [NSString stringWithFormat:@"%@人",self.detailModel.num];
                self.noteView.rightTF.text = self.detailModel.remark;
                self.moneyView.rightTF.text = [NSString stringWithFormat:@"￥%0.2f",self.detailModel.allMoney.floatValue];
                self.payTimeView.rightTF.text = self.detailModel.payTime;
                
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}

-(void)onTimer1
{
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:_time--];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"mm:ss"];
    NSString * timeStr = [df stringFromDate:beDate];
    [self.bottomBtn setTitle:[NSString stringWithFormat:@"支付 00:%@",timeStr] forState:UIControlStateNormal];
    if (self.time<0)
    {
        [self.timer invalidate];
        self.timer = nil;
        //关闭
        self.stateView.textlab.text = @"删除订单";
        self.stateView.textlab.textColor = BlueColor;
        self.payStyleView.frame = CGRectMake(0, 0, ScreenW, 0);
        self.payTimeView.frame  = CGRectMake(0, 0, ScreenW, 0);
        self.stateBtn.frame = CGRectMake(0, 370, ScreenW, 50);
        self.footerView.frame = CGRectMake(0, 0, ScreenW, 420);
        [self.bottomBtn removeFromSuperview];
        if (kDevice_Is_iPhoneX) {
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34);
        }else{
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        }
        [self deleteOrder];
    }
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
    [self.bottomBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}


//去支付
- (void)bottomBtnClick{
    PayVC * payVC = [[PayVC alloc] initWithTableViewStyle:UITableViewStylePlain type:2];
    payVC.orderID = [NSString stringWithFormat:@"%@",self.applyId];
    __weak typeof(self) safe_self = self;
    payVC.refreshPreVC = ^{
        [safe_self loadDetailData];
        if (safe_self.refreshPreVC) {
            safe_self.refreshPreVC();
        }
    };
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)initFooterView{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 320+200)];
    self.footerView.layer.masksToBounds = YES;
    self.tableView.tableFooterView = self.footerView;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    line.backgroundColor = LineColor;
    [self.footerView addSubview:line];
    
    self.nameView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 50)];
    self.nameView.textlab.text = @"姓名";
    self.nameView.rightTF.userInteractionEnabled = NO;
    self.nameView.rightTF.text = @"王甜甜";
    [self.footerView addSubview:self.nameView];
    
    self.phoneView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 60, ScreenW, 50)];
    self.phoneView.textlab.text = @"手机号";
    self.phoneView.rightTF.userInteractionEnabled = NO;
    self.phoneView.rightTF.text = @"12345678996";
    [self.footerView addSubview:self.phoneView];
    
    self.numView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 110, ScreenW, 50)];
    self.numView.textlab.text = @"报名人数";
    self.numView.rightTF.userInteractionEnabled = NO;
    self.numView.rightTF.text = @"2人";
    [self.footerView addSubview:self.numView];
    
    
    self.noteView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 160, ScreenW, 50)];
    self.noteView.textlab.text = @"备注";
    self.noteView.rightTF.userInteractionEnabled = NO;
    self.noteView.lineView.hidden = YES;
    [self.footerView addSubview:self.noteView];
    
    self.noteTextView = [[IQTextView alloc] initWithFrame:CGRectMake(10, 210, ScreenW-20, 100)];
    self.noteTextView.userInteractionEnabled = NO;
    self.noteTextView.placeholder = @"";
    self.noteTextView.font = [UIFont systemFontOfSize:15];
    [self.footerView addSubview:self.noteTextView];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 310, ScreenW, 10)];
    line1.backgroundColor = BGGrayColor;
    [self.footerView addSubview:line1];
    
    self.moneyView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 320, ScreenW, 50)];
    self.moneyView.textlab.text = @"订单金额";
    self.moneyView.rightTF.userInteractionEnabled = NO;
    self.moneyView.rightTF.text = @"￥100";
    [self.footerView addSubview:self.moneyView];
    
    self.payStyleView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 370, ScreenW, 50)];
    self.payStyleView.layer.masksToBounds = YES;
    self.payStyleView.textlab.text = @"支付方式";
    self.payStyleView.rightTF.userInteractionEnabled = NO;
    self.payStyleView.rightTF.text = @"账户余额";
    [self.footerView addSubview:self.payStyleView];
    
    self.payTimeView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 420, ScreenW, 50)];
    self.payTimeView.layer.masksToBounds = YES;
    self.payTimeView.textlab.text = @"付款时间";
    self.payTimeView.rightTF.userInteractionEnabled = NO;
    self.payTimeView.rightTF.text = @"2018-02-12 14:00:11";
    [self.footerView addSubview:self.payTimeView];
    
    self.stateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 470, ScreenW, 50)];
    [self.stateBtn addTarget:self action:@selector(stateButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.stateBtn];
    
    self.stateView = [[LxmTextTFView1 alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.stateView.userInteractionEnabled = NO;
    self.stateView.textlab.text = @"删除订单";
    self.stateView.textlab.textColor = CharacterLightGrayColor;
    [self.stateBtn addSubview:self.stateView];
}

- (void)stateButtonHandle {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否删除订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteOrder];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteOrder{
    if (self.detailModel.status.intValue == 4||self.detailModel.status.intValue == 2) {
        if (ISLOGIN) {
            [SVProgressHUD show];
            NSDictionary * dict = @{
                                    @"token":SESSION_TOKEN,
                                    @"applyId":self.applyId
                                    };
            [LxmNetworking networkingPOST:[LxmURLDefine user_deleteMyTour] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"key"] intValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"已删除"];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.refreshPreVC) {
                        self.refreshPreVC();
                    }
                }else{
                    [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
        }
    }else{
        //关闭订单
        if (ISLOGIN) {
            [SVProgressHUD show];
            NSDictionary * dict = @{
                                    @"token":SESSION_TOKEN,
                                    @"applyId":self.applyId
                                    };
            [LxmNetworking networkingPOST:[LxmURLDefine user_closeMyTour] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"key"] intValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"已删除"];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.refreshPreVC) {
                        self.refreshPreVC();
                    }
                }else{
                    [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
        }
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
    cell.detailModel = self.detailModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
