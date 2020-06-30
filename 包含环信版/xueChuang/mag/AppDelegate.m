//
//  AppDelegate.m
//  mag
//
//  Created by 李晓满 on 2018/7/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "AppDelegate.h"
#import "LxmLoginAndRegisterVC.h"
#import "TabBarController.h"
#import "BaseNavigationController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

#import "LxmFullInfoVC.h"

#import <UMPush/UMessage.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
 #import <Hyphenate/Hyphenate.h>
//http://www.biuworks.com/zentao/user-login-L3plbnRhby90ZXN0Y2FzZS1icm93c2UtMy5odG1s.html
//lixiaoman  Lxm123@
// 友盟账号 学创空间  Xuechuang@1  环信账号 MAGcampus@163.com  Xiaoyuan123
// 苹果账号 n73v3t@163.com   Aa11223344
#define UMAppkey @"5e02efa8cb23d2e76c000808"

//pid 2019121769968589
#define ZhiFuBaoAPPID @"2019121769968589"
/**微信的需生成 需要微信账号本人登录微信进行身份认证*/
#define WXAppID @"wx7f5370a9c4c1cca4"
#define WXAppSecret @"8dcf1b1ec5c02df356cb08cd8fd63707"

#define QQAppID @"1110158840"
#define QQAppKey @"fzE0e65X8hh7uMmb"

#define HuanxinAPPKey @"1162180720146041#mag"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if (ISLOGIN) {
        self.window.rootViewController = [[TabBarController alloc] init];
    } else {
        LxmLoginAndRegisterVC *vc = [[LxmLoginAndRegisterVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    [self.window makeKeyAndVisible];
    
    [self initPush];
    [self initUMeng:launchOptions];
    
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
    [self configHuanxinSDK];
    
    return YES;
}


- (void)configHuanxinSDK {
    EMOptions *options = [EMOptions optionsWithAppkey:HuanxinAPPKey];
    options.apnsCertName = @"MAG_push_dis"; // MAG_push_dev
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

- (void)configUSharePlatforms{
    
    //向微信注册,发起支付必须注册
    [WXApi registerApp:WXAppID enableMTA:YES];
    
    /* 设置微信的appKey和appSecret */
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID appSecret:QQAppID redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:ZhiFuBaoAPPID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

- (void)confitUShareSettings{
    //打开图片水印
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    //关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}


-(void)initUMeng:(NSDictionary *)launchOptions
{
    [UMConfigure initWithAppkey:UMAppkey channel:@"App Store"];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
        
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
}

-(void)initPush
{
     [UMConfigure initWithAppkey:@"59892ebcaed179694b000104" channel:@"App Store"];
    //1.向系统申请推送
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}
//在用户接受推送通知后系统会调用
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    //2.获取到deviceToken
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //将deviceToken给后台
    NSLog(@"send_token:%@",token);
    [LxmTool ShareTool].deviceToken = token;
    if (ISLOGIN) {
        NSLog(@"%@",[LxmTool ShareTool].deviceToken);
        [[LxmTool ShareTool] uploadDeviceToken];
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"com.biuwork.xckj.alipayLogin"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoLogin" object:resultDic];
            }
            
        }];
    }else if ([url.scheme isEqualToString:@"com.biuwork.xckj.alipayrenzheng"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoRenZheng" object:resultDic];
            }
            
        }];
    }else if ([url.scheme isEqualToString:@"com.biuwork.xckj.safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoPay" object:resultDic];
            }
            
        }];
        
    }else if([url.scheme isEqualToString:@"wx7f5370a9c4c1cca4"]) {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else {
        [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    NSLog(@"url.scheme : %@",url.scheme);
    
    if ([url.scheme isEqualToString:@"com.biuwork.xckj.alipayLogin"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoLogin" object:resultDic];
            }
            
        }];
    }else if ([url.scheme isEqualToString:@"com.biuwork.xckj.alipayrenzheng"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoRenZheng" object:resultDic];
            }
        }];
    }else if ([url.scheme isEqualToString:@"magzmrz"]) {
        
        NSString *encodedString = url.absoluteString;
        
        NSLog(@"encodedString : %@",[encodedString stringByRemovingPercentEncoding]);
        
        NSArray *strarray = [[encodedString stringByRemovingPercentEncoding]componentsSeparatedByString:@"&"];
        
        NSString *resultString = strarray[0];
        
        NSString *strUrl = [resultString stringByReplacingOccurrencesOfString:@"magzmrz://?biz_content=" withString:@""];
        
        NSData * datas = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"jsonDict : %@",jsonDict);
        
        if (jsonDict != nil && [(NSString *)jsonDict[@"passed"] isEqualToString:@"true"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_MINE_CHANGEUSER" object:nil];
        }
        
    }else if ([url.scheme isEqualToString:@"com.biuwork.xckj.safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
               [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoPay" object:resultDic];
            }
            
        }];
    }else if([url.scheme isEqualToString:@"wx7f5370a9c4c1cca4"]&&[url.resourceSpecifier containsString:@"//pay?"]) {
        [WXApi handleOpenURL:url delegate:self];
    }else if([url.scheme isEqualToString:@"wx7f5370a9c4c1cca4"]&&[url.resourceSpecifier containsString:@"//oauth?"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    }else{
        [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    }
    return YES;
}

-(void)onResp:(BaseResp*)resp{
    //发送一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:resp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
     [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
