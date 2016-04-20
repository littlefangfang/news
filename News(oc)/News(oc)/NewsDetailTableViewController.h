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

@interface NewsDetailTableViewController : UITableViewController

@property (nonatomic, retain) NSDictionary *dataDictionary;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
