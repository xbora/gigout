//
//  GOAppDelegate.h
//  GigOut
//
//  Created by BORA CELIK on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kSearchRadiusKms        (10)
#define kMaxResults             (25)

@interface GOAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window_;
    NSMutableArray *gigs_;
    CLLocationManager *locationMgr_;
    NSTimer *locationTimer_;
    NSOperationQueue *operationQueue_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (retain) NSMutableArray *gigs;
@property (nonatomic, retain) CLLocationManager *locationMgr;
@property (nonatomic, retain) NSTimer *locationTimer;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

@property (strong, nonatomic) UINavigationController *navigationController;

- (void)gigsDidUpdate: (NSNotification *) notification;

@end