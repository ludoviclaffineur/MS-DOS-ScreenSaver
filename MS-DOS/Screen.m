//
//  screen.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "Screen.h"

@implementation Screen{
    int currentLine;;
    NSRect frame;
    int maxWidth;
}

@synthesize linesOnScreen;

- (id) init{
    self = [super init];
    currentLine = 0;
    linesOnScreen = [[NSMutableArray alloc] init];
    [linesOnScreen addObject:[[NSMutableString alloc] init]];
    nbrLineMax = 24;
    maxWidth=50;
    return self;
}
- (id) initWithFrame:(NSRect) frame{
    self = [self init];
    self->frame = frame;
    nbrLineMax = frame.size.height / 37.0;
    maxWidth = frame.size.width / 16.3;
    return self;
}

- (void) addChar:(char)theLine{
    NSMutableString* lastLine = [linesOnScreen lastObject];
    if ([lastLine length] > maxWidth) {
        [self newLine];
    }
    [lastLine appendString:[NSString stringWithFormat:@"%c",theLine]];
}

- (void) addString:(NSString *)theLine{
    NSMutableString* lastLine = [linesOnScreen lastObject];
    [lastLine appendString:theLine];

}

- (void) newLine{
    [linesOnScreen addObject:[[NSMutableString alloc] init]];
    currentLine++;
    if (currentLine >= nbrLineMax) {
        [linesOnScreen removeObjectAtIndex:0];
        currentLine = nbrLineMax;
    }
}

- (void) deleteChar{
    NSMutableString* lastLine = [linesOnScreen lastObject];
    [lastLine deleteCharactersInRange:NSMakeRange([lastLine length]-1, 1)];
}

- (void) clearScreen{
    [ linesOnScreen removeAllObjects ];
    [ linesOnScreen addObject:[[NSMutableString alloc] init]];
    currentLine = 0;
}

- (void) draw{
    NSAttributedString* styleText = nil;
    NSColor* myGreenColor = [NSColor colorWithCalibratedRed:0.066 green:0.99f blue:0.16 alpha:1.0];
    NSMutableDictionary* attribute = [NSMutableDictionary dictionary];
    
    [attribute setObject:[NSFont fontWithName:@"Glass_TTY_VT220" size:32.0] forKey:NSFontAttributeName];

    [attribute setObject:myGreenColor forKey:NSForegroundColorAttributeName];
    for (int i=0; i<[[self linesOnScreen]count]; i++) {
        NSMutableString* s = [[self linesOnScreen]objectAtIndex:i];
        styleText = [[NSAttributedString alloc] initWithString:s attributes:attribute];
        /* free up the resulting document */
        [styleText drawAtPoint:CGPointMake(0, frame.size.height-(37.0*(i+1)))];
    }
}

@end