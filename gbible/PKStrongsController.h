//
//  PKStrongsController.h
//  gbible
//
//  Created by Kerri Shotts on 3/16/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKHotLabelDelegate.h"
#import "PKBibleReferenceDelegate.h"
#import "PKTableViewController.h"

@interface PKStrongsController : PKTableViewController <UISearchBarDelegate, PKHotLabelDelegate, PKBibleReferenceDelegate>

@property (strong, nonatomic) NSString *theSearchTerm;

@property (strong, nonatomic) NSArray *theSearchResults;

@property (strong, nonatomic) UISearchBar *theSearchBar;

@property (strong, nonatomic) UIButton *clickToDismiss;

@property (strong, nonatomic) UILabel *noResults;

@property (strong, nonatomic) UIFont *theFont;
@property (strong, nonatomic) UIFont *theBigFont;

@property BOOL byKeyOnly;

@property (strong, nonatomic) UIMenuController *ourMenu;
@property (strong, nonatomic) NSString *selectedWord;
@property NSUInteger selectedRow;

@property (nonatomic, weak) id <PKBibleReferenceDelegate> delegate;

-(void)doSearchForTerm: (NSString *) theTerm;
-(void)doSearchForTerm: (NSString *) theTerm byKeyOnly: (BOOL) keyOnly;

@end