//
//  PictureNewsDetailViewController.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/9.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureNewsDetailViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (retain, nonatomic) NSMutableArray *dataArray;

@end
