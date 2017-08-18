//
//  MessageModel.m
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/17.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+(instancetype)messageWithDict:(NSDictionary *)dict
{
    MessageModel * message = [[self alloc]init];
    [message setValuesForKeysWithDictionary:dict];
    return message;
}
@end
