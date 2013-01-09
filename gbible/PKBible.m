//
//  PKBible.m
//  gbible
//
//  Created by Kerri Shotts on 3/19/12.
//  Copyright (c) 2012 photoKandy Studios LLC. All rights reserved.
//

#import "PKBible.h"
#import "PKSettings.h"
#import "PKDatabase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "PKConstants.h"

@implementation PKBible

  +(NSArray *) availableTextsForSide: (NSString *)side andColumn: (int)column
  {
    // http://stackoverflow.com/questions/3940615/find-current-country-from-iphone-device
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    FMDatabase *db = [[PKDatabase instance] bible];
    FMResultSet *s = [db executeQuery:@"select bibleAbbreviation, bibleAttribution, bibleSide, bibleID, bibleName, bibleParsedID from bibles where bibleSide=? order by bibleAbbreviation", side];

    NSMutableArray *texts = [[NSMutableArray alloc] initWithCapacity:4];
    while ([s next])
    {
      // make sure we don't add the KJV version if we're in the UK, or in the Euro-zone (since they
      // must respect the UK copyright) Adding Canada and Australia, just to be safe.
      if ( !(([@" GB AT BE BG CY CZ DK EE FI FR DE GR HU IE IT LV LT LU MT NL PL PT RO SK SI ES SE CA AU "
            rangeOfString:[NSString stringWithFormat:@" %@ ", countryCode]].location != NSNotFound)
          && [[s stringForColumnIndex:PK_TBL_BIBLES_ABBREVIATION] isEqualToString:@"KJV"]) )
      {
        [texts addObject: [s objectForColumnIndex:column] ];
      }
    }
    return texts;
  }
  +(NSArray *) availableOriginalTexts: (int)column
  {
    return [PKBible availableTextsForSide:@"greek" andColumn:column];
  }

  +(NSArray *) availableHostTexts: (int)column
  {
    return [PKBible availableTextsForSide:@"english" andColumn:column];
    // really a misnomer; we should allow the reader to choose any language edition of their choosing.
  }


/**
 *
 * Returns the canonical name for a Bible book, given the book number. For example, 40=Matthew
 *
 */
    +(NSString *) nameForBook: (int)theBook
    {
    //
    // Books of the bible and chapter count obtained from http://www.deafmissions.com/tally/bkchptrvrs.html
    //
        NSArray *bookList = [NSArray arrayWithObjects: 
                      __T(@"Genesis"),         __T(@"Exodus"),   __T(@"Leviticus"), __T(@"Numbers"),
                      __T(@"Deuteronomy"),     __T(@"Joshua"),   __T(@"Judges"),    __T(@"Ruth"),
                      __T(@"1 Samuel"),        __T(@"2 Samuel"), __T(@"1 Kings"),   __T(@"2 Kings"),
                      __T(@"1 Chronicles"),    __T(@"2 Chronicles"),
                      __T(@"Ezra"),            __T(@"Nehemia"),  __T(@"Esther"),    __T(@"Job"),
                      __T(@"Psalms"),          __T(@"Proverbs"), __T(@"Ecclesiastes"),
                      __T(@"Song of Solomon"), __T(@"Isaiah"),   __T(@"Jeremiah"),  __T(@"Lamentations"),
                      __T(@"Ezekial"),         __T(@"Daniel"),
                      __T(@"Hosea"),           __T(@"Joel"),     __T(@"Amos"),      __T(@"Obadiah"),
                      __T(@"Jonah"),           __T(@"Micah"),    __T(@"Nahum"),     __T(@"Habakkuk"),
                      __T(@"Zephaniah"),       __T(@"Haggai"),   __T(@"Zechariah"), __T(@"Malachi"),
                      // New Testament
                      __T(@"Matthew"),         __T(@"Mark"),            __T(@"Luke"),          __T(@"John"),
                      __T(@"Acts"),            __T(@"Romans"),          __T(@"1 Corinthians"),
                      __T(@"2 Corinthians"),   __T(@"Galatians"), // FIX ISSUE #44
                      __T(@"Ephesians"),       __T(@"Philippians"),     __T(@"Colossians"),
                      __T(@"1 Thessalonians"), __T(@"2 Thessalonians"), __T(@"1 Timothy"),     __T(@"2 Timothy"), __T(@"Titus"),
                      __T(@"Philemon"),        __T(@"Hebrews"),         __T(@"James"),         __T(@"1 Peter"),   __T(@"2 Peter"),
                      __T(@"1 John"),          __T(@"2 John"),
                      __T(@"3 John"),          __T(@"Jude"),            __T(@"Revelation"), nil];
        return [bookList objectAtIndex:theBook-1];
    }
    
/**
 *
 * Returns the numerical 3-letter code for the given book. For example, 40 = 40N, 10 = 10O
 *
 */
    +(NSString *) numericalThreeLetterCodeForBook:(int)theBook
    {
        NSArray *bookList = [NSArray arrayWithObjects:
                          @"01O", @"02O", @"03O", @"04O", @"05O", @"06O", @"07O", @"08O",
                          @"09O", @"10O", @"11O", @"12O", @"13O", @"14O",
                          @"15O", @"16O", @"17O", @"18O", @"19O", @"20O", @"21O",
                          @"22O", @"23O", @"24O", @"25O", @"26O", @"27O",
                          @"28O", @"29O", @"30O", @"31O", @"32O", @"33O", @"34O", @"35O",
                          @"36O", @"37O", @"38O", @"39O",
                          // New Testament
                          @"40N", @"41N", @"42N", @"43N", @"44N", @"45N", @"46N",
                          @"47N", @"48N", @"49N", @"50N", @"51N",
                          @"52N", @"53N", @"54N", @"55N", @"56N",
                          @"57N", @"58N", @"59N", @"60N", @"61N", @"62N", @"63N",
                          @"64N", @"65N", @"66N", nil];
        return [bookList objectAtIndex:theBook-1];
    }
    
/**
 *
 * Returns the 3-letter abbreviation for a given book. For example, 40 = Mat
 *
 */
    +(NSString *) abbreviationForBook:(int)theBook
    {
        NSArray *bookList = [NSArray arrayWithObjects:
                          @"Gen", @"Exo", @"Lev", @"Num", @"Deu", @"Jos", @"Jdg", @"Rut",
                          @"1Sa", @"2Sa", @"1Ki", @"2Ki", @"1Ch", @"2Ch",
                          @"Ezr", @"Neh", @"Est", @"Job", @"Psa", @"Pro", @"Ecc",
                          @"Sos", @"Isa", @"Jer", @"Lam", @"Eze", @"Dan",
                          @"Hos", @"Joe", @"Amo", @"Oba", @"Jon", @"Mic", @"Nah", @"Hab",
                          @"Zep", @"Hag", @"Zec", @"Mal",
                          // New Testament
                          @"Mat", @"Mar", @"Luk", @"Joh", @"Act", @"Rom", @"1Co",
                          @"2Co", @"Gal", @"Eph", @"Phi", @"Col",
                          @"1Th", @"2Th", @"1Ti", @"2Ti", @"Tit",
                          @"Phl", @"Heb", @"Jas", @"1Pe", @"2Pe", @"1Jo", @"2Jo",
                          @"3Jo", @"Jud", @"Rev", nil];
        return [bookList objectAtIndex:theBook-1];
    }
    
/**
 *
 * Returns the number of chapters in the given Bible book.
 *
 */
    +(int) countOfChaptersForBook:(int)theBook 
    {
        NSArray *chapterCountList = [NSArray arrayWithObjects:
                              [NSNumber numberWithInt:50], 
                              [NSNumber numberWithInt:40], 
                              [NSNumber numberWithInt:27], 
                              [NSNumber numberWithInt:36], 
                              [NSNumber numberWithInt:34], 
                              [NSNumber numberWithInt:24], 
                              [NSNumber numberWithInt:21], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:31], 
                              [NSNumber numberWithInt:24], 
                              [NSNumber numberWithInt:22], 
                              [NSNumber numberWithInt:25], 
                              [NSNumber numberWithInt:29], 
                              [NSNumber numberWithInt:36], 
                              [NSNumber numberWithInt:10], 
                              [NSNumber numberWithInt:13], 
                              [NSNumber numberWithInt:10], 
                              [NSNumber numberWithInt:42], 
                              [NSNumber numberWithInt:150],
                              [NSNumber numberWithInt:31], 
                              [NSNumber numberWithInt:12] ,
                              [NSNumber numberWithInt:8] ,
                              [NSNumber numberWithInt:66] ,
                              [NSNumber numberWithInt:52], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:48], 
                              [NSNumber numberWithInt:12], 
                              [NSNumber numberWithInt:14], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:9], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:7], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:2], 
                              [NSNumber numberWithInt:14], 
                              [NSNumber numberWithInt:4],
                              // New Testament
                              [NSNumber numberWithInt:28], 
                              [NSNumber numberWithInt:16], 
                              [NSNumber numberWithInt:24], 
                              [NSNumber numberWithInt:21], 
                              [NSNumber numberWithInt:28], 
                              [NSNumber numberWithInt:16], 
                              [NSNumber numberWithInt:16], 
                              [NSNumber numberWithInt:13], // re: issue #29
                              [NSNumber numberWithInt:6], 
                              [NSNumber numberWithInt:6], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:6], 
                              [NSNumber numberWithInt:4], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:13], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:3], 
                              [NSNumber numberWithInt:5], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:1], 
                              [NSNumber numberWithInt:22]
                              , nil ];
        return [[chapterCountList objectAtIndex:theBook-1] intValue];
    }
    
/**
 *
 * Returns the number of verses for the given book and chapter.
 *
 */
    +(int) countOfVersesForBook:(int)theBook forChapter:(int)theChapter 
    {
        int totalGreekCount =0 ;
        int totalEnglishCount =0;
        int totalCount;
        NSString *theSQL = @"SELECT count(*) FROM content WHERE bibleID=? AND bibleBook = ? AND bibleChapter = ?";
    
        int currentGreekBible = [[PKSettings instance] greekText];
        int currentEnglishBible = [[PKSettings instance] englishText];
        FMDatabase *db = [[PKDatabase instance] bible];
        
        FMResultSet *s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentGreekBible], 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter]];
        while ([s next])
        {
            totalGreekCount = [s intForColumnIndex:0];
        }

        s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentEnglishBible], 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter]];
        while ([s next])
        {
            totalEnglishCount = [s intForColumnIndex:0];
        }
        
        totalCount = MAX(totalGreekCount, totalEnglishCount);
        
        return totalCount;
    }
    
/**
 *
 * Returns the text for a given reference (book chapter:verse) and side (1=greek,2=english)
 *
 * Note: adds the verse # to the english side. TODO?: Add to greek side too?
 *
 */
    +(NSString *) getTextForBook:(int)theBook forChapter:(int)theChapter forVerse:(int)theVerse forSide:(int)theSide
    {
        int currentBible = (theSide==1 ? [[PKSettings instance] greekText] : [[PKSettings instance] englishText]);
        FMDatabase *db = [[PKDatabase instance] bible];
        NSString *theSQL = @"SELECT bibleText FROM content WHERE bibleID=? AND bibleBook=? AND bibleChapter=? AND bibleVerse=?";
        NSString *theText;
        NSString *theRef = [NSString stringWithFormat:@"%i ", theVerse];
        
        FMResultSet *s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentBible] , 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter],
                                                  [NSNumber numberWithInt:theVerse]];
        while ([s next])
        {
            theText = [s stringForColumnIndex:0];
        }
        
        if (theSide == 2)
        {
            if (theText != nil)
            {
                theText = [theRef stringByAppendingString:theText];
            }
            else 
            {
                theText = theRef;
            }
        }
        theText = [theText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([[PKSettings instance] transliterateText])
            {
              theText = [self transliterate:theText];
            }
        return theText;
    }

/**
 *
 * Return the text for a given chapter (book chapter) and side (1=greek, 2=english). Note that
 * the english text has verse #s prepended to the text. Also note that is entirely possible
 * for the array on one side to be of a different length than the other side (Notably, Romans 13,16)
 *
 */
    +(NSArray *) getTextForBook:(int)theBook forChapter:(int)theChapter forSide:(int)theSide
    {
        int currentBible = (theSide==1 ? [[PKSettings instance] greekText] : [[PKSettings instance] englishText]);
        FMDatabase *db = [[PKDatabase instance] bible];
        
        NSString *theSQL = @"SELECT bibleText FROM content WHERE bibleID=? AND bibleBook = ? AND bibleChapter = ?";
        //NSArray *theArray = [[NSArray alloc] init];
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        
        FMResultSet *s = [db executeQuery:theSQL, [NSNumber numberWithInt:currentBible], 
                                                  [NSNumber numberWithInt:theBook],
                                                  [NSNumber numberWithInt:theChapter]];
        int i=1;
        while ([s next])
        {
            NSString *theText = [s stringForColumnIndex:0];
            NSString *theRef = [NSString stringWithFormat:@"%i ", i];
            if (theSide == 2)
            {
                theText = [theRef stringByAppendingString:theText];
            }
            theText = [theText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([[PKSettings instance] transliterateText])
            {
              theText = [self transliterate:theText];
            }
            [theArray addObject:theText];
            i++;
        }
        
        return theArray;
    }

    
/**
 *
 * Returns a string for the given passage. For example, for Matthew(book 40), Chapter 1, Verse 1
 * we return 40N.1.1 . Most useful when maintaining dictionary keys. Otherwise, it is better
 * and faster to use the book/chapter/verse method.
 *
 */
    +(NSString *) stringFromBook:(int)theBook forChapter:(int)theChapter forVerse:(int)theVerse
    {
        NSString *theString;
        theString = [[[[[self numericalThreeLetterCodeForBook:theBook] stringByAppendingString:@"."]
                         stringByAppendingFormat:@"%i", theChapter] stringByAppendingString:@"."]
                         stringByAppendingFormat:@"%i", theVerse];
        return theString;
    }
    
/**
 *
 * Returns a shortened passage reference, containing the book and chapter. (No verse reference.)
 *
 * For example, given Matthew Chapter 1 (book 40), return 40N.1
 *
 */
    +(NSString *) stringFromBook:(int)theBook forChapter:(int)theChapter
    {
        NSString *theString;
        theString = [[[self numericalThreeLetterCodeForBook:theBook] stringByAppendingString:@"."] 
                       stringByAppendingFormat:@"%i", theChapter];
        return theString;
    }

/**
 *
 * Returns the book portion of a string formatted by stringFromBook:forChapter:forVerse
 *
 * For example, given 40N.1.1, return 40
 *
 */
    +(int) bookFromString:(NSString *)theString
    {
        return [theString intValue];
    }
    
/**
 *
 * Returns the chapter portion of a string formatted by stringFromBook:forChapter:forVerse
 *
 * For example, given 40N.12.1, return 12
 *
 */
    +(int) chapterFromString:(NSString *)theString
    {
    
        // return the chapter portion of a string
        int firstPeriod = [theString rangeOfString:@"."].location;
        int secondPeriod = [theString rangeOfString:@"." options:0 range:NSMakeRange(firstPeriod+1, [theString length]-(firstPeriod+1))].location;
        
        return [[theString substringWithRange:NSMakeRange(firstPeriod+1, secondPeriod-(firstPeriod+1))] intValue];
    }
    
/**
 *
 * Returns the verse portion of a string formatted by stringfromBook:forChapter:forVerse
 *
 * For example, given 40N.12.1, returns 1
 *
 */
    +(int) verseFromString:(NSString *)theString
    {
        // return the verse portion of a string
        int firstPeriod = [theString rangeOfString:@"."].location;
        int secondPeriod = [theString rangeOfString:@"." options:0 range:NSMakeRange(firstPeriod+1, [theString length]-(firstPeriod+1))].location;
        
        return [[theString substringFromIndex:secondPeriod+1] intValue];
    }
    
/**
 *
 * Return the maximum height of the desired formatted text (in theWordArray). If withParsings
 * is YES, we include the height of the Strong's Numbers and (potentially) the Morphology.
 *
 */
    +(CGFloat)formattedTextHeight: (NSArray *)theWordArray withParsings:(BOOL)parsed
    {
        // this is our font
        UIFont *theFont = [UIFont fontWithName:[[PKSettings instance] textFontFace]
                                          size:[[PKSettings instance] textFontSize]];
        // we need to know the height of an M (* the setting...)
        CGFloat lineHeight = [@"M" sizeWithFont:theFont].height;
        lineHeight = lineHeight * ((float)[[PKSettings instance] textLineSpacing] / 100.0);
        // determine the maximum size of the column (1 line, 2 lines, 3 lines?)
        CGFloat columnHeight = lineHeight;
        columnHeight += (lineHeight * [[PKSettings instance] textVerseSpacing]);
        if (parsed)
        {
            // are we going to show morphology?
            if ([[PKSettings instance] showMorphology])
            {
                columnHeight += lineHeight;
            }
            columnHeight += lineHeight; // for G#s
        }
        
        CGFloat maxY = 0.0;
        for (int i=0; i<[theWordArray count];i++)
        {
            NSArray *theWordElement = [theWordArray objectAtIndex:i];
            //NSString *theWord = [theWordElement objectAtIndex:0];
            //int theWordType = [[theWordElement objectAtIndex:1] intValue];
            //CGFloat wordX = [[theWordElement objectAtIndex:2] floatValue];
            CGFloat wordY = [[theWordElement objectAtIndex:3] floatValue];
            
            if (wordY > maxY)
            {
                maxY = wordY;
            }
        }
        
        //maxY += columnHeight + lineHeight;
        maxY += lineHeight + (lineHeight / 2); //RE: ISSUE # 5
        
        return maxY;
    }
    
/**
 *
 * Return the width of a given column for the given bounds, based upon the user's
 * column settings. TODO: Doesn't feel quite right on a smaller screen, though
 *
 */
    +(CGFloat) columnWidth: (int) theColumn forBounds: (CGRect)theRect
    {
        // set Margin
        CGFloat theMargin = 5;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            // iPad gets wider margins
            theMargin = 44;
        }
        // define our column (based on incoming rect)
        float columnMultiplier = 1;
        int columnSetting = [[PKSettings instance] layoutColumnWidths];
        if (columnSetting == 0) // 600930
        {
            if (theColumn == 1) {   columnMultiplier = 1.75;    }
            if (theColumn == 2) {   columnMultiplier = 1.25;    }
        }
        if (columnSetting == 1) // 300960
        {
            if (theColumn == 1) {   columnMultiplier = 1.25;    }
            if (theColumn == 2) {   columnMultiplier = 1.75;    }
        }
        if (columnSetting == 2) // 600930
        {
            columnMultiplier = 1.5;
        }
        if (theColumn == 3) { columnMultiplier = 0.25; }
        columnMultiplier = columnMultiplier / 3;
        
        CGFloat columnWidth = ((theRect.size.width) - (theMargin)) * columnMultiplier;
        
        return columnWidth;
    }

    +(BOOL) isMorphology: (NSString*)theWord
    {
      // there's no easy way to determine if a word is a morphology word. Instead, let's encode
      // the various options
      if ( [theWord hasPrefix:@"A-"]) return YES;
      if ( [theWord hasPrefix:@"C-"]) return YES;
      if ( [theWord hasPrefix:@"D-"]) return YES;
      if ( [theWord hasPrefix:@"F-"]) return YES;
      if ( [theWord hasPrefix:@"I-"]) return YES;
      if ( [theWord hasPrefix:@"K-"]) return YES;
      if ( [theWord hasPrefix:@"N-"]) return YES;
      if ( [theWord hasPrefix:@"P-"]) return YES;
      if ( [theWord hasPrefix:@"Q-"]) return YES;
      if ( [theWord hasPrefix:@"R-"]) return YES;
      if ( [theWord hasPrefix:@"S-"]) return YES;
      if ( [theWord hasPrefix:@"T-"]) return YES;
      if ( [theWord hasPrefix:@"V-"]) return YES;
      if ( [theWord hasPrefix:@"X-"]) return YES;
      if ( [theWord hasPrefix:@"Noun-"]) return YES;
      if ( [theWord hasPrefix:@"Art-"]) return YES;
      if ( [theWord hasPrefix:@"Adj-"]) return YES;
      if ( [theWord hasPrefix:@"Adv-"]) return YES;
      if ( [theWord hasPrefix:@"RefPro-"]) return YES;
      if ( [theWord hasPrefix:@"RelPro-"]) return YES;
      if ( [theWord hasPrefix:@"IPro-"]) return YES;
      if ( [theWord hasPrefix:@"DPro-"]) return YES;
      if ( [theWord hasPrefix:@"PPro-"]) return YES;
      if ( [theWord hasPrefix:@"Ppro-"]) return YES;
      if ( [theWord hasPrefix:@"Prtcl-"]) return YES;
      if ( [theWord hasPrefix:@"PRT-"]) return YES;
      if ( [theWord hasPrefix:@"ADV-"]) return YES;
      if ( [theWord hasPrefix:@"COND-"]) return YES;
      
      /*if ([theWord isEqualToString:@"N"])
      {
        NSLog (@"Here");
      }*/
      
      NSString *morphWords = @" Adv Adj N V Heb Conj Prep Prtcl Prt Cond Inj ADV ADJ HEB CONJ PREP PRTCL PRT COND ARAM INJ ";
      if ( [morphWords rangeOfString:[NSString stringWithFormat:@" %@ ", theWord]].location != NSNotFound)
      {
        return YES;
      }
      return NO;
    }
    
    +(NSString *)transliterate: (NSString*)theWord
    {
        // See what we can do about using CFStringTransform...
        //NSString *theWordND = [theWord stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
        NSMutableString *myMString = [theWord mutableCopy];
        CFMutableStringRef myCFString = (__bridge CFMutableStringRef)myMString;
        CFStringTransform( myCFString, NULL, kCFStringTransformToLatin, false);
      
        return myMString;
    
    /*
        NSString *theWordND = [theWord stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
      
        if ([theWordND isEqualToString:@""])
        {
          return [theWordND mutableCopy];
        }
      
        NSMutableString *theNewWord = [[NSMutableString alloc] initWithCapacity:[theWordND length]];
      
        NSString *ccSource = @"γγ/γξ/γκ/γχ/";
        NSString *ccTarget = @"ng nx nk nch";
      
        NSString *scSource = @"' α Α β Β γ Γ δ Δ ε Ε ζ Ζ η Η θ Θ ι Ι κ Κ λ Λ μ Μ ν Ν ξ Ξ ο Ο π Π ρ Ρ σ Σ ς τ Τ υ Υ φ Φ χ Χ ψ Ψ ω Ω ";
        NSString *scTarget = @"h a A b B g G d D e E z Z e E thThi I k K l L m M n N c C o O p P r R s S s t T u U phPhchChpsPso O ";
      
        BOOL ignoreNext = NO;
        int l = [theWordND length];
        for (int i=0; i<l; i++)
        {
          if (!ignoreNext)
          {
          
            //@try
            {
              NSString *ccChar;
              
              if (i<(l-1))
              {
                ccChar = [theWordND substringWithRange:NSMakeRange(i, 2)] ;
              }
              else
              {
                ccChar = @"zzz";
              }
              
              NSString *scChar = [theWordND substringWithRange:NSMakeRange(i, 1)];

              if (![scChar isEqualToString:@" "])
              {
                NSRange ccRange = [ccSource rangeOfString:ccChar];
                NSRange scRange = [scSource rangeOfString:scChar];
                
                if ( ccRange.location != NSNotFound )
                {
                  ignoreNext = YES;
                  ccRange.length = 3;
                  [theNewWord appendString: [[ccTarget substringWithRange:ccRange] stringByReplacingOccurrencesOfString:@" " withString:@"" ]];
                }
                else if ( scRange.location != NSNotFound )
                {
                  ignoreNext = NO;
                  scRange.length = 2;
                  [theNewWord appendString: [[scTarget substringWithRange:scRange] stringByReplacingOccurrencesOfString:@" " withString:@"" ]];
                }
                else
                {
                  ignoreNext = NO;
                  [theNewWord appendString:scChar];
                }
              }
              else
              {
                  ignoreNext = NO;
                  [theNewWord appendString:scChar];
              }
            }
          //  @catch (NSException *e)
          //  {
          //    NSLog (@"Exception.");
          //  }
          }
          else
          {
            ignoreNext = NO;
          }
        }
      */
/*        NSDictionary *ccMatrix = @{
                                    @"γγ": @"ng",
                                    @"γξ": @"nx",
                                    @"γκ": @"nk",
                                    @"γχ": @"nch"
                                  };
        NSDictionary *scMatrix = @{
                                 @"῾":@"h",
                                 @"ῥ":@"rh",
                                 @"α":@"a", @"Α":@"A",
                                 @"β":@"b", @"Β":@"B",
                                 @"γ":@"g", @"Γ":@"G",
                                 @"δ":@"d", @"Δ":@"D",
                                 @"ε":@"e", @"Ε":@"E",
                                 @"ζ":@"z", @"Ζ":@"Z",
                                 @"η":@"e", @"Η":@"E",
                                 @"θ":@"th",@"Θ":@"Th",
                                 @"ι":@"i", @"Ι":@"I",
                                 @"κ":@"k", @"Κ":@"K",
                                 @"λ":@"l", @"Λ":@"L",
                                 @"μ":@"m", @"Μ":@"M",
                                 @"ν":@"n", @"Ν":@"N",
                                 @"ξ":@"c", @"Ξ":@"C",
                                 @"ο":@"o", @"Ο":@"O",
                                 @"π":@"p", @"Π":@"P",
                                 @"ρ":@"r", @"Ρ":@"R",
                                 @"σ":@"s", @"Σ":@"S",
                                 @"ς":@"s",
                                 @"τ":@"t", @"Τ":@"T",
                                 @"υ":@"u", @"Υ":@"U",
                                 @"φ":@"ph",@"Φ":@"Ph",
                                 @"χ":@"ch",@"Χ":@"Ch",
                                 @"ψ":@"ps",@"Ψ":@"Ps",
                                 @"ω":@"o", @"Ω":@"O"
                                 };
        NSArray *theCCKeys = [ccMatrix allKeys];
        NSArray *theSCKeys = [scMatrix allKeys];
      
        for ( int i=0; i<[theCCKeys count]; i++)
        {
            [theNewWord replaceOccurrencesOfString:theCCKeys[i]
                        withString:ccMatrix[theCCKeys[i]]
                        options:0 range:NSMakeRange(0,[theNewWord length])];
        }
        for ( int i=0; i<[theSCKeys count]; i++)
        {
            [theNewWord replaceOccurrencesOfString:theSCKeys[i]
                        withString:scMatrix[theSCKeys[i]]
                        options:0 range:NSMakeRange(0,[theNewWord length])];
        }
*/
        
      //  return theNewWord;
    }
    
/**
 *
 * Formats the supplied text into an array of positions and types that will fit
 * within the given column's width and perform word-wrap where necessary. 
 *
 */
    +(NSArray *)formatText: (NSString *)theText forColumn: (int)theColumn withBounds: (CGRect)theRect withParsings: (BOOL)parsed
    {/*
    if ( [theText rangeOfString:@"Abraam"].location != NSNotFound)
    {
      NSLog (@"Here");
    }*/
        // should we include the morphology?
        BOOL showMorphology = [[PKSettings instance] showMorphology];
        BOOL showStrongs = [[PKSettings instance] showStrongs];
        BOOL showInterlinear = [[PKSettings instance] showInterlinear];
        
        // should we transliterate?
        //BOOL transliterate = [[PKSettings instance] transliterateText];
      
        // what greek text are we?
        BOOL whichGreekText = [[PKSettings instance] greekText];
    
        // this array will contain the word elements
        NSMutableArray *theWordArray = [[NSMutableArray alloc]init];
        
        // this is our font
        UIFont *theFont = [UIFont fontWithName:[[PKSettings instance] textFontFace]
                                          size:[[PKSettings instance] textFontSize]];
        if (theFont == nil)
        {
            theFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Regular", [[PKSettings instance] textFontFace]]
                                                  size:[[PKSettings instance] textFontSize]];
        }
        if (theFont == nil)
        {
            theFont = [UIFont fontWithName:@"Helvetica"
                                                  size:[[PKSettings instance] textFontSize]];
        }

        UIFont *theBoldFont = [UIFont fontWithName:[[PKSettings instance] textGreekFontFace]
                                              size:[[PKSettings instance] textFontSize]];
        
        if (theBoldFont == nil)
        {
            theBoldFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Regular", [[PKSettings instance] textGreekFontFace]]
                                          size:[[PKSettings instance] textFontSize]];
        }
        if (theBoldFont == nil)     // just in case there's no alternate
        {
            theBoldFont = theFont;
        }
      
        // set Margin
        CGFloat theMargin = 5;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            // iPad gets wider margins
            theMargin = 44;
        }
        // set starting points
        CGFloat startX = theRect.origin.x + theMargin; // some margin
        CGFloat startY = 0; //theRect.origin.y;
        
        CGFloat curX = startX;
        CGFloat curY = startY;
        
        // maximum point
        CGFloat endX   = startX + theRect.size.width;
        
        CGFloat columnWidth = [self columnWidth:theColumn forBounds:theRect]; // (theRect.size.width) * columnMultiplier;
        
        // new maximum point
        endX = startX + columnWidth;
        if (theColumn == 2)
        {
            endX = endX - theMargin;
        }
        else
        {
            endX = endX - (theMargin/2);
        }
      
        NSMutableString *theFixedText = [theText mutableCopy];
        [theFixedText replaceOccurrencesOfString:@" ) " withString:@") " options:0 range:NSMakeRange(0,  [theFixedText length])];
        // split by spaces
        NSArray *matches = [theFixedText componentsSeparatedByString:@" "];
      
        // we need to know the width of a space
        CGFloat spaceWidth = [@" " sizeWithFont:theFont].width;
        // we need to know the height of an M (* the setting...)
        CGFloat lineHeight = [@"M" sizeWithFont:theFont].height;
        lineHeight = lineHeight * ((float)[[PKSettings instance] textLineSpacing] / 100.0);
        // determine the maximum size of the column (1 line, 2 lines, 3 lines?)
        CGFloat columnHeight = lineHeight;
        columnHeight += (lineHeight * [[PKSettings instance] textVerseSpacing]);
        if (parsed)
        {
            // are we going to show morphology?
            if ([[PKSettings instance] showMorphology])
            {
                columnHeight += lineHeight;
            }
            if (showStrongs)
            {
                columnHeight += lineHeight; // for G#s
            }
            if (whichGreekText == 7 && showInterlinear)
            {
                columnHeight += lineHeight;
            }
        }
      
        CGFloat yOffset = 0.0;
        
        // give us some margin at the top
        startY = lineHeight / 2; //RE: ISSUE # 5
        curY = startY; //RE: ISSUE # 5
        
        // iterate through each word and wrap where necessary, building an
        // array of x, y points and words.
        
        int thePriorWordType = -1;
        int theWordType = -1;
        NSString *theWord;
        NSString *thePriorWord;
        NSArray *thePriorWordArray = @[];
        
        CGFloat maxX = 0.0;
        
        for (int i=0; i<[matches count]; i++)
        {
            
            // move priors
            thePriorWordType = theWordType;
            thePriorWord = theWord;
            
            // got the current word
            NSString *theOriginalWord = [matches objectAtIndex:i];
            theWord = [matches objectAtIndex:i];
          
            // obtain the prior word array
            if (thePriorWordType == 0)
            {
              thePriorWordArray = [theWordArray lastObject];
            }
          
         /* if ([theWord isEqualToString:@"Abraam"])
          {
            NSLog (@"Here");
          }*/
          
            // transliterate?
            //if (transliterate)
            //{
            //    theWord = [self transliterate:theWord];
            //}
            
            // and its size
            CGSize theSize;
            
            
            // determine the type of the word
            theWordType = 0;    // by default, we're a regular word
            yOffset = 0.0;
          
/*          if ([theWord isEqualToString:@"N"])
          {
            NSLog (@"Here");
          }
*/            
            if (theColumn == 1 ) // we only do this for greek text
            {
                // originally we used regular expressions, but they are SLOW
                // G#s are of the form G[0-9]+
              
                if ( [theOriginalWord length]>1 &&
                     [[theOriginalWord substringToIndex:1] isEqualToString:@"G"] &&
                     [[theOriginalWord substringFromIndex:1] intValue] > 0 )
                {
                    // we're a G#
                    theWordType = 10;
                    yOffset = lineHeight;
                    if (!showStrongs) { theWord = @""; }
                    // add the G# to the previous word if it was a greek word --
                    // this lets us get to the Strong's # from the greek word too.
                    if (thePriorWordArray != nil && thePriorWordArray.count>0 )
                    {
                      int theIndex = [theWordArray indexOfObject:thePriorWordArray];
                      if (theIndex>-1 && theIndex<theWordArray.count)
                      {
                        NSMutableArray *theNewPriorWordArray = [thePriorWordArray mutableCopy];
                        theNewPriorWordArray[6] = @([[theOriginalWord substringFromIndex:1] intValue]);
                        [theWordArray replaceObjectAtIndex:theIndex withObject:[theNewPriorWordArray copy]];
                      }
                    }
                }
                else
                {
                    // are we a (interlinear word)?
                    if ( [theOriginalWord length]>1 && (
                         [[theOriginalWord substringToIndex:1] isEqualToString:@"("] ||
                         [[theOriginalWord substringFromIndex:[theOriginalWord length]-1] isEqualToString:@")"]) )
                    {
                        theWordType = 5;
                        yOffset = lineHeight*3;
                        if (!showMorphology) { yOffset -= lineHeight; }
                        if (!showStrongs) { yOffset -= lineHeight; }
                        if ([[theWord substringToIndex:1] isEqualToString:@"("])
                        {
                          theWord = [theWord substringFromIndex:1];
                        }
                        if ([[theWord substringFromIndex:[theWord length]-1] isEqualToString:@")"])
                        {
                          theWord = [theWord substringToIndex:[theWord length]-1];
                        }
                      
                        if (!showInterlinear) { theWord = @""; }
                    }
                    else
                    {
                        // are we a VARiant? (regex: VAR[0-9]
                        if ( [theOriginalWord length]>1 &&
                             [[theOriginalWord substringToIndex:2] isEqualToString:@"VAR"] )
                        {
                            theWordType = 0; // we're really just a regular word.
                            yOffset = 0.0;
                        }
                        else
                        {
                            // are we a morphology word? [A-Z]+[A-Z0-9\\-]+
                            if ( [PKBible isMorphology:theWord] ) //[[theWord uppercaseString] isEqualToString:theWord]
                                 /*([theOriginalWord characterAtIndex:0] >= 'A' &&
                                   [theOriginalWord characterAtIndex:0] <= 'Z')
                                 &&
                                 thePriorWordType >= 10 && thePriorWordType <20) */
                            {
                                // we are!
                                theWordType = 20;
                                yOffset = lineHeight *2;
                                if (!showStrongs) { yOffset -= lineHeight; }
                                if (!showMorphology) { theWord = @""; }
                            }
                        }
                    }
                }
            }
            
            
            if (theColumn == 1 && theWordType == 0)
            {
                theSize = [theWord sizeWithFont:theBoldFont];
            }
            else
            {
                theSize  = [theWord sizeWithFont:theFont];
            }

            // determine this word's position, and if we should word-wrap or not.
            if (theWordType <= thePriorWordType || (theColumn == 2 && i>0))
            {
                // we're a new variation on the column. curX can move foward by maxX
                curX += maxX + spaceWidth;
                if (curX + theSize.width> endX-maxX-spaceWidth)
                {
                    curX = startX;
                    curY += columnHeight;
                }
                maxX = 0.0; // reset maximum width
            }
            
            if (theSize.width > maxX)
            {
                maxX = theSize.width;
            }
            
            // start creating our word element
            NSArray *theWordElement = [NSArray arrayWithObjects: theWord,
                                                                 [NSNumber numberWithInt:theWordType],
                                                                 [NSNumber numberWithFloat:curX],
                                                                 [NSNumber numberWithFloat:(curY + yOffset)], 
                                                                 [NSNumber numberWithFloat:theSize.width],
                                                                 [NSNumber numberWithFloat:theSize.height],
                                                                 @-1, // G# placeholder
                                                                 nil];
            if ( (showMorphology || (theWordType < 20  && !showMorphology)) &&
                 (showStrongs    || (theWordType != 10 && !showStrongs))    &&
                 (showInterlinear|| (theWordType != 5  && !showInterlinear))    )
            {
                [theWordArray addObject:theWordElement]; 
            }
            
            
        }
        
        return theWordArray;
    }
    
    +(NSArray *) passagesMatching:(NSString *)theTerm
    {
        int currentGreekBible = [[PKSettings instance] greekText];
        int currentEnglishBible=[[PKSettings instance] englishText];
        
        return [self passagesMatching:theTerm withGreekBible:currentGreekBible andEnglishBible:currentEnglishBible];
    }
    
    +(int) parsedVariant: (int)theBook
    {
        int theParsedBook = -1; // return this if nothing matches
        FMDatabase *db = [[PKDatabase instance] bible];
        FMResultSet *s = [db executeQuery:@"SELECT IFNULL(bibleParsedID,-1) FROM bibles WHERE bibleID=?",[NSNumber numberWithInt:theBook]];
        if ([s next])
        {
            theParsedBook = [s intForColumnIndex:0];
        }
        return theParsedBook;
    }
    
    +(BOOL) checkParsingsForBook: (int)theBook
    {
        return (theBook == [self parsedVariant:theBook]);
    }
    
    +(NSArray *) passagesMatching:(NSString *)theTerm requireParsings: (BOOL)parsings
    {
        int currentGreekBible = [[PKSettings instance] greekText];
        int currentEnglishBible=[[PKSettings instance] englishText];
        
        if (parsings)
        {
            int parsedGreekBible = [self parsedVariant:currentGreekBible];
            if (parsedGreekBible>-1)
            {
                currentGreekBible = parsedGreekBible;
            }
        }
        return [self passagesMatching:theTerm withGreekBible:currentGreekBible andEnglishBible:currentEnglishBible];
    }
    

    +(NSArray *) passagesMatching: (NSString *)theTerm withGreekBible: (int)theGreekBible andEnglishBible: (int)theEnglishBible
    {
        NSMutableArray *theMatches = [[NSMutableArray alloc] init];
        FMDatabase *db = [[PKDatabase instance] bible];
        
        // in order to support Issue #32 (multiple words), we need to craft a SQL statement
        // based on the inputs. There's really very little risk of SQL injection here --
        // but it should be properly handled.
        
        // search support is as follows:
        //   * "Jesus Mercy" results in an /Exact Phrase/ search. 
        //   * Jesus Mercy results in an OR search: "Jesus" OR "Mercy"
        //   * Jesus +Mercy results in an AND search: "Jesus" AND "Mercy"
        //     * note: a prepended + should be removed
        //   * Jesus -Mercy results in an NAND search: "Jesus" AND NOT "Mercy"
        //   * Jesus%Mercy results in a wildcard search: Jesus, followed by Mercy in the verse.
        //
        // Words separated by SPACES will thus be transformed into LIKE "%word%". Any suspicious
        // characters (", /, ;) will be removed prior. All words will be transformed to lowercase
        // for proper searching.
        
        NSMutableString *searchPhrase = [[[theTerm lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
        BOOL exactMatch = NO;
        
        if ([searchPhrase characterAtIndex:0] == '"' &&
            [searchPhrase characterAtIndex:[searchPhrase length]-1] == '"')
        {
            exactMatch = YES;
        }
        
        [searchPhrase replaceOccurrencesOfString:@"\"" withString:@"" options:0 range:NSMakeRange(0, [searchPhrase length])];
        [searchPhrase replaceOccurrencesOfString:@";" withString:@"" options:0 range:NSMakeRange(0, [searchPhrase length])];
        [searchPhrase replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, [searchPhrase length])];
        [searchPhrase replaceOccurrencesOfString:@"\\" withString:@"" options:0 range:NSMakeRange(0, [searchPhrase length])];        
        [searchPhrase replaceOccurrencesOfString:@"%" withString:@"%%" options:0 range:NSMakeRange(0, [searchPhrase length])];
        
        if (!exactMatch)
        {
            NSArray *allTerms = [searchPhrase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            searchPhrase = [@"" mutableCopy];
            for (int i=0; i<[allTerms count]; i++)
            {
                NSMutableString *theWord = [[allTerms objectAtIndex:i] mutableCopy];
                
                switch ( [theWord characterAtIndex:0] )
                {
case '.':
case '+':           [searchPhrase appendString: (i!=0 ? @"AND ( " : @"( ") ];
                    [theWord deleteCharactersInRange:NSMakeRange(0, 1)];
                    break;
case '!':
case '-':           [searchPhrase appendString: (i!=0 ? @"AND ( NOT " : @"( NOT ") ];
                    [theWord deleteCharactersInRange:NSMakeRange(0, 1)];
                    break;
default:            [searchPhrase appendString: (i!=0 ? @"OR ( " : @"( ") ];
                    break;
                }
                
                //[searchPhrase appendString:@"TRIM(stripDiacritics(lowercase(bibleText))) LIKE \"%"];
                //[searchPhrase appendString:theWord];
                [searchPhrase appendString:@"doesContain(TRIM(bibleText),\""];
                [searchPhrase appendString:[[theWord lowercaseString] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]]];
                //[searchPhrase appendString:@"%\" ) "];
                [searchPhrase appendString:@"\"))"];
            }
        }
        else
        {
            NSString *theWord = searchPhrase;
            searchPhrase = [@"" mutableCopy];
//            [searchPhrase appendString:@"( TRIM(lowercase(bibleText)) LIKE \"%"];
            [searchPhrase appendString:@"doesContain(TRIM(bibleText),\""];
            [searchPhrase appendString:[[theWord lowercaseString] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]]];
            //[searchPhrase appendString:@"%\" ) "];
            [searchPhrase appendString:@"\")"];
        }
        //NSLog (@"Original: %@\nTransformed: %@", theTerm, searchPhrase);
        
        FMResultSet *s = [db executeQuery:[NSString stringWithFormat: @"SELECT DISTINCT bibleBook, bibleChapter, bibleVerse FROM content WHERE bibleID in (?,?) AND (%@) ORDER BY 1,2,3", searchPhrase],
                                           [NSNumber numberWithInt:theGreekBible],
                                           [NSNumber numberWithInt:theEnglishBible]];
        while ([s next])
        {
            int theBook = [s intForColumnIndex:0];
            int theChapter=[s intForColumnIndex:1];
            int theVerse=[s intForColumnIndex:2];
            NSString *thePassage = [PKBible stringFromBook:theBook forChapter:theChapter forVerse:theVerse];
            [theMatches addObject:thePassage];
        }
        
        return [theMatches copy];
    }



@end
