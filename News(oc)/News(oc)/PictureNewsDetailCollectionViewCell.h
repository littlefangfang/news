//
//  PictureNewsDetailCollectionViewCell.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/9.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureNewsDetailCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end
