//
//  PKBibleBookChaptersViewController.h
//  gbible
//
//  Created by Kerri Shotts on 3/16/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKBibleBookChaptersViewController : UITableViewController

-(id)initWithBook: (int) theBook;

@property int selectedBook;

@end