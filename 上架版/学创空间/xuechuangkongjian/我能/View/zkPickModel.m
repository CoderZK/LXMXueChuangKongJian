//
//  zkPickModel.m
//  QYZJAPP
//
//  Created by zk on 2019/11/5.
//  Copyright © 2019 kunzhang. All rights reserved.
//

#import "zkPickModel.h"

@implementation zkPickModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (void)setCityList:(NSMutableArray<zkPickModel *> *)cityList {
    _cityList = [zkPickModel mj_objectArrayWithKeyValuesArray:cityList];
}
- (void)setAreaList:(NSMutableArray<zkPickModel *> *)areaList {
    _areaList = [zkPickModel mj_objectArrayWithKeyValuesArray:areaList];
}
@end
