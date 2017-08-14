//
//  FriendTableViewCell.h
//  xiaoweixin
//
//  Created by chenlishuang on 16/9/14.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendModel;
@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (assign, nonatomic) NSInteger cellHeight;

@property (strong,nonatomic)FriendModel *model;
@end
