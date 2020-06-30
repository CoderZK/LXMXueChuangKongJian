//
//  XckjLvAndPaiMaiDetailVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface XckjLvAndPaiMaiDetailVC : BaseTableViewController
@property (nonatomic , copy)void(^refreshMineCollection)(void);
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style typeModel:(LxmArticleModel *)model type:(NSNumber *)typeID;
@property (strong , nonatomic) NSString *textId;
@end
