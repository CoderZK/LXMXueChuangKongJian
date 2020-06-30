//
//  zkPickModel.h
//  QYZJAPP
//
//  Created by zk on 2019/11/5.
//  Copyright © 2019 kunzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface zkPickModel : NSObject
@property(nonatomic,strong)NSString *pname;
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)NSMutableArray<zkPickModel *> *cityList;
@property(nonatomic,strong)NSString *cname;
@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSMutableArray<zkPickModel *> *areaList;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString*ID;
@property(nonatomic,strong)NSString*proId;


@end

NS_ASSUME_NONNULL_END
