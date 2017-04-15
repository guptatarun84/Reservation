//
//  PagedImageScrollView.h
//  Test
//
//  Created by jianpx on 7/11/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PageControlPosition {
    PageControlPositionRightCorner = 0,
    PageControlPositionCenterBottom = 1,
    PageControlPositionLeftCorner = 2,
    PageControlPositionCenter = 3, // #Tarun: Changes made to external library to show PageControl on center of screen.
};

@interface PagedImageScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) enum PageControlPosition pageControlPos; //default is PageControlPositionRightCorner

/*!
 * @brief Block executed when the user scrolls to particular page.
 */
@property (copy, nonatomic) void (^pageSelectionBlock)(BOOL);

- (void)setScrollViewContents: (NSArray *)images;
@end
