//
//  ConversationTableViewCell.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/25.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *potraitButton;

@property (strong, nonatomic) IBOutlet UIButton *nameButton;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UIView *replyView;

@property (strong, nonatomic) IBOutlet UILabel *articleLabel;

@property (nonatomic, assign) NSInteger viewCount;

@end
