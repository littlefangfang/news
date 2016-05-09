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
#import "NewsDetailTableViewController.h"

@interface NewsTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic,retain) PictureTableViewCell *pictureCell;

@end

@implementation NewsTableViewController{
    
    __weak typeof(NewsTableViewController *)weakSelf;
    
    NSInteger pageNumber;
    
    NSArray *pictureArray;
    
    NSInteger currentIdx;

    NSArray *dataArray;
    
    UIActivityIndicatorView *indicatorView;
    
    UILabel *label;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentIdx = 1;
    weakSelf = self;
    
    [self setTableViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (dataArray.count == 0) {
        pageNumber = 0;
        [self loadNewsData];
    }
}

#pragma mark Helper


- (void)showDetail:(UITapGestureRecognizer *)tap
{
    if ([pictureArray count]) {
        if (pictureArray.count == 1) {
            if ([[[pictureArray objectAtIndex:0] objectForKey:@"tag"] isEqualToString:@"photoset"]) {
                [self.parentViewController performSegueWithIdentifier:@"show_picture_detail" sender:[[pictureArray objectAtIndex:0] objectForKey:@"url"]];
            }else{
                [self.parentViewController performSegueWithIdentifier:@"show_Detail" sender:[pictureArray objectAtIndex:0]];
            }
        }else{
            if ([[[pictureArray objectAtIndex:0] objectForKey:@"tag"] isEqualToString:@"photoset"]) {
                [self.parentViewController performSegueWithIdentifier:@"show_picture_detail" sender:[[pictureArray objectAtIndex:currentIdx] objectForKey:@"url"]];
            }else{
                [self.parentViewController performSegueWithIdentifier:@"show_Detail" sender:[pictureArray objectAtIndex:currentIdx]];
            }
        }
    }else{
        [self.parentViewController performSegueWithIdentifier:@"show_Detail" sender:[dataArray objectAtIndex:0]];
    }
}

- (void)setTableViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 143)];
    [_tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"picture_cell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, -60, 0)];
    [self createTableFooterView];
    [self.view addSubview:_tableView];
}

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

- (void)createTableFooterView
{
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height, [UIScreen mainScreen].bounds.size.width, 60)];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(60, 15, 30, 30)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    label = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 200, 30)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = @"上拉加载更多";
    
    [tableFooterView addSubview:label];
    [tableFooterView addSubview:indicatorView];
    _tableView.tableFooterView = tableFooterView;
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
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail:)];
                [_pictureCell.scrollView addGestureRecognizer:tapGesture];
            }
            if ([[dataArray objectAtIndex:indexPath.row] objectForKey:@"ads"]) {
                pictureArray = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"ads"];
                if (pictureArray.count == 1) {
                    _pictureCell.scrollView.scrollEnabled = NO;
                    _pictureCell.pageControl.hidden = YES;
                    [_pictureCell.beforeImageView downloadImageWithURL:[[pictureArray objectAtIndex:0] objectForKey:@"imgsrc"]];
                    _pictureCell.pictureTitleLabel.text = [[pictureArray objectAtIndex:currentIdx] objectForKey:@"title"];
                    return _pictureCell;
                }
                _pictureCell.scrollView.contentSize = CGSizeMake(3 * [UIScreen mainScreen].bounds.size.width, _pictureCell.frame.size.height);
                _pictureCell.scrollView.delegate = self;
                _pictureCell.pictureTitleLabel.text = [[pictureArray objectAtIndex:currentIdx - 1] objectForKey:@"title"];
                _pictureCell.pageControl.numberOfPages = pictureArray.count;
                [self setScrollViewPictures];
                return _pictureCell;
                
            }else{
                _pictureCell.scrollView.scrollEnabled = NO;
                _pictureCell.pageControl.hidden = YES;
                [_pictureCell.beforeImageView downloadImageWithURL:[[dataArray objectAtIndex:0] objectForKey:@"imgsrc"]];
                [_pictureCell.currentImageView  downloadImageWithURL:[[dataArray objectAtIndex:0] objectForKey:@"imgsrc"]];
                _pictureCell.pictureTitleLabel.text = [[dataArray objectAtIndex:0] objectForKey:@"title"];
                return _pictureCell;
            }
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
    if (![pictureArray count]) {
        return;
    }
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
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
        [UIView animateWithDuration:1.0 animations:^{
            [indicatorView startAnimating];
            label.text = @"正在加载";
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } completion:^(BOOL finished) {
            [indicatorView stopAnimating];
            label.text = @"上拉加载更多";
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, -60, 0)];
            pageNumber += 20;
            [weakSelf loadNewsData];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"skipType"] isEqualToString:@"photoset"]) {
            [self.parentViewController performSegueWithIdentifier:@"show_picture_detail" sender:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"photosetID"]];
        }else{
            [self.parentViewController performSegueWithIdentifier:@"show_Detail" sender:[dataArray objectAtIndex:indexPath.row]];
        }
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
