//
//  ImageInfo.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/20.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo

- (id)initWithInfo:(NSDictionary *)dic
{
    if (self) {
        [self setValuesForKeysWithDictionary:dic];//kvc
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
