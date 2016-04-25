//
//  ConversationViewController.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/21.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationTableViewCell.h"
#import "HttpTool.h"
#import "UIButton+WebCache.h"

@interface ConversationViewController : UIViewController

@property (retain, nonatomic) NSString *replyBoard;

@property (retain, nonatomic) NSString *postid;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
