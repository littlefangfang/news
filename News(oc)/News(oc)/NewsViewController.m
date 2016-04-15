//
//  NewsViewController.m
//  News(oc)
//
//  Created by fy on 16/3/29.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface NewsViewController ()<UIScrollViewDelegate>{
    NSArray *btnTitleArray;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnTitleArray = [NSArray arrayWithObjects:@"推荐",@"科技",@"娱乐",@"游戏",@"汽车", nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setButtonScrollView];
    [self setContentScrollView];
}

#pragma mark - Helper


- (void)setButtonScrollView
{
    _buttonScrollView.contentSize = CGSizeMake(10 + btnTitleArray.count * 50 + 10, _buttonScrollView.frame.size.height);
    for (int i = 0; i < btnTitleArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i * 70, 2, 40, 20)];
        [button setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.tag = i * SCREEN_W;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonScrollView addSubview:button];
    }
}

- (void)setContentScrollView
{
    _contentScrollView.contentSize = CGSizeMake(btnTitleArray.count  * SCREEN_W, _contentScrollView.frame.size.height);
    _contentScrollView.delegate = self;
    for (int i = 0; i < btnTitleArray.count; i++) {
        NewsTableViewController *vc = [[NewsTableViewController alloc] init];

        [self addChildViewController:vc];
    }
}

- (void)clickButton:(UIButton *)sender
{
    [_contentScrollView setContentOffset:CGPointMake(sender.tag, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / SCREEN_W;
    [self.childViewControllers[index].view setFrame:CGRectMake(index * SCREEN_W, 0, SCREEN_W, _contentScrollView.frame.size.height)];
    self.childViewControllers[index].view.tag = index + 100;
    [_contentScrollView addSubview:self.childViewControllers[index].view];
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
