//
//  VideoTableViewCell.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/25.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;

@property (strong, nonatomic) IBOutlet UIButton *portraitButton;

@property (strong, nonatomic) IBOutlet UIButton *nameButton;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UIButton *replyButton;

@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
