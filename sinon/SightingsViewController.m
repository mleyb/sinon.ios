//
//  SightingsViewController.m
//  sinon
//
//  Created by Mark Leybourne on 02/06/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import "SightingsViewController.h"

#import "ReportNewSightingViewController.h"
#import "AppDelegate.h"
#import "AzureService.h"
#import "UILoadingView.h"
#import "AlertUtility.h"

@interface SightingsViewController ()
{
    // private iVars
}

-(void)refreshSightings;

@end

@implementation SightingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Sightings", @"Sightings");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    AppDelegate *app = [AppDelegate instance];
    
    // Set the busy method
    app.azureService.busyUpdate = ^(BOOL busy) {
        if (busy)
        {
            [self.view addSubview:[[UILoadingView alloc] initWithFrameAndLabel:self.view.bounds label:@"Loading..."]];
        }
        else {
            [NSThread sleepForTimeInterval:1.0];
            [[self.view.subviews lastObject] removeFromSuperview]; //removes the UILoadingView
            [self.tableView reloadData];
        }
    };
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(reportNewSighting:)];
    self.navigationItem.leftBarButtonItem = refreshButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self refreshSightings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshSightings
{    
    int networkId = [[NSUserDefaults standardUserDefaults] integerForKey:@"NetworkId"];
    
    AppDelegate *app = [AppDelegate instance];
    
    [app.azureService refreshSightings:networkId completion:^(NSError *error){
        if (error) {
            [AlertUtility showAlert:@"Error" message:@"An error occurred. Please try again."];
        } else {
            NSLog(@"Got sightings");
        }
    }];
}

- (void)refreshTable:(id)sender
{
    [self refreshSightings];
}

- (void)reportNewSighting:(id)sender
{
    if (!self.reportNewSightingViewController) {
        self.reportNewSightingViewController = [[ReportNewSightingViewController alloc] initWithNibName:@"ReportNewSightingViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:self.reportNewSightingViewController animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *app = [AppDelegate instance];
    
    return app.azureService.networks.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    AppDelegate *app = [AppDelegate instance];
    
    NSObject *network = app.azureService.networks[indexPath.row];
    cell.textLabel.text = [network valueForKey:@"Name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
