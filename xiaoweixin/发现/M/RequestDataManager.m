//
//  RequestDataManager.m
//  xiaoweixin
//
//  Created by chenlishuang on 17/5/14.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import "RequestDataManager.h"
#import <AFNetworking.h>
#import "FriendModel.h"
@implementation RequestDataManager
+ (instancetype)sharedRequestData{
    static RequestDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [RequestDataManager new];
        }
    });
    return manager;
}

- (void)requestDataSuccess:(void(^)(NSArray *array))success{
    NSMutableArray *dataArray = [NSMutableArray array];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSArray *arr = dic[@"list"];
        
        for (NSDictionary *d in arr) {
            FriendModel *model = [FriendModel new];
            [model setValuesForKeysWithDictionary:d];
            [dataArray addObject:model];
        }
//        NSLog(@"%@",responseObject);
        success(dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
