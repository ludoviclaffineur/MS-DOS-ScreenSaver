//
//  MS_DOSView.m
//  MS-DOS
//
//  Created by Ludovic Laffineur on 23/06/15.
//  Copyright (c) 2015 Ludovic Laffineur. All rights reserved.
//

#import "MS_DOSView.h"
#import "Action.h"
#import "ActionLetters.h"
#import "ActionTimeToWait.h"
#import "ActionTime.h"

@implementation MS_DOSView{
    xmlDocPtr doc;
    xmlNode *root_element;
    xmlNode *current_element;
    Action* currentAction;
    int currentCursorState, timeBlinking;
    BOOL blinking;
    NSString *thepath;
}

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {

        [self loadConfigWithXml:"/Library/Screen Savers/MS-DOS.saver/Contents/Resources/ms_dos-config.xml"];
        [self setAnimationTimeInterval:1/30.0];
        currentAction = NULL;
        screen = [[Screen alloc ]initWithFrame:frame];

        blinking = NO;
        timeBlinking = 0;
    }
    return self;
}

- (void)viewDidMoveToWindow
{
    // this NSView method is called when our screen saver view is added to its window
    // we'll use this signal to tell drawRect: to erase the background
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{

}

- (void) loadConfigWithXml :(const char*) filename{
    xmlParserCtxtPtr ctxt; /* the parser context */
  //  xmlDocPtr doc; /* the resulting document tree */

    /* create a parser context */
    ctxt = xmlNewParserCtxt();
    if (ctxt == NULL) {
        fprintf(stderr, "Failed to allocate parser context\n");
        return;
    }
    /* parse the file, activating the DTD validation option */
    doc = xmlCtxtReadFile(ctxt, filename, NULL, XML_PARSE_DTDVALID);
    /* check if parsing suceeded */
    if (doc == NULL) {
        fprintf(stderr, "Failed to parse %s\n", filename);
    } else {
        /* check if validation suceeded */
        if (ctxt->valid == 0)
            fprintf(stderr, "Failed to validate %s\n", filename);
                //xmlFreeDoc(doc);
        root_element = NULL;
        root_element = xmlDocGetRootElement(doc);
        current_element = root_element->children;
    }
    /* free up the parser context */
    xmlFreeParserCtxt(ctxt);
}

- (void)animateOneFrame
{
   [[NSColor blackColor]set];
    NSRectFill([self bounds]);

    NSAttributedString* styleText = nil;
    if(currentAction==NULL || [currentAction isDone]){
        [self getNextCommand];
    }
    [currentAction process:screen];

    [self printCursor];
    return;
}

- (void) printCursor{
    switch (currentCursorState) {
        case kBlinking:
            timeBlinking++;
            if (timeBlinking > 20 ) {
                blinking = !blinking;
                timeBlinking=0;

            }

            break;
        case kFixed:
            blinking = YES;
            break;

        default:
            blinking = NO;
            break;
    }
    if (blinking) {
        [screen addChar:'_'];
    }

    [screen draw];
    if (blinking && currentCursorState!= kHidden) {
        [screen deleteChar];
    }
}

- (void) getNextCommand{
    if (current_element->next) {
        current_element = current_element->next;
    }
    if(current_element->type != XML_ELEMENT_NODE && current_element->next){
        current_element = current_element->next;
    }
    if (strcmp(current_element->name, "letters")==0)
    {
        NSString* string = [NSString stringWithFormat:@"%s" , xmlNodeGetContent(current_element) ];
        xmlAttr* attribute = current_element->properties;
        int tbl_min, tbl_max;
        while(attribute && attribute->name && attribute->children)
        {
            xmlChar* value = xmlNodeListGetString(current_element->doc, attribute->children, 1);
            if (strcmp(attribute->name, "tblMin")==0) {
                tbl_min = atoi(value);
            }
            else if (strcmp(attribute->name, "tblMax")==0) {
                tbl_max = atoi(value);
            }

            xmlFree(value);
            attribute = attribute->next;
        }
        //[screen addString:[ NSString stringWithFormat:@"%s",attribute->name ]];
        currentAction = [[ActionLetters alloc] initWithString:string timeBetweenLetterMin:tbl_min timeBetweenLetterMax:tbl_max andCursorState:0];
        //
    }
    else if (strcmp(current_element->name, "clearscreen")==0)
    {
        [screen clearScreen];
        [self getNextCommand];
    }
    else if (strcmp(current_element->name, "crlf")==0)
    {
        [screen newLine];
        //[self getNextCommand];
    }
    else if (strcmp(current_element->name, "cursor")==0) {
        xmlAttr* attribute = current_element->properties;
        xmlChar* value = xmlNodeListGetString(current_element->doc, attribute->children, 1);
        currentCursorState = 0;
        if (strcmp(value, "hidden")==0) {
            currentCursorState = kHidden;
        }
        else if (strcmp(value, "fixed")==0) {
            currentCursorState = kFixed;
        }
        else if (strcmp(value, "blinking")==0) {
            currentCursorState = kBlinking;
        }
    }
    else if (strcmp(current_element->name, "timetowait")==0)
    {
        xmlAttr* attribute = current_element->properties;
        int delay=0;
        xmlChar* value = xmlNodeListGetString(current_element->doc, attribute->children, 1);
        //do something with value
       // [screen addString:[NSString stringWithFormat:@"%s",value ]];
        if (strcmp(attribute->name, "delay")==0) {
            delay = atoi(value);
        }

        currentAction = [[ActionTimeToWait alloc]initWithDelay:delay];
        
        //[self getNextCommand];
    }
    else if (strcmp(current_element->name, "loop")==0)
    {
        [screen clearScreen];
        
        current_element = root_element->children;

        //[self getNextCommand];
    }
    else if (strcmp(current_element->name, "time")==0)
    {
        currentAction = [[ActionTime alloc]init];
        //[self getNextCommand];
    }
    else if (strcmp(current_element->name, "delete")==0)
    {
        [screen deleteChar];
        //[self getNextCommand];
    }



}

- (BOOL)hasConfigureSheet
{
    return NO;
}
- (BOOL)isOpaque {
    // this keeps Cocoa from unneccessarily redrawing our superview
    return YES;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
