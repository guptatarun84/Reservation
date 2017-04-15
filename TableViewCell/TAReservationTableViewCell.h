//
//  TAReservationTableViewCell.h
//  Reservation
//
//  Created by Tarun Gupta on 2/18/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAReservationTableViewCell : UITableViewCell

/*!
 * @brief The button for rescheduling the event
 */
@property (weak, nonatomic) IBOutlet UIButton *rescheduleButton;

/*!
 * @brief The button for displaying cancel event
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/*!
 * @brief The label for displaying schedule date of appointment
 */
@property (weak, nonatomic) IBOutlet UILabel *scheduledDateLabel;

/*!
 * @brief The label to display time of appointment
 */
@property (weak, nonatomic) IBOutlet UILabel *appointmentTime;

/*!
 * @brief The label to display type of massage requested
 */
@property (weak, nonatomic) IBOutlet UILabel *massageType;

/*!
 * @brief The label to display number of members comimg on said timings
 */
@property (weak, nonatomic) IBOutlet UILabel *partySizeLabel;

/*!
 * @brief The label to display massage description
 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

/*!
 * @brief The block used for callback for particular cell
 */
@property (nonatomic, copy) void(^authResponseBlock)(NSInteger);

/*!
 * @brief This IBAction to cancel any scheduled appointment
 */
- (IBAction)cancelButtonClicked:(id)sender;

/*!
 * @brief This IBAction to reschedule any appointment
 */
- (IBAction)rescheduleButtonClicked:(id)sender;

@end
