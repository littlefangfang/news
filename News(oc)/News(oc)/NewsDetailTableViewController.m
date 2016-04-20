//
//  NewsDetailTableViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/16.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "NewsDetailTableViewController.h"

@interface NewsDetailTableViewController ()

@property (nonatomic, retain) WebViewJavascriptBridge *bridge;
@end

@implementation NewsDetailTableViewController{
    NSDictionary *dataDic;
    
    __weak typeof(NewsDetailTableViewController *)weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weakSelf = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initJSBridge];
}

#pragma mark - Helper
- (void)initJSBridge
{
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge registerHandler:@"webCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"webCallBack called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
}

- (void)setupRequest
{
    NSString *requestString = [_dataDictionary objectForKey:@"postid"];
    HttpTool *tool = [[HttpTool alloc] init];
    
    tool.handlerBlock = ^(NSData *data, NSURLResponse *response, NSError *error){
        NSDictionary *dataJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        dataDic = [dataJson objectForKey:requestString];
        [weakSelf setWebViewWithDictionary:dataDic];
        
    };
    [tool getData:[NSString stringWithFormat:@"article/%@/full.html",requestString]];
}

- (void)setWebViewWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary) {
        NSMutableString *bodyString = [NSMutableString stringWithString:[dictionary objectForKey:@"body"]];
        
        NSMutableString *titleStr= [dictionary objectForKey:@"title"];
        NSMutableString *sourceStr = [dictionary objectForKey:@"source"];
        NSMutableString *ptimeStr = [dictionary objectForKey:@"ptime"];
        
        NSMutableString *allTitleStr =[NSMutableString stringWithString:@"<style type='text/css'> p.thicker{font-weight: 900}p.light{font-weight: 0}p{font-size: 108%}h2 {font-size: 120%}h3 {font-size: 80%}</style> <h2 class = 'thicker'>haha</h2><h3>hehe    lala</h3>"];
        
        [allTitleStr replaceOccurrencesOfString:@"haha" withString:titleStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"haha"]];
        [allTitleStr replaceOccurrencesOfString:@"hehe" withString:sourceStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"hehe"]];
        [allTitleStr replaceOccurrencesOfString:@"lala" withString:ptimeStr options:NSCaseInsensitiveSearch range:[allTitleStr rangeOfString:@"lala"]];
        
        NSArray *imageArray = [dictionary objectForKey:@"img"];
        NSArray *videoArray = [dictionary objectForKey:@"video"];
        if ([videoArray count]) {
            NSLog(@"这个新闻里面有视频或者音频---");
            NSMutableArray *videos = [NSMutableArray arrayWithCapacity:[videoArray count]];
            for (NSDictionary *videoDic in videoArray) {
                videoInfo *videoin = [[videoInfo alloc] initWithInfo:videoDic];
                [videos addObject:videoin];
                NSRange range = [bodyStr rangeOfString:videoin.ref];
                NSString *videoStr = [NSString stringWithFormat:@"<embed height='50' width='280' src='%@' />",videoin.url_mp4];
                [bodyStr replaceOccurrencesOfString:videoin.ref withString:videoStr options:NSCaseInsensitiveSearch range:range];
            }
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [UIScreen mainScreen].bounds.size.height;
    }
    return 0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
