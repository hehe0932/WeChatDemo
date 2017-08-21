//
//  MessageCell.m
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/17.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "MessageCell.h"
#import <Masonry.h>

@interface MessageCell()
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UIButton *contentLabel;
@property (strong, nonatomic)UIImageView *iconImage;
@property (strong, nonatomic)UIImageView *otherIconImage;
@property (strong, nonatomic)UIButton *otherContentLabel;
@end
@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initViews{
//    self.timeLabel = [[UILabel alloc]init];
//    self.timeLabel.text = @"111";
////    self.timeLabel.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:self.timeLabel];
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(10);
//        make.centerX.equalTo(self.contentView);
//    }];
    
    self.otherIconImage = [[UIImageView alloc]init];
    self.otherIconImage.backgroundColor = [UIColor lightGrayColor];
    self.otherIconImage.image = [UIImage imageNamed:@"game_tag_icon"];
    [self.contentView addSubview:self.otherIconImage];
    [self.otherIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    self.iconImage.backgroundColor = [UIColor lightGrayColor];
    self.iconImage.image = [UIImage imageNamed:@"xhr"];
    [self.contentView addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.otherContentLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.otherContentLabel.titleLabel.numberOfLines = 0;
    self.otherContentLabel.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.otherContentLabel setBackgroundImage:[UIImage resizebleImageNamed:@"ReceiverTextNodeBkg"] forState:UIControlStateNormal];
    [self.otherContentLabel setBackgroundImage:[UIImage resizebleImageNamed:@"ReceiverTextNodeBkgHL"] forState:UIControlStateHighlighted];
    [self.otherContentLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.otherContentLabel];

    [self.otherContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.otherIconImage.mas_right).offset(10);
        make.top.equalTo(self.otherIconImage).offset(10);
        make.width.lessThanOrEqualTo(@200);
        make.width.greaterThanOrEqualTo(@50);
    }];
    
    self.contentLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.contentLabel.titleLabel.numberOfLines = 0;
    self.contentLabel.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentLabel setBackgroundImage:[UIImage resizebleImageNamed:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
    [self.contentLabel setBackgroundImage:[UIImage resizebleImageNamed:@"SenderTextNodeBkgHL"] forState:UIControlStateHighlighted];
    [self.contentLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImage.mas_left).offset(-10);
        make.top.equalTo(self.iconImage).offset(10);
        make.width.lessThanOrEqualTo(@200);
        make.width.greaterThanOrEqualTo(@50);
    }];
    
}

- (void)setMessageModel:(MessageModel *)messageModel{
    _messageModel = messageModel;
    
//    self.timeLabel.hidden = messageModel.isHiddenTime;
//    if (messageModel.isHiddenTime) {
//        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//    }else{
//        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@20);
//        }];
//    }
    
//    self.timeLabel.text = messageModel.time;
    
    if (messageModel.type == MessageTypeMe) {
        [self settingShowContent:self.contentLabel showIcon:self.iconImage hiddenConten:self.otherContentLabel hiddenIcon:self.otherIconImage];
    }else{
        [self settingShowContent:self.otherContentLabel showIcon:self.otherIconImage hiddenConten:self.contentLabel hiddenIcon:self.iconImage];
    }
}

-(void)settingShowContent:(UIButton *)showContent showIcon:(UIImageView *)showIcon hiddenConten:(UIButton *)hiddenConten hiddenIcon:(UIImageView *)hiddenIcon
{
    [showContent setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 5, 10)];
    showContent.hidden = NO;
    showIcon.hidden = NO;
    hiddenConten.hidden = YES;
    hiddenIcon.hidden = YES;
    
    [showContent setTitle:self.messageModel.text forState:UIControlStateNormal];
    //重新布局
    [showContent layoutIfNeeded];

    CGFloat labelHeight = showContent.titleLabel.frame.size.height;
    
    [showContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(labelHeight + 30);
    }];

    [showContent layoutIfNeeded];
    CGFloat iconMaxY = 60;
    CGFloat contentMaxY = 20 + showContent.titleLabel.height + 15;
    CGFloat margin = 10;
    _messageModel.cellHeight = MAX(iconMaxY, contentMaxY) + margin;
}
@end
