//
//  LxmWebViewController.h
//  zhima
//
//  Created by lxm on 14/11/19.
//  Copyright (c) 2014年 lxm. All rights reserved.
//
#import "BaseViewController.h"

#define PregressColor MainColor

@interface LxmWebViewController: BaseViewController
@property(nonatomic,strong)NSURL * loadUrl;
@property(nonatomic,strong)NSString * postParames;
-(void)loadHtmlStr:(NSString *)htmlStr withBaseUrl:(NSString *)urlStr;
@end
