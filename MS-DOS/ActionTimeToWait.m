//
//  screen.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "ActionTimeToWait.h"

@implementation ActionTimeToWait{
    int currentDelay ;
}


-(id) init{
    self = [super init];
    currentDelay=0;
    return self;

}


-(id) initWithDelay: (int) delay {
    self = [self init];
    self->delay = delay;
    return self;
}

- (void) process:(Screen *)screen{
    currentDelay++;
    if (currentDelay >= delay) {
        done = YES;
    }
}




@end