//
//  TAScheduleViewController.h
//  Reservation
//
//  Created by Tarun Gupta on 2/17/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAScheduleViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) NSManagedObject *managedObject;

@end
