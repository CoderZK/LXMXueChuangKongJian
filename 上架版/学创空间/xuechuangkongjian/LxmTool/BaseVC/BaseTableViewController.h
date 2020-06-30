//
//  BaseTableViewController.h
//  ShareGo
//
//  Created by 李晓满 on 16/4/7.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

-(instancetype)initWithTableViewStyle:(UITableViewStyle)style;

@property(nonatomic,strong,readonly)UITableView * tableView;

- (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize;
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

//分享
- (void)shareWeChatTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock;
- (void)shareWXPYQTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock;
- (void)shareQQTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock;
- (void)shareZFBTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock;


@end
