//
//  PKNotesViewController.m
//  gbible
//
//  Created by Kerri Shotts on 3/16/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKNotesViewController.h"
#import "PKNotes.h"
#import "PKBible.h"
#import "ZUUIRevealController.h"
#import "PKBibleViewController.h"
#import "PKRootViewController.h"
#import "PKSettings.h"

@interface PKNotesViewController ()

@end

@implementation PKNotesViewController

    @synthesize notes;
    @synthesize noResults;

- (void)reloadNotes
{
    notes = [(PKNotes *)[PKNotes instance] allNotes];
    [self.tableView reloadData];
    
    if ([notes count] == 0)
    {
        noResults.text = __Tv(@"no-notes", @"You don't have any notes.");
    }
    else 
    {
        noResults.text = @"";
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) updateAppearanceForTheme
{
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [PKSettings PKSidebarPageColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [TestFlight passCheckpoint:@"ANNOTATIONS"];
    self.tableView.backgroundView = nil; 
    self.tableView.backgroundColor = [PKSettings PKSelectionColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect theRect = CGRectMake(0, self.tableView.center.y + 20, 260, 60);
    noResults = [[UILabel alloc] initWithFrame:theRect];
    noResults.textColor = [PKSettings PKTextColor]; //[UIColor whiteColor];
    noResults.font = [UIFont fontWithName:@"Zapfino" size:15];
    noResults.textAlignment = UITextAlignmentCenter;
    noResults.backgroundColor = [UIColor clearColor];
    noResults.shadowColor = [UIColor clearColor];
    noResults.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    noResults.numberOfLines = 0;
    [self.view addSubview:noResults];
     self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   
}

/**
 *
 * Force our width and then reload our highlights
 *
 */
- (void)viewDidAppear:(BOOL)animated
{
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.size.width = 260;
    self.navigationController.view.frame = newFrame;
    [self reloadNotes];
    [self updateAppearanceForTheme];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    notes = nil;
    noResults = nil;
}

/**
 *
 * When animating for rotation, keep our frame at 260
 *
 */
- (void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.size.width = 260;
    self.navigationController.view.frame = newFrame;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.size.width = 260;
    self.navigationController.view.frame = newFrame;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark -
#pragma mark tableview

/**
 *
 * We have one section
 *
 */
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 *
 * Return the number of highlights
 *
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notes count];
}

/**
 *
 * Generate a cell for the table. We will fill the cell with the "pretty" passage.
 *
 */
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *highlightCellID = @"PKHighlightCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:highlightCellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier:highlightCellID];
    }
    
    NSUInteger row = [indexPath row];
    
    NSString *thePassage = [notes objectAtIndex:row];
//    int theBook = [PKBible bookFromString:thePassage];
//    int theChapter = [PKBible chapterFromString:thePassage];
//    int theVerse = [PKBible verseFromString:thePassage];
//    NSString *thePrettyPassage = [NSString stringWithFormat:@"%@ %i:%i",
//                                           [PKBible nameForBook:theBook], theChapter, theVerse];
                                           
    NSArray *theNoteArray = [(PKNotes *)[PKNotes instance] getNoteForPassage:thePassage];
    NSString *theTitle = [theNoteArray objectAtIndex:0];
    NSString *theNote = [theNoteArray objectAtIndex:1];
                                           
    cell.textLabel.text = theTitle;
    cell.textLabel.textColor = [PKSettings PKSidebarTextColor];
    cell.detailTextLabel.text = theNote;
    cell.detailTextLabel.textColor = [PKSettings PKSidebarTextColor];
    cell.detailTextLabel.numberOfLines=4;
    [cell.detailTextLabel sizeToFit];

    return cell;
}

/**
 *
 * If the user clicks on a highlight, we should navigate to that position in the Bible text.
 *
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *thePassage = [notes objectAtIndex:row];
    int theBook = [PKBible bookFromString:thePassage];
    int theChapter = [PKBible chapterFromString:thePassage];
    int theVerse = [PKBible verseFromString:thePassage];
    
    ZUUIRevealController  *rc = (ZUUIRevealController *)self.parentViewController
                                                            .parentViewController;
    PKRootViewController *rvc = (PKRootViewController *)rc.frontViewController;
        
    PKBibleViewController *bvc = [[[rvc.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];     
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [rc revealToggle:self];

    [bvc displayBook:theBook andChapter:theChapter andVerse:theVerse];
    
  
}

@end
