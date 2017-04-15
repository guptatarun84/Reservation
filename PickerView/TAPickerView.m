//
//  TAPickerView.m
//  Reservation
//
//  Created by Tarun Gupta on 2/18/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "TAPickerView.h"

#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define KNumberOfPickerComponents 1
#define KPEOPLECOUNT @"PEOPLECOUNT"

#define INT16_MAX  32767

@interface TAPickerView () {
    NSInteger pickerViewMiddle;
}

@property (strong, nonatomic) NSArray *partySizeArray;

@end

@implementation TAPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _partySizeArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
        
        [self addPickerView];
    }
    return self;
}


- (void) addPickerView {
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancelClicked)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(doneClicked)];
    toolBar.items = @[barButtonCancel, flex, barButtonDone];
    barButtonDone.tintColor = [UIColor customBlueColor_];
    
    pickerView_ = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                 toolBar.frame.size.height,
                                                                 KSCREEN_WIDTH,
                                                                 200)];
    [pickerView_ setBackgroundColor:[UIColor whiteColor]];
    [pickerView_ setDataSource: self];
    [pickerView_ setDelegate: self];
    pickerView_.showsSelectionIndicator = YES;
    
    [self addSubview:toolBar];
    [self addSubview:pickerView_];
    
    [pickerView_ selectRow:(INT16_MAX/(2*[_partySizeArray count]))*[_partySizeArray count] inComponent:0 animated:NO];
    pickerViewMiddle = ((INT16_MAX / [_partySizeArray count]) / 2) * [_partySizeArray count];

}

- (void)removePickerView {
    [self removeFromSuperview];
}

- (void)cancelClicked {
    [self removePickerView];
}

- (void)doneClicked {
    NSInteger row = [pickerView_ selectedRowInComponent:0];
    NSString *partySize = [_partySizeArray objectAtIndex:(row % [_partySizeArray count])];
    _peopleCountBlock(partySize);

    //save the count in NSUserDefaults
    [[NSUserDefaults standardUserDefaults]setObject:partySize forKey:KPEOPLECOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self removePickerView];
}

//- (NSInteger)rowForValue:(NSInteger)value {
//    NSInteger i = [_partySizeArray value];
//    if let valueIndex = find(pickerViewData, value) {
//        return pickerViewMiddle + value
//    }
//}

- (NSInteger) valueForRow:(NSInteger)row {
    row = row % [_partySizeArray count]; // This is the value you should use as index of your data
    return ++row;
}

#pragma mark - UIPickerView Datasource Methods -
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return INT16_MAX;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return KNumberOfPickerComponents;
}

#pragma mark - UIPickerView Delegate Methods -

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [_partySizeArray objectAtIndex:row];
    NSString *displayString = [NSString stringWithFormat: @"%ld", [self valueForRow:row]];
    return displayString;
}

//- (void)pickerView:(UIPickerView *)pickerView
//      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = pickerView.frame.size.width;
    return sectionWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}


//- (UIView *)pickerView:(UIPickerView *)pickerView
//            viewForRow:(NSInteger)row
//          forComponent:(NSInteger)component
//           reusingView:(UIView *)view {
//    UILabel *textLabel = (UILabel *)view;
//    if (!textLabel) {
//        textLabel = [[UILabel alloc] init];
//        [textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
//        [textLabel setTextAlignment:NSTextAlignmentCenter];
//        textLabel.numberOfLines = 1;
//    }
//    
//    textLabel.text = [_partySizeArray objectAtIndex:row];
//    return textLabel;
//}

@end
