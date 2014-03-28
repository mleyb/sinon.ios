#import "AzureService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "Network.h"

#pragma mark * Private interace


@interface AzureService() <MSFilter>

@property (nonatomic, strong)   MSTable *networkTable;
@property (nonatomic, strong)   MSTable *stationTable;
@property (nonatomic, strong)   MSTable *sightingTable;
@property (nonatomic)           NSInteger busyCount;

@end


#pragma mark * Implementation


@implementation AzureService

@synthesize networks;
@synthesize stations;
@synthesize sightings;
@synthesize items;


+ (AzureService *)defaultService
{
    // Create a singleton instance of AzureService
    static AzureService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[AzureService alloc] init];
    });
    
    return service;
}

-(AzureService *)init
{
    self = [super init];
    
    if (self)
    {
        // Initialize the Mobile Service client
        MSClient *client = [MSClient clientWithApplicationURLString:@""
                                                     applicationKey:@""];
        
        // Add a Mobile Service filter to enable the busy indicator
        self.client = [client clientWithFilter:self];
        
        // Create MSTable instances
        self.networkTable = [self.client tableWithName:@"Network"];
        self.stationTable = [self.client tableWithName:@"Station"];
        self.sightingTable = [self.client tableWithName:@"Sighting"];
        
        self.networks = [[NSMutableArray alloc] init];
        self.stations = [[NSMutableArray alloc] init];
        self.sightings = [[NSMutableArray alloc] init];
        self.busyCount = 0;
    }
    
    return self;
}

- (void)refreshStations:(int)networkId completion:(CompletionBlock)completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NetworkId == %d", networkId];
    
    [self.stationTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
    {
        [self logErrorIfNotNil:error];
         
        stations = [results mutableCopy];
         
        // Let the caller know that we finished
        completion(error);
    }];
}


- (void)refreshNetworks:(CompletionBlock)completion
{
    [self.networkTable readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error)
    {
        [self logErrorIfNotNil:error];
        
        networks = [results mutableCopy];
        
        // Let the caller know that we finished
        completion(error);
     }];
}

- (void)refreshSightings:(int)networkId completion:(CompletionBlock)completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NetworkId == %d", networkId];
    
    [self.sightingTable readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         
         sightings = [results mutableCopy];
         
         // Let the caller know that we finished
         completion(error);
     }];
}

-(void)addSighting:(NSDictionary *)sighting completion:(CompletionWithIndexBlock)completion
{
    // Insert the item into the Sighting table and add to the items array on completion
    [self.sightingTable insert:sighting completion:^(NSDictionary *result, NSError *error)
     {
         [self logErrorIfNotNil:error];
         
         NSUInteger index = [sightings count];
         [(NSMutableArray *)sightings insertObject:result atIndex:index];
         
         // Let the caller know that we finished
         completion(index, error);
     }];
}

- (void)busy:(BOOL)busy
{
    // assumes always executes on UI thread
    if (busy)
    {
        if (self.busyCount == 0 && self.busyUpdate != nil)
        {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil)
        {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void)logErrorIfNotNil:(NSError *) error
{
    if (error)
    {
        NSLog(@"ERROR %@", error);
    }
}


#pragma mark * MSFilter methods


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *innerResponse, NSData *data, NSError *error)
    {
        [self busy:NO];
        response(innerResponse, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    next(request, wrappedResponse);
}

@end
