//
//  CVDateCollectionViewCell.h
//  Reservation
//
//  Created by Tarun Gupta on 2/18/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVDateCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImage;

@end
