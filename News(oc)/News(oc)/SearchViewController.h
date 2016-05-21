//
//  SearchViewController.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/22.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *hotPointArray;

@property (strong, nonatomic) IBOutlet UIButton *firstTitleButton;

@property (strong, nonatomic) IBOutlet UIButton *secondTitleButton;

@property (strong, nonatomic) IBOutlet UITableView *hotPointTableView;

@end
