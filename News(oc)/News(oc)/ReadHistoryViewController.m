//
//  ReadHistoryViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/21.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "ReadHistoryViewController.h"
#import "PictureNewsDetailViewController.h"
#import "NewsDetailTableViewController.h"

@interface ReadHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ReadHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dictionary = [_dataArray objectAtIndex:indexPath.row];
    if ([[dictionary objectForKey:@"skipType"] isEqualToString:@"photoset"]) {
        [self performSegueWithIdentifier:@"show_with_picture" sender:dictionary];
    }else if([[dictionary objectForKey:@"tag"] isEqualToString:@"photoset"]){
        [self performSegueWithIdentifier:@"show_with_picture" sender:dictionary];
    }else{
        [self performSegueWithIdentifier:@"show_with_no_picture" sender:dictionary];
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_with_picture"]) {
        PictureNewsDetailViewController *vc = [segue destinationViewController];
        if ([(NSDictionary *)sender objectForKey:@"url"]) {
            vc.dataString = [(NSDictionary *)sender objectForKey:@"url"];
        }else{
            vc.dataString = [(NSDictionary *)sender objectForKey:@"photosetID"];
        }
    }else if ([segue.identifier isEqualToString:@"show_with_no_picture"]){
        NewsDetailTableViewController *vc = [segue destinationViewController];
        vc.dataDictionary = (NSDictionary *)sender;
    }
}


@end
