//
//  PictureTableViewCell.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/15.
//  Copyright © 2016年 founder. All rights reserved.
//

#define SCREEN_W [UIScreen mainScreen].bounds.size.width

#import "PictureTableViewCell.h"
#import "UIImageView+Category.h"

@implementation PictureTableViewCell{

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _beforeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, self.bounds.size.height)];
    _currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W, self.bounds.size.height)];
    _afterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * SCREEN_W, 0, SCREEN_W, self.bounds.size.height)];
    [_scrollView addSubview:_beforeImageView];
    [_scrollView addSubview:_currentImageView];
    [_scrollView addSubview:_afterImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
