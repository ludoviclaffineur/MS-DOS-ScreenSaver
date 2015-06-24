//
//  MS_DOSView.h
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#import "Screen.h"

@interface MS_DOSView : ScreenSaverView{
    Screen* screen;
}
- (void) getNextCommand;
@end
