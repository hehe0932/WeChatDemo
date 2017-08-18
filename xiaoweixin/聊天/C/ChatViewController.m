//
//  ChatViewController.m
//  xiaoweixin
//
//  Created by chenlishuang on 17/5/13.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageViewController.h"
#import "RequestDataManager.h"
#import "FriendModel.h"
#import <UIImageView+WebCache.h>
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableVeiw*/
@property (nonatomic,strong)UITableView *tableView;
/** 数据*/
@property (nonatomic,strong)NSArray *dataArray;

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

    [[RequestDataManager sharedRequestData]requestDataSuccess:^(NSArray *array) {
        self.dataArray = array;
        [self.tableView reloadData];
    }];
    //先选第一个
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
}

- (void)rightItemAction {
    NSLog(@"添加");
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    FriendModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.text;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image]placeholderImage:[UIImage imageNamed:@"game_tag_icon"]];
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
