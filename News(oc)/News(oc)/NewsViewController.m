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
    btnTitleArray = [NSArray arrayWithObjects:@"头条",@"科技",@"游戏",@"娱乐",@"手机",@"漫画", nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setContentScrollView];
    [self setButtonScrollView];
}

#pragma mark - Helper

- (void)setButtonScrollView
{
    _buttonScrollView.contentSize = CGSizeMake(10 + btnTitleArray.count * 80 - 20, _buttonScrollView.frame.size.height);
    for (int i = 0; i < btnTitleArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i * 80, 2, 50, 26)];
        [button setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.tag = i * SCREEN_W;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonScrollView addSubview:button];
    }
    NSInteger index = _contentScrollView.contentOffset.x / SCREEN_W;
    UIButton *currentBtn = _buttonScrollView.subviews[index];
    [currentBtn setTitleColor:[UIColor colorWithRed:248.0 / 255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
}

- (void)setContentScrollView
{
    _contentScrollView.contentSize = CGSizeMake(btnTitleArray.count  * SCREEN_W, _contentScrollView.frame.size.height);
    _contentScrollView.delegate = self;
    for (int i = 0; i < btnTitleArray.count; i++) {
        NewsTableViewController *vc = [[NewsTableViewController alloc] init];
        vc.title = [btnTitleArray objectAtIndex:i];
        [self addChildViewController:vc];
    }
    [_contentScrollView addSubview:self.childViewControllers[0].view];

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double index = scrollView.contentOffset.x / SCREEN_W;
    NSInteger leftIndex = (NSInteger)index;
    NSInteger rightIndex = leftIndex + 1;
    if (leftIndex >= 0 && leftIndex < btnTitleArray.count - 1) {
        UIButton *leftButton = _buttonScrollView.subviews[leftIndex];
        UIButton *rightButton = _buttonScrollView.subviews[rightIndex];
        [leftButton setTitleColor:[UIColor colorWithRed:0.502 + (1 - (index - leftIndex)) * (248.0 / 255.0 - 0.502) green:(index - leftIndex) * 0.502 blue:(index - leftIndex) * 0.502 alpha:1] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:0.502 + (index - leftIndex) * (248.0 / 255.0 - 0.502) green:0.502 - (index - leftIndex) * 0.502 blue:0.502 - (index - leftIndex) * 0.502 alpha:1] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / SCREEN_W;
    [self.childViewControllers[index].view setFrame:CGRectMake(index * SCREEN_W, 0, SCREEN_W, _contentScrollView.frame.size.height)];
    self.childViewControllers[index].view.tag = index + 100;
    [_contentScrollView addSubview:self.childViewControllers[index].view];
    
    CGPoint tempPoint = CGPointMake(_buttonScrollView.subviews[index].frame.origin.x - _buttonScrollView.frame.size.width / 2, 0);
    if (tempPoint.x < 0) {
        tempPoint.x = 0;
    }else if(tempPoint.x > _buttonScrollView.contentSize.width - _buttonScrollView.frame.size.width){
        tempPoint.x = _buttonScrollView.contentSize.width - _buttonScrollView.frame.size.width;
    }
    [_buttonScrollView setContentOffset:tempPoint animated:YES];
}

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
