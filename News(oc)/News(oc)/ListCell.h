//
//  ListCell.h
//  ShowTime
//
//  Created by xinyue-0 on 16/9/2.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *portraitImgView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UILabel *nickLabel;

@property (strong, nonatomic) IBOutlet UILabel *onlineNumberLabel;

@end
