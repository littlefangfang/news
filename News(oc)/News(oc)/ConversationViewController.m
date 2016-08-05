//
//  ConversationViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/21.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationView.h"

@interface ConversationViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation ConversationViewController
{
    __weak typeof (ConversationViewController *)weakSelf;
    
    NSInteger pageNum;
    
    NSArray *hotArray;
    
    NSMutableArray *normalArray;
    
    NSDictionary *normalInfo;
    
    UIActivityIndicatorView *indicatorView;
    
    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    pageNum = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, -60, 0)];
    [self getHotInfo];
    [self getNormalInfo];
    [self createTableFooterView];
    [self setLeftBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper

- (void)setLeftBarItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [button setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_back_highlighted.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -12;
    
    self.navigationItem.leftBarButtonItems = @[fixedButton, backItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        if ([normalArray count] > 0) {
            normalArray = [[normalArray arrayByAddingObjectsFromArray:[normalInfo objectForKey:@"newPosts"]] mutableCopy];
        }else{
            normalArray = [normalInfo objectForKey:@"newPosts"];
        }
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
    }else{
        [button setTitle:@"最新跟帖" forState:UIControlStateNormal];
    }
    
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
    NSInteger viewCount = [tempDic count];
    NSInteger lastH = 0;
    
    // 删除replyView中的所有view
    for (id v in cell.replyView.subviews) {
        if ([v isKindOfClass:[UIView class]]) {
            [v removeFromSuperview];
        }
    }
    
    // 计算楼中楼的每个View的frame
    for (NSInteger i = 1; i < viewCount - 1; i++) {
        NSDictionary *dic = [tempDic objectForKey:[NSString stringWithFormat:@"%ld",i]];

        if (lastH == 0) {
            if (viewCount * 3 >= 18) {
                lastH = 18;
            }else{
                lastH = viewCount * 3;
            }
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((viewCount - 2 - i) * 3, (viewCount - 2 - i) * 3, [UIScreen mainScreen].bounds.size.width - 49 - ((viewCount - 2 - i) * 2) * 3, 0)];
        
        if (view.frame.size.width <= [UIScreen mainScreen].bounds.size.width - 49 - (2 * 2) * 6) {
            CGRect frame = view.frame;
            frame.size.width = [UIScreen mainScreen].bounds.size.width - 49 - (2 * 2) * 6;
            frame.origin.y = 4 * 3;
            frame.origin.x = 4 * 3;
            view.frame = frame;
        }
        _nButton = [[UIButton alloc] initWithFrame:CGRectMake(8, lastH + 3, 250, 15)];
        if ([dic objectForKey:@"n"]) {
            [_nButton setTitle:[dic objectForKey:@"n"] forState:UIControlStateNormal];
        }else{
            [_nButton setTitle:@"火星网友" forState:UIControlStateNormal];
        }
        _nButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _nButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_nButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        _aLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, lastH + 31, 173, 12)];
        _aLabel.text = [[[dic objectForKey:@"f"] componentsSeparatedByString:@"&"] firstObject];
        _aLabel.font = [UIFont systemFontOfSize:12.0];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, lastH + 51, view.bounds.size.width - 16, 21)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.text = [dic objectForKey:@"b"];
        CGSize size = [_contentLabel sizeThatFits:CGSizeMake(_contentLabel.bounds.size.width, MAXFLOAT)];
        _contentLabel.frame = CGRectMake(8, lastH + 51, view.bounds.size.width - 16, size.height);
        
        CGRect tempFrame = view.frame;
        tempFrame.size.height = _contentLabel.frame.size.height + _contentLabel.frame.origin.y + 8;
        view.frame = tempFrame;
        
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [view addSubview:_nButton];
        [view addSubview:_aLabel];
        [view addSubview:_contentLabel];
        
        [cell.replyView setFrame:view.frame];
        
        lastH = CGRectGetMaxY(view.frame);
        
        [cell.replyView insertSubview:view aboveSubview:cell.replyView];
    }
    
    
    NSString *imgURLStr = [[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"timg"];
    if (imgURLStr) {
        [cell.potraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURLStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"covernewscell_editor_default"]];
        cell.potraitButton.layer.cornerRadius = 12.5;
        cell.potraitButton.clipsToBounds = YES;
    }else{
        [cell.potraitButton setBackgroundImage:[UIImage imageNamed:@"covernewscell_editor_default"] forState:UIControlStateNormal];
    }
    if ([[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"n"]) {
        [cell.nameButton setTitle:[[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"n"] forState:UIControlStateNormal];
    }else{
        [cell.nameButton setTitle:@"火星网友" forState:UIControlStateNormal];
    }
    
    cell.addressLabel.text = [[[[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"f"] componentsSeparatedByString:@"&"] firstObject];
    cell.articleLabel.text = [[tempDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)tempDic.count]] objectForKey:@"b"];
    CGSize size = [cell.articleLabel sizeThatFits:CGSizeMake(cell.articleLabel.bounds.size.width, MAXFLOAT)];
    cell.articleLabel.frame = CGRectMake(cell.articleLabel.frame.origin.x, cell.articleLabel.frame.origin.y, cell.articleLabel.frame.size.width, size.height);
    
    cell.viewHeight.constant = lastH;
    cell.bottomConstrait.constant = cell.articleLabel.bounds.size.height + 8;
 
    if (viewCount <= 2) {
        cell.replyView.hidden = YES;
    }else{
        cell.replyView.hidden = NO;
    }
    return cell;
}
- (void)createTableFooterView
{
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 60)];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(60, 15, 30, 30)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    label = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 200, 30)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = @"上拉加载更多";
    
    [tableFooterView addSubview:label];
    [tableFooterView addSubview:indicatorView];
    _tableView.tableFooterView = tableFooterView;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
        [UIView animateWithDuration:1.0 animations:^{
            [indicatorView startAnimating];
            label.text = @"正在加载";
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } completion:^(BOOL finished) {
            [indicatorView stopAnimating];
            label.text = @"上拉加载更多";
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, -60, 0)];
            pageNum += 10;
            [weakSelf getNormalInfo];
        }];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    pageNum = 0;
    [self getNormalInfo];
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
