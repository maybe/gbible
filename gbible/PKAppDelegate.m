//
//  PKAppDelegate.m
//  gbible
//
//  Created by Kerri Shotts on 3/12/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKAppDelegate.h"

@implementation PKAppDelegate

@synthesize window = _window;
@synthesize database;
@synthesize mySettings;
@synthesize rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //open our databases...
    database = [PKDatabase instance];
    
    //and get our settings
    mySettings = [PKSettings instance];
    [mySettings reloadSettings];
    
    // for play's sake, put out some settings :-)
    NSLog (@"Our greek text is: %i", mySettings.greekText);

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.rootViewController = [[PKRootViewController alloc] init];
    self.window.rootViewController = self.rootViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
