//
//  HTMLNode.h
//  StackOverflow
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>
#import <libxml/HTMLparser.h>
#import "HTMLParser.h"

@class HTMLParser;

#define ParsingDepthUnlimited 0
#define ParsingDepthSame -1
#define ParsingDepth size_t

@interface HTMLNode : NSObject

//Init with a lib xml node (shouldn't need to be called manually)
//Use [parser doc] to get the root Node
-(id)initWithXMLNode:(xmlNode*)xmlNode;

//Finds all children with a matching attribute
-(NSArray*)findChildrenWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial;

//Gets the attribute value matching tha name
-(NSString*)getAttributeNamed:(NSString*)name;

//Find childer with the specified tag name
-(NSArray*)findChildrenWithTag:(NSString*)tagName;

//Looks for a tag name e.g. "h3"
-(HTMLNode*)findChildWithTag:(NSString*)tagName;

//Returns the tag name
-(NSString*)tagName;

//Returns the parent
-(HTMLNode*)parent;

@end
