//
//  NewsTableViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/14.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "NewsTableViewController.h"
#import "FirstTableViewCell.h"
#import "HttpTool.h"
#import "UIImageView+Category.h"
#import "PictureTableViewCell.h"

@interface NewsTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic,retain) PictureTableViewCell *pictureCell;

@end

@implementation NewsTableViewController{
    
    __weak NewsTableViewController *weakSelf;
    
    NSInteger pageNumber;
    
    NSArray *pictureArray;
    
    NSInteger currentIdx;

    NSMutableArray *dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentIdx = 1;
    weakSelf = self;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 143)];
    [_tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"picture_cell"];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
     [self loadNewsData];
}

#pragma mark Helper

- (void)loadNewsData
{
    NSString *requestString;
    if ([self.title isEqualToString:@"头条"]) {
        requestString = @"headline/T1348647853363";
    }else if ([self.title isEqualToString:@"科技"]){
        requestString = @"list/T1348649580692";
    }else if ([self.title isEqualToString:@"游戏"]){
        requestString = @"list/T1348654151579";
    }else if ([self.title isEqualToString:@"娱乐"]){
        requestString = @"list/T1348648517839";
    }else if ([self.title isEqualToString:@"手机"]){
        requestString = @"list/T1348649654285";
    }else if ([self.title isEqualToString:@"漫画"]){
        requestString = @"list/T1444270454635";
    }
    HttpTool *tool = [[HttpTool alloc] init];
    tool.handlerBlock = ^(NSData *data, NSURLResponse *response, NSError *error){
        NSDictionary *dataJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dataArray.count > 0) {
        dataArray = [dataArray arrayByAddingObjectsFromArray:[[dataJson objectForKey:requestString.lastPathComponent] mutableCopy]];
        }else{
            dataArray = [dataJson objectForKey:requestString.lastPathComponent];
        }
        [_tableView reloadData];
    };
    if ([self.title isEqualToString:@"头条"]) {
        [tool getData:[NSString stringWithFormat:@"article/%@/%ld-20.html",requestString,pageNumber]];
    }else if ([self.title isEqualToString:@"科技"]){
        [tool getData:[NSString stringWithFormat:@"article/%@/%ld-20.html",requestString,pageNumber]];
    }else if ([self.title isEqualToString:@"游戏"]){
        [tool getData:[NSString stringWithFormat:@"article/%@/%ld-20.html",requestString,pageNumber]];
    }else if ([self.title isEqualToString:@"娱乐"]){
        [tool getData:[NSString stringWithFormat:@"article/%@/%ld-20.html",requestString,pageNumber]];
    }else if ([self.title isEqualToString:@"手机"]){
        [tool getData:[NSString stringWithFormat:@"article/%@/%ld-20.html",requestString,pageNumber]];
    }else if ([self.title isEqualToString:@"漫画"]){
        [tool getData:[NSString stringWithFormat:@"article/%@/%ld-20.html",requestString,pageNumber]];
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
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (indexPath.row > 0) {
            cell.titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
            [cell.titleImageView downloadImageWithURL:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imgsrc"]];
            cell.contentLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"digest"];
            cell.replyLabel.text = [NSString stringWithFormat:@"%@跟帖",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"replyCount"]];
            [cell.replyLabel sizeToFit];
        }else{
            if (!_pictureCell) {
                _pictureCell = [tableView dequeueReusableCellWithIdentifier:@"picture_cell"];
            }
            
            pictureArray = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"ads"];
            if (pictureArray.count == 1) {
                _pictureCell.scrollView.scrollEnabled = NO;
                _pictureCell.pageControl.numberOfPages = pictureArray.count;
                [_pictureCell.currentImageView downloadImageWithURL:[[pictureArray objectAtIndex:0] objectForKey:@"imgsrc"]];
                _pictureCell.pictureTitleLabel.text = [[pictureArray objectAtIndex:0] objectForKey:@"title"];
                return _pictureCell;
            }
            _pictureCell.scrollView.contentSize = CGSizeMake(3 * [UIScreen mainScreen].bounds.size.width, _pictureCell.frame.size.height);
            _pictureCell.scrollView.delegate = self;
            _pictureCell.pictureTitleLabel.text = [[pictureArray objectAtIndex:currentIdx] objectForKey:@"title"];
            [self setScrollViewPictures];
            return _pictureCell;
        }

    return cell;
}

- (void)setScrollViewPictures
{
    [_pictureCell.currentImageView downloadImageWithURL:[[pictureArray objectAtIndex:currentIdx] objectForKey:@"imgsrc"]];
    if (currentIdx == pictureArray.count - 1) {
        [_pictureCell.afterImageView downloadImageWithURL:[[pictureArray objectAtIndex:0] objectForKey:@"imgsrc"]];
    }else{
        [_pictureCell.afterImageView downloadImageWithURL:[[pictureArray objectAtIndex:currentIdx + 1] objectForKey:@"imgsrc"]];
    }
    if (currentIdx == 0) {
        [_pictureCell.beforeImageView downloadImageWithURL:[[pictureArray objectAtIndex:pictureArray.count - 1] objectForKey:@"imgsrc"]];
    }else{
        [_pictureCell.beforeImageView downloadImageWithURL:[[pictureArray objectAtIndex:currentIdx - 1] objectForKey:@"imgsrc"]];
    }

}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentIdx += _pictureCell.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width - 1;
    if (currentIdx <= -1) {
        currentIdx = pictureArray.count - 1;
    }else if(currentIdx >= pictureArray.count){
        currentIdx = 0;
    }
    [self setScrollViewPictures];
    [_pictureCell.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    _pictureCell.pictureTitleLabel.text = [[pictureArray objectAtIndex:currentIdx] objectForKey:@"title"];
    _pictureCell.pageControl.currentPage = currentIdx;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        [UIView animateWithDuration:1.0 animations:^{
            
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
        } completion:^(BOOL finished) {
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            pageNumber += 20;
            [weakSelf loadNewsData];
        }];
    }
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
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
