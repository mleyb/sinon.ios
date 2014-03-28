//
//  SightingsViewController.h
//  sinon
//
//  Created by Mark Leybourne on 02/06/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportNewSightingViewController;
@class AzureService;

@interface SightingsViewController : UITableViewController

@property (strong, nonatomic) ReportNewSightingViewController *reportNewSightingViewController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
