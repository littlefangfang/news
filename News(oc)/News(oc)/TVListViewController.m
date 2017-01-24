//
//  TVListViewController.m
//  ShowTime
//
//  Created by xinyue-0 on 16/7/22.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "TVListViewController.h"
#import "TVShowViewController.h"
#import "ListCell.h"
#import "UIImageView+Category.h"
#import "UIImageView+WebCache.h"

@interface TVListViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation TVListViewController{
    NSMutableArray *arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"tvlist" ofType:@"txt"];
//    NSString *contentStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSArray *tArr = [contentStr componentsSeparatedByString:@"\n"];
//    arr = [NSMutableArray array];
//    for (int i = 0; i < tArr.count; i++) {
//        NSString *tStr = [tArr objectAtIndex:i];
//        if (![tStr isEqualToString:@""]) {
//            [arr addObject:tStr];
//        }
//    }
    self.navigationController.hidesBarsOnTap = true;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}
#pragma mark - Helper
-(void)loadData {
    NSURL *url = [NSURL URLWithString:@"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *info = (NSDictionary *)json;
        arr = [info objectForKey:@"lives"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
        });
        
    }];
    [dataTask resume];
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arr.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    NSString *fullStr = [arr objectAtIndex:indexPath.row];
//    NSArray *tempArr = [fullStr componentsSeparatedByString:@" "];
//    cell.textLabel.text = [tempArr objectAtIndex:0];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *str = [arr objectAtIndex:indexPath.row];
//    NSArray *temp = [str componentsSeparatedByString:@" "];
//    NSString *channel = [temp objectAtIndex:1];
//    [self performSegueWithIdentifier:@"showTV" sender:channel];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = (ListCell *)[_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.portraitImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",[[[arr objectAtIndex:indexPath.row] objectForKey:@"creator"] objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"test_image.jpeg"]];
    cell.nameLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.addressLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"city"];
    cell.onlineNumberLabel.text = [NSString stringWithFormat:@"%d",[[[arr objectAtIndex:indexPath.row] objectForKey:@"online_users"] intValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *channel = [[arr objectAtIndex:indexPath.row] objectForKey:@"stream_addr"];
    [self performSegueWithIdentifier:@"showTV" sender:channel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TVShowViewController *vc = [segue destinationViewController];
    
    vc.channelString = (NSString *)sender;
}


@end
