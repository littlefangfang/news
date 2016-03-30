//
//  NewsViewController.m
//  News(oc)
//
//  Created by fy on 16/3/29.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"


@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *btnTitleArray;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnTitleArray = [NSArray arrayWithObjects:@"推荐",@"科技",@"娱乐",@"游戏",@"汽车", nil];
    [self setButtonScrollView];
    [self setContentScrollView];
}

#pragma mark - Helper
- (void)setButtonScrollView
{
    _buttonScrollView.contentSize = CGSizeMake(10 + btnTitleArray.count * 50 + 10, _buttonScrollView.frame.size.height);
    for (int i = 0; i < btnTitleArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i * 50, 2, 40, 20)];
        [button setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_buttonScrollView addSubview:button];
    }
}

- (void)setContentScrollView
{
    _contentScrollView.contentSize = CGSizeMake(btnTitleArray.count * _contentScrollView.frame.size.width, _contentScrollView.frame.size.height);
    for (int i = 0; i < btnTitleArray.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * _contentScrollView.frame.size.width, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [_contentScrollView addSubview:tableView];
    }
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
    return btnTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] initWithNibName:@"NewsTableViewCell" bundle:nil];
    [vc.view setRestorationIdentifier:@"cell"];

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
