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
    
    NSArray *pictureArray;
    
    NSInteger currentIdx;

    NSArray *dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentIdx = 1;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 143)];
    [_tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"picture_cell"];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self loadNewsData];
}

#pragma mark Helper

- (void)loadNewsData
{
    HttpTool *tool = [[HttpTool alloc] init];
    tool.handlerBlock = ^(NSData *data, NSURLResponse *response, NSError *error){
        NSDictionary *dataJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        dataArray = [dataJson objectForKey:@"T1348647853363"];
        [_tableView reloadData];
    };
    [tool getData:[NSURL URLWithString:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html"]];
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.view.tag == 100) {
        cell.titleLabel.text = @"新建一个 Table View Controller 页面，并把我们之前创建的 Swift on iOS 那个按钮的点击事件绑定过去，我们得到";
        cell.contentLabel.text = @"新建一个 Table View Controller 页面，并把我们之前创建的 Swift on iOS 那个按钮的点击事件绑定过去，我们得到";
        cell.titleImageView.image = [UIImage imageNamed:@"81.jpg"];
    }else if(self.view.tag == 101){
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
            _pictureCell.scrollView.contentSize = CGSizeMake(3 * [UIScreen mainScreen].bounds.size.width, _pictureCell.frame.size.height);
            _pictureCell.scrollView.delegate = self;
            _pictureCell.pictureTitleLabel.text = [[pictureArray objectAtIndex:currentIdx] objectForKey:@"title"];
            [self setScrollViewPictures];
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
