//
//  screen.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "ActionNews.h"
#include <libxml/parser.h>
#include <libxml/tree.h>


@implementation ActionNews{
    int currentDelay ;
    NSXMLParser *xmlparser;
    NSString* TodayCondition;
    NSString* Time;
    NSString* Temperature;
    /*NSString* TomorrowForeCast;
    NSString* TomorrowMinTemp;
    NSString* TomorrowMaxTemp;*/
    NSMutableArray* Posts;
    NSMutableString* title;
    int loadingCycle;
    BOOL loaded,isTitle, isItem;
    int currentPost;
    int maxPost;

}

-(id) init{
    self = [super init];



    /* free up the parser context */


    return self;
}

-(id) initWithScreen:(Screen*)screen{

    self = [super init];
    maxPost = 10;
    isTitle = NO;
    loaded = NO;
    isItem = NO;
    loadingCycle =0;
    Posts = [[NSMutableArray alloc]init];
    [screen addString:@"Connecting Weather Distant Server."];
    self->screen = screen;
    dispatch_async( dispatch_get_global_queue(0, 0), ^{

        [self parseDocumentWithURL:[NSURL URLWithString:@"http://rss.feedsportal.com/c/864/f/11087/index.rss" ]];
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
                currentPost++;
                if (currentPost < [Posts count] && currentPost< maxPost) {
                    [screen newLine];
                    [screen newLine];
                    actionLetter = [[ActionLetters alloc]initWithString:[NSString stringWithFormat:@"%@", Posts[currentPost] ]timeBetweenLetterMin:0 timeBetweenLetterMax:2 andCursorState:0];
                }
                else{
                    done = YES;
                }

            }

        }
        else{
            [screen addChar:'.'];
            loadingCycle++;
            if(loadingCycle>3000){
                [screen newLine];
                actionLetter =[[ActionLetters alloc]initWithString:@"Impossible to connect to the server... Trying to dial up.................. abort." timeBetweenLetterMin:0 timeBetweenLetterMax:3 andCursorState:0];
                xmlparser = nil;
                loaded = YES;
            }
        }

    }
}


-(BOOL)parseDocumentWithURL:(NSURL *)url {
    if (url == nil)
        return NO;

    // this is the parsing machine
     xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];

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
    NSString* s = [NSString stringWithFormat: @"News : %@", Posts[currentPost] ];
    actionLetter = [[ActionLetters alloc]initWithString:s timeBetweenLetterMin:0 timeBetweenLetterMax:2 andCursorState:0];
    [screen newLine];
    [screen newLine];
    loaded = YES;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"didStartElement: %@", elementName);
    //[screen addString:elementName];
    //[screen newLine];
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
    else if ([elementName compare:@"item"]== 0) {
        title = [[NSMutableString alloc]init];
        isItem = YES;

    }
    else if ([elementName compare:@"title"]== 0) {
        if (title ){
            self->isTitle = YES;
        }


    }
    else{
    }


    // add code here to load any data members
    // that your custom class might have

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    if(isTitle){
        [title appendString:string];

    }

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"didEndElement: %@", elementName);
     if ([elementName compare:@"item"]== 0) {

         isItem = NO;
    }
    else if ([elementName compare:@"title"]== 0 && isItem) {
        [Posts addObject:[NSString stringWithString:title ]];
       // [screen addString:s];
        title = [[NSMutableString alloc]init];
        isTitle = NO;
    }

}

// error handling
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}

@end
