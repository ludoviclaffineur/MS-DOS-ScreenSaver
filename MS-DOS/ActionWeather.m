//
//  screen.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "ActionWeather.h"
#include <libxml/parser.h>
#include <libxml/tree.h>


@implementation ActionWeather{
    int currentDelay ;
    NSString* TodayCondition;
    NSString* Time;
    NSString* Temperature;
    /*NSString* TomorrowForeCast;
    NSString* TomorrowMinTemp;
    NSString* TomorrowMaxTemp;*/


    BOOL loaded;

}

-(id) init{
    self = [super init];
    loaded = NO;


    /* free up the parser context */


    return self;
}

-(id) initWithScreen:(Screen*)screen{
    self = [super init];
    loaded = NO;
    [screen addString:@"Connecting Weather Distant Server."];
    self->screen = screen;
    dispatch_async( dispatch_get_global_queue(0, 0), ^{

        [self parseDocumentWithURL:[NSURL URLWithString:@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(968019)&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" ]];
        // call the result handler block on the main queue (i.e. main thread)

    });

    return self;
}

-(id) initWithIdCity: (NSString*) woeid {
    self = [self init];
    self->woeid = woeid;
    const char* URL = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(968019)&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

    return self;
}

- (void) process:(Screen *)screen{

    if (!done){
        if(loaded) {

            //done = YES;
            [actionLetter process:screen];
            if ([actionLetter isDone]) {
                done = YES;
            }

        }
        else{
            [screen addChar:'.'];
        }

    }
}


-(BOOL)parseDocumentWithURL:(NSURL *)url {
    if (url == nil)
        return NO;

    // this is the parsing machine
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];

    // this class will handle the events
    [xmlparser setDelegate:self];
    [xmlparser setShouldResolveExternalEntities:NO];

    // now parse the document
    BOOL ok = [xmlparser parse];
    if (ok == NO){
        [screen newLine];
        actionLetter =[[ActionLetters alloc]initWithString:@"Impossible to connect to the server... Trying to dial up.................. abort." timeBetweenLetterMin:0 timeBetweenLetterMax:3 andCursorState:0];

        loaded = YES;

    }
    else
        NSLog(@"OK");

    //[xmlparser release];
    return ok;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"didStartDocument");
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"didEndDocument");
    NSString* s = [NSString stringWithFormat: @"%@, the weather is %@ , and the current temperature is : %@",Time,TodayCondition,Temperature ];
    actionLetter = [[ActionLetters alloc]initWithString:s timeBetweenLetterMin:0 timeBetweenLetterMax:2 andCursorState:0];
    [screen newLine];
    [screen newLine];
    loaded = YES;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"didStartElement: %@", elementName);
    //[screen addString:elementName];
    if (namespaceURI != nil)
        NSLog(@"namespace: %@", namespaceURI);

    if (qName != nil)
        NSLog(@"qualifiedName: %@", qName);

    // print all attributes for this element
    NSEnumerator *attribs = [attributeDict keyEnumerator];
    NSString *key, *value;
    if ([elementName compare:@"yweather:forecast"]== 0) {
       /* while((key = [attribs nextObject]) != nil) {
            value = [attributeDict objectForKey:key];
            NSLog(@"  attribute: %@ = %@", key, value);
            [screen addString: [NSString stringWithFormat: @"  attribute: %@ = %@", key, value] ];
            [screen newLine];
        }*/
    }
    else if ([elementName compare:@"yweather:condition"]== 0) {
        while((key = [attribs nextObject]) != nil) {
            value = [attributeDict objectForKey:key];
            if ([key compare:@"text"]==0) {
                TodayCondition =value;
            }
            else if ([key compare:@"temp"]==0) {
                NSInteger TempInt =   [value intValue];
                int a = (TempInt- 32) * 5.0/9.0;

                Temperature =[NSString stringWithFormat:@"%d °C", a ];
            }
            else if ([key compare:@"date"]==0) {
                Time =value;
            }

        }
    }


    // add code here to load any data members
    // that your custom class might have

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"didEndElement: %@", elementName);
}

// error handling
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}

@end
