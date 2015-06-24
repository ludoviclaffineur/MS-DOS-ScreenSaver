//
//  Action.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 24/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//
#import "Action.h"

@implementation Action

- (id) init{
    self = [super init];
    return self;
}

- (BOOL) isDone{
    return done;
}

@end