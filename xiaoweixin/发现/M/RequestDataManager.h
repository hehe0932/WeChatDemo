//
//  RequestDataManager.h
//  xiaoweixin
//
//  Created by chenlishuang on 17/5/14.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestDataManager : NSObject
+ (instancetype)sharedRequestData;
- (void)requestDataSuccess:(void(^)(NSArray *array))succes;
@end
