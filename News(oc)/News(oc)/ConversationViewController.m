//
//  ConversationViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/21.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ConversationViewController
{
    NSInteger pageNum;
    
    NSArray *hotArray;
    
    NSArray *normalArray;
    
    NSDictionary *normalInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageNum = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getHotInfo];
    [self getNormalInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getHotInfo
{
    NSString *urlString = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2",self.replyBoard,self.postid];
    HttpTool *tool = [[HttpTool alloc] init];
    tool.handlerBlock = ^(NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary *hotInfo = (NSDictionary *)response;
        hotArray = [hotInfo objectForKey:@"hotPosts"];
        [_tableView reloadData];
    };
    [tool getConversationWithUrl:urlString];
}

- (void)getNormalInfo
{
    NSString *urlString = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/normal/%@/%@/desc/%ld/10/10/2/2",self.replyBoard,self.postid,pageNum];
    HttpTool *tool = [[HttpTool alloc] init];
    tool.handlerBlock = ^(NSData *data,NSURLResponse *response,NSError *error){
        normalInfo = (NSDictionary *)response;
        normalArray = [normalInfo objectForKey:@"newPosts"];
        [_tableView reloadData];
    };
    [tool getConversationWithUrl:urlString];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return hotArray.count;
    }
    return normalArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-20, 5, 100, 40)];
    UIImage *contentImage = [UIImage imageNamed:@"contentview_commentbacky.png"];
    contentImage = [contentImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 20, 20, 20)];
    [button setBackgroundImage:contentImage forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    if (section == 0) {
        [button setTitle:@"热门跟帖" forState:UIControlStateNormal];
    }
    [button setTitle:@"最新跟帖" forState:UIControlStateNormal];
    [headerView addSubview:button];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    NSDictionary *tempDic;
    if (indexPath.section == 0) {
        tempDic = [hotArray objectAtIndex:indexPath.row];
    }else{
        tempDic = [normalArray objectAtIndex:indexPath.row];
    }
    NSString *imgURLStr = [[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"timg"];
    if (imgURLStr) {
        [cell.potraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURLStr] forState:UIControlStateNormal];
    }
    [cell.nameButton setTitle:[[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"n"] forState:UIControlStateNormal];
    cell.addressLabel.text = [[[[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"f"] componentsSeparatedByString:@"&"] firstObject];
    cell.articleLabel.text = [[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"b"];
    return cell;
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
