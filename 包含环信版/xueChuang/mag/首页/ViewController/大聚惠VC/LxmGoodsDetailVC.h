//
//  LxmGoodsDetailVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/16.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmLiuYanView.h"

typedef NS_ENUM(NSInteger){
    LxmGoodsDetailVC_type_goodsDetail,
    LxmGoodsDetailVC_type_ableDetail,
    LxmGoodsDetailVC_type_myJineng
}LxmGoodsDetailVC_type;

@interface LxmGoodsDetailVC : BaseTableViewController

@property (nonatomic, assign) BOOL isyouke;
@property (nonatomic , strong) LxmCanListModel * model;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmGoodsDetailVC_type)type;
@property (nonatomic , strong) NSNumber * billId;
@property (assign , nonatomic) BOOL isOwn;//是否是自己的技能
@end

@interface LxmGoodsDetailNavItemView : UIView
@property (nonatomic , strong) LxmGoodsDetailModel * infoModel;
@end

@interface LxmGoodsDetailTableTopView : UIView
@property (nonatomic , strong) LxmGoodsDetailModel * infoModel;
@property (nonatomic , copy) void(^zanBlock)(void);
@end


@interface LxmGoodsDetailTableBottomView : UIView
@property (nonatomic , strong) LxmLiuYanView * liuYanView;
@property (nonatomic , strong) LxmGoodsDetailModel * infoModel;
@end

@interface LxmAbleTableFooterView : UITableViewHeaderFooterView
@property (nonatomic , strong) LxmLiuYanView * liuYanView;
@property (nonatomic , strong) LxmGoodsDetailModel * infoModel;
@end

