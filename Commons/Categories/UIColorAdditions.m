//
//  UIColorAdditions.h
//  Reservation
//
//  Created by Tarun Gupta on 2/16/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "UIColorAdditions.h"

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation UIColor (Additions)

+ (UIColor*) colorFromHexRGB:(unsigned) rgbHexValue alpha:(float)alpha
{
    return [UIColor colorWithRed:
            ((float)((rgbHexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbHexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor*) colorFromHexRGB:(unsigned) rgbHexValue
{
    return [UIColor colorFromHexRGB:rgbHexValue alpha:1.0];
}

+ (UIColor*) colorFromRGB:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor*) colorFromRGB:(float)red green:(float)green blue:(float)blue
{
    return [UIColor colorFromRGB:red green:green blue:blue alpha:1.0];
}

+(UIColor *) randomColor
{
  CGFloat red =  (arc4random() % 255) / 255.0f;
  CGFloat blue = (arc4random() % 255) / 255.0f;
  CGFloat green = (arc4random() % 255) / 255.0f;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
