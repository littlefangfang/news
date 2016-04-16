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

@interface NewsTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation NewsTableViewController{

NSArray *dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [_tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"picture_cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self loadNewsData];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 137, 0);
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
        }else{
            PictureTableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:@"picture_cell"];
            NSMutableArray *pictureArray = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"ads"];
            cell0.scrollView.contentSize = CGSizeMake(pictureArray.count * [UIScreen mainScreen].bounds.size.width, cell0.frame.size.height);
            for (NSInteger i = 0; i < pictureArray.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, cell0.frame.size.height)];
                [imageView downloadImageWithURL:[[pictureArray objectAtIndex:i] objectForKey:@"imgsrc"]];
                cell0.pageControl.numberOfPages = pictureArray.count;
                cell0.pageControl.currentPage = 0;
                [cell0.scrollView insertSubview:imageView belowSubview:cell0.pageControl];
            }
            return cell0;
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
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
