//
//  GoodsDetailVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/16.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmLiuYanView.h"

typedef NS_ENUM(NSInteger){
    GoodsDetailVC_type_goodsDetail,
    GoodsDetailVC_type_ableDetail,
    GoodsDetailVC_type_myJineng
}GoodsDetailVC_type;

@interface GoodsDetailVC : BaseTableViewController

@property (nonatomic, assign) BOOL isyouke;
@property (nonatomic , strong) LxmCanListModel * model;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(GoodsDetailVC_type)type;
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

