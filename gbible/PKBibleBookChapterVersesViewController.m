//
//  PKBibleBookChapterVersesViewController.m
//  gbible
//
//  Created by Kerri Shotts on 3/16/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKBibleBookChapterVersesViewController.h"
#import "PKBible.h"
#import "PKBibleViewController.h"
//#import "PKRootViewController.h"
#import "ZUUIRevealController.h"
#import "PKSettings.h"
#import "PKSimpleCollectionViewCell.h"
#import "PKBibleReferenceDelegate.h"
#import "PKAppDelegate.h"

@interface PKBibleBookChapterVersesViewController ()

@end

@implementation PKBibleBookChapterVersesViewController

@synthesize selectedBook;
@synthesize selectedChapter;
@synthesize delegate;

#pragma mark -
#pragma mark view lifecycle

/**
 *
 * Set the book and chapter
 *
 */
-(id)initWithBook: (int) theBook withChapter: (int) theChapter
{
  self = [super initWithCollectionViewLayout:[PSUICollectionViewFlowLayout new]];
  
  if (self)
  {
    // Custom initialization
    selectedBook    = theBook;
    selectedChapter = theChapter;
  }
  return self;
}

/**
 *
 * Set our title and background
 *
 */
-(void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [TestFlight passCheckpoint: @"BIBLE_BOOK_CHAPTER_VERSES"];
  
  self.view.backgroundColor = (self.delegate)?[PKSettings PKPageColor]:[PKSettings PKSidebarPageColor];
  self.collectionView.backgroundColor = (self.delegate)?[PKSettings PKPageColor]:[PKSettings PKSidebarPageColor];
  //self.title                                       = __T(@"Select Verse");
  self.title = [__T(@"Chapter") stringByAppendingFormat:@" %i", selectedChapter];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  [self.collectionView registerClass:[PKSimpleCollectionViewCell class] forCellWithReuseIdentifier:@"simple-cell"];
  
  if (delegate)
  {
    UIBarButtonItem *closeButton =
      [[UIBarButtonItem alloc] initWithTitle: __T(@"Done") style: UIBarButtonItemStylePlain target: self action: @selector(closeMe:)
      ];
    self.navigationItem.rightBarButtonItem = closeButton;
  }
}

-(void) updateAppearanceForTheme
{
  self.view.backgroundColor = (self.delegate)?[PKSettings PKPageColor]:[PKSettings PKSidebarPageColor];
  self.collectionView.backgroundColor = (self.delegate)?[PKSettings PKPageColor]:[PKSettings PKSidebarPageColor];
  [self.collectionView reloadData];
}

-(void)viewWillAppear: (BOOL) animated
{
  [self updateAppearanceForTheme];
}

-(void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
  return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSTCollectionViewDataSource

-(NSInteger) numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView
{
  return 1;
}

/**
 *
 * Return # of verses for the book & chapter
 *
 */
- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
  return [PKBible countOfVersesForBook: selectedBook forChapter: selectedChapter];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSTCollectionViewDelegate

/**
 *
 * Return the cell with a typical reference, like Matthew 1:1
 *
 */
- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  PKSimpleCollectionViewCell *cell = (PKSimpleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simple-cell" forIndexPath:indexPath];
  
  NSUInteger row = [indexPath row];
  
  cell.label.text      = [NSString stringWithFormat: @"%i:%i", selectedChapter, row + 1];
  cell.backgroundColor = (self.delegate)?[PKSettings PKPageColor]:[PKSettings PKSidebarPageColor];
  cell.label.textColor = [PKSettings PKSidebarTextColor];
  
  return cell;
}

/**
 *
 * If we press a row, we need to tell the BibleView controller to go there
 *
 */
-(void) collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSUInteger row = [indexPath row];
  
  [collectionView deselectItemAtIndexPath: indexPath animated: YES];
  
  // we can now form a complete reference. Pass that back to the bible view
  if (!self.delegate)
  {
    [self.navigationController popToRootViewControllerAnimated: YES];
    [[PKAppDelegate sharedInstance].rootViewController revealToggle: self];
    [[PKAppDelegate sharedInstance].bibleViewController displayBook: selectedBook andChapter: selectedChapter andVerse: row + 1];
  }
  else
  {
    if (self.notifyWithCopyOfVerse)
    {
      [self.delegate newVerseByBook:selectedBook andChapter:selectedChapter andVerse:row+1];
    }
    else
    {
      [self.delegate newReferenceByBook:selectedBook andChapter:selectedChapter andVerse:row+1];
    }
    [self dismissModalViewControllerAnimated: YES];
  }
 
}
-(CGSize) collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 86 : 65),
                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 50 : 44) );
}

-(CGFloat) collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  return 0;
}

-(CGFloat) collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
  return 0;
}

- (UIEdgeInsets)collectionView:
(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

#pragma mark -
#pragma mark Button Actions

-(void) closeMe: (id) sender
{
  [self dismissModalViewControllerAnimated: YES];
  [[PKSettings instance] saveSettings];
}


@end