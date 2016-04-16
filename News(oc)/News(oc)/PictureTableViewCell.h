//
//  PictureTableViewCell.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/15.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@end
