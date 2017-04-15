//
//  TAPickerView.h
//  Reservation
//
//  Created by Tarun Gupta on 2/18/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate> {
    /*!
     * @brief The pickerView for displaying the party list.
     */
    UIPickerView *pickerView_;
}

/*!
 * @brief Block executed when the user select the people size.
 */
@property (copy, nonatomic) void (^peopleCountBlock)(NSString *size);


@end
