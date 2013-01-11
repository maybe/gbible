//
//  PKBibleViewController.h
//  gbible
//
//  Created by Kerri Shotts on 3/16/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKLayoutControllerDelegate.h"

//#import "FWTPopoverView.h"

@interface PKBibleViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIActionSheetDelegate, PKLayoutControllerDelegate>

- (void)displayBook: (int)theBook andChapter: (int)theChapter andVerse: (int)theVerse;
   
    @property (strong, nonatomic) NSArray *currentGreekChapter;
    @property (strong, nonatomic) NSArray *currentEnglishChapter;
    
    @property (strong, nonatomic) NSMutableArray *formattedGreekChapter;
    @property (strong, nonatomic) NSMutableArray *formattedEnglishChapter;
    
    @property (strong, nonatomic) NSMutableArray *formattedGreekVerseHeights;
    @property (strong, nonatomic) NSMutableArray *formattedEnglishVerseHeights;
    
    @property (strong, nonatomic) NSMutableDictionary *selectedVerses;
    @property (strong, nonatomic) NSMutableDictionary *highlightedVerses;
    
    @property (strong, nonatomic) NSString *selectedWord;
    @property (strong, nonatomic) NSString *selectedPassage;
    
    @property (strong, nonatomic) NSMutableArray *cellHeights; // RE: ISSUE #1
    @property (strong, nonatomic) NSMutableArray *cells;       // RE: ISSUE #1
    
    @property (strong, nonatomic) NSMutableArray *reusableLabels;
    
    // UI elements
    @property (strong, nonatomic) UIBarButtonItem *changeHighlight;
    @property (strong, nonatomic) NSMutableArray *formattedCells;
    @property (strong, nonatomic) UIMenuController *ourMenu;
    @property int ourMenuState;
    @property (strong, nonatomic) UIActionSheet *ourPopover;
    
    @property (strong, nonatomic) UIButton *btnRegularScreen;
    
    @property (strong, nonatomic) UILabel *tableTitle;
    
    @property int theWordTag;
    @property int theWordIndex;
    
    @property BOOL fullScreen;
    
    @property (strong, nonatomic) UITableViewCell *theCachedCell;
    
    @property BOOL dirty;

    @property (strong, nonatomic) UIButton *previousChapterButton;
    @property (strong, nonatomic) UIButton *nextChapterButton;

    @property (strong, nonatomic) UIPopoverController *PO;
    //@property (strong, nonatomic) FWTPopoverView *popoverView;
    -(void)notifyNoteChanged;
    
@end
