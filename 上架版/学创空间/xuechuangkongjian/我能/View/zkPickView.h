//
//  zkPickView.h
//  QYZJAPP
//
//  Created by zk on 2019/11/5.
//  Copyright © 2019 kunzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    NormalArray,// 取出 zkpickModel 的名字
    titleArray,//单列标题
    AreaArray,//地区不限
    AreaArrayTwo,//地区和城市不限
    ArerArrayNormal,//正常三列城市
    titleArrWithArr//根据数组返回列数
};

@protocol zkPickViewDelelgate <NSObject>

- (void)didSelectLeftIndex:(NSInteger)leftIndex centerIndex:(NSInteger)centerIndex rightIndex:(NSInteger )rightIndex;

@end

@interface zkPickView : UIView
@property (nonatomic, assign) ARRAYTYPE arrayType;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)UILabel *selectLb;
@property(nonatomic,assign)id<zkPickViewDelelgate>delegate;
- (void)show;
- (void)diss;

@end

NS_ASSUME_NONNULL_END
