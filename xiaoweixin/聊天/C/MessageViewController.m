//
//  ConversationViewController.m
//  xiaoweixin
//
//  Created by chenlishuang on 2017/8/17.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import <Masonry.h>
#import <RongIMLib/RongIMLib.h>
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,RCIMClientReceiveMessageDelegate>{
    int _index;
}
@property(nonatomic,strong)NSMutableArray * messages;/** 消息模型  */
/** 输入view*/
@property (nonatomic,strong)UIImageView *inputView;
/** tableView*/
@property (nonatomic,strong)UITableView *tableView;
/** 语音按钮*/
@property (nonatomic,strong)UIButton *soundButton;
/** 加号按钮*/
@property (nonatomic,strong)UIButton *upButton;
/** 表情按钮*/
@property (nonatomic,strong)UIButton *emotionButton;
/** 输入框*/
@property (nonatomic,strong)UITextField *inputTextField;
@end

@implementation MessageViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
}
- (void)initViews{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.right.equalTo(self.tableView.mas_right);
        make.bottom.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(@44);
    }];
    
    [self.inputView addSubview:self.soundButton];
    [self.soundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.inputView);
        make.left.equalTo(self.inputView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.inputView addSubview:self.upButton];
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.inputView);
        make.right.equalTo(self.inputView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.inputView addSubview:self.emotionButton];
    [self.emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.inputView);
        make.right.equalTo(self.upButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.inputView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.bottom.equalTo(@-5);
        make.left.equalTo(self.soundButton.mas_right);
        make.right.equalTo(self.emotionButton.mas_left);
    }];
    
}

- (void)keyboardNotification:(NSNotification *)notification{
    //取出键盘弹出或者退出的frame
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //坐标是从(0,0)开始的;
    CGFloat margin = frame.origin.y - self.view.frame.size.height;
    self.view.transform = CGAffineTransformMakeTranslation(0, margin);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _index += 1;
    static NSString *messageCell = @"messageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCell];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCell];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.messageModel = self.messages[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_index) {
        [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    }
    MessageModel * message = self.messages[indexPath.row];
    return message.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.messages[indexPath.row];
    return model.cellHeight;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma maek - UITextFieldDelegate代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if ([textField.text isEqualToString:@""]) {
//        return YES;
//    }
    

    // 构建消息的内容，这里以文本消息为例。
    RCTextMessage *testMessage = [RCTextMessage messageWithContent:textField.text];
    // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:@"003"
                                       content:testMessage
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                           dispatch_sync(dispatch_get_main_queue(), ^{
                                               MessageModel *model = [[MessageModel alloc]init];
                                               model.text = textField.text;
                                               model.type = MessageTypeMe;
                                               [self.messages addObject:model];
                                               
                                               NSInteger lastRow = self.messages.count - 1;
                                               NSIndexPath * lastIndexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
                                               //手动创建cell
                                               [self tableView:self.tableView cellForRowAtIndexPath:lastIndexPath];
                                               [self.tableView insertRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                                               // 滚动tableview到指定的Cell 的那个位置UITableViewScrollPositionBottom Cell的地底部
                                               [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                               //    [self.tableView reloadData];
                                               self.inputTextField.text = @"";
                                               
                                           });
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                           NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                                       }];
    
    return YES;
}
#pragma mark - 接收消息的回调
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param nLeft       还剩余的未接收的消息数，left>=0
 @param object      消息监听设置的key值
 
 @discussion 如果您设置了IMlib消息监听之后，SDK在接收到消息时候会执行此方法。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 object为您在设置消息接收监听时的key值。
 */
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            MessageModel *model = [[MessageModel alloc]init];
            model.text = testMessage.content;
            model.type = MessageTypeOther;
            [self.messages addObject:model];
            
            NSInteger lastRow = self.messages.count - 1;
            NSIndexPath * lastIndexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            //手动创建cell
            [self tableView:self.tableView cellForRowAtIndexPath:lastIndexPath];
            [self.tableView insertRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            // 滚动tableview到指定的Cell 的那个位置UITableViewScrollPositionBottom Cell的地底部
            [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //    [self.tableView reloadData];
            self.inputTextField.text = @"";
        });
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}
#pragma mark - 懒加载
- (NSMutableArray *)messages{
    if (!_messages) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil];
        NSArray * arr = [NSArray arrayWithContentsOfFile:path];
        NSLog(@"%@",arr);
        NSMutableArray * tempArr = [NSMutableArray array];
        MessageModel * lastModel = nil;
        for (NSDictionary * dict in arr) {
            MessageModel * message = [MessageModel messageWithDict:dict];
            message.hiddenTime = [message.time isEqualToString:lastModel.time];
            //储存上一次模型
            lastModel = message;
            [tempArr addObject:message];
        }
        _messages = tempArr ;
    }
    return _messages;
}
- (UIImageView *)inputView{
    if (!_inputView) {
        _inputView = [[UIImageView alloc]init];
        _inputView.image = [UIImage imageNamed:@"chat_bottom_bg"];
        _inputView.userInteractionEnabled = YES;
    }
    return _inputView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)soundButton{
    if (!_soundButton) {
        _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundButton setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_soundButton setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [_soundButton addTarget:self action:@selector(soundButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soundButton;
}

- (UIButton *)upButton{
    if (!_upButton) {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_upButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
    }
    return _upButton;
}

- (UIButton *)emotionButton{
    if (!_emotionButton) {
        _emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emotionButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_emotionButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
    }
    return _emotionButton;
}

- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]init];
        [_inputTextField setBackground:[UIImage imageNamed:@"chat_bottom_textfield"]];
        //占位view
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
        _inputTextField.leftView = view;
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}
- (void)soundButtonAction{
    NSLog(@"发声音");
}
@end
