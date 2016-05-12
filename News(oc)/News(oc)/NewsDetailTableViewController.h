//
//  NewsDetailTableViewController.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/16.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "HttpTool.h"
#import "VideoInfo.h"
#import "ImageInfo.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "ConversationViewController.h"
#import "MoveTransition.h"

@interface NewsDetailTableViewController : UITableViewController

@property (nonatomic, retain) NSDictionary *dataDictionary;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
