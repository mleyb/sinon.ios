#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <Foundation/Foundation.h>


#pragma mark * Block Definitions


typedef void (^CompletionBlock) (NSError *error);
typedef void (^CompletionWithIndexBlock) (NSUInteger index, NSError *error);
typedef void (^BusyUpdateBlock) (BOOL busy);


#pragma mark * AzureService public interface


@interface AzureService : NSObject

@property (nonatomic, strong)   NSArray *networks;
@property (nonatomic, strong)   NSArray *stations;
@property (nonatomic, strong)   NSArray *sightings;
@property (nonatomic, strong)   NSArray *items;
@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, copy)     BusyUpdateBlock busyUpdate;

+ (AzureService *)defaultService;

- (void)refreshNetworks:(CompletionBlock)completion;
- (void)refreshStations:(int)networkId completion:(CompletionBlock)completion;
- (void)refreshSightings:(int)networkId completion:(CompletionBlock)completion;

- (void)addSighting:(NSDictionary *)sighting
         completion:(CompletionWithIndexBlock)completion;

- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response;

@end
