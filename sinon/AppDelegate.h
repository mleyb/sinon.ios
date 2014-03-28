//
//  AppDelegate.h
//  sinon
//
//  Created by Mark Leybourne on 02/06/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AzureService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) AzureService *azureService;

+ (AppDelegate *)instance;

@end
