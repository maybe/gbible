//
//  PKAppDelegate.m
//  gbible
//
//  Created by Kerri Shotts on 3/12/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKAppDelegate.h"
#import "PKBibleBooksController.h"
#import "PKHistoryViewController.h"
#import "PKNotesViewController.h"
#import "PKHighlightsViewController.h"
#import "PKRootViewController.h"
#import "PKBibleViewController.h"
//#import "iOSHierarchyViewer.h"
#import "PKSettings.h"
#import "TestFlight.h"

#import <QuartzCore/QuartzCore.h>

/*
@interface UINavigationBar (PKNavigationBarShadow)
- (void)drawOurShadow;
@end

@implementation UINavigationBar (PKNavigationBarShadow)

- (void)drawOurShadow
{
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake (0.0, 4);
    self.layer.shadowOpacity = 0.5f;
    self.layer.masksToBounds = NO;
    CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, 
                                   self.layer.bounds.size.height - 6, 
                                   1044, 5); // assume our widest -- we're a shadow, after all
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    self.layer.shouldRasterize = YES;
}
- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    [self drawOurShadow];
}


@end
*/


@implementation PKAppDelegate

@synthesize window = _window;
@synthesize database;
@synthesize mySettings;
@synthesize rootViewController;
@synthesize segmentController;
@synthesize segmentedControl;

    static id _instance;
    
/**
 *
 * returns the global instance of PKAppDelegate (for singleton properties)
 *
 */
    +(id) instance
    {
        @synchronized (self)
        {
            if (!_instance)
            {
                _instance = [[self alloc] init];
            }
        }
        return _instance;
    }

/**
 *
 * Do all the application startup. We open our databases, load our settings, and create all
 * our views.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _instance = self;
    
//    [TestFlight takeOff:@"f04cb885223a70de7f0bd87330878bc8_Njc1MTgyMDEyLTAzLTAyIDAzOjAzOjEzLjY4NTc0Mw"];
//    #ifndef RELEASE
//        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
//    #endif
        
    //open our databases...
    database = [PKDatabase instance];
    
    //and get our settings
    mySettings = [PKSettings instance];
    [mySettings reloadSettings];

  if ([mySettings usageStats] == YES)
  {
    [TestFlight takeOff:@"4b66b818-4e6f-4d4e-ba76-e4a53e944f80"];
  }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // define our "top-level" controller -- this is the one above the navigation panel 
    PKRootViewController *topController = [[PKRootViewController alloc] init];
    
    // define an array that houses all our navigation panels.
    NSArray *navViewControllers = [[NSArray alloc] initWithObjects:
                                    [[PKBibleBooksController alloc] init],
                                    [[PKHighlightsViewController alloc] init],
                                    [[PKNotesViewController alloc] init],
                                    [[PKHistoryViewController alloc] init]
                                    , nil];
    
    UINavigationController *segmentedNavBarController = 
                            [[UINavigationController alloc] init ];
    segmentedNavBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    //segmentedNavBarController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
   

    if ([segmentedNavBarController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //[segmentedNavBarController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BlueNavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
        [segmentedNavBarController.navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextShadowColor,
        [UIColor whiteColor], UITextAttributeTextColor, nil]];
    }

    if ([[UIBarButtonItem class] respondsToSelector:@selector(appearance)])
    {
        [[UIBarButtonItem appearance] setTintColor:    [PKSettings PKBaseUIColor]];
        

    }
    
    self.segmentController = [[SegmentsController alloc]
                                             initWithNavigationController:segmentedNavBarController viewControllers:navViewControllers];

    self.segmentedControl = [[UISegmentedControl alloc]
                                          initWithItems:[NSArray arrayWithObjects:@"Goto", @"Highlights", @"Notes", @"History", nil]];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl addTarget:self.segmentController 
                    action:@selector(indexDidChangeForSegmentedControl:) 
                    forControlEvents:UIControlEventValueChanged];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    if ([self.segmentedControl respondsToSelector:@selector(setApportionsSegmentWidthsByContent:)])
    {
        self.segmentedControl.apportionsSegmentWidthsByContent = YES;
    }
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGRect scFrame = segmentedNavBarController.view.bounds;
    scFrame.origin.y=5;
    scFrame.size.height=34;
    //scFrame.size.width = 260;
    self.segmentedControl.frame = scFrame;
    
    if ([self.segmentedControl respondsToSelector:@selector(setTintColor:)])
    {
        self.segmentedControl.tintColor = [PKSettings PKBaseUIColor];
    }
    [self.segmentController indexDidChangeForSegmentedControl:segmentedControl];
    
    // define our ZUII
    ZUUIRevealController *revealController = [[ZUUIRevealController alloc]
                                              initWithFrontViewController:topController 
                                              rearViewController:segmentedNavBarController];
    
    self.rootViewController = revealController;
    self.window.rootViewController = self.rootViewController;
    self.window.backgroundColor = [PKSettings PKBaseUIColor];
    [self.window makeKeyAndVisible];

    [TestFlight passCheckpoint:@"APPLICATION_START"];
    return YES;
}

/**
 *
 * Not used
 *
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *
 * Save settings when we go to the background
 *
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // before going, get the top verse
    ZUUIRevealController  *rc = (ZUUIRevealController *)self.rootViewController;
    PKRootViewController *rvc = (PKRootViewController *)rc.frontViewController;
        
    PKBibleViewController *bvc = [[[rvc.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
  
    // attempt to fix issue #36
    NSArray *indexPaths = [bvc.tableView indexPathsForVisibleRows];
    if ([indexPaths count] > 0)
    {
        ((PKSettings *)[PKSettings instance]).topVerse = [[indexPaths objectAtIndex:0] row]+1;
    }
  
    // save our settings
    [[PKSettings instance ]saveSettings];
}

/**
 *
 * Not used
 *
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 *
 * Not used
 *
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 //[iOSHierarchyViewer start];
 }

/**
 *
 * Save settings when we terminate
 *
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PKSettings instance ]saveSettings];
}

@end
