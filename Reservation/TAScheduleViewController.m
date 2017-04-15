//
//  TAScheduleViewController.m
//  Reservation
//
//  Created by Tarun Gupta on 2/17/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "TAScheduleViewController.h"

#import "TAPickerView.h"
#import "CVCell.h"
#import "WeekViewFlowLayout.h"
#import "WeekView.h"

#import "UIView+Borders.h"
#import "NSDate+Extended.h"
#import "ReservationList+CoreDataClass.h"
#import "ReservationList+CoreDataProperties.h"


#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TAScheduleViewController () {
    /*!
     * @brief The pickerView for displaying the party list.
     */
    UIPickerView *pickerView_;
    
    NSInteger count;
}
    
@property (weak, nonatomic) IBOutlet UIView *massageInfoView;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UIButton *peopleCountButton;

@property (strong, nonatomic) NSArray *partySizeArray;
@property (strong, nonatomic) NSArray *timmingsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet WeekView *calendarCollectionView;
@property (strong, nonatomic) NSString *selectedString;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSString *peopleCount;

@property (strong, nonatomic) ReservationList *reservationList;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (copy, nonatomic) void (^reserveButtonActivated)(NSInteger, NSString *string);    
    
- (IBAction)reserveButtonClicked:(id)sender;
- (IBAction)peopleCountButtonClicked:(id)sender;
    
    @end

@implementation TAScheduleViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.reserveButton setBackgroundColor:[UIColor headerColor_]];
    
    [self loadAvailableTimings];
    [self loadDateSelectionView];
}
    
- (void) viewWillAppear:(BOOL)animated {
    count = 0;
    __weak TAScheduleViewController *weakSelf = self;
    self.reserveButtonActivated = ^(NSInteger total, NSString *string){
        if (total == 2) {
            weakSelf.reserveButton.enabled = true;
            weakSelf.reserveButton.alpha = 1.0;
            weakSelf.reserveButton.backgroundColor = [UIColor customBlueColor_];
        }
        if (![string isEqualToString:@""]) {
            _selectedString = string;
        }
    };
}
    
- (void)setNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor headerColor_];
    self.navigationController.navigationBar.topItem.title = @" ";
    self.navigationItem.title = @"SCHEDULE";
    self.navigationController.navigationBar.titleTextAttributes = [TAUtilityView getNavigationTitleAttributes];
    
    //    [self.navigationController.navigationBar
    //     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)loadDateSelectionView {
    _calendarCollectionView.delegate = self;
    _calendarCollectionView.dataSource = self;
    int nextYear = (int)[[NSDate date] year] +1;
    [_calendarCollectionView setStartDate:[NSDate date] endDate:[NSDate dateWithYear:nextYear month:1 day:1 hour:1 minute:1 second:1]];
    [_calendarCollectionView setCurrentDate:[NSDate date] animated:NO];
    
    [_calendarCollectionView setBackgroundColor:[UIColor clearColor]];
    _calendarCollectionView.showsHorizontalScrollIndicator = NO;
    [_calendarCollectionView registerClass:[WeekViewCell class] forCellWithReuseIdentifier:@"WeekViewCellIdentifier"];
    
    // Week View
    WeekViewFlowLayout *weekViewLayout = [[WeekViewFlowLayout alloc] init];
    [weekViewLayout setItemSize:CGSizeMake(60, 80)];
    weekViewLayout.flowLayoutCellSpacing = 10;
    [self.calendarCollectionView setCollectionViewLayout:weekViewLayout];
}
    
- (void)loadAvailableTimings {
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    
    /* Small logic to check and change AM to PM */
    int j = 9;
    NSString *timeZone = @"AM";
    for (int i=0; i<12; i++) {
        [firstSection addObject:[NSString stringWithFormat:@"%d:00 %@", j, timeZone]];
        if (j==12) {
            j=0;
            timeZone = @"PM";
        }
        j++;
    }
    
    self.timmingsArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    
    [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    // Configure layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 40)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
}
    
    
- (IBAction)reserveButtonClicked:(id)sender {
    NSManagedObjectContext *context = [[DataStore sharedManager] managedObjectContext];
    [self saveOrUpdateDataInDB:_managedObject withContext:context];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
    
- (IBAction)peopleCountButtonClicked:(id)sender {
    TAPickerView *taPickerView = [[TAPickerView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT - 300, KSCREEN_WIDTH, 300)];
    [self.view addSubview:taPickerView];
    
    __weak TAScheduleViewController *weakSelf = self;
    taPickerView.peopleCountBlock = ^(NSString *value){
        weakSelf.peopleCountButton.titleLabel.text = value;
        _peopleCount = value;
    };
}
    
    
- (void)saveOrUpdateDataInDB:(NSManagedObject *)object withContext:(NSManagedObjectContext *)context { //TBD: In separate view class
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"ReservationList"
                inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"(scheduleDate CONTAINS %@)",[[object valueForKey:@"scheduleDate"] description]];
    
    if (!predicate)
    return;
    
    [fetchRequest setPredicate:predicate];
    
    NSString *peopleCount = _peopleCount;
    if (peopleCount == nil) {
        if ([[object valueForKey:@"partySize"] description]!= nil) {
            peopleCount = [[object valueForKey:@"partySize"] description];
        } else {
            peopleCount = @"12"; //Default for first timers
        }
    }
    NSLog(@"scheduleDate : %@",[[object valueForKey:@"scheduleDate"] description]);
    NSArray *objects;
    if ([[object valueForKey:@"scheduleDate"] description] != nil) {
        objects = [[context executeFetchRequest:fetchRequest
                                          error:nil] mutableCopy];
    }
    
    if (objects.count > 0) {
        _reservationList = [objects lastObject];
    } else {
        _reservationList = [NSEntityDescription insertNewObjectForEntityForName:@"ReservationList" inManagedObjectContext:context];
    }
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    NSDate *date = [NSDate date];
    [_reservationList setValue:[date weekdayDate:_selectedDate] forKey:@"scheduleDate"];
    [_reservationList setValue:@"Massage focused on the deepest layer of muscles to target knots and release chronic muscle tension." forKey:@"massageDesc"]; // replace with dynamic string later # Api can be used to fetch the desc
    [_reservationList setValue:@"Hot Stone Massage" forKey:@"massageType"]; // replace with dynamic string later # API can be used to fetch the type of massage
    [_reservationList setValue:peopleCount forKey:@"partySize"];
    [_reservationList setValue:_selectedString forKey:@"scheduleTime"];
    [_reservationList setValue:date forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
    
    
#pragma mark - UICollectionView Datasource -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.collectionView)
    return [self.timmingsArray count];
    else if (collectionView == self.calendarCollectionView)
    return 1;
    
    return 1;
}
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger cellCount;
    if (collectionView == self.collectionView) {
        NSMutableArray *sectionArray = [self.timmingsArray objectAtIndex:section];
        cellCount = [sectionArray count];
    } else if (collectionView == self.calendarCollectionView) {
        WeekView *weakView = (WeekView *)collectionView;
        cellCount = [weakView.weekViewDays count];
    }
    return cellCount;
}
    
    //- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    //{
    //    float widthOfCell;
    //    float heightOfCell;
    //    if(collectionView != self.collectionView) {
    //        widthOfCell = 60;
    //        heightOfCell = collectionView.frame.size.height;
    //    }
    //
    //    return CGSizeMake(heightOfCell, widthOfCell);
    //}
    
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    // Setup cell identifier
    if(collectionView == self.collectionView)
    {
        //return cell for collection1
        static NSString *cellIdentifier = @"cvCell";
        
        CVCell *cvCell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        NSMutableArray *data = [self.timmingsArray objectAtIndex:indexPath.section];
        NSString *cellData = [data objectAtIndex:indexPath.row];
        [cvCell.titleLabel setText:cellData];
        
        cell = cvCell;
    }
    else if (collectionView == self.calendarCollectionView) {
        //return cell for collection2
        static NSString *cellIdentifier = @"WeekViewCellIdentifier";
        WeekViewCell *weakViewCell = (WeekViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        WeekView *weakView = (WeekView *)collectionView;
        WeekViewDay *cellDay = (WeekViewDay *)[weakView.weekViewDays objectAtIndex:indexPath.row];
        
        weakViewCell.dayNameLabel.text = cellDay.name;
        weakViewCell.dayDateLabel.text = [NSString stringWithFormat:@"%@",cellDay.day];
        
        NSString *month = [TAUtilityView monthToDisplay:cellDay.date];
        _monthLabel.text = [month uppercaseString];
        
        [weakViewCell setNeedsDisplay];
        
        cell = weakViewCell;
    }
    
    // Return the cell
    return cell;
}
    
    //- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //
    //}
    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        NSMutableArray *sectionArray = [self.timmingsArray objectAtIndex:indexPath.section];
        NSString *sender=[sectionArray objectAtIndex:indexPath.item];
        NSLog(@"%@", sender);
        
        CVCell *cell = (CVCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //set color with animation
        [UIView animateWithDuration:0.5
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [cell setBackgroundColor:[UIColor headerColor_]];
                             _reserveButtonActivated(++count, sender);
                         }
                         completion:nil ];
        
        [cell.checkmarkView setHidden:NO];
    } else if (collectionView == self.calendarCollectionView) {
        
        WeekView *weakView = (WeekView *)collectionView;
        WeekViewDay *cellDay = (WeekViewDay *)[weakView.weekViewDays objectAtIndex:indexPath.row];
        NSLog(@"cellDay.name = %@", cellDay.date);
        
        WeekViewCell *cell = (WeekViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //set color with animation
        [UIView animateWithDuration:0.1
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             cell.dayDateLabel.backgroundColor = [UIColor headerColor_];
                             cell.dayNameLabel.backgroundColor = [UIColor headerColor_];
                             _reserveButtonActivated(++count, @"");
                             _selectedDate = cellDay.date;
                         }
                         completion:nil ];
        
        [cell.checkmarkView setHidden:NO];
    }
}
    
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        CVCell *cell = (CVCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.5
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [cell setBackgroundColor:[UIColor whiteColor]];
                             _reserveButtonActivated(--count, @"");
                         }
                         completion:nil ];
        
        [cell.checkmarkView setHidden:YES];
    } else if (collectionView == self.calendarCollectionView) {
        WeekViewCell *cell = (WeekViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //set color with animation
        [UIView animateWithDuration:0.1
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             cell.dayDateLabel.backgroundColor = [UIColor whiteColor];
                             cell.dayNameLabel.backgroundColor = [UIColor whiteColor];
                             _reserveButtonActivated(--count, @"");
                             _selectedDate = nil;
                         }
                         completion:nil ];
        
        [cell.checkmarkView setHidden:YES];
    }
}
    
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
