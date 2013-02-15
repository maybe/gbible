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
#import "NSString+FontAwesome.h"
#import "PSTCollectionView.h"
#import "iRate.h"
#import <Parse/Parse.h>

#import <QuartzCore/QuartzCore.h>

@implementation PKAppDelegate

@synthesize window = _window;
@synthesize database;
@synthesize mySettings;
@synthesize rootViewController;
@synthesize segmentController;
@synthesize segmentedControl;
@synthesize brightness;

static id _instance;

+(void) initialize
{
  [iRate sharedInstance].promptAtLaunch = NO;
}

/**
 *
 * returns the global instance of PKAppDelegate (for singleton properties)
 *
 */
+(id) instance
{
  @synchronized(self) {
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
-(BOOL)application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
  _instance = self;
  
  // set up parse
  [Parse setApplicationId:@"rOwVOFBI8HSnZK928jZ5jGfoE2F79GEvgHz0hVca"
              clientKey:@"wY5I952RGaLpdZk8lvjsD712UXsCkUYysLO9Je0k"];
  
  
  //open our databases...
  database   = [PKDatabase instance];
  
  //and get our settings
  mySettings = [PKSettings instance];
  [mySettings reloadSettings];
  
  if ([mySettings usageStats] == YES)
  {
    [TestFlight takeOff: @"4b66b818-4e6f-4d4e-ba76-e4a53e944f80"];
  }
  
  self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
  // define our "top-level" controller -- this is the one above the navigation panel
  PKRootViewController *topController = [[PKRootViewController alloc] init];
  
  // define an array that houses all our navigation panels.
  NSArray *navViewControllers         = [[NSArray alloc] initWithObjects:
                                         [[PKBibleBooksController alloc] initWithCollectionViewLayout:[PSUICollectionViewFlowLayout new]],
                                         [[PKHighlightsViewController alloc] init],
                                         [[PKNotesViewController alloc] init],
                                         [[PKHistoryViewController alloc] init]
                                         , nil];
  
  UINavigationController *segmentedNavBarController =
  [[UINavigationController alloc] init];
  segmentedNavBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  
  if ([segmentedNavBarController.navigationBar respondsToSelector: @selector(setBackgroundImage:forBarMetrics:)])
  {
    [segmentedNavBarController.navigationBar setTitleTextAttributes: [[NSDictionary alloc] initWithObjectsAndKeys: [UIColor
                                                                                                                    blackColor],
                                                                      UITextAttributeTextShadowColor,
                                                                      [UIColor whiteColor], UITextAttributeTextColor,
                                                                      //        [UIFont fontWithName:kFontAwesomeFamilyName size:20], UITextAttributeFont,
                                                                      nil]];
  }
  
  if ([[UIBarButtonItem class] respondsToSelector: @selector(appearance)])
  {
    [[UIBarButtonItem appearance] setTintColor:    [PKSettings PKBaseUIColor]];
  }
  
  if ([[UISearchBar class] respondsToSelector: @selector(appearance)])
  {
    [[UISearchBar appearance] setTintColor: [PKSettings PKBaseUIColor]];
  }
  
  self.segmentController = [[SegmentsController alloc]
                            initWithNavigationController: segmentedNavBarController viewControllers: navViewControllers];
  
  self.segmentedControl  = [[UISegmentedControl alloc]
                            initWithItems: [NSArray arrayWithObjects: __T(@"Goto"), __T(@"Highlights"), __T(@"Notes"),
                                            __T(@"History"), nil]];
  self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  [self.segmentedControl addTarget: self.segmentController
                            action: @selector(indexDidChangeForSegmentedControl:)
                  forControlEvents: UIControlEventValueChanged];
  
  self.segmentedControl.selectedSegmentIndex = 0;
  
  if ([self.segmentedControl respondsToSelector: @selector(setApportionsSegmentWidthsByContent:)])
  {
    self.segmentedControl.apportionsSegmentWidthsByContent = YES;
  }
  self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  
  CGRect scFrame = segmentedNavBarController.view.bounds;
  scFrame.origin.y            = 5;
  scFrame.size.height         = 34;
  self.segmentedControl.frame = scFrame;
  
  if ([self.segmentedControl respondsToSelector: @selector(setTintColor:)])
  {
    self.segmentedControl.tintColor = [PKSettings PKBaseUIColor];
  }
  [self.segmentController indexDidChangeForSegmentedControl: segmentedControl];
  
  // define our ZUII
  ZUUIRevealController *revealController = [[ZUUIRevealController alloc]
                                            initWithFrontViewController: topController
                                            rearViewController: segmentedNavBarController];
  
  self.rootViewController        = revealController;
  self.window.rootViewController = self.rootViewController;
  self.window.backgroundColor    = [PKSettings PKBaseUIColor];
  
  // Add imageView overlay with fade out and zoom in animation
  // inspired by https://gist.github.com/1026439 and https://gist.github.com/3798781
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame: self.window.frame];
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    switch ([[UIApplication sharedApplication] statusBarOrientation])
    {
      case UIInterfaceOrientationLandscapeLeft:
      case UIInterfaceOrientationLandscapeRight:
        
        if ([UIScreen mainScreen].scale == 2)
        {
          imageView.image = [UIImage imageNamed: @"Default-Landscape@2x~ipad.png"];
        }
        else
        {
          imageView.image = [UIImage imageNamed: @"Default-Landscape~ipad.png"];
        }
        [imageView setFrame: CGRectMake(0, 0, 1024, 748)];
        break;
        
      case UIInterfaceOrientationPortrait:
      case UIInterfaceOrientationPortraitUpsideDown:
        
        if ([UIScreen mainScreen].scale == 2)
        {
          imageView.image = [UIImage imageNamed: @"Default-Portrait@2x~ipad.png"];
        }
        else
        {
          imageView.image = [UIImage imageNamed: @"Default-Portrait~ipad.png"];
        }
        [imageView setFrame: CGRectMake(0, 0, 768, 1004)];
        break;
    }
  }
  else
  {
    // we're an iPhone or iPod touch. No rotation for you.
    if ([UIScreen mainScreen].scale == 2)
    {
      // are we a 3.5in? or a 4?
      if ([UIScreen mainScreen].bounds.size.height == 568.0f)
      {
        // 4 inch iPhone 5
        imageView.image = [UIImage imageNamed: @"Default-568h@2x.png"];
        [imageView setFrame: CGRectMake(0, 0, 320, 548)];
      }
      else
      {
        imageView.image = [UIImage imageNamed: @"Default@2x.png"];
        [imageView setFrame: CGRectMake(0, 0, 320, 460)];
      }
    }
    else
    {
      imageView.image = [UIImage imageNamed: @"Default.png"];
      [imageView setFrame: CGRectMake(0, 0, 320, 460)];
    }
  }
  [self.window.rootViewController.view addSubview: imageView];
  [self.window.rootViewController.view bringSubviewToFront: imageView];
  
  PKWaitDelay(2, {
    [UIView transitionWithView: self.window
                      duration: 1.00f
                       options: UIViewAnimationCurveEaseInOut
                    animations:^(void) {
                      imageView.alpha = 0.0f;
                    }
                    completion:^(BOOL finished) {
                      [imageView removeFromSuperview];
                    }
     ];
  }
              );
  [self.window makeKeyAndVisible];
  
  [TestFlight passCheckpoint: @"APPLICATION_START"];
  
  // since we alter the brightness, get the value now
  brightness = [[UIScreen mainScreen] brightness];
  
  return YES;
}

/**
 *
 * Not used
 *
 */
-(void)applicationWillResignActive: (UIApplication *) application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary
  // interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the
  // transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method
  // to pause the game.
  // and restore the brightness
  [[UIScreen mainScreen] setBrightness: brightness];
}

/**
 *
 * Save settings when we go to the background
 *
 */
-(void)applicationDidEnterBackground: (UIApplication *) application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information
  // to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user
  // quits.
  
  // and restore the brightness
  [[UIScreen mainScreen] setBrightness: brightness];
  
  // before going, get the top verse
  ZUUIRevealController  *rc  = (ZUUIRevealController *)self.rootViewController;
  PKRootViewController *rvc  = (PKRootViewController *)rc.frontViewController;
  
  PKBibleViewController *bvc = [[[rvc.viewControllers objectAtIndex: 0] viewControllers] objectAtIndex: 0];
  
  // attempt to fix issue #36
  NSArray *indexPaths        = [bvc.tableView indexPathsForVisibleRows];
  
  if ([indexPaths count] > 0)
  {
    ( (PKSettings *)[PKSettings instance] ).topVerse = [[indexPaths objectAtIndex: 0] row] + 1;
  }
  
  // save our settings
  [[PKSettings instance] saveSettings];
}

/**
 *
 * Not used
 *
 */
-(void)applicationWillEnterForeground: (UIApplication *) application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on
  // entering the background.
  brightness = [[UIScreen mainScreen] brightness];
}

/**
 *
 * Not used
 *
 */
-(void)applicationDidBecomeActive: (UIApplication *) application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously
  // in the background, optionally refresh the user interface.
  //[iOSHierarchyViewer start];

  // before going, get the top verse
  ZUUIRevealController  *rc  = (ZUUIRevealController *)self.rootViewController;
  PKRootViewController *rvc  = (PKRootViewController *)rc.frontViewController;
  
  PKBibleViewController *bvc = [[[rvc.viewControllers objectAtIndex: 0] viewControllers] objectAtIndex: 0];
  if (rvc.selectedIndex == 0)
  {
    [bvc resignFirstResponder];
    PKWaitDelay(0.5,
    [bvc becomeFirstResponder];
    );
  }
}

/**
 *
 * Save settings when we terminate
 *
 */
-(void)applicationWillTerminate: (UIApplication *) application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // and restore the brightness
  [[UIScreen mainScreen] setBrightness: brightness];
  [[PKSettings instance] saveSettings];
}

@end