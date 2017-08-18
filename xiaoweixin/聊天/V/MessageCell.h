//
//  MessageCell.h
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/17.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageCell : UITableViewCell
/** 消息模型*/
@property (nonatomic,strong)MessageModel *messageModel;
@end
