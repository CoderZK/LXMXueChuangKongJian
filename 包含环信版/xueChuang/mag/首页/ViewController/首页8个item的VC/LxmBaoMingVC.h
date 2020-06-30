//
//  LxmBaoMingVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/11.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmBaoMingVC : BaseTableViewController
@property (nonatomic , strong) LxmArticleDetailModel * model;
@property (nonatomic , strong) NSNumber * articleID;
@end

@interface LxmBaoMingCell : UITableViewCell
@property (nonatomic , strong) LxmArticleDetailModel * model;
@property (nonatomic , strong) LxmMyTourListModel * detailModel;
@end

@interface LxmTextTFView1 : UIView
@property (nonatomic,strong) UILabel * textlab;
@property (nonatomic,strong) UITextField * rightTF;
@property (nonatomic,strong) UIView * lineView;
@end
