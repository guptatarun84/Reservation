//
//  DataStore.h
//  Reservation
//
//  Created by Tarun Gupta on 2/19/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

/*!
 * @brief Singleton defined for managedObjectContext
 */
+ (id)sharedManager;


@end
