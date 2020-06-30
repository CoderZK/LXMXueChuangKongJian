//
//  LxmBindPhoneVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmBindPhoneVC : BaseTableViewController
@property (nonatomic , copy)void(^refreshPreVC)(void);
@end

@interface LxmBindPutinView : UIView
@property (nonatomic , strong)UITextField * leftTF;
@property (nonatomic , strong)UIButton * rightBtn;
@end
