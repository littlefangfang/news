//
//  NewsTableViewCell.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/3/30.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UIView

@property (nonatomic, retain) IBOutlet UIImageView *titleImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *contentLabel;
@end
