//
//  TAReservationViewController.h
//  Reservation
//
//  Created by Tarun Gupta on 2/16/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAReservationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

/*!
 * @brief This property defines fetchresultcontroller used in tableview
 */
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
