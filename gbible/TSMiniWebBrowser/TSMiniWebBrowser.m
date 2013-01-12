//
//  TSMiniWebBrowser.m
//  TSMiniWebBrowserDemo
//
//  Created by Toni Sala Echaurren on 18/01/12.
//  Copyright 2012 Toni Sala. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TSMiniWebBrowser.h"
#import "SSZipArchive.h"

@implementation TSMiniWebBrowser

@synthesize delegate;
@synthesize mode;
@synthesize showURLStringOnActionSheetTitle;
@synthesize showPageTitleOnTitleBar;
@synthesize showReloadButton;
@synthesize showActionButton;
@synthesize barStyle;
@synthesize modalDismissButtonTitle;
@synthesize downloadFile;
#pragma mark - Private Methods

-(void)setTitleBarText:(NSString*)pageTitle {
    if (mode == TSMiniWebBrowserModeModal) {
        navigationBarModal.topItem.title = pageTitle;
        
    } else if(mode == TSMiniWebBrowserModeNavigation) {
        if(pageTitle) [[self navigationItem] setTitle:pageTitle];
    }
}

-(void) toggleBackForwardButtons {
    buttonGoBack.enabled = webView.canGoBack;
    buttonGoForward.enabled = webView.canGoForward;
}

-(void)showActivityIndicators {
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideActivityIndicators {
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void) dismissController {
    [self dismissModalViewControllerAnimated:YES];
    
    // Notify the delegate
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(tsMiniWebBrowserDidDismiss)]) {
        [delegate tsMiniWebBrowserDidDismiss];
    }
}

#pragma mark - Init

-(void) initTitleBar {
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithTitle:modalDismissButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(dismissController)];
    
    UINavigationItem *titleBar = [[UINavigationItem alloc] initWithTitle:@""];
    titleBar.leftBarButtonItem = buttonDone;
    
    CGFloat width = self.view.frame.size.width;
    navigationBarModal = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    //navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    navigationBarModal.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBarModal.barStyle = barStyle;
    [navigationBarModal pushNavigationItem:titleBar animated:NO];
    
    [self.view addSubview:navigationBarModal];
}

-(void) initToolBar {
    if (mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = barStyle;
    }
    
    CGSize viewSize = self.view.frame.size;
    if (mode == TSMiniWebBrowserModeTabBar) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, viewSize.width, kToolBarHeight)];
    } else {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height-kToolBarHeight, viewSize.width, kToolBarHeight)];
    }
    
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    toolBar.barStyle = barStyle;
    [self.view addSubview:toolBar];
    
    buttonGoBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 30;
    
    buttonGoForward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonTouchUp:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *buttonReload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace2.width = 20;
    
    UIBarButtonItem *buttonAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonActionTouchUp:)];
    
    // Activity indicator is a bit special
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(11, 7, 20, 20);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 33)];
    [containerView addSubview:activityIndicator];
    UIBarButtonItem *buttonContainer = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    // nuke the appearance proxy for these buttons:
    if ([buttonGoBack respondsToSelector:@selector(setTintColor:)])
    {
    buttonGoBack.tintColor = [UIColor whiteColor];
    buttonGoForward.tintColor = [UIColor whiteColor];
    buttonReload.tintColor = [UIColor whiteColor];
    buttonAction.tintColor = [UIColor whiteColor];
    }
    
    // Add butons to an array
    NSMutableArray *toolBarButtons = [[NSMutableArray alloc] init];
    [toolBarButtons addObject:buttonGoBack];
    [toolBarButtons addObject:fixedSpace];
    [toolBarButtons addObject:buttonGoForward];
    [toolBarButtons addObject:flexibleSpace];
    [toolBarButtons addObject:buttonContainer];
    if (showReloadButton) { 
        [toolBarButtons addObject:buttonReload];
    }
    if (showActionButton) {
        [toolBarButtons addObject:fixedSpace2];
        [toolBarButtons addObject:buttonAction];
    }
    
    // Set buttons to tool bar
    [toolBar setItems:toolBarButtons animated:YES];
}

-(void) initWebView {
    CGSize viewSize = self.view.frame.size;
    if (mode == TSMiniWebBrowserModeModal) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kToolBarHeight, viewSize.width, viewSize.height-kToolBarHeight*2)];
    } else if(mode == TSMiniWebBrowserModeNavigation) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-kToolBarHeight)];
    } else if(mode == TSMiniWebBrowserModeTabBar) {
        self.view.backgroundColor = [UIColor redColor];
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kToolBarHeight-1, viewSize.width, viewSize.height-kToolBarHeight+1)];
    }
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
    
    webView.scalesPageToFit = YES;
    
    webView.delegate = self;
    
    // Load the URL in the webView
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlToLoad];
    [webView loadRequest:requestObj];
}

#pragma mark -

- (id)initWithUrl:(NSURL*)url {
    self = [self init];
    if(self)
    {
        urlToLoad = url;
        
        // Defaults
        mode = TSMiniWebBrowserModeNavigation;
        showURLStringOnActionSheetTitle = YES;
        showPageTitleOnTitleBar = YES;
        showReloadButton = YES;
        showActionButton = YES;
        modalDismissButtonTitle = NSLocalizedString(@"Done", nil);
        forcedTitleBarText = nil;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Main view frame.
    if (mode == TSMiniWebBrowserModeTabBar) {
        CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - kTabBarHeight;
        if (![UIApplication sharedApplication].statusBarHidden) {
            viewHeight -= [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    
    // Store the current navigationBar bar style to be able to restore it later.
    if (mode == TSMiniWebBrowserModeNavigation) {
        originalBarStyle = self.navigationController.navigationBar.barStyle;
    }
    
    // Init tool bar
    [self initToolBar];
    
    // Init web view
    [self initWebView];
    
    // Init title bar if presented modally
    if (mode == TSMiniWebBrowserModeModal) {
        [self initTitleBar];
    }
    
    // UI state
    buttonGoBack.enabled = NO;
    buttonGoForward.enabled = NO;
    if (forcedTitleBarText != nil) {
        [self setTitleBarText:forcedTitleBarText];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Restore navigationBar bar style.
    if (mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = originalBarStyle;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/* Fix for landscape + zooming webview bug.
 * If you experience perfomance problems on old devices ratation, comment out this method.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat ratioAspect = webView.bounds.size.width/webView.bounds.size.height;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
            // Going to Portrait mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview 
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale/ratioAspect) animated:YES];
                }
            }
            break;
        default:
            // Going to Landscape mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview 
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale *ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale *ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale*ratioAspect) animated:YES];
                }
            }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Sheet

- (void)showActionSheet {
    NSString *urlString = @"";
    if (showURLStringOnActionSheetTitle) {
        NSURL* url = [webView.request URL];
        urlString = [url absoluteString];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:urlString
															 delegate:self 
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
													otherButtonTitles:NSLocalizedString(@"Open in Safari", nil),  nil];
    
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    if (mode == TSMiniWebBrowserModeTabBar) {
        [actionSheet showInView:self.tabBarController.view];
        
    } else {
        [actionSheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch(buttonIndex) {
		case 0:
			// Open in Safari
            [[UIApplication sharedApplication] openURL:[webView.request URL]];
			break;
		default:
			break;
	}
}

#pragma mark - Actions

- (void)backButtonTouchUp:(id)sender {
    [webView goBack];
    
    [self toggleBackForwardButtons];
}

- (void)forwardButtonTouchUp:(id)sender {
    [webView goForward];
    
    [self toggleBackForwardButtons];
}

- (void)reloadButtonTouchUp:(id)sender {
    [webView reload];
    
    [self toggleBackForwardButtons];
}

- (void)buttonActionTouchUp:(id)sender {
    [self showActionSheet];
}

#pragma mark - Public Methods

- (void)setFixedTitleBarText:(NSString*)newTitleBarText {
    forcedTitleBarText = newTitleBarText;
    showPageTitleOnTitleBar = NO;
}

#pragma mark - UIWebViewDelegate

/*
// inspired by http://stackoverflow.com/questions/7377565/how-to-download-files-from-uiwebview-and-open-again

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1)
  {
    // user agreed to download the file
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = NSTemporaryDirectory();
    NSLog (@"%@", directoryPath);
    NSURL *theURL = [NSURL URLWithString:downloadFile];
    NSString *downloadFileTo = [NSString stringWithFormat:@"%@/%@", directoryPath, [theURL lastPathComponent]];
    
    __block UIAlertView *anAlert = [[UIAlertView alloc] init];
    [anAlert setTitle:__T(@"Downloading")];
//    [anAlert addButtonWithTitle:__T(@"OK")];
    [anAlert setMessage:__T(@"Please Wait")];
    [anAlert setDelegate:nil];
    [anAlert show];
    PKWait(
      {
        
        NSError *error = nil;
        NSData *tmp = [[NSData alloc] initWithContentsOfURL:theURL options:0 error:&error];
        
        if (error)
        {
          [anAlert dismissWithClickedButtonIndex:0 animated:NO];
          anAlert = [[UIAlertView alloc] init];
          [anAlert setTitle:__T(@"Download Error")];
          [anAlert addButtonWithTitle:__T(@"OK")];
          [anAlert setMessage:[error description]];
          [anAlert setDelegate:nil];
          [anAlert show];
        }
        else
        {
          [tmp writeToFile:downloadFileTo options:NSDataWritingAtomic error:&error];
          if (error)
          {
            [anAlert dismissWithClickedButtonIndex:0 animated:NO];
            anAlert = [[UIAlertView alloc] init];
            [anAlert setTitle:__T(@"Failed to Save File")];
            [anAlert addButtonWithTitle:__T(@"OK")];
            [anAlert setMessage:[error description]];
            [anAlert setDelegate:nil];
            [anAlert show];
          }
          else
          {
            [anAlert dismissWithClickedButtonIndex:0 animated:NO];
            anAlert = [[UIAlertView alloc] init];
            [anAlert setTitle:__T(@"Unzipping File")];
            [anAlert setDelegate:nil];
            [anAlert show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,100000),dispatch_get_current_queue(),
              ^{
                // import the file?
                NSString *zipPath = downloadFileTo;
                NSString *destinationPath = directoryPath;
                [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
                [anAlert dismissWithClickedButtonIndex:0 animated:NO];
                // now that we're done unzipping, the file we want is in
                // bible_name_utf8.txt
              }
            );
          }
        }
      }
    );
  }
}
 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

/*      // PK ADDITION
      NSString *extension = [request.URL pathExtension];
      if ( [extension isEqualToString:@"zip"] )
      {
        // we have a zip file; ask user if they want to download it
        downloadFile = [request.URL absoluteString];
        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:__T(@"Download File?")
                                message: [NSString stringWithFormat:__Tv(@"download-file", @"Do you want to download %@?"),
                                          downloadFile]
                                delegate:self
                                cancelButtonTitle:__T(@"Cancel")
                                otherButtonTitles:__T(@"Download") , nil];
        [anAlert show];
        
        return NO;
      }
 */
    if ([[request.URL absoluteString] hasPrefix:@"sms:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    if ([[request.URL absoluteString] hasPrefix:@"http://www.youtube.com/v/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://itunes.apple.com/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://phobos.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self toggleBackForwardButtons];
    
    [self showActivityIndicators];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    // Show page title on title bar?
    if (showPageTitleOnTitleBar) {
        NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self setTitleBarText:pageTitle];
    }
    
    [self hideActivityIndicators];
    
    [self toggleBackForwardButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideActivityIndicators];
    
    // Show error alert
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not load page", nil)
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alert show];*/
}

@end
