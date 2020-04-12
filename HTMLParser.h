//
//  HTMLParser.h
//  StackOverflow
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/HTMLparser.h>
#import "HTMLNode.h"

@class HTMLNode;

@interface HTMLParser : NSObject

-(id)initWithData:(NSData*)data error:(NSError**)error;

//Returns the doc tag
-(HTMLNode*)doc;

//Returns the body tag
-(HTMLNode*)body;

@end
