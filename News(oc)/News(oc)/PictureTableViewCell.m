//
//  PictureTableViewCell.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/15.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "PictureTableViewCell.h"
#import "UIImageView+Category.h"

@implementation PictureTableViewCell{
    UIViewController *vc;
    NSMutableArray *controllers;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _scrollView.delegate = self;
}



#pragma mark - Helper

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = _scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width + 0.5;
    _pageControl.currentPage = index;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
