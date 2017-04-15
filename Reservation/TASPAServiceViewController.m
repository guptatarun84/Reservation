//
//  TASPAServiceViewController.m
//  Reservation
//
//  Created by Tarun Gupta on 2/16/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "TASPAServiceViewController.h"

#import "TAScheduleViewController.h"
#import "PagedImageScrollView.h"

/** Private category of the TASPAServiceViewController class */
@interface TASPAServiceViewController () {
    NSArray *_massageArray;
}
/** Background Images Array */
@property (nonatomic, strong) NSArray *imagesArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *_amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *_descLabel;
@property (weak, nonatomic) IBOutlet UILabel *_infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *_validityLabel;

@property (weak, nonatomic) IBOutlet UIButton *reserveButton;

@property (nonatomic, strong) PagedImageScrollView *pageScrollView;

@property (assign, nonatomic) BOOL isHotStoneMassage;

- (IBAction)reserveButtonClicked:(id)sender;

@end

@implementation TASPAServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor headerColor_];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _imagesArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"Image1"], [UIImage imageNamed:@"Image2"], [UIImage imageNamed:@"Image3"], nil];
    
    [self loadPageControl:_imagesArray];
    
    [self.view addSubview:_pageScrollView];
    [self.view bringSubviewToFront:_tableView];
    [self.view bringSubviewToFront:_reserveButton];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    _reserveButton.layer.cornerRadius = 6; // this value vary as per requirement, done in nib file
    _massageArray = [NSArray arrayWithObjects:@"Swedish Massage", @"Deep Tissue Massage", @"Hot Stone Massage", @"Reflexology", @"Trigger Point Therapy", nil];
    
    _isHotStoneMassage = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"SPA SERVICE";
    self.navigationController.navigationBar.titleTextAttributes = [TAUtilityView getNavigationTitleAttributes];
}

- (IBAction)reserveButtonClicked:(id)sender {
    TAScheduleViewController *_taScheduleVC = [[TAScheduleViewController alloc] initWithNibName:@"TAScheduleViewController" bundle:nil];
    [self.navigationController pushViewController:_taScheduleVC animated:YES];
}

- (void)loadPageControl:(NSArray *)imagesArray {
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.y = self.navigationController.navigationBar.frame.size.height-20;
    _pageScrollView = [[PagedImageScrollView alloc] initWithFrame:rect];
    [_pageScrollView setScrollViewContents:imagesArray];
    //easily setting pagecontrol pos, see PageControlPosition defination in PagedImageScrollView.h
    _pageScrollView.pageControlPos = PageControlPositionCenter;
    __weak TASPAServiceViewController *weakSelf = self;
    _pageScrollView.pageSelectionBlock = ^(BOOL value){
        weakSelf.reserveButton.enabled = value;
        _isHotStoneMassage = value;
        if (value == true)
            weakSelf.reserveButton.alpha = 1.0;
        else
            weakSelf.reserveButton.alpha = 0.5;
    };
}

#pragma mark - UITableViewDatasource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {              // Default is 1 if not implemented
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_massageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_massageArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_isHotStoneMassage == true && indexPath.row == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        TAScheduleViewController *_taScheduleVC = [[TAScheduleViewController alloc] initWithNibName:@"TAScheduleViewController" bundle:nil];
        [self.navigationController pushViewController:_taScheduleVC animated:YES];
        
    }
}

@end
