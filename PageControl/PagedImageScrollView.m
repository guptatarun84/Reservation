//
//  PagedImageScrollView.m
//  Test
//
//  Created by jianpx on 7/11/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import "PagedImageScrollView.h"

@interface PagedImageScrollView() <UIScrollViewDelegate>
@property (nonatomic) BOOL pageControlIsChangingPage;
@end

@implementation PagedImageScrollView


#define PAGECONTROL_DOT_WIDTH 30
#define PAGECONTROL_HEIGHT 20

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.pageControl = [[UIPageControl alloc] init];
        [self setDefaults];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.scrollView.delegate = self;
    }
    return self;
}


- (void)setPageControlPos:(enum PageControlPosition)pageControlPos
{
    CGFloat width = PAGECONTROL_DOT_WIDTH * self.pageControl.numberOfPages;
    _pageControlPos = pageControlPos;
    if (pageControlPos == PageControlPositionRightCorner)
    {
        self.pageControl.frame = CGRectMake(self.scrollView.frame.size.width - width, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionCenterBottom)
    {
        self.pageControl.frame = CGRectMake((self.scrollView.frame.size.width - width) / 2, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionLeftCorner)
    {
        self.pageControl.frame = CGRectMake(0, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionCenter) // #Tarun: Changes made to external library to show PageControl on center of screen.
    {
        self.pageControl.frame = CGRectMake((self.scrollView.frame.size.width - width) / 2, (self.scrollView.frame.size.height - PAGECONTROL_HEIGHT) / 2, width, PAGECONTROL_HEIGHT);
    }
}

- (void)setDefaults
{
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.hidesForSinglePage = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControlPos = PageControlPositionRightCorner;
}


- (void)setScrollViewContents: (NSArray *)images
{
    //remove original subviews first.
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    if (images.count <= 0) {
        self.pageControl.numberOfPages = 0;
        return;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, self.scrollView.frame.size.height);
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [imageView setImage:images[i]];
        [self.scrollView addSubview:imageView];
    }
    self.pageControl.numberOfPages = images.count;
    //call pagecontrolpos setter.
    self.pageControlPos = self.pageControlPos;
}

- (void)changePage:(UIPageControl *)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlIsChangingPage = YES;
}

#pragma mark - ScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageControlIsChangingPage) {
        return;
    }
    CGFloat offset = _scrollView.contentOffset.x;
    CGFloat pageWidth = scrollView.frame.size.width;
    //switch page at 50% across
    int page = floor((offset - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    
//    CGFloat offset = _scrollView.contentOffset.x;
//    CGFloat pageWidth = _scrollView.frame.size.width;
//    
//    NSInteger page = floor((offset + (pageWidth/2)) / pageWidth);
//    if (page == 0) {
//        page = _pageControl.numberOfPages - 1;
//    }
//    else if (page == _pageControl.numberOfPages + 1) {
//        page = 0;
//    }
//    else {
//        page = page - 1;
//    }
//    _pageControl.currentPage = page;
//    
//    // If present in scroll view's first page, move it to second last page
//    if (offset < pageWidth) {
//        [_scrollView setContentOffset:CGPointMake(pageWidth * 3 + offset, 0) animated:NO];
//    }
//    // If present in scroll view's last page, move it to second page.
//    else if (offset >= pageWidth * (_pageControl.numberOfPages + 1)) {
//        CGFloat difference = offset - pageWidth * _pageControl.numberOfPages;
//        [_scrollView setContentOffset:CGPointMake(difference, 0) animated:NO];
//    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
    
    CGFloat offset = _scrollView.contentOffset.x;
    CGFloat pageWidth = scrollView.frame.size.width;
    //switch page at 50% across
    int page = floor((offset - pageWidth / 2) / pageWidth) + 1;
    
    // Change the text accordingly
    if (page == 1){
        _pageSelectionBlock(true);
    }else {
        _pageSelectionBlock(false);
    }
    
//    NSLog(@"%f",self.scrollView.contentOffset.x);
//    // The key is repositioning without animation
//    if (self.scrollView.contentOffset.x == 0) {
//        // user is scrolling to the left from image 1 to image 3
//        // reposition offset to show image 3 that is on the right in the scroll view
//        [self.scrollView setContentOffset:CGPointMake(750, 0) animated:YES];
//    }
//    else if (self.scrollView.contentOffset.x == 750) {
//        // user is scrolling to the right from image 3 to image 1
//        // reposition offset to show image 1 that is on the left in the scroll view
//        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
}


@end
