//
//  WeekViewCell.m
//  WeekViewDemo
//
//  Created by Yashwant Chauhan on 3/31/14.
//  Copyright (c) 2014 Yashwant Chauhan. All rights reserved.
//

#import "WeekViewCell.h"

#define CHECKMARKHEIGHTPADDING 10
#define CHECKMARKWIDTHPADDING 6

@implementation WeekViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor customBlueColor_];
        // TODO: Label adding isn't memory efficient
        float heightOfLabel = self.frame.size.height/2;
        float widthOfLabel = self.frame.size.width;
        
        self.dayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, widthOfLabel, heightOfLabel)];
        self.dayNameLabel.font = [UIFont systemFontOfSize:15];
        self.dayNameLabel.backgroundColor = [UIColor whiteColor];
        self.dayNameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.dayNameLabel];
        
        self.dayDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, widthOfLabel, heightOfLabel)];
        self.dayDateLabel.font = [UIFont boldSystemFontOfSize:17];
        self.dayDateLabel.backgroundColor = [UIColor whiteColor];
        self.dayDateLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.dayDateLabel];
        
        // #Tarun: Changes made to external library to show checkmark image on selection. 
//        self.checkmarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthOfLabel - CHECKMARKHEIGHTPADDING,
//                                                                           heightOfLabel - CHECKMARKWIDTHPADDING)];
        self.checkmarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.checkmarkView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        [self.checkmarkView setImage:[UIImage imageNamed:@"checkmark"]];
        [self.checkmarkView setHidden:YES];
        [self addSubview:self.checkmarkView];
    }
    return self;
}

@end
