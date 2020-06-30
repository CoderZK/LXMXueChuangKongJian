//
//  LxmAroundVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmStarImgView.h"

typedef NS_ENUM(NSInteger){
    LxmAroundVC_type_home,
    LxmAroundVC_type_mine
    
} LxmAroundVC_type;
@interface LxmAroundVC : BaseTableViewController
@property(nonatomic , strong)BaseViewController * preVC;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmAroundVC_type)type;

@end

@interface LxmAroundCell : UITableViewCell
@property (nonatomic , strong) LxmAroundModel * model;
@end

@protocol LxmAroundBottomViewDelegate;
@interface LxmAroundBottomView : UIView
@property (nonatomic , weak) id<LxmAroundBottomViewDelegate>delegate;
@end
@protocol LxmAroundBottomViewDelegate<NSObject>
- (void)LxmAroundBottomView:(LxmAroundBottomView *)view btnAtIndex:(NSInteger)index;
@end


@interface LxmAroundBtn : UIButton
@property (nonatomic , strong) UIImageView * iconImgView;
@property (nonatomic , strong) UILabel * titleLab;
@end
