//
//  SearchViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/22.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomBarView.h"
#import "HttpTool.h"
#import "PictureNewsDetailViewController.h"
#import "NewsDetailTableViewController.h"
#import "ReadHistoryViewController.h"

@implementation SearchViewController{
    
    __weak typeof(SearchViewController *)weakSelf;
    
    CustomBarView *navigationView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    weakSelf = self;
    
    [self setNavigationBar];
    
    [self setButtonTitle];
    
    [self getData];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

#pragma mark - Action
- (IBAction)clickHistoryButton:(UIButton *)sender {
    NSDictionary * dictionary = [_dataArray objectAtIndex:sender.tag - 1];
    if ([[dictionary objectForKey:@"skipType"] isEqualToString:@"photoset"]) {
        [self performSegueWithIdentifier:@"show_detail_with_picture" sender:dictionary];
    }else if([[dictionary objectForKey:@"tag"] isEqualToString:@"photoset"]){
        [self performSegueWithIdentifier:@"show_detail_with_picture" sender:dictionary];
    }else{
        [self performSegueWithIdentifier:@"show_detail_no_picture" sender:dictionary];
    }
}


#pragma mark - Helper

- (void)setNavigationBar
{
    UIViewController *vc = [[UIViewController alloc] initWithNibName:@"CustomBarView" bundle:nil];
    navigationView = (CustomBarView *)vc.view;
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

- (void)setButtonTitle
{
    if (_dataArray.count >= 2) {
        [_firstTitleButton setTitle:[[_dataArray objectAtIndex:0] objectForKey:@"title"] forState:UIControlStateNormal];
        [_secondTitleButton setTitle:[[_dataArray objectAtIndex:1] objectForKey:@"title"] forState:UIControlStateNormal];
    } else if (_dataArray.count == 1) {
        [_firstTitleButton setTitle:[[_dataArray objectAtIndex:0] objectForKey:@"title"] forState:UIControlStateNormal];
        [_secondTitleButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [_firstTitleButton setTitle:@"" forState:UIControlStateNormal];
        [_secondTitleButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)getData
{
    HttpTool *tool = [[HttpTool alloc] init];
    tool.handlerBlock = ^(NSData *data,NSURLResponse *response,NSError *error) {
        NSDictionary *dic = (NSDictionary *)response;
        _hotPointArray = [dic objectForKey:@"hotWordList"];

        [_hotPointTableView reloadData];
    };
    [tool getConversationWithUrl:@"http://c.m.163.com/nc/search/hotWord.html"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.navigationBar endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _hotPointArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotPointCell" forIndexPath:indexPath];
    cell.textLabel.text = [[_hotPointArray objectAtIndex:indexPath.row] objectForKey:@"hotWord"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    navigationView.searchBar.text = cell.textLabel.text;
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"show_detail_with_picture"]) {
         PictureNewsDetailViewController *vc = [segue destinationViewController];
         if ([(NSDictionary *)sender objectForKey:@"url"]) {
             vc.dataString = [(NSDictionary *)sender objectForKey:@"url"];
         }else{
             vc.dataString = [(NSDictionary *)sender objectForKey:@"photosetID"];
         }
         
     } else if ([segue.identifier isEqualToString:@"show_detail_no_picture"]){
         NewsDetailTableViewController *vc = [segue destinationViewController];
         vc.dataDictionary = (NSDictionary *)sender;
     } else if ([segue.identifier isEqualToString:@"show_full_history"]){
         ReadHistoryViewController *vc = [segue destinationViewController];
         vc.dataArray = _dataArray;
     }
 }

@end
