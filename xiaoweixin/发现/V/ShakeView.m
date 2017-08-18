//
//  ShakeView.m
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/14.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ShakeView.h"

@interface ShakeView()
/** 背景图*/
@property (nonatomic,strong)UIImageView *backView;
@end
@implementation ShakeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAllViews];
    }
    return self;
}
- (void)initAllViews{
    self.backgroundColor = [UIColor colorWithRed:0.16 green:0.18 blue:0.18 alpha:1.00];
    
    self.backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ShakeHideImg_women"]];
    self.backView.center = self.center;
    self.backView.centerY += 10;
    [self addSubview:self.backView];

    UIImage *upImage = [UIImage imageNamed:@"Shake_Logo_Up"];
    UIImageView *upImageView = [[UIImageView alloc]initWithImage:upImage];
    
    upImageView.frame = CGRectMake((ScreenWidth - upImage.size.width) * 0.5, ScreenHeight * 0.5  - upImage.size.height, upImage.size.width, upImage.size.height);
    
    UIImage *downImage = [UIImage imageNamed:@"Shake_Logo_Down"];
    UIImageView *downImageView = [[UIImageView alloc]initWithImage:downImage];
    
    downImageView.frame = CGRectMake((ScreenWidth - downImage.size.width) * 0.5, CGRectGetMaxY(upImageView.frame), downImage.size.width, downImage.size.height);
    
    UIImageView *upLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shake_Line_Up"]];
    upLine.frame = CGRectMake(0, CGRectGetMaxY(upImageView.frame), ScreenWidth, 5);
    
    UIImageView *downLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shake_Line_Down"]];
    downLine.frame = CGRectMake(0, downImageView.frame.origin.y - 5, ScreenWidth, 5);
    
    upLine.hidden = YES;
    downLine.hidden = YES;
    
    [self addSubview:upImageView];
    [self addSubview:downImageView];
    
    [self addSubview:upLine];
    [self addSubview:downLine];
}
@end
