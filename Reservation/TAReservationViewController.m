//
//  TAReservationViewController.m
//  Reservation
//
//  Created by Tarun Gupta on 2/16/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "TAReservationViewController.h"

#import "TASPAServiceViewController.h"
#import "IonIcons.h"
#import "TAReservationTableViewCell.h"
#import "TAScheduleViewController.h"

@interface TAReservationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TAReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"MY RESERVATIONS";
    self.navigationController.navigationBar.titleTextAttributes = [TAUtilityView getNavigationTitleAttributes];
    
    self.navigationController.navigationBar.barTintColor = [UIColor headerColor_];
    UIImage *rightButtonImage = [IonIcons imageWithIcon:ion_plus iconColor:[UIColor whiteColor]
                                               iconSize:20.0f
                                              imageSize:CGSizeMake(40.0f, 40.0f)];
    
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc]initWithImage:rightButtonImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(addbuttonClicked_:)];
    
    self.navigationItem.rightBarButtonItem=_btn;
}

- (void)viewWillAppear:(BOOL)animated {
//    [_tableView reloadData];
}

- (void)addbuttonClicked_:(id)sender {
    TASPAServiceViewController *_taSpaServiceVC = [[TASPAServiceViewController alloc] initWithNibName:@"TASPAServiceViewController" bundle:nil];
    UINavigationController *_navigationController =
    [[UINavigationController alloc] initWithRootViewController:_taSpaServiceVC];
    
    //now present this navigation controller modally
    [self presentViewController:_navigationController
                       animated:YES
                     completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TAReservationTableViewCell *)loadReservationCell:(UITableView *)tableView {
    NSString *resvCellIdentifier = @"ReservationCell";
    TAReservationTableViewCell *cell =
    (TAReservationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:resvCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TAReservationTableViewCell"
                                              owner:self
                                            options:nil] lastObject];
    }
    return cell;
}

#pragma mark - UITableViewDatasource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {              // Default is 1 if not implemented
//    return 1;
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAReservationTableViewCell *cell = [self loadReservationCell:tableView];
    cell.authResponseBlock = ^(NSInteger tag){
        if (tag == 0)
            [self rescheduleCell:indexPath];
        else
            [self deleteCell:indexPath];
    };
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.contentView.backgroundColor = [UIColor blueColor];
//    UIView  *whiteRoundedView = [[UIView alloc]initWithFrame:CGRectMake(0, 4, self.view.frame.size.width, cell.contentView.frame.size.height)];
//    CGFloat colors[]={1.0,1.0,1.0,1.0};//cell color white
//    whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), colors);
//    whiteRoundedView.layer.masksToBounds = false;
//    whiteRoundedView.layer.cornerRadius = 5.0;
//    whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1);
//    whiteRoundedView.layer.shadowOpacity = 0.2;
//    [cell.contentView addSubview:whiteRoundedView];
//    [cell.contentView sendSubviewToBack:whiteRoundedView];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *resvCellIdentifier = @"ReservationCell";
//    //assign the right cell identifier
//    UITableViewCell *cell = [[self tableView]dequeueReusableCellWithIdentifier:resvCellIdentifier];
//    return cell.bounds.size.height;
    
    return 220;
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)configureCell:(TAReservationTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.scheduledDateLabel.text = [[object valueForKey:@"scheduleDate"] description];
    cell.appointmentTime.text = [[object valueForKey:@"scheduleTime"] description];
    cell.massageType.text = [[object valueForKey:@"massageType"] description];
    cell.partySizeLabel.text = [NSString stringWithFormat:@"PARTY SIZE - %@",[[object valueForKey:@"partySize"] description]];
    cell.descriptionLabel.text = [[object valueForKey:@"massageDesc"] description];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ReservationList" inManagedObjectContext:[[DataStore sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[DataStore sharedManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void) deleteCell:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [[DataStore sharedManager] managedObjectContext];
    if ([self.fetchedResultsController objectAtIndexPath:indexPath]!=nil) {
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    } else {
        return;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) rescheduleCell:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    TAScheduleViewController *_taScheduleVC = [[TAScheduleViewController alloc] initWithNibName:@"TAScheduleViewController" bundle:nil];
    UINavigationController *_navigationController =
    [[UINavigationController alloc] initWithRootViewController:_taScheduleVC];
    _taScheduleVC.managedObject = object;
    
    //now present this navigation controller modally
    [self presentViewController:_navigationController
                       animated:YES
                     completion:nil];
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
