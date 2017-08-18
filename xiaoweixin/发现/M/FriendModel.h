//
//  FriendModel.h
//  xiaoweixin
//
//  Created by chenlishuang on 17/5/14.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *profile_image;
@property (nonatomic,strong)NSString *text;
@property (nonatomic,weak)NSString *image0;
@property (nonatomic,assign)NSInteger height;
@end
