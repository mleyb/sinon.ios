//
//  Station.h
//  Sinon
//
//  Created by Mark Leybourne on 30/05/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (assign, atomic)      int id;
@property (assign, atomic)      int NetworkId;
@property (nonatomic, retain)   NSString* Name;

@end
