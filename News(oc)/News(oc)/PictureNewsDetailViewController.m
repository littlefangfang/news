//
//  PictureNewsDetailViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/9.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "PictureNewsDetailViewController.h"
#import "PictureNewsDetailCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HttpTool.h"

@interface PictureNewsDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation PictureNewsDetailViewController
{
    NSArray *_pictureArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helper

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
        NSDictionary *dic = (NSDictionary *)response;
        _pictureArray = [dic objectForKey:@"photos"];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end