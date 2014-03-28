//
//  Network.h
//  Sinon
//
//  Created by Mark Leybourne on 30/05/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

@property (assign, atomic)      int networkId;
@property (nonatomic, retain)   NSString *name;
@property (nonatomic, retain)   NSString *cultureCode;

-(id)initWithData:(int)networkId name:(NSString *)name cultureCode:(NSString *)cultureCode;

@end
