//
//  NewsViewController.m
//  News(oc)
//
//  Created by fy on 16/3/29.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewController.h"
#import "NewsDetailTableViewController.h"
#import "PictureNewsDetailViewController.h"
#import "SearchViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface NewsViewController ()<UIScrollViewDelegate>{
    
    NSArray *btnTitleArray;
    
    NSMutableArray *plistArray;
    
    NSString *filePath;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    btnTitleArray = [NSArray arrayWithObjects:@"头条",@"科技",@"游戏",@"娱乐",@"手机",@"漫画", nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setContentScrollView];
    [self setButtonScrollView];
    [self setPlistFile];
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    testView.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:0 blue:0 alpha:1];
    [self.view addSubview:testView];
    // 设置tabbar文字和图片颜色
    [self setTabbarColor];
}

#pragma mark - Helper

- (void)setPlistFile
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    filePath = [path stringByAppendingPathComponent:@"History.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        plistArray = [NSMutableArray array];
        
    }else{
        plistArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
}

- (void)setTabbarColor
{
    UIImage *img = [self.tabBarController.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = img;
}

- (void)setButtonScrollView
{
    _buttonScrollView.contentSize = CGSizeMake(10 + btnTitleArray.count * 80 - 20, _buttonScrollView.frame.size.height);
    for (int i = 0; i < btnTitleArray.count; i++) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + i * 80, 2, 50, 26);
        [button setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = i * SCREEN_W;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonScrollView addSubview:button];
    }
    NSInteger index = _contentScrollView.contentOffset.x / SCREEN_W;
    UIButton *currentBtn = _buttonScrollView.subviews[index];
    [currentBtn setTitleColor:[UIColor colorWithRed:248.0 / 255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    currentBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
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
        leftButton.transform = CGAffineTransformMakeScale((rightIndex - index) * 0.3 + 1, (rightIndex - index) * 0.3 + 1);
        rightButton.transform = CGAffineTransformMakeScale((index - leftIndex) * 0.3 + 1, (index - leftIndex) * 0.3 + 1);
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_Detail"]) {
        NewsDetailTableViewController *vc = (NewsDetailTableViewController *)[segue destinationViewController];
        if ([vc respondsToSelector:@selector(setDataDictionary:)]) {
            [self addObjectToPlistWithSender:(NSDictionary *)sender];
            vc.dataDictionary = (NSDictionary *)sender;
        }
    }else if ([segue.identifier isEqualToString:@"show_picture_detail"]) {
        PictureNewsDetailViewController *vc = [segue destinationViewController];
        [self addObjectToPlistWithSender:(NSDictionary *)sender];
        if ([sender objectForKey:@"url"]) {
            vc.dataString = [sender objectForKey:@"url"];
        }else{
            vc.dataString = [sender objectForKey:@"photosetID"];
        }
    }else if ([segue.identifier isEqualToString:@"show_search_and_history"]) {
        SearchViewController *vc = [segue destinationViewController];
        vc.dataArray = plistArray;
    }
}

- (void)addObjectToPlistWithSender:(NSDictionary *)sender
{
    if (plistArray.count >= 20) {
        [plistArray removeLastObject];
        if (![self equalBetween:plistArray andDic:sender]) {
            [plistArray insertObject:sender atIndex:0];
            [plistArray writeToFile:filePath atomically:YES];
        }
    }else {
        if (![self equalBetween:plistArray andDic:sender]) {
            [plistArray insertObject:sender atIndex:0];
            [plistArray writeToFile:filePath atomically:YES];
        }
    }
}

- (BOOL)equalBetween:(NSMutableArray *)array andDic:(NSDictionary *)dic
{
    for (NSDictionary *dictionary in array) {
        if ([[dictionary objectForKey:@"title"] isEqualToString:[dic objectForKey:@"title"]]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

@end
