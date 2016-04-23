//
//  SearchViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/22.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomBarView.h"

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

#pragma mark - Helper

- (void)setNavigationBar
{
    UIViewController *vc = [[UIViewController alloc] initWithNibName:@"CustomBarView" bundle:nil];
    CustomBarView *navigationView = (CustomBarView *)vc.view;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:navigationView];
    [navigationView.cancelButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixLeft.width = -15;
    
    self.navigationItem.leftBarButtonItems = @[fixLeft,barItem];
}

- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.navigationBar endEditing:YES];
}

@end
