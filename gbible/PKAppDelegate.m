//
//  PKAppDelegate.m
//  gbible
//
//  Created by Kerri Shotts on 3/12/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKAppDelegate.h"
#import "PKBibleBooksController.h"
#import "PKBookmarksViewController.h"
#import "PKNotesViewController.h"
#import "PKHighlightsViewController.h"
#import "PKRootViewController.h"

@implementation PKAppDelegate

@synthesize window = _window;
@synthesize database;
@synthesize mySettings;
@synthesize rootViewController;
@synthesize segmentController;
@synthesize segmentedControl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //open our databases...
    database = [PKDatabase instance];
    
    //and get our settings
    mySettings = [PKSettings instance];
    [mySettings reloadSettings];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // define our "top-level" controller -- this is the one above the navigation panel 
    PKRootViewController *topController = [[PKRootViewController alloc] init];
    
    // define an array that houses all our navigation panels.
    NSArray *navViewControllers = [[NSArray alloc] initWithObjects:
                                    [[PKBibleBooksController alloc] init],
                                    [[PKHighlightsViewController alloc] init],
                                    [[PKBookmarksViewController alloc] init],
                                    [[PKNotesViewController alloc] init]
                                    , nil];
                                    
    UINavigationController *segmentedNavBarController = 
                            [[UINavigationController alloc] init ];
    [segmentedNavBarController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BlueNavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    segmentedNavBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.segmentController = [[SegmentsController alloc]
                                             initWithNavigationController:segmentedNavBarController viewControllers:navViewControllers];

    self.segmentedControl = [[UISegmentedControl alloc]
                                          initWithItems:[NSArray arrayWithObjects:@"Goto", @"Highlights", @"Bookmarks", @"Notes", nil]];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl addTarget:self.segmentController 
                    action:@selector(indexDidChangeForSegmentedControl:) 
                    forControlEvents:UIControlEventValueChanged];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.apportionsSegmentWidthsByContent = YES;
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGRect scFrame = segmentedNavBarController.view.bounds;
    scFrame.origin.y=5;
    scFrame.size.height=34;
    //scFrame.size.width = 260;
    self.segmentedControl.frame = scFrame;
    
    self.segmentedControl.tintColor = [UIColor colorWithRed:0.250980 green:0.282352 blue:0.313725 alpha:1.0];
    
    [self.segmentController indexDidChangeForSegmentedControl:segmentedControl];
    
    // define our ZUII
    ZUUIRevealController *revealController = [[ZUUIRevealController alloc]
                                              initWithFrontViewController:topController 
                                              rearViewController:segmentedNavBarController];
    
    self.rootViewController = revealController;
    self.window.rootViewController = self.rootViewController;
    self.window.backgroundColor = [UIColor colorWithRed:0.250980 green:0.282352 blue:0.313725 alpha:1.0];
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
    [[PKSettings instance ]saveSettings];
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
    [[PKSettings instance ]saveSettings];
}

@end
