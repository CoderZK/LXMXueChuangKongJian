//
//  LxmTool.h
//  emptyCityNote
//
//  Created by 李晓满 on 2017/11/22.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LxmMagModel.h"
#import "LxmEventBus.h"
#import "NSArray+Safe.h"

#define ISLOGIN [LxmTool ShareTool].isLogin
#define SESSION_TOKEN [LxmTool ShareTool].session_token

#define WeakObj(_obj)    __weak typeof(_obj) _obj##Weak = _obj;
//iPhoneX iPhoneXS CGSizeMake(375, 812), iPhoneXR iPhoneXs max CGSizeEqualToSize(CGSizeMake(414, 896)
#define kDevice_Is_iPhoneX (CGSizeEqualToSize(CGSizeMake(375, 812), UIScreen.mainScreen.bounds.size) || CGSizeEqualToSize(CGSizeMake(414, 896), UIScreen.mainScreen.bounds.size))
//屏幕的长宽
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define StateBarH [UIApplication sharedApplication].statusBarFrame.size.height

//文字三种颜色
#define CharacterDarkColor [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1]
#define CharacterGrayColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
#define CharacterLightGrayColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

//背景两种颜色
#define BGGrayColor [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]
#define BGWhiteColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]

//辅助色
#define  LinghtRedColor [UIColor colorWithRed:238/255.0 green:74/255.0 blue:38/255.0 alpha:1]
#define  RedColor [UIColor colorWithRed:254/255.0 green:89/255.0 blue:96/255.0 alpha:1]
#define  BlueColor [UIColor colorWithRed:0/255.0 green:130/255.0 blue:255/255.0 alpha:1]
#define  OrRedColor [UIColor colorWithRed:241/255.0 green:144/255.0 blue:76/255.0 alpha:1]
#define  GreenColor [UIColor colorWithRed:96/255.0 green:192/255.0 blue:32/255.0 alpha:1]
#define  YellowColor [UIColor colorWithRed:240/255.0 green:147/255.0 blue:68/255.0 alpha:1]

//分割线
#define  LineColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]
//
/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}


@interface LxmTool : NSObject
+(LxmTool *)ShareTool;

@property (nonatomic,strong)LxmUserInfoModel * userModel;
@property (nonatomic,strong)LxmThirdInfoModel * thirdInfoModel;
@property(nonatomic,assign)bool isLogin;
@property(nonatomic,strong)NSString * session_uid;
@property(nonatomic,strong)NSString * session_token;
@property(nonatomic,strong)NSString * hasPerfect;
@property(nonatomic,strong)NSString * commentStr;
@property(nonatomic,strong)NSString * loginType;
//推送token
@property(nonatomic,strong)NSString * deviceToken;
-(void)uploadDeviceToken;

@property (nonatomic, readonly) BOOL isShenHe;


@property(nonatomic,strong)NSString * xiaDanName;
@property(nonatomic,strong)NSString * xiaDanPhone;
@property(nonatomic,strong)NSString * xiaDanAddress;


@end
