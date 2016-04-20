//
//  ImageInfo.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/20.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

@property(nonatomic,copy)NSString *alt;
@property(nonatomic,copy)NSString *pixel;
@property(nonatomic,copy)NSString *ref;
@property(nonatomic,copy)NSString *src;

- (id)initWithInfo:(NSDictionary *)dic;

@end
