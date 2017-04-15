//
//  TAUtilityView.h
//  Reservation
//
//  Created by Tarun Gupta on 2/19/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAUtilityView : NSObject

/*!
 * @brief The label defines the generic label for UIView
 */
+ (UILabel *)getSystemFont:(NSString *)string;

/*!
 * @brief The dictionary return the text attributes for UINavigation Bar
 */
+ (NSDictionary *)getNavigationTitleAttributes;

/*!
 * @brief The method returns month format 
 */
+ (NSString *)monthToDisplay:(NSDate*)date;


@end
