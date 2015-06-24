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
#import "ActionLetters.h"



@interface ActionTime :Action{
    int delay;
    NSString* command;
    ActionLetters* actionLetter;
}


- (id) initWithDelay:(int) delay;

@end
