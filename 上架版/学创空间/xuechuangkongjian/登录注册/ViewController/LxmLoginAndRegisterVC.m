//
//  LxmLoginAndRegisterVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmLoginAndRegisterVC.h"
#import "LxmLoginAndRegisterView.h"
#import "LxmLoginView.h"
#import "LxmRegistView.h"
#import "LxmThirdLoginView.h"

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "LxmFullInfoVC.h"
#import "LxmWebViewController.h"
#import "LxmForgetPasswordVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LxmAlipayAuthInfoModel.h"
#import "AbleVC.h"

#import <UMShare/UMShare.h>
#import <AuthenticationServices/AuthenticationServices.h>

@interface LxmLoginAndRegisterVC () <ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic , strong)LxmLoginAndRegisterView *headerView;
@property (nonatomic , strong)LxmThirdLoginView *footerView;
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)LxmLoginView * loginView;
@property (nonatomic , strong)LxmRegistView * registView;


/**
 发送验证码
 */
@property (nonatomic , strong)NSTimer * timer;
@property (nonatomic , assign)int time;

@property (nonatomic , strong)NSString * headerImg;
@property (nonatomic , strong)NSString * nameStr;
@property (nonatomic , strong)NSString * tenceID;

@end

@implementation LxmLoginAndRegisterVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFuBaoNoti:) name:@"ZhiFuBaoLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatFull) name:@"wechatFullInfouccess" object:nil];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    if (ScreenH == 480) {
        self.tableView.contentOffset = CGPointMake(0, 40);
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
- (void)wechatFull{
    [self loadHasPerfect];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LxmLoginAndRegisterView class]) owner:self options:nil].firstObject;
    self.headerView.frame = CGRectMake(0, 0, ScreenW, 300+191+220 );
    
    self.headerView.logoImg.layer.cornerRadius = 10;
    self.headerView.logoImg.layer.masksToBounds = YES;
    
    [self.headerView.loginBtn addTarget:self action:@selector(loginOrRegistChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.registBtn addTarget:self action:@selector(loginOrRegistChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.loginImgView.hidden = NO;
    self.headerView.registImgView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, ScreenW, 191)];
    self.scrollView.backgroundColor = UIColor.whiteColor;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(ScreenW*2, 191);
    self.scrollView.delegate = self;
    [self.headerView addSubview:self.scrollView];
    
    self.footerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LxmThirdLoginView class]) owner:nil options:nil].firstObject;
    self.footerView.frame = CGRectMake(0, 300+191, ScreenW, 160);
    [self.footerView.zhifubaoBtn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView.wechatBtn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView.youkeLogin addTarget:self action:@selector(youKELogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.footerView.QQBtn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.footerView];
//    if (@available(iOS 13.0, *)) {
//
//    } else {
        self.footerView.QQBtn.hidden = YES;
        [self.footerView.zhifubaoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.headerView.mas_centerX).offset(-30);
        }];
        [self.footerView.wechatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.headerView.mas_centerX).offset(30);
        }];
        [self.footerView layoutIfNeeded];
//    }
    
    if (LxmTool.ShareTool.isShenHe) {
        self.footerView.wechatBtn.hidden = YES;
        self.footerView.zhifubaoBtn.hidden = YES;
        self.footerView.xckj.text = @"学创空间";
    }
    
    self.loginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LxmLoginView class]) owner:nil options:nil].firstObject;
    self.loginView.frame = CGRectMake(0, 0, ScreenW, 191);
    self.loginView.loginBtn.layer.cornerRadius = 22;
    self.loginView.loginBtn.layer.masksToBounds = YES;
    self.loginView.phoneTF.tintColor = self.loginView.passwordTF.tintColor = CharacterDarkColor;
    self.loginView.passwordTF.secureTextEntry = YES;
    [self.loginView.secretryBtn addTarget:self action:@selector(secretBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginView.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.loginView.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginView.forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.loginView.forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.loginView];
    
    self.registView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LxmRegistView class]) owner:nil options:nil].firstObject;
    [self.registView.sendCodeBtn addTarget:self action:@selector(sendCodeClick) forControlEvents:UIControlEventTouchUpInside];
    self.registView.frame = CGRectMake(ScreenW, 0, ScreenW, 270);
    [self.registView.secretBTn addTarget:self action:@selector(secretBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    self.registView.phoneTF.tintColor = self.registView.codeTF.tintColor = self.registView.passwordTF.tintColor = CharacterDarkColor;
    self.registView.phoneTF.keyboardType = self.registView.codeTF.keyboardType = UIKeyboardTypeNumberPad;
//    self.registView.phoneTF.font = self.registView.codeTF.font = self.registView.passwordTF.font = [UIFont systemFontOfSize:16];
    self.registView.registBtn.layer.cornerRadius = 22;
    self.registView.registBtn.layer.masksToBounds = YES;
    [self.registView.registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.registView.protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.registView];
}

//游客登录
- (void)youKELogin {
    AbleVC * vc = [[AbleVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    vc.isyouke = YES;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

- (void)protocolBtnClick{
    
    [LxmNetworking networkingPOST:[LxmURLDefine app_getBaseInfo] parameters:@{@"type":@1} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            NSString * str = responseObject[@"result"][@"substance"];
            if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) {
                str = @"";
            } else{
                str = str;
            }
            LxmWebViewController * vc = [[LxmWebViewController alloc] init];
            vc.navigationItem.title = @"用户协议";
            vc.loadUrl = [NSURL URLWithString:str];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

/**
 忘记密码
 */
- (void)forgetBtnClick{
    LxmForgetPasswordVC * vc = [[LxmForgetPasswordVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)secretBtnCLick:(UIButton *)btn{
    if (btn == self.loginView.secretryBtn) {
        self.loginView.secretryBtn.selected = !self.loginView.secretryBtn.selected;
        self.loginView.passwordTF.secureTextEntry = !self.loginView.secretryBtn.selected;
    }else{
        self.registView.secretBTn.selected = !self.registView.secretBTn.selected;
        self.registView.passwordTF.secureTextEntry = !self.registView.secretBTn.selected;
    }
}

/**
 发送验证码
 */
- (void)sendCodeClick{
    if (self.registView.phoneTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入手机号"];
        return;
    }
    if (self.registView.phoneTF.text.length!=11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.registView.phoneTF.text forKey:@"phone"];
    [dict setObject:@1 forKey:@"type"];
    if ([LxmTool ShareTool].session_token) {
        [dict setObject:[LxmTool ShareTool].session_token forKey:@"token"];
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine app_sendMobile] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] != 1&&[[responseObject objectForKey:@"key"] intValue] != 10002) {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        } else if ([[responseObject objectForKey:@"key"] intValue] == 10002) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"账号已经存在，请直接登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self.timer invalidate];
            self.timer = nil;
            self.time = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)onTimer1 {
    self.registView.sendCodeBtn.enabled = NO;
    [self.registView.sendCodeBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",_time--] forState:UIControlStateDisabled];
    if (self.time<0)
    {
        [self.timer invalidate];
        self.timer = nil;
        self.registView.sendCodeBtn.enabled = YES;
        [self.registView.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
    }
}

/**
 登录
 */
- (void)loginBtnClick:(UIButton *)btn {
    if (self.loginView.phoneTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (self.loginView.phoneTF.text.length!=11) {
           [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
           return;
       }
    if (self.loginView.passwordTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (self.loginView.passwordTF.text.length < 6 || self.loginView.passwordTF.text.length > 15) {
        [SVProgressHUD showErrorWithStatus:@"密码长度必须在6~15之间"];
        return;
    }
    
    NSString * signature = [NSString stringToMD5:self.loginView.passwordTF.text];
    NSDictionary * dict = @{@"phone":self.loginView.phoneTF.text,@"password":signature};
    NSString * loginStr = [LxmURLDefine app_login];
    [SVProgressHUD show];
    btn.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:loginStr parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [LxmTool ShareTool].loginType = @"4";
            [LxmTool ShareTool].isLogin = YES;
            [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [[LxmTool ShareTool] uploadDeviceToken];
            [self loadHasPerfect];
        } else if ([[responseObject objectForKey:@"key"] intValue] == 10003) {
            btn.userInteractionEnabled = YES;
            [LxmTool ShareTool].isLogin = NO;
            [LxmTool ShareTool].session_token = nil;
        } else if ([[responseObject objectForKey:@"key"] intValue] == 7) {
            btn.userInteractionEnabled = YES;
            [LxmTool ShareTool].isLogin = NO;
            [LxmTool ShareTool].session_token = nil;
        } else  if ([[responseObject objectForKey:@"key"] intValue] == 10001) {
            btn.userInteractionEnabled = YES;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"您还没有注册，请先注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else if ([[responseObject objectForKey:@"key"] intValue] == 10006) {
            btn.userInteractionEnabled = YES;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"账号或密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            btn.userInteractionEnabled = YES;
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        btn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}
//注册
- (void)registBtnClick {
    //注册
    if (self.registView.phoneTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }else if (self.registView.codeTF.text.length < 1){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }else if (self.registView.passwordTF.text.length < 6 || self.registView.passwordTF.text.length > 15){
        [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.registView.phoneTF.text forKey:@"phone"];
    [dict setObject:[NSString stringToMD5:self.registView.passwordTF.text] forKey:@"password"];
    [dict setObject:self.registView.codeTF.text forKey:@"verificationCode"];
    NSString * str = [LxmURLDefine app_register];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] != 1)
        {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }else{
            [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [LxmTool ShareTool].isLogin = YES;
            [self loadHasPerfect];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
   
}

/**
 检查资料是否完善
 */
- (void)loadHasPerfect {
    [LxmNetworking networkingPOST:[LxmURLDefine user_hasPerfect] parameters:@{@"token":[LxmTool ShareTool].session_token} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1)
        {
            NSNumber * num = responseObject[@"result"][@"hasPerfect"];
            if (num.intValue == 1) {
                [self loadUserInfo];
            } else {
                self.headerView.loginBtn.userInteractionEnabled = YES;
                LxmFullInfoVC * vc  = [[LxmFullInfoVC alloc] init];
                vc.isFirtstLogin = YES;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                if (self.headerImg) {
                    vc.headerImgStr = self.headerImg;
                }
                if (self.nameStr) {
                     vc.nikeName = self.nameStr;
                }
                
                BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
            
        } else {
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

//获取个人信息接口
- (void)loadUserInfo{
    if (SESSION_TOKEN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_getMyInfo] parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
               if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                   self.headerView.loginBtn.userInteractionEnabled = YES;
                   [LxmTool ShareTool].userModel = [LxmUserInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                   [UIApplication sharedApplication].delegate.window.rootViewController = [[TabBarController alloc] init];
               } else {
                   self.headerView.loginBtn.userInteractionEnabled = YES;
               }
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
               self.headerView.loginBtn.userInteractionEnabled = YES;
           }];
    } else {
        self.headerView.loginBtn.userInteractionEnabled = YES;
    }
}

/**
 登录注册 View的切换
 */
- (void)loginOrRegistChangeClick:(UIButton *)btn{
    if (btn == self.headerView.loginBtn) {
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 300+191+220);
        self.scrollView.frame = CGRectMake(0, 300, ScreenW, 191);
        self.scrollView.contentSize = CGSizeMake(ScreenW*2, 191);
        self.footerView.frame = CGRectMake(0, 300+191, ScreenW, 160);
        self.headerView.loginImgView.hidden = NO;
        self.headerView.registImgView.hidden = YES;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }else{
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 300+270+220);
        self.scrollView.frame = CGRectMake(0, 300, ScreenW, 270);
        self.scrollView.contentSize = CGSizeMake(ScreenW*2, 270);
        self.footerView.frame = CGRectMake(0, 300+270, ScreenW, 160);
        self.headerView.loginImgView.hidden = YES;
        self.headerView.registImgView.hidden = NO;
        self.scrollView.contentOffset = CGPointMake(ScreenW, 0);
    }
    [self.scrollView layoutIfNeeded];
    [self.footerView layoutIfNeeded];
}
/**
 登录注册 View的切换
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x/ScreenW;
        if (index == 0) {
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 300+191+220);
            self.scrollView.frame = CGRectMake(0, 300, ScreenW, 191);
            self.scrollView.contentSize = CGSizeMake(ScreenW*2, 191);
            self.footerView.frame = CGRectMake(0, 300+191, ScreenW, 160);
            self.headerView.loginImgView.hidden = NO;
            self.headerView.registImgView.hidden = YES;
        }else{
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 300+270+220);
            self.scrollView.frame = CGRectMake(0, 300, ScreenW, 270);
            self.scrollView.contentSize = CGSizeMake(ScreenW*2, 270);
            self.footerView.frame = CGRectMake(0, 300+270, ScreenW, 160);
            self.headerView.loginImgView.hidden = YES;
            self.headerView.registImgView.hidden = NO;
        }
        [self.scrollView layoutIfNeeded];
        [self.footerView layoutIfNeeded];
    }
}



/**
 第三方登录
 */
- (void)thirdBtnClick:(UIButton *)btn{
    if (btn == self.footerView.zhifubaoBtn) {
        LxmAlipayAuthInfoModel *model = [LxmAlipayAuthInfoModel new];
        model.appID = @"2019121769968589";
        model.pid =   @"2088731024827837";
        NSString *info = [model getInfoStr];
        [[AlipaySDK defaultService] auth_V2WithInfo:info fromScheme:@"com.biuwork.xckj.alipayLogin" callback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
        }];
    }else if (btn == self.footerView.wechatBtn){
        [self getAuthWithUserInfoFromWechat];
    }else{
        [self getAuthWithUserInfoFromApple];
    }
}

- (void)getAuthWithUserInfoFromApple {
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc]init];
        ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *auth = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
        auth.delegate = self;
        auth.presentationContextProvider = self;
        [auth performRequests];
    } else {
    }
}

///代理主要用于展示在哪里
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return UIApplication.sharedApplication.delegate.window;
}


-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
        if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
            // 用户登录使用ASAuthorizationAppleIDCredential
            ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
            NSString *user = appleIDCredential.user;
            // 使用过授权的，可能获取不到以下三个参数
            NSString *familyName = appleIDCredential.fullName.familyName;
            NSString *givenName = appleIDCredential.fullName.givenName;
            NSString *email = appleIDCredential.email;
            
            NSData *identityToken = appleIDCredential.identityToken;
            NSData *authorizationCode = appleIDCredential.authorizationCode;
            
            // 服务器验证需要使用的参数
            NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
            NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
            NSLog(@"%@\n\n%@", identityTokenStr, authorizationCodeStr);

        }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
            
            //// Sign in using an existing iCloud Keychain credential.
            ASPasswordCredential *pass = authorization.credential;
            NSString *username = pass.user;
            NSString *passw = pass.password;
            
        }
    
}

///回调失败
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"%@",error);
}


//QQ登录
- (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            LxmThirdInfoModel * info = [[LxmThirdInfoModel alloc] init];
            info.threeId = resp.uid;
            info.threeName = resp.name;
            info.headimg = resp.iconurl;
            info.type = 3;
            [self loadWithThirdInfo:info];
            
//            // 授权信息
//            NSLog(@"QQ uid: %@", resp.uid);
//            NSLog(@"QQ openid: %@", resp.openid);
//            NSLog(@"QQ unionid: %@", resp.unionId);
//            NSLog(@"QQ accessToken: %@", resp.accessToken);
//            NSLog(@"QQ expiration: %@", resp.expiration);
//
//            // 用户信息
//            NSLog(@"QQ name: %@", resp.name);
//            NSLog(@"QQ iconurl: %@", resp.iconurl);
//            NSLog(@"QQ gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
        }
    }];
}


// 微信登录
#import <UMShare/UMShare.h>

- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            LxmThirdInfoModel * info = [[LxmThirdInfoModel alloc] init];
            info.threeId = resp.uid;
            info.threeName = resp.name;
            info.headimg = resp.iconurl;
            info.type = 2;
            [self loadWithThirdInfo:info];
        }
    }];
}



- (void)zhiFuBaoNoti:(NSNotification *)noti{
    NSDictionary *resultDic = noti.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        //用户取消支付
        [SVProgressHUD showErrorWithStatus:@"用户取消了授权"];
        
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        
        [SVProgressHUD showSuccessWithStatus:@"授权成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *parmasArr = [resultDic[@"result"] componentsSeparatedByString:@"&"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *parma in parmasArr) {
                NSArray *tempArr = [parma componentsSeparatedByString:@"="];
                if (tempArr.count == 2) {
                    [dict setObject:tempArr.lastObject forKey:tempArr.firstObject];
                }
            }
            if ([dict[@"result_code"] isEqualToString:@"200"]) {
                //auth_code表示授权成功的授码。
                NSString * str = dict[@"auth_code"];
                [self getThirdInfoDataWithAuthCode:str];
                                  
            }else if ([dict[@"result_code"] isEqualToString:@"1005"]){
                [SVProgressHUD showErrorWithStatus:@"账户已冻结"];
             }
        });
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
        [SVProgressHUD showErrorWithStatus:@"系统异常"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"授权失败"];
    }
}

- (void)loadWithThirdInfo:(LxmThirdInfoModel *)info{
    NSDictionary * dict = @{
                            @"type":@(info.type),
                            @"threeId":info.threeId,
                            @"threeName":info.threeName,
                            @"headimg":info.headimg,
                            };
    [LxmNetworking networkingPOST:[LxmURLDefine app_three_login] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue]==1) {
            [LxmTool ShareTool].loginType = [NSString stringWithFormat:@"%ld",(long)info.type];
            [LxmTool ShareTool].isLogin=YES;
            [LxmTool ShareTool].session_token=[[responseObject objectForKey:@"result"] objectForKey:@"token"];
            [[LxmTool ShareTool] uploadDeviceToken];
            self.headerImg = info.headimg;
            self.nameStr = info.threeName;
            self.tenceID = info.threeId;
            [self loadHasPerfect];
        } else if ([[responseObject objectForKey:@"key"] intValue]==10003) {
            [LxmTool ShareTool].isLogin=NO;
            [LxmTool ShareTool].session_token = nil;
        } else if ([[responseObject objectForKey:@"key"] intValue]==7) {
            [LxmTool ShareTool].isLogin=NO;
            [LxmTool ShareTool].session_token = nil;
        } else if ([[responseObject objectForKey:@"key"] intValue]==10001) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"您还没有注册，请先注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if ([[responseObject objectForKey:@"key"] intValue]==10006) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"账号或密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)getThirdInfoDataWithAuthCode:(NSString *)code{
    NSDictionary * dict = @{
                            @"type":@1,
                            @"code":code
                            };
    [LxmNetworking networkingPOST:[LxmURLDefine app_three_login] parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [LxmTool ShareTool].loginType = @"1";
            [LxmTool ShareTool].isLogin=YES;
            [LxmTool ShareTool].session_token=[[responseObject objectForKey:@"result"] objectForKey:@"token"];
            [[LxmTool ShareTool] uploadDeviceToken];
            self.headerImg = responseObject[@"result"][@"headimg"];
            self.nameStr = responseObject[@"result"][@"threeName"];
            [LxmTool ShareTool].thirdInfoModel = [LxmThirdInfoModel mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            [self loadHasPerfect];
            
        } else if ([[responseObject objectForKey:@"key"] intValue] == 10003){
            [LxmTool ShareTool].isLogin=NO;
            [LxmTool ShareTool].session_token = nil;
        } else if ([[responseObject objectForKey:@"key"] intValue] == 7){
            [LxmTool ShareTool].isLogin=NO;
            [LxmTool ShareTool].session_token = nil;
        } else if ([[responseObject objectForKey:@"key"] intValue] == 10001) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"您还没有注册，请先注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else if ([[responseObject objectForKey:@"key"] intValue]==10006) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"账号或密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
