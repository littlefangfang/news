//
//  FirstTableViewCell.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/3/31.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTableViewCell : UITableViewCell

@property(retain, nonatomic) IBOutlet UIImageView *titleImageView;

@property(retain, nonatomic) IBOutlet UILabel *titleLabel;

//@property(retain, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UILabel *replyLabel;

@end
