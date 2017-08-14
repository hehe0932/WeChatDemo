//
//  FindTableViewController.m
//  xiaoweixin
//
//  Created by chenlishuang on 16/9/13.
//  Copyright © 2016年 chenlishuang. All rights reserved.
//

#import "FindTableViewController.h"
#import "FriendTableViewController.h"
#import "ScanViewController.h"
@interface FindTableViewController ()
@property (nonatomic,weak)NSArray *cellTitleArray;
@property (nonatomic,weak)NSArray *cellImageArray;
@end

@implementation FindTableViewController
- (NSArray *)cellTitleArray{
    if (!_cellTitleArray) {
        _cellTitleArray = [NSArray arrayWithObjects:@[@"朋友圈"],@[@"扫一扫",@"摇一摇"],@[@"附近的人",@"漂流瓶"],@[@"购物",@"游戏"], nil];
    }
    return _cellTitleArray;
}
- (NSArray *)cellImageArray{
    if (!_cellImageArray) {
        _cellImageArray = [NSArray arrayWithObjects:@[@"ff_IconShowAlbum"],@[@"ff_IconQRCode",@"ff_IconShake"],@[@"ff_IconLocationService",@"ff_IconBottle"],@[@"CreditCard_ShoppingBag",@"MoreGame"], nil];
    }
    return _cellImageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"findCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.cellTitleArray[section];
    
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"findCell"];
    }
    cell.textLabel.text = self.cellTitleArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.cellImageArray[indexPath.section][indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        FriendTableViewController *friendsVC= [[FriendTableViewController alloc]init];
        [self.navigationController pushViewController:friendsVC animated:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            ScanViewController *scanVC = [ScanViewController new] ;
            [self.navigationController pushViewController:scanVC animated:YES];
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
