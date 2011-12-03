//
//  GOFetchGigsOperation.m
//  GigOut
//
//  Created by BORA CELIK on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GOFetchGigsOperation.h"
#import <CoreLocation/CoreLocation.h>
#import "GOGig.h"
#import "GOAppDelegate.h"
#import "PSLog.h"

@implementation GOFetchGigsOperation

@synthesize location = location_;

#pragma mark - Initialization

- (id) initiWithLocation: (CLLocation *)location
{
    self = [self init];
    if (self)
    {
        location_ = [location copy];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Cleanup

- (void) dealloc
{
    [location_ release];
    [super dealloc];
}

#pragma mark - Operation main method

- (void)main
{
    
    @try {        
        //check to see if we have been cancelled.
        if (![self isCancelled])
        {
            NSMutableArray *gigs = [[NSMutableArray alloc] init];
            NSString *apiKey = @"b25b959554ed76058ac220b7b2e0a026";
            //NSUInteger count = kMaxResults;
            NSUInteger radius = kSearchRadiusKms;
            NSString *fetchUrlString = [NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=geo.getevents&lat=%@&lng=%@&format=json&api_key=%@",
                                        @"51.549751017014245",
                                        @"-1.494140625",                                        apiKey];
            NSURL *fetchUrl = [NSURL URLWithString: fetchUrlString];
            NSStringEncoding encoding;
            
            //fetch data from web service
            NSString *jsonString = [NSString stringWithContentsOfURL:fetchUrl usedEncoding:&encoding error:nil];
            PSLogDebug(@"json %@", jsonString);
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
            NSError *jsonError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
            
      
        
            //check to see if we have been cancelled
            if (![self isCancelled])
            {
                if (dictionary) {
                    
                    NSDictionary *events = [dictionary objectForKey:@"events"];
                    if (events) {
                        
                        for (NSDictionary *thisEvent in events)
                        {
                            NSDictionary *event = [thisEvent objectForKey:@"event"];
                            GOGig *gig = [[GOGig alloc] init];
                            gig.gigName = [event objectForKey:@"title"];
                            
                            NSDictionary *artists = [event objectForKey:@"artists"];
                            
                            
                            gig.artistName = [artists objectForKey:@"headliner"];                            
                           
                            NSDictionary *venue = [thisEvent objectForKey:@"venue"];
                            
                            gig.venueId = [venue objectForKey:@"id"]; 
                            gig.venueName = [venue objectForKey:@"name"];
                            
                            
                            NSDictionary *location = [venue objectForKey:@"location"];
                            NSDictionary *geopoint = [location objectForKey:@"geo:point"];
                            
                            gig.venueLat = [geopoint objectForKey:@"geo:lat"];
                            gig.venueLng = [geopoint objectForKey:@"geo:long"];
                            
                            gig.venueCity = [venue objectForKey:@"city"];
                            gig.venueCountry = [venue objectForKey:@"country"];
                            gig.venueStreet = [venue objectForKey:@"street"];
                            gig.venueZip = [venue objectForKey:@"postalcode"];
                            gig.venueUrl = [venue objectForKey:@"website"];
                            gig.venuePhone = [venue objectForKey:@"phonenumber"];
                            gig.description = [venue objectForKey:@"description"];
                            gig.startDate = [venue objectForKey:@"startDate"];

                            
                            [gigs addObject:gig];
                            
                            
                            PSLogDebug(@"gig name = %@", gig.gigName);
                            
                            
                        }
                    }
                    
                }
            }
            
            [gigs release];
        
        }  
        
    }
    @catch (NSException *e) {
        PSLogException(@"%@", e);
    }
    
    
}

@end
