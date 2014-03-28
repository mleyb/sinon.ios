//
//  AlertUtility.m
//  sinon
//
//  Created by Mark Leybourne on 06/06/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import "AlertUtility.h"

@implementation AlertUtility

+ (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end