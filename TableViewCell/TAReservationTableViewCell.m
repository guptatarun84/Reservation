//
//  TAReservationTableViewCell.m
//  Reservation
//
//  Created by Tarun Gupta on 2/18/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "TAReservationTableViewCell.h"

@implementation TAReservationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {0, 10, 0, 10};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
//
//- (void)layoutSubviews {
//    self.preferredMaxLayoutWidth = self.frame.size.width;
//    [super layoutSubviews];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cancelButtonClicked:(id)sender {
    self.authResponseBlock([sender tag]);
}

- (IBAction)rescheduleButtonClicked:(id)sender {
    self.authResponseBlock([sender tag]);
}

@end
