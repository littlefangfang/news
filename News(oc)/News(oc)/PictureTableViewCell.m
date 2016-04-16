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


}



#pragma mark - Helper





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
