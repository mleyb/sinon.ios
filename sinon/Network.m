//
//  Network.m
//  Sinon
//
//  Created by Mark Leybourne on 30/05/2013.
//  Copyright (c) 2013 Mark Leybourne. All rights reserved.
//

#import "Network.h"

@implementation Network

-(id)initWithData:(int)networkId name:(NSString*)name cultureCode:(NSString*)cultureCode
{
    self = [super init];
    if (self) {
        _networkId = networkId;
        _name = name;
        _cultureCode = cultureCode;
        return self;
    }
    return nil;
}

@end
