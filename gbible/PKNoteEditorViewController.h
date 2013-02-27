//
//  PKNoteEditorViewController.h
//  gbible
//
//  Created by Kerri Shotts on 4/1/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

// ============================ LICENSE ============================
//
// The code that is not otherwise licensed or is owned by photoKandy
// Studios LLC is hereby licensed under a CC BY-NC-SA 3.0 license.
// That is, you may copy the code and use it for non-commercial uses
// under the same license. For the entire license, see
// http://creativecommons.org/licenses/by-nc-sa/3.0/.
//
// Furthermore, you may use the code in this app for your own
// personal or educational use. However you may NOT release a
// competing app on the App Store without prior authorization and
// significant code changes. If authorization is granted, attribution
// must be kept, but you must also add in your own attribution. You
// must also use your own API keys (TestFlight, Parse, etc.) and you
// must provide your own support. As the code is released for non-
// commercial purposes, any directly competing app based on this code
// must not require payment of any form (including ads).
//
// Attribution must be visual and be of the form:
//
//   Portions of this code from Greek Interlinear Bible,
//   (C) photokandy Studios LLC and Kerri Shotts, released
//   under a CC BY-NC-SA 3.0 license.
//
// NOTE: The graphical assets are not covered under the above license.
// They are copyright their respective owners. Any third party code
// (such as that under the Third Party section) are licensed under
// their respective licenses.
//
#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "PKTextView.h"
#import "PKTextViewDelegate.h"
#import "PKBibleReferenceDelegate.h"
#import "KBKeyboardHandlerDelegate.h"


@interface PKNoteEditorViewController : UIViewController <UITextViewDelegate, PKTextViewDelegate, PKBibleReferenceDelegate, KBKeyboardHandlerDelegate>

@property (strong, nonatomic) NSString *passage;
@property (strong, nonatomic) NSString *noteTitle;
@property (strong, nonatomic) NSString *note;
@property int state;

@property (strong, nonatomic) UITextView *txtTitle;
@property (strong, nonatomic) PKTextView *txtNote;
@property (strong, nonatomic) UIBarButtonItem *btnDelete;
@property (strong, nonatomic) UIBarButtonItem *btnCancel;
@property (strong, nonatomic) UIBarButtonItem *btnDone;

@property (strong, nonatomic) TPKeyboardAvoidingScrollView *scroller;

-(id) initWithPassage: (NSString *) thePassage;
-(id) initWithPassage: (NSString *) thePassage andTitle: (NSString *) theTitle andNote: (NSString *) theNote;

@end