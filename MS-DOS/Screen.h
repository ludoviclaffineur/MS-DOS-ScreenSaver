//
//  NSObject_Screen.h
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface Screen : NSObject{
    //NSMutableArray* linesOnScreen;
    int nbrLineMax;
}


- (id) initWithFrame:(NSRect) frame;
- (void) addString:(NSString*) theLine;
- (void) addChar:(char) theLine;
- (void) deleteChar;
- (void) clearScreen;
- (void) newLine;
- (void) draw;

@property (nonatomic, retain) NSMutableArray* linesOnScreen;
@end
