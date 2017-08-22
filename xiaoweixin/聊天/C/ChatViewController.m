//
//  ChatViewController.m
//  xiaoweixin
//
//  Created by chenlishuang on 17/5/13.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageViewController.h"
#import <RongIMLib/RongIMLib.h>
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableVeiw*/
@property (nonatomic,strong)UITableView *tableView;

@end


@implementation ChatViewController
- (void)loadView{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.view = self.tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barbuttonicon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItme;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    //先选第一个
//    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self tableView:self.tableView didSelectRowAtIndexPath:path];
   NSArray *arr = [[RCIMClient sharedRCIMClient]getLatestMessages:ConversationType_PRIVATE targetId:@"003" count:99];
    for (RCMessage *message in arr) {
        NSLog(@"消息~%@",message.targetId);
    }
    
}

- (void)rightItemAction {
    NSLog(@"添加");
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"003";
    cell.detailTextLabel.text = @"消息内容";
    cell.imageView.image = [UIImage imageNamed:@"xhr"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
}
@end
