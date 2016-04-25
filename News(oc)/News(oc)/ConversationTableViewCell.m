//
//  ConversationTableViewCell.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/25.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "ConversationTableViewCell.h"

@implementation ConversationTableViewCell{
    NSInteger lastH;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        for (NSInteger i; i < _viewCount; i++) {
            <#statements#>
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViews
{
    if (!lastH) {
        lastH = _viewCount * 3;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(41 + _viewCount * 3, _viewCount * 3, [UIScreen mainScreen].bounds.size.width - 49 - (_viewCount * 2) * 3, _viewCount * 3)];
    
    if (view.frame.size.width <= [UIScreen mainScreen].bounds.size.width - 49 - (_viewCount * 2) * 6) {
        CGRect frame = view.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width - 49 - (_viewCount * 2) * 6;
        view.frame = frame;
    }
    UIButton *nButton = [[UIButton alloc] initWithFrame:CGRectMake(8, lastH + 8, 173, 15)];
    nButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, lastH + 31, 173, 12)];
    aLabel.font = [UIFont systemFontOfSize:12.0];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, lastH + 51, view.bounds.size.width - 16, 21)];
    contentLabel.numberOfLines = 0;
    
    CGRect tempFrame = view.frame;
    tempFrame.size.height = contentLabel.frame.size.height + contentLabel.frame.origin.y + 8;
    view.frame = tempFrame;
    
    lastH = view.frame.origin.y + view.frame.size.height;
    [view addSubview:nButton];
    [view addSubview:aLabel];
    [view addSubview:contentLabel];
}


@end
