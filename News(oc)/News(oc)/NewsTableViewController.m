//
//  NewsTableViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/14.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "NewsTableViewController.h"
#import "FirstTableViewCell.h"

@interface NewsTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.titleLabel.text = @"新建一个 Table View Controller 页面，并把我们之前创建的 Swift on iOS 那个按钮的点击事件绑定过去，我们得到";
    cell.contentLabel.text = @"新建一个 Table View Controller 页面，并把我们之前创建的 Swift on iOS 那个按钮的点击事件绑定过去，我们得到";
    cell.titleImageView.image = [UIImage imageNamed:@"81.jpg"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
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
