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
#import <Foundation/Foundation.h>
#import "XMLReader.h"



@interface ActionNews :Action <NSXMLParserDelegate>{
    NSString* woeid;
    NSString* command;
    ActionLetters* actionLetter;
    Screen* screen;
}

-(BOOL)parseDocumentWithURL:(NSURL *)url;
- (id) initWithIdCity:(NSString*) woied;
- (id) initWithScreen:(Screen*) screen;

@end
