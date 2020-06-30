//
//  NSArray+Safe.h
//  xuechuangkongjian
//
//  Created by 李晓满 on 2020/2/18.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Safe)
- (id)lxm_object1AtIndex:(NSInteger)index;
@end

@interface NSMutableArray (Safe)
- (void)lxm_add1Object:(id)anObject;
@end

@interface NSDictionary (Safe)
- (id)lxm_object1ForKey:(id)aKey;
@end

@interface NSMutableDictionary (safe)
- (void)lxm_set1Object:(id)anObject forKey:(id<NSCopying>)aKey;
@end

NS_ASSUME_NONNULL_END
