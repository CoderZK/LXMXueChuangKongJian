//
//  PublishDanVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PublishDanVC : BaseTableViewController

@property (strong, nonatomic) UIViewController *backViewController;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style LxmHomeBannerModel:(LxmHomeBannerModel *)model;
@end

@protocol LxmPublishImgViewDelegate;
@interface LxmPublishImgView : UIView
@property (nonatomic , weak)id<LxmPublishImgViewDelegate>delegate;
@property (nonatomic,strong)UILabel * maxLab;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)NSMutableArray *imgs;
@property (nonatomic,strong)UIButton *switchBtn;
@property (nonatomic,strong)UILabel * nimingLab;

@end

@protocol LxmPublishImgViewDelegate<NSObject>
- (void)LxmPublishImgView:(LxmPublishImgView *)imgView deleteAtIndex:(NSInteger)index;

@end


@protocol LxmLeftLabRightNumViewDelegate;
@interface LxmLeftLabRightNumView : UIView
@property (nonatomic,strong) UILabel * textlab;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic , strong) UIView * numView;
@property (nonatomic , strong) UIButton * desBtn;
@property (nonatomic , strong) UITextField * numTF;
@property (nonatomic , strong) UIButton * incBtn;
@property (nonatomic , weak)id<LxmLeftLabRightNumViewDelegate>delegate;
@property(nonatomic , assign)BOOL isFloat;
@end
@protocol LxmLeftLabRightNumViewDelegate<NSObject>
- (void)jiaJianClick;
@end

