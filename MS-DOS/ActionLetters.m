//
//  screen.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "ActionLetters.h"

@implementation ActionLetters


-(id) init{
    self = [super init];
    stringToAdd = @"TEST";
    letterIsPrinted = NO;
    currentPositionInString = 0;
    waitingCycle = 0;
    return self;

}

-(void) setCurrentTbl{
    currentTbl = rand()%(tbl_max+1 - tbl_min) + (tbl_min);
    

}

-(id) initWithString:(NSString*) string timeBetweenLetterMin:(int)tbl_min timeBetweenLetterMax:(int) tbl_max andCursorState:(int)cursorState {
    self = [self init];
    self->cursorState = cursorState;
    done = NO;
    self->tbl_max = tbl_max;
    self->tbl_min = tbl_min;
    [self setCurrentTbl];
    stringToAdd = string;
    return self;
}

- (void) process:(Screen *)screen{
    //[screen addChar:'C'];
    do{
        [self printOnScreenNext:screen];
            // [screen addString: [NSString stringWithFormat:@"%d",waitingCycle ]];

    }
    while (!letterIsPrinted && !done);


}

- (void) printOnScreenNext:(Screen *)screen{
    if (!letterIsPrinted) {
        //[screen addChar:'C'];
        [screen addChar:[stringToAdd characterAtIndex:currentPositionInString]];
        currentPositionInString++;
        //[screen addChar:[stringToAdd characterAtIndex:currentPositionInString]];
        //currentPositionInString++;
        letterIsPrinted = YES;

    }
    else{
        waitingCycle++;
    }
    if (waitingCycle>=currentTbl) {
        letterIsPrinted = NO;
        waitingCycle=0;
        [self setCurrentTbl];
    }
    if (currentPositionInString == stringToAdd.length) {
        done=YES;
    }
}



@end