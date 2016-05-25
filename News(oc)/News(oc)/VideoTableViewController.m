//
//  VideoTableViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/25.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "VideoTableViewController.h"
#import "VideoTableViewCell.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "FYTableFooterView.h"
#import "AFNetworkReachabilityManager.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation VideoTableViewController{
    NSInteger pageNumber;
    NSMutableArray *responsArray;
    UIView *footerView;
    AVPlayerViewController *AvViewController;
    __weak typeof(VideoTableViewController *)weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    pageNumber = 0;
    responsArray = [NSMutableArray array];
    [self setTableView];
    [self getData];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper

- (void)getData
{
    HttpTool *tool = [[HttpTool alloc] init];
    tool.handlerBlock = ^(NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary *dic = (NSDictionary *)response;
        if ([responsArray count]) {
            [responsArray addObjectsFromArray:[dic objectForKey:[_dataDictionary objectForKey:@"tid"]]];
        }else{
            responsArray = [[dic objectForKey:[_dataDictionary objectForKey:@"tid"]] mutableCopy];
        }
        
        [_tableView reloadData];
    };
    [tool getConversationWithUrl:[NSString stringWithFormat:@"http://c.m.163.com/nc/video/Tlist/%@/%ld-10.html",[_dataDictionary objectForKey:@"tid"],pageNumber]];
}

- (void)setTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"video_cell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return responsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"video_cell" forIndexPath:indexPath];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[[responsArray objectAtIndex:indexPath.row] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"81.jpg"]];
//    [cell.portraitButton sd_setImageWithURL:[NSURL URLWithString:[[responsArray objectAtIndex:indexPath.row] objectForKey:@"topicImg"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"81.jpg"]];
    [cell.portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[[responsArray objectAtIndex:indexPath.row] objectForKey:@"topicImg"]] forState:UIControlStateNormal];
    [cell.nameButton setTitle:[[responsArray objectAtIndex:indexPath.row] objectForKey:@"topicName"] forState:UIControlStateNormal];
    cell.titleLabel.text = [[responsArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%@",[[responsArray objectAtIndex:indexPath.row] objectForKey:@"playCount"]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    footerView = [[NSBundle mainBundle] loadNibNamed:@"FYTableFooterView" owner:nil options:nil][0];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [AvViewController removeFromParentViewController];
    AvViewController = nil;
    if (AvViewController.player) {
        return;
    }
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"使用流量中" message:@"是否继续播放？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"有钱！继续看！" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                 __strong __typeof(self) strongSelf = weakSelf;
                if (!AvViewController) {
                    AvViewController = [[AVPlayerViewController alloc] init];
                    AvViewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:[[responsArray objectAtIndex:indexPath.row] objectForKey:@"mp4_url"]]];
                    [strongSelf presentViewController:AvViewController animated:YES completion:nil];
                }
                
            }];
            UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"擦！不看了！" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:actionYes];
            [alertController addAction:actionNo];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            if (!AvViewController) {
                AvViewController = [[AVPlayerViewController alloc] init];
                AvViewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:[[responsArray objectAtIndex:indexPath.row] objectForKey:@"mp4_url"]]];
                [weakSelf presentViewController:AvViewController animated:YES completion:nil];
            }
            
        }
    }];
    [manager startMonitoring];
}

- (void)alert
{
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
        pageNumber += 10;
        [self getData];
    }
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
