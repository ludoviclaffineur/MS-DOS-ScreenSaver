//
//  screen.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "ActionTime.h"


@implementation ActionTime{
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
        [screen addString:[[NSDate date] descriptionWithLocale:currentLocale]];
        [screen addString:@"GMT"];
        done = YES;
    }



    //[currentLocale ]
}




@end