//
//  SNYQRCodeVC.h
//  suzhouIOS
//
//  Created by sny on 15/12/9.
//  Copyright © 2015年 sny. All rights reserved.
//

#import "BaseViewController.h"

@protocol SNYQRCodeVCDelegate;
@interface SNYQRCodeVC : BaseViewController
@property(nonatomic,assign)id<SNYQRCodeVCDelegate>delegate;
@end

@protocol SNYQRCodeVCDelegate <NSObject>

-(void)SNYQRCodeVC:(SNYQRCodeVC *)vc scanResult:(NSString *)str;

@end