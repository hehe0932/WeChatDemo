//
//  FriendTableViewCell.m
//  xiaoweixin
//
//  Created by chenlishuang on 17/5/14.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import "FriendTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "FriendModel.h"
@implementation FriendTableViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(FriendModel *)model{
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image]];
    self.profileImageView.layer.cornerRadius = 25;
    self.profileImageView.layer.masksToBounds = YES;
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.text;
    self.cellHeight = model.height;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.image0]];
}

@end
