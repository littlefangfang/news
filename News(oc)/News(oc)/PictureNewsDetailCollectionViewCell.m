//
//  PictureNewsDetailCollectionViewCell.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/9.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "PictureNewsDetailCollectionViewCell.h"

@implementation PictureNewsDetailCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
     self.scrollView.delegate = self;
    [self setZoomScale];
}

#pragma mark - Helper

- (void)setZoomScale
{
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 3.0f;
    self.scrollView.zoomScale = 1.0f;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize imageViewSize = _imgView.frame.size;
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGFloat vertical = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    CGFloat horizon = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
    _scrollView.contentInset = UIEdgeInsetsMake(vertical, horizon, vertical, horizon);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGSize imageViewSize = _imgView.frame.size;
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGFloat vertical = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    CGFloat horizon = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
    _scrollView.contentInset = UIEdgeInsetsMake(vertical, horizon, vertical, horizon);
}

@end
