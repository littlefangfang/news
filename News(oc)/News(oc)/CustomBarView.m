//
//  CustomBarView.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/22.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "CustomBarView.h"

@implementation CustomBarView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.searchBar.backgroundImage = [UIImage new];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.frame = CGRectMake(-5, 0,[UIScreen mainScreen].bounds.size.width, 44);
    }
    return self;
}


@end
