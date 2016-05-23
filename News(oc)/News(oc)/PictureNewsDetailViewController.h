//
//  PictureNewsDetailViewController.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/9.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureNewsDetailView.h"

@interface PictureNewsDetailViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (retain, nonatomic) NSString *dataString;

@property (strong, nonatomic) IBOutlet UILabel *pictureNewsTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *pictureNewsSubtitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *pictureCountLabel;

@property (strong, nonatomic) IBOutlet PictureNewsDetailView *detailView;
@end
