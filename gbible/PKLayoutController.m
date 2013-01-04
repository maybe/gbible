//
//  PKLayoutController.m
//  gbible
//
//  Created by Kerri Shotts on 12/14/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKLayoutController.h"
#import "PKSettings.h"
#import "NSString+FontAwesome.h"
#import "CoolButton.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface PKLayoutController ()
  @property (strong, nonatomic) UILabel * previewLabel;
  @property (strong, nonatomic) UILabel * label1;
  @property (strong, nonatomic) UILabel * fontSizeLabel;
  @property (strong, nonatomic) UILabel * greekFontLabel;
  @property (strong, nonatomic) UILabel * englishFontLabel;
  @property (strong, nonatomic) UILabel * rowSpacingLabel;
  @property (strong, nonatomic) UIStepper * fontStepper;
  @property (strong, nonatomic) UISlider * brightnessSlider;
  @property (strong, nonatomic) UISegmentedControl * rowSpacingSelector;
  @property (strong, nonatomic) UISegmentedControl * lineSpacingSelector;
  @property (strong, nonatomic) UISegmentedControl * columnSelector;
  @property (strong, nonatomic) UITableView * englishFontPicker;
  @property (strong, nonatomic) UITableView * greekFontPicker;
  @property (strong, nonatomic) UILabel* decreaseBrightnessLabel;
  @property (strong, nonatomic) UILabel* increaseBrightnessLabel;
  @property (strong, nonatomic) UISegmentedControl * themeSelector;

  @property (strong, nonatomic) NSArray* fontNames;
  @property (strong, nonatomic) NSArray* fontFaces;
  @property (strong, nonatomic) NSArray* fontSizes;
  @property (strong, nonatomic) NSArray* themeTextColors;
  @property (strong, nonatomic) NSArray* themeBgColors;

@end

@implementation PKLayoutController

  @synthesize previewLabel;
  @synthesize fontSizeLabel;
  @synthesize greekFontLabel;
  @synthesize englishFontLabel;
  @synthesize rowSpacingLabel;
  @synthesize fontStepper;
  @synthesize brightnessSlider;
  @synthesize rowSpacingSelector;
  @synthesize lineSpacingSelector;
  @synthesize columnSelector;
  @synthesize englishFontPicker;
  @synthesize greekFontPicker;
  @synthesize decreaseBrightnessLabel;
  @synthesize increaseBrightnessLabel;
  @synthesize fontNames;
  @synthesize fontFaces;
  @synthesize delegate;
  @synthesize fontSizes;
  @synthesize themeSelector;
  @synthesize themeTextColors;
  @synthesize themeBgColors;
  @synthesize label1;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setFrame: CGRectMake(0,0,320,460)];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
//[self updateThemeColors:themeSelector];
}
/*
- (NSUInteger) supportedInterfaceOrientations
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    return UIInterfaceOrientationMaskPortrait;
  }
  else
  {
    return YES;
  }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
      return NO;
    }
    return YES;
  }
  else
  {
    return NO;
  }
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  if (self.navigationItem)
  {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(closeMe:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    self.navigationItem.title = @"Appearance";
  }
/*
  TPKeyboardAvoidingScrollView * scroller = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 40 )];
  scroller.scrollEnabled = YES;
  scroller.scrollsToTop = YES;
  scroller.showsHorizontalScrollIndicator = NO;
  scroller.showsVerticalScrollIndicator = YES;
  scroller.directionalLockEnabled = YES;
  */
  
  fontSizes = @[ @9, @10, @11, @12, @14, @16, @18, @20, @22, @26, @32, @48];
  
  themeBgColors = @[ [UIColor colorWithRed:0.945098 green:0.933333 blue:0.898039 alpha:1],
                            [UIColor colorWithWhite:0.90 alpha:1],
                            [UIColor colorWithWhite:0.10 alpha:1],
                            [UIColor colorWithWhite:0.10 alpha:1]
                          ];
  themeTextColors =  @[ [UIColor colorWithRed:0.341176 green:0.223529 blue:0.125490 alpha:1.0],
                            [UIColor colorWithWhite:0.10 alpha:1],
                            [UIColor colorWithWhite:0.65 alpha:1.0],
                            [UIColor colorWithRed:0.65 green:0.50 blue:0.00 alpha:1.0]
                          ];
  
  self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
  
  //previewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 196, 60)];
  //[self.view addSubview:previewLabel];
  
  label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 160, 30)];
  label1.text = [NSString stringWithFormat:@"Theme %i", [[PKSettings instance] textTheme]+1 ];
  label1.textAlignment = UITextAlignmentLeft;
  label1.backgroundColor = [UIColor clearColor];
  [self.view addSubview:label1];
  
  CoolButton *theme1 = [[CoolButton alloc] initWithFrame:CGRectMake(10, 44, 49, 27)];
  [theme1 addTarget:self action:@selector(themeChanged:) forControlEvents:UIControlEventTouchUpInside];
  theme1.buttonColor = themeBgColors[0];
  [theme1 setTag:0];
  [theme1 setTitle:@"1" forState:UIControlStateNormal];
  [theme1 setTitleColor:themeTextColors[0] forState:UIControlStateNormal];
  [self.view addSubview:theme1];

  CoolButton *theme2 = [[CoolButton alloc] initWithFrame:CGRectMake(59, 44, 49, 27)];
  [theme2 addTarget:self action:@selector(themeChanged:) forControlEvents:UIControlEventTouchUpInside];
  theme2.buttonColor = themeBgColors[1];
  [theme2 setTag:1];
  [theme2 setTitle:@"2" forState:UIControlStateNormal];
  [theme2 setTitleColor:themeTextColors[1] forState:UIControlStateNormal];
  [self.view addSubview:theme2];

  CoolButton *theme3 = [[CoolButton alloc] initWithFrame:CGRectMake(108, 44, 49, 27)];
  [theme3 addTarget:self action:@selector(themeChanged:) forControlEvents:UIControlEventTouchUpInside];
  theme3.buttonColor = themeBgColors[2];
  [theme3 setTag:2];
  [theme3 setTitle:@"3" forState:UIControlStateNormal];
  [theme3 setTitleColor:themeTextColors[2] forState:UIControlStateNormal];
  [self.view addSubview:theme3];

  CoolButton *theme4 = [[CoolButton alloc] initWithFrame:CGRectMake(157, 44, 49, 27)];
  [theme4 addTarget:self action:@selector(themeChanged:) forControlEvents:UIControlEventTouchUpInside];
  theme4.buttonColor = themeBgColors[3];
  [theme4 setTag:3];
  [theme4 setTitle:@"4" forState:UIControlStateNormal];
  [theme4 setTitleColor:themeTextColors[3] forState:UIControlStateNormal];
  [self.view addSubview:theme4];
  
/*  themeSelector = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 43, 196, 29)];
  [themeSelector addTarget:self action:@selector(themeChanged:) forControlEvents:UIControlEventValueChanged];
  [themeSelector insertSegmentWithTitle:@"1" atIndex:0 animated:NO];
  [themeSelector insertSegmentWithTitle:@"2" atIndex:1 animated:NO];
  [themeSelector insertSegmentWithTitle:@"3" atIndex:2 animated:NO];
  [themeSelector insertSegmentWithTitle:@"4" atIndex:3 animated:NO];
  themeSelector.segmentedControlStyle = UISegmentedControlStyleBar;
 
  [self.view addSubview:themeSelector];
  */
  
  fontSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(216, 10, 94, 30)];
  fontSizeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
  fontSizeLabel.textAlignment = UITextAlignmentCenter;
  fontSizeLabel.text = [NSString stringWithFormat:@"%ipt", [[PKSettings instance] textFontSize]];
  fontSizeLabel.backgroundColor = [UIColor clearColor];
  [self.view addSubview:fontSizeLabel];
  
  fontStepper = [[UIStepper alloc] initWithFrame:CGRectMake(216, 44, 88, 60)];
  fontStepper.value = [fontSizes indexOfObject: [NSNumber numberWithInt:[[PKSettings instance] textFontSize]]];
  [fontStepper setMinimumValue:0];
  [fontStepper setMaximumValue:11];
  [fontStepper addTarget:self action:@selector(fontSizeChanged:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:fontStepper];
  
  greekFontLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 140, 20)];
  greekFontLabel.text = @"Greek Typeface";
  greekFontLabel.backgroundColor = [UIColor clearColor];
  greekFontLabel.textAlignment = UITextAlignmentCenter;
  [self.view addSubview:greekFontLabel];
  
  englishFontLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 80, 140, 20)];
  englishFontLabel.text = @"English Typeface";
  englishFontLabel.backgroundColor = [UIColor clearColor];
  englishFontLabel.textAlignment = UITextAlignmentCenter;
  [self.view addSubview:englishFontLabel];
  
  greekFontPicker = [[UITableView alloc] initWithFrame:CGRectMake(00, 100, 165, 190) style:UITableViewStyleGrouped];
  greekFontPicker.backgroundColor = [UIColor clearColor];
  greekFontPicker.backgroundView = nil;
  greekFontPicker.dataSource = self;
  greekFontPicker.delegate = self;
  
  [self.view addSubview:greekFontPicker];
  
  englishFontPicker = [[UITableView alloc] initWithFrame:CGRectMake(155, 100, 165, 190) style:UITableViewStyleGrouped];
  englishFontPicker.backgroundColor = [UIColor clearColor];
  englishFontPicker.backgroundView = nil;
  englishFontPicker.dataSource = self;
  englishFontPicker.delegate = self;
  
  [self.view addSubview:englishFontPicker];
  
  lineSpacingSelector = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 300, 145, 30)];

  [lineSpacingSelector insertSegmentWithImage:[UIImage imageNamed:@"SingleSpacing"] atIndex:0 animated:NO];
  [lineSpacingSelector insertSegmentWithImage:[UIImage imageNamed:@"OneHalfSpacing"] atIndex:1 animated:NO];
  [lineSpacingSelector insertSegmentWithImage:[UIImage imageNamed:@"DoubleSpacing"] atIndex:2 animated:NO];
  lineSpacingSelector.selectedSegmentIndex = (((PKSettings *)[PKSettings instance]).textVerseSpacing);
  [lineSpacingSelector addTarget:self action:@selector(lineSpacingChanged:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:lineSpacingSelector];

  columnSelector = [[UISegmentedControl alloc] initWithFrame:CGRectMake(165, 300, 145, 30)];
  [columnSelector addTarget:self action:@selector(columnChanged:) forControlEvents:UIControlEventValueChanged];
  [columnSelector insertSegmentWithImage:[UIImage imageNamed:@"WideLeftColumns"] atIndex:0 animated:NO];
  [columnSelector insertSegmentWithImage:[UIImage imageNamed:@"EqualColumns"] atIndex:1 animated:NO];
  [columnSelector insertSegmentWithImage:[UIImage imageNamed:@"WideRightColumns"] atIndex:2 animated:NO];
  switch (((PKSettings *)[PKSettings instance]).layoutColumnWidths)
  {
    case 0:
            columnSelector.selectedSegmentIndex = 0; break;
    case 1:
            columnSelector.selectedSegmentIndex = 2; break;
    case 2:
            columnSelector.selectedSegmentIndex = 1; break;
  }
  [self.view addSubview:columnSelector];
  
  rowSpacingSelector = [[UISegmentedControl alloc] initWithFrame:CGRectMake(116, 340, 194, 30)];
  
  [rowSpacingSelector insertSegmentWithImage:[UIImage imageNamed:@"One"] atIndex:0 animated:NO];
  [rowSpacingSelector insertSegmentWithImage:[UIImage imageNamed:@"OneAndOneQuarter"] atIndex:1 animated:NO];
  [rowSpacingSelector insertSegmentWithImage:[UIImage imageNamed:@"OneAndOneHalf"] atIndex:2 animated:NO];
  [rowSpacingSelector insertSegmentWithImage:[UIImage imageNamed:@"Two"] atIndex:3 animated:NO];
  
  switch (((PKSettings *)[PKSettings instance]).textLineSpacing)
  {
    case 100: rowSpacingSelector.selectedSegmentIndex = 0; break;
    case 125: rowSpacingSelector.selectedSegmentIndex = 1; break;
    case 150: rowSpacingSelector.selectedSegmentIndex = 2; break;
    case 200: rowSpacingSelector.selectedSegmentIndex = 3; break;
  }
  [rowSpacingSelector addTarget:self action:@selector(rowSpacingChanged:) forControlEvents:UIControlEventValueChanged];
  
  [self.view addSubview:rowSpacingSelector];
  
  rowSpacingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 340, 96, 30)];
  rowSpacingLabel.backgroundColor = [UIColor clearColor];
  rowSpacingLabel.text = @"Line Spacing";
  rowSpacingLabel.font = [UIFont systemFontOfSize:15];
  rowSpacingLabel.textAlignment = UITextAlignmentLeft;
  [self.view addSubview:rowSpacingLabel];
  
  decreaseBrightnessLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 380, 30, 30)];
  decreaseBrightnessLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16];
  decreaseBrightnessLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-adjust"];
  decreaseBrightnessLabel.backgroundColor = [UIColor clearColor];
  decreaseBrightnessLabel.textAlignment = UITextAlignmentCenter;
  [self.view addSubview:decreaseBrightnessLabel];
  
  increaseBrightnessLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 380, 30, 30)];
  increaseBrightnessLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:24];
  increaseBrightnessLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-adjust"];
  increaseBrightnessLabel.backgroundColor = [UIColor clearColor];
  increaseBrightnessLabel.textAlignment = UITextAlignmentCenter;
  [self.view addSubview:increaseBrightnessLabel];

  brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 380, 220, 30)];
  [brightnessSlider setMinimumValue:0];
  [brightnessSlider setMaximumValue:1];
  [brightnessSlider setValue: [[UIScreen mainScreen] brightness]];
  [brightnessSlider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
  
  [self.view addSubview:brightnessSlider];
  
  //[self.view addSubview:scroller];
  
  fontNames = @[ @"Courier New", @"Courier New Bold", @"Helvetica Light", @"Helvetica",
                 @"Helvetica Bold", @"Helvetica Neue Light", @"Helvetica Neue", @"Helvetica Neue Bold",
                 @"OpenDyslexic", @"OpenDyslexic Bold", @"Palatino", @"Palatino Bold" ];

  fontFaces = @[ @"CourierNewPSMT", @"CourierNewPS-BoldMT", @"Helvetica-Light", @"Helvetica",
                 @"Helvetica-Bold", @"HelveticaNeue-Light", @"HelveticaNeue", @"HelveticaNeue-Bold",
                 @"OpenDyslexic", @"OpenDyslexic-Bold", @"Palatino-Roman", @"Palatino-Bold" ];
  
  
  // my height is 440px
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyDelegate
{
  // see, we only need to ntify the delegate on the iPad; the iPhone will do it on "done"
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    [[PKSettings instance] saveSettings];
    if (delegate)
    {
      [delegate didChangeLayout:self];
    }
  }
}

# pragma mark -
# pragma mark font table routines

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return fontFaces.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellID = @"PKLayoutFontID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell)
  {
    cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellID];
  }

  int row = [indexPath row];
  
  cell.textLabel.text = fontNames[row]; cell.textLabel.numberOfLines=2;
  cell.textLabel.font = [UIFont fontWithName:fontFaces[row] size:14];
  cell.accessoryType = UITableViewCellAccessoryNone;
  
  if (tableView == greekFontPicker)
  {
    if ( [[[PKSettings instance] textGreekFontFace] isEqualToString:fontFaces[row]] )
    {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  }
  else
  {
    if ( [[[PKSettings instance] textFontFace] isEqualToString:fontFaces[row]] )
    {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  }
  
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  int row = [indexPath row];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  if (tableView == greekFontPicker)
  {
    ((PKSettings *)[PKSettings instance]).textGreekFontFace = fontFaces[row];
  }
  else
  {
    ((PKSettings *)[PKSettings instance]).textFontFace = fontFaces[row];
  }
  [tableView reloadData];
  [self notifyDelegate];
}

#pragma mark -
#pragma mark control notifications

-(void) columnChanged: (id)sender
{
  switch (columnSelector.selectedSegmentIndex)
  {
    case 0:
            ((PKSettings *)[PKSettings instance]).layoutColumnWidths = 0;
            break;
    case 1:
            ((PKSettings *)[PKSettings instance]).layoutColumnWidths = 2;
            break;
    case 2:
            ((PKSettings *)[PKSettings instance]).layoutColumnWidths = 1;
            break;
  }
  [self notifyDelegate];
}

-(void) fontSizeChanged: (id)sender
{
  ((PKSettings *)[PKSettings instance]).textFontSize = [fontSizes[(int)fontStepper.value] intValue];
  fontSizeLabel.text = [NSString stringWithFormat:@"%ipt", [[PKSettings instance] textFontSize]];
  [self notifyDelegate];
}

-(void) lineSpacingChanged: (id)sender
{
  (((PKSettings *)[PKSettings instance]).textVerseSpacing) = lineSpacingSelector.selectedSegmentIndex;
  [self notifyDelegate];
}

-(void) rowSpacingChanged: (id)sender
{
  switch (rowSpacingSelector.selectedSegmentIndex)
  {
    case 0: ((PKSettings *)[PKSettings instance]).textLineSpacing = 100; break;
    case 1: ((PKSettings *)[PKSettings instance]).textLineSpacing = 125; break;
    case 2: ((PKSettings *)[PKSettings instance]).textLineSpacing = 150; break;
    case 3: ((PKSettings *)[PKSettings instance]).textLineSpacing = 200; break;
  }
  [self notifyDelegate];
}

-(void) themeChanged: (id)sender
{
    ((PKSettings *)[PKSettings instance]).textTheme = ((CoolButton *)sender).tag;
  label1.text = [NSString stringWithFormat:@"Theme %i", [[PKSettings instance] textTheme]+1 ];

  [self notifyDelegate];
//  [self updateThemeColors:themeSelector];
}

-(void) brightnessChanged: (id)sender
{
  [[UIScreen mainScreen] setBrightness:brightnessSlider.value];
}

-(void) closeMe: (id)sender
{
        [self dismissModalViewControllerAnimated:YES];
    [[PKSettings instance] saveSettings];
  if (delegate)
  {
    [delegate didChangeLayout:self];
  }
}

/*
-(void) updateThemeColors: (UISegmentedControl *)betterSegmentedControl
{
// Get number of segments
    int numSegments = [betterSegmentedControl.subviews count];
 
    // Reset segment's color (non selected color)
    for( int i = 0; i < numSegments; i++ ) {
        // reset color
        [[betterSegmentedControl.subviews objectAtIndex:i] setTintColor:nil];
        [[betterSegmentedControl.subviews objectAtIndex:i] setTintColor:themeBgColors[i]];
      //  [[betterSegmentedControl.subviews objectAtIndex:i] setTextColor:themeTextColors[i]];
    }
 
    // Sort segments from left to right
    NSArray *sortedViews = [betterSegmentedControl.subviews sortedArrayUsingFunction:compareViewsByOrigin context:NULL];
 
    // Change color of selected segment
    if (betterSegmentedControl.selectedSegmentIndex>-1)
    {
        [[sortedViews objectAtIndex:betterSegmentedControl.selectedSegmentIndex] setTintColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    }
    // Remove all original segments from the control
    for (id view in betterSegmentedControl.subviews) {
        [view removeFromSuperview];
    }
 
    // Append sorted and colored segments to the control
    for (id view in sortedViews) {
        [betterSegmentedControl addSubview:view];
    }
}

NSInteger static compareViewsByOrigin(id sp1, id sp2, void *context)
{
    // UISegmentedControl segments use UISegment objects (private API). But we can safely cast them to UIView objects.
    float v1 = ((UIView *)sp1).frame.origin.x;
    float v2 = ((UIView *)sp2).frame.origin.x;
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
*/

@end
