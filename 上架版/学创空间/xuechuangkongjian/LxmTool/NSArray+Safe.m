//
//  NSArray+Safe.m
//  xuechuangkongjian
//
//  Created by 李晓满 on 2020/2/18.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "NSArray+Safe.h"


@implementation NSArray (Safe)

- (id)lxm_object1AtIndex:(NSInteger)index {
    if (index >= 0 && index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end

@implementation NSMutableArray (Safe)

- (void)lxm_add1Object:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

@end


@implementation NSDictionary (Safe)

- (id)lxm_object1ForKey:(id)aKey {
    if (aKey) {
        return [self objectForKey:aKey];
    }
    return nil;
}

@end

@implementation NSMutableDictionary (Safe)

- (void)lxm_set1Object:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
