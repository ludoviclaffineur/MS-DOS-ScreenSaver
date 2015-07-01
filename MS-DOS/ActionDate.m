//
//  screen.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "ActionDate.h"


@implementation ActionDate{
    int currentDelay ;
    NSLocale* currentLocale;
}

-(id) init{
    self = [super init];
    [NSLocale currentLocale];
    return self;
}

-(id) initWithDelay: (int) delay {
    self = [self init];
    self->delay = delay;
    return self;
}

- (void) process:(Screen *)screen{
    if (!done){
        NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        NSString *dateString = [dateFormat stringFromDate:today];
        //NSLog(@"Date: %@", dateString);
        [screen addString:dateString];
        done = YES;
    }
}

@end