//
//  TAUtilityView.m
//  Reservation
//
//  Created by Tarun Gupta on 2/19/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "TAUtilityView.h"

@implementation TAUtilityView

+ (UILabel *)getSystemFont:(NSString *)string {
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:8.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = string;
    
    return label;
}

+ (NSDictionary *)getNavigationTitleAttributes {
    NSDictionary *settings = @{
                               NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:21],
                               NSForegroundColorAttributeName: [UIColor whiteColor]
                               };
    return settings;
}

+ (NSString *)monthToDisplay:(NSDate*)date {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM"];    
    NSString *dateString = [format stringFromDate:date];
    return dateString;
}

@end
