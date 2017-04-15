//
//  CVDateCollectionViewCell.m
//  Reservation
//
//  Created by Tarun Gupta on 2/18/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "CVDateCollectionViewCell.h"

@implementation CVDateCollectionViewCell

@synthesize dayDateLabel = _dayDateLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CVDateCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
    
}

@end
