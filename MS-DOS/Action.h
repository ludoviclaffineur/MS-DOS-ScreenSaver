//
//  Action.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 24/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//
#import <ScreenSaver/ScreenSaver.h>

#import "Screen.h"

@protocol ScreenHandler

- (BOOL) isDone;
- (void) process:(Screen*) screen;

@end

@interface Action : NSObject <ScreenHandler>{
    BOOL done;
}

@end

