//
//  SightingsViewController.m
//  sinon
//
//  Created by Mark Leybourne on 02/06/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import "ReportNewSightingViewController.h"
#import "AppDelegate.h"
#import "AzureService.h"

@interface ReportNewSightingViewController ()
{
    // private iVars
}
@end

@implementation ReportNewSightingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"New Sighting", @"New Sighting");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *app = [AppDelegate instance];
 
    // Set the busy method
    UIActivityIndicatorView *indicator = self.activityIndicator;
    app.azureService.busyUpdate = ^(BOOL busy)
    {
        if (busy)
        {
            [indicator startAnimating];
        } else
        {
            [indicator stopAnimating];
        }
    };
    
    // add the refresh control to the table (iOS6+ only)
    //[self addRefreshControl];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *app = [AppDelegate instance];
    
    return app.azureService.stations.count;
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
    
    NSObject *station = app.azureService.stations[indexPath.row];
    cell.textLabel.text = [station valueForKey:@"Name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = [AppDelegate instance];
    
    NSObject *station = app.azureService.stations[indexPath.row];
    
    // TODO - save the sighting
}

@end
