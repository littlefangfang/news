//
//  PictureNewsDetailViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/9.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "PictureNewsDetailViewController.h"
#import "PictureNewsDetailCollectionViewCell.h"
#import "ConversationViewController.h"
#import "UIImageView+WebCache.h"
#import "HttpTool.h"

@interface PictureNewsDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@end

@implementation PictureNewsDetailViewController
{
    NSArray *_pictureArray;
    
    NSDictionary *_dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getData];
    [self setLeftBarItem];
    [self setRightBarItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helper

- (void)setLeftBarItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [button setImage:[UIImage imageNamed:@"top_navigation_back.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"top_navigation_back_highlighted.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -12;
    
    self.navigationItem.leftBarButtonItems = @[fixedButton, backItem];
}

- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightBarItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [button setTitle:@"查看跟帖   " forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button sizeToFit];
    [button setFrame:CGRectMake(0, 0, button.frame.size.width + 10, 44)];
    [button addTarget:self action:@selector(showNextPage) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImage = [UIImage imageNamed:@"contentview_commentbacky.png"];
    buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeTile];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -12;
    
    self.navigationItem.rightBarButtonItems = @[fixedButton,rightItem];
}

- (void)showNextPage
{
    [self performSegueWithIdentifier:@"show_picture_reply" sender:nil];
}

- (NSString *)setUrlStringWithString:(NSString *)str
{
    NSInteger strIdx = [str rangeOfString:@"|"].location;
    NSString *firstStr = [str substringWithRange:NSMakeRange(strIdx - 4, 4)];
    NSString *lastStr = [str substringFromIndex:strIdx + 1];
    NSString *fullStr = [NSString stringWithFormat:@"%@/%@",firstStr,lastStr];
    NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@.json",fullStr];
    return urlStr;
}

- (void)getData
{
    HttpTool *tool = [[HttpTool alloc] init];
    tool.handlerBlock = ^(NSData *data, NSURLResponse *response, NSError *error){
        _dic = (NSDictionary *)response;
        _pictureArray = [_dic objectForKey:@"photos"];
        _pictureNewsTitleLabel.text = [_dic objectForKey:@"setname"];
        _pictureNewsSubtitleLabel.text = [[_pictureArray objectAtIndex:0] objectForKey:@"note"];
        _pictureCountLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_pictureArray.count];
        [_collectionView reloadData];
    };
    [tool getConversationWithUrl:[self setUrlStringWithString:_dataString]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _pictureArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureNewsDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picture_collection_cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[[_pictureArray objectAtIndex:indexPath.row] objectForKey:@"imgurl"]];
    
    return cell;
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _collectionView.bounds.size;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath;
    for (UICollectionViewCell *cell in [_collectionView visibleCells]) {
        indexPath = [_collectionView indexPathForCell:cell];
    }
    _pictureCountLabel.text = [NSString stringWithFormat:@"%ld/%lu",indexPath.row + 1,(unsigned long)_pictureArray.count];
    _pictureNewsSubtitleLabel.text = [[_pictureArray objectAtIndex:indexPath.row] objectForKey:@"note"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ConversationViewController *vc = [segue destinationViewController];
    vc.postid = [_dic objectForKey:@"postid"];
    vc.replyBoard = [_dic objectForKey:@"boardid"];
}


@end
