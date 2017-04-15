//
//  UIColorAdditions.h
//  Reservation
//
//  Created by Tarun Gupta on 2/16/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

/** This UIColor  class is for  Helper for quickly creating UIColor objects from RGB or HEX representation.
 
 */
@interface UIColor (Additions)

/**
 * @abstract Create a UIColor object from the HEX representation and the given alpha value
 * @param rgbHexValue for RGB hex value
 * @param  alpha for alpha value.
 * @return A UIColor instance object
 */
+ (UIColor*) colorFromHexRGB:(unsigned) rgbHexValue alpha:(float)alpha;

/**
 * @abstract Create a UIColor object from the HEX representation
 * @param rgbHexValue RGB hex value
 * @return A UIColor instance object
 */
+ (UIColor*) colorFromHexRGB:(unsigned) rgbHexValue;

/**
 * @abstract Create a UIColor object from the RGB representation and the given alpha value
 * @param  red for red value
 * @param  blue for blue value
 * @param  green for green value.
 * @return A UIColor instance object
 */
+ (UIColor*) colorFromRGB:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

/**
 * @abstract Create a UIColor object from the RGB representation
 * @param  red for red value
 * @param  blue for blue value
 * @param  green for green value.
 * @return A UIColor instance object
 */
+ (UIColor*) colorFromRGB:(float)red green:(float)green blue:(float)blue;

/**
 * @abstract Random UIColor (for debugging/personal entertainment only)
 * @return A UIColor instance object
 */
+ (UIColor *) randomColor;

@end
