//
//  PictureTableViewCell.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/15.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "PictureTableViewCell.h"

@implementation PictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setPictures];
}

#pragma mark - Helper

- (void)setPictures
{
    for (NSInteger i = 0; i < _pictureArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height)];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
