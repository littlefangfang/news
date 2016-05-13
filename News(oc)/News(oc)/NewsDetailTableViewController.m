//
//  NewsDetailTableViewController.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/16.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "NewsDetailTableViewController.h"

@interface NewsDetailTableViewController ()<UINavigationControllerDelegate>

@property (nonatomic, retain) WebViewJavascriptBridge *bridge;
@end

@implementation NewsDetailTableViewController{
    NSDictionary *dataDic;
    NSMutableArray *_allImagesOfThisArticle;
    __weak typeof(NewsDetailTableViewController *)weakSelf;
    UIPercentDrivenInteractiveTransition *_percentDrivenInteractiveTransition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    weakSelf = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.navigationController.delegate = self;
    [self initJSBridge];
    [self setupRequest];
    [self setLeftBarItem];
    [self setRightBarItem];
    [self addGesture];
}


#pragma mark - Helper

- (void)setLeftBarItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [button setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_back_highlighted.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -12;
    
    self.navigationItem.leftBarButtonItems = @[fixedButton, backItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightBarItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [button setTitle:[NSString stringWithFormat:@"%@跟帖   ",[_dataDictionary objectForKey:@"replyCount"]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button sizeToFit];
    [button setFrame:CGRectMake(0, 0, button.frame.size.width + 10, 44)];
    [button addTarget:self action:@selector(showNextPage:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImage = [UIImage imageNamed:@"contentview_commentbacky.png"];
    buttonImage = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeTile];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -12;

    self.navigationItem.rightBarButtonItems = @[fixedButton,rightItem];
    
}

- (void)addGesture
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextPage:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeGesture];
}

//- (void)addGesture
//{
//    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
//    panGesture.edges = UIRectEdgeRight;
//    [self.tableView addGestureRecognizer:panGesture];
//}
//
//- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)pan
//{
//    CGFloat progress = [pan translationInView:self.view].x / self.view.bounds.size.width;
//    NSLog(@"%f",progress);
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        _percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
//        [self showNextPage:nil];
//    }else if (pan.state == UIGestureRecognizerStateChanged){
//        [_percentDrivenInteractiveTransition updateInteractiveTransition:progress];
//    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
//        if (progress < -0.5) {
//            [_percentDrivenInteractiveTransition finishInteractiveTransition];
//        } else {
//            [_percentDrivenInteractiveTransition cancelInteractiveTransition];
//        }
//        _percentDrivenInteractiveTransition = nil;
//    }
//}

- (void)showNextPage:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"show_conversations" sender:nil];
}


- (void)initJSBridge
{
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:(id)self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
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
    if ([dictionary count]) {
        NSMutableString *bodyStr = [NSMutableString stringWithString:[dictionary objectForKey:@"body"]];
        
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
                VideoInfo *videoin = [[VideoInfo alloc] initWithInfo:videoDic];
                [videos addObject:videoin];
                NSRange range = [bodyStr rangeOfString:videoin.ref];
                NSString *videoStr = [NSString stringWithFormat:@"<embed height='50' width='280' src='%@' />",videoin.url_mp4];
                [bodyStr replaceOccurrencesOfString:videoin.ref withString:videoStr options:NSCaseInsensitiveSearch range:range];
            }
        }
        
        if (![imageArray count]) {
            NSLog(@"新闻没图片");
            NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
            [_webView loadHTMLString:str5 baseURL:[[NSURL URLWithString:@""] baseURL]];
            
        }else{
            NSLog(@"新闻内容里面有图片");
            
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
            
            for (NSDictionary *d in imageArray) {
                
                ImageInfo *info = [[ImageInfo alloc] initWithInfo:d];//kvc
                [images addObject:info];

                NSRange range = [bodyStr rangeOfString:info.ref];
                NSArray *wh = [info.pixel componentsSeparatedByString:@"*"];
                CGFloat width = [[wh objectAtIndex:0] floatValue];
                
                CGFloat rate = (self.view.bounds.size.width-15)/ width;
                CGFloat height = [[wh objectAtIndex:1] floatValue];
                CGFloat newWidth = width * rate;
                CGFloat newHeight = height *rate;
                
                NSString *imageStr = [NSString stringWithFormat:@"<img src = 'loading' id = '%@' width = '%.0f' height = '%.0f' hspace='0.0' vspace='5'>",[self replaceUrlSpecialString:info.src],newWidth,newHeight];
                [bodyStr replaceOccurrencesOfString:info.ref withString:imageStr options:NSCaseInsensitiveSearch range:range];
            }
        
            [self getImageFromDownloaderOrDiskByImageUrlArray:imageArray];

//            [bodyStr replaceOccurrencesOfString:@"<p>　　" withString:@"<p>" options:NSCaseInsensitiveSearch range:[bodyStr rangeOfString:@"<p>　　"]];

            NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
            
            NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"WebViewHtml" ofType:@"html"];
            NSMutableString* appHtml = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            
            NSRange range = [appHtml rangeOfString:@"<p>mainnews</p>"];
            
            [appHtml replaceOccurrencesOfString:@"<p>mainnews</p>" withString:str5 options:NSCaseInsensitiveSearch range:range];
            NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
            [_webView loadHTMLString:appHtml baseURL:baseURL];
            
        }
    }
}

- (void)getImageFromDownloaderOrDiskByImageUrlArray:(NSArray *)imageArray {
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    [[SDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url) {
        url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
        NSString *str = [self replaceUrlSpecialString:[url absoluteString]];
        return str;
    }];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    for (NSDictionary *d in imageArray) {
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[imageArray count]];
        ImageInfo *info = [[ImageInfo alloc] initWithInfo:d];//kvc
        [images addObject:info];
        NSURL *imageUrl = [NSURL URLWithString:info.src];
        if ([imageManager diskImageExistsForURL:imageUrl]) {
            NSString *cacheKey = [imageManager cacheKeyForURL:imageUrl];
            NSString *imagePaths = [NSString stringWithFormat:@"%@/%@",filePath,[imageManager.imageCache cachedFileNameForKey:cacheKey]];
   
            [_bridge send:[NSString stringWithFormat:@"replaceimage%@,%@",[self replaceUrlSpecialString:info.src],imagePaths]];
        }else {
            [imageManager downloadImageWithURL:imageUrl options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (image && finished) {//如果下载成功
                    
                    NSString *cacheKey = [imageManager cacheKeyForURL:imageUrl];
                    NSString *imagePaths = [NSString stringWithFormat:@"%@/%@",filePath,[imageManager.imageCache cachedFileNameForKey:cacheKey]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [_bridge send:[NSString stringWithFormat:@"replaceimage%@,%@",[self replaceUrlSpecialString:info.src],imagePaths]];
                    });
                }else {
                    
                }
            }];
        }
    }
}


- (NSString *)replaceUrlSpecialString:(NSString *)string {
    
    return [string stringByReplacingOccurrencesOfString:@"/"withString:@"_"];
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
        return [UIScreen mainScreen].bounds.size.height - 64;
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

#pragma UINavigationController Delegate
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    if (operation == UINavigationControllerOperationPush) {
//        return [[MoveTransition alloc] init];
//    }else{
//        return nil;
//    }
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
//{
//    if ([navigationController isKindOfClass:[MoveTransition class]]) {
//        return _percentDrivenInteractiveTransition;
//    }else {
//        return nil;
//    }
//}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ConversationViewController *vc = [segue destinationViewController];
    vc.replyBoard = [dataDic objectForKey:@"replyBoard"];
    vc.postid = [dataDic objectForKey:@"docid"];
}


@end
