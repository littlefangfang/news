//
//  VideoMainViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/24.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "VideoMainViewController.h"
#import "HttpTool.h"
#import "VideoTableViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface VideoMainViewController ()<UIScrollViewDelegate>

@end

@implementation VideoMainViewController{
    NSArray *buttonTitleArray;
    
    __weak typeof(VideoMainViewController *)weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    [self getButtonScrollViewListData];
}

- (void)viewDidLayoutSubviews
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper

- (void)getButtonScrollViewListData
{
    HttpTool *tool = [[HttpTool alloc] init];
    buttonTitleArray = [NSArray array];
    tool.handlerBlock = ^(NSData *data,NSURLResponse *response,NSError *error){
        buttonTitleArray = (NSArray *)response;
        [weakSelf setTitleButtons];
        [weakSelf setTableScrollView];
    };
    [tool getConversationWithUrl:@"http://c.m.163.com/nc/video/topiclist.html"];
}

- (void)setTitleButtons
{
    
    _buttonScrollView.contentSize = CGSizeMake(10 + buttonTitleArray.count * 90 - 20, _buttonScrollView.frame.size.height);
    
    for (id obj in _buttonScrollView.subviews) {
        [obj removeFromSuperview];
    }
    for (int i = 0; i < buttonTitleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + i * 90, 7, 60, 26);
        [button setTitle:[[buttonTitleArray objectAtIndex:i] objectForKey:@"tname"] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonScrollView addSubview:button];
    }
}

- (void)clickButton:(UIButton *)button
{
    NSInteger index = [button.superview.subviews indexOfObject:button];
    CGPoint tempPoint = CGPointMake(_buttonScrollView.subviews[index].frame.origin.x - _buttonScrollView.frame.size.width / 2, 0);
    if (tempPoint.x < 0) {
        tempPoint.x = 0;
    }else if(tempPoint.x > _buttonScrollView.contentSize.width - _buttonScrollView.frame.size.width){
        tempPoint.x = _buttonScrollView.contentSize.width - _buttonScrollView.frame.size.width;
    }
    [_buttonScrollView setContentOffset:tempPoint animated:YES];
    [_tableScrollView setContentOffset:CGPointMake(index * SCREEN_W, 0) animated:YES];
}

- (void)setTableScrollView
{
    _tableScrollView.contentSize = CGSizeMake(buttonTitleArray.count * SCREEN_W, _tableScrollView.frame.size.height);
    _tableScrollView.delegate = self;

    for (int i = 0; i < buttonTitleArray.count; i++) {
        VideoTableViewController *vc = [[VideoTableViewController alloc] init];
        vc.dataDictionary = buttonTitleArray[i];
        [vc.view setFrame:CGRectMake(i * SCREEN_W, 0, SCREEN_W, _tableScrollView.frame.size.height)];
        [self addChildViewController:vc];
    }
    [_tableScrollView addSubview:self.childViewControllers[0].view];
    NSInteger index = _tableScrollView.contentOffset.x / SCREEN_W;
    UIButton *currentBtn = _buttonScrollView.subviews[index];
    [currentBtn setTitleColor:[UIColor colorWithRed:248.0 / 255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    currentBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double index = _tableScrollView.contentOffset.x / SCREEN_W;
    NSInteger leftIndex = index;
    NSInteger rightIndex = leftIndex + 1;
    
    if (leftIndex >= 0 && leftIndex < buttonTitleArray.count - 1) {
        UIButton *leftButton = _buttonScrollView.subviews[leftIndex];
        UIButton *rightButton = _buttonScrollView.subviews[rightIndex];
        leftButton.transform = CGAffineTransformMakeScale((rightIndex - index) * 0.3 + 1, (rightIndex - index) * 0.3 + 1);
        rightButton.transform = CGAffineTransformMakeScale((index - leftIndex) * 0.3 + 1, (index - leftIndex) * 0.3 + 1);
        [leftButton setTitleColor:[UIColor colorWithRed:0.502 + (1 - (index - leftIndex)) * (248.0 / 255.0 - 0.502) green:(index - leftIndex) * 0.502 blue:(index - leftIndex) * 0.502 alpha:1] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:0.502 + (index - leftIndex) * (248.0 / 255.0 - 0.502) green:0.502 - (index - leftIndex) * 0.502 blue:0.502 - (index - leftIndex) * 0.502 alpha:1] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / SCREEN_W;
    [self.childViewControllers[index].view setFrame:CGRectMake(index * SCREEN_W, 0, SCREEN_W, _tableScrollView.frame.size.height)];
    self.childViewControllers[index].view.tag = index + 100;
    [_tableScrollView addSubview:self.childViewControllers[index].view];
    
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
    [self.childViewControllers[index].view setFrame:CGRectMake(index * SCREEN_W, 0, SCREEN_W, _tableScrollView.frame.size.height)];
    self.childViewControllers[index].view.tag = index + 100;
    [_tableScrollView addSubview:self.childViewControllers[index].view];
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
