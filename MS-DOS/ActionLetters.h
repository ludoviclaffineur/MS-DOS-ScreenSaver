//
//  NSObject_Screen.h
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
//#import "Screen.h"
#import "Action.h"

typedef enum {
    kHidden,
    kBlinking,
    kFixed
} CURSOR_STATE;

@interface ActionLetters :Action{
    NSString* stringToAdd;
    BOOL letterIsPrinted;
    int currentPositionInString;
    int waitingCycle;
    int tbl_max;//time between letter
    int tbl_min;
    int cursorState; // 0 -> hidden; 1 -> blinking; 2 -> fixed
    int currentTbl;
}


- (id) initWithString:(NSString*) string timeBetweenLetterMin:(int)tbl_min timeBetweenLetterMax:(int) tbl_max andCursorState:(int)cursorState;
- (void) printOnScreenNext:(Screen *)screen;
@end
