//
//  MessageModel.h
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/17.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,MessageType) {
    MessageTypeMe = 0,
    MessageTypeOther = 1
};
@interface MessageModel : NSObject
/** cell高度 */
@property(assign,nonatomic)CGFloat cellHeight;
/** 聊天内容 */
@property(copy,nonatomic)NSString * text;
/** 时间 */
@property(copy,nonatomic)NSString * time;
/** 类型 */
@property(assign,nonatomic)MessageType type;
/** 隐藏time */
@property(assign,nonatomic,getter=isHiddenTime)BOOL hiddenTime;
+(instancetype)messageWithDict:(NSDictionary *)dict;
@end
