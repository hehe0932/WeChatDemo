//
//  ShakeViewController.m
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/14.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "ShakeViewController.h"
#import "ShakeView.h"
@interface ShakeViewController ()
/** 视图*/
@property (nonatomic,strong)ShakeView *shakeView;
@end

@implementation ShakeViewController
//ShakeHideImg_women
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)loadView{
    self.shakeView = [[ShakeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.shakeView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickAction)];
    
        
    
}

- (void)clickAction {
    NSLog(@"设置");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
