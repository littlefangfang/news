//
//  UIImageView+Category.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/15.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

- (void)downloadImageWithURL:(NSString *)URL
{
    if (URL) {
        __block NSString *temp = NSTemporaryDirectory();
        temp = [temp stringByAppendingString:URL.lastPathComponent];
        
        __block UIImage *image = [UIImage imageWithContentsOfFile:temp];
        
        
        NSURL *imageURL = [NSURL URLWithString:URL];
        if (!image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    image = [UIImage imageWithData:imageData];
                    self.image = image;
                    
                    [imageData writeToFile:temp atomically:YES];
                });
            });
        }
        self.image = image;
    }
}

@end
