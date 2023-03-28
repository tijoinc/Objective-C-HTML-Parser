//
//  HTMLNode.m
//  StackOverflow
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import "HTMLNode.h"
#import <libxml/HTMLtree.h>

#if defined(__has_attribute) && __has_attribute(objc_direct_members)
__attribute__((objc_direct_members))
#endif
@implementation HTMLNode  {
    xmlNode * _node;
}

-(HTMLNode*)parent
{
    return [[HTMLNode alloc] initWithXMLNode:_node->parent];
}

-(NSString*)getAttributeNamed:(NSString*)name
{	
	const char * nameStr = [name UTF8String];
	
    for(xmlAttrPtr attr = _node->properties; NULL != attr; attr = attr->next)
    {
        if (strcmp((char*)attr->name, nameStr) == 0)
        {
            xmlNode * child = attr->children;
            if (child)
            {
                return [NSString stringWithCString:(void*)child->content encoding:NSUTF8StringEncoding];
            }
            else
            {
                // Needed for <html amp> to indicate the attribute is present even if empty.
                return @"";
            }
        }
    }
    
    return NULL;
}

//Returns the tag name
-(NSString*)tagName
{
	if (_node->name != NULL) {
		return [NSString stringWithCString:(void*)_node->name encoding:NSUTF8StringEncoding];
	}
	return @"br";
}

-(void)findChildrenWithAttribute:(const char*)attribute matchingName:(const char*)className inXMLNode:(xmlNode *)node inArray:(NSMutableArray*)array allowPartial:(BOOL)partial
{
	xmlNode *cur_node = NULL;
    
    for (cur_node = node; cur_node; cur_node = cur_node->next) 
	{				
		for(xmlAttrPtr attr = cur_node->properties; NULL != attr; attr = attr->next)
		{
			
			if (strcmp((char*)attr->name, attribute) == 0)
			{				
				for(xmlNode * child = attr->children; NULL != child; child = child->next)
				{
                    const BOOL match = partial ? strstr((char*)child->content, className) != NULL : strcmp((char*)child->content, className) == 0;
					if (match)
					{
						//Found node
						HTMLNode * nNode = [[HTMLNode alloc] initWithXMLNode:cur_node];
						[array addObject:nNode];
						break;
					}
				}
				break;
			}
		}
		
		[self findChildrenWithAttribute:attribute matchingName:className inXMLNode:cur_node->children inArray:array allowPartial:partial];
	}	
	
}

-(void)findChildTags:(NSString*)tagName inXMLNode:(xmlNode *)node inArray:(NSMutableArray*)array
{
	xmlNode *cur_node = NULL;
	const char * tagNameStr =  [tagName UTF8String];
	
	if (tagNameStr == nil)
		return;
	
    for (cur_node = node; cur_node; cur_node = cur_node->next) 
	{				
		if (cur_node->name && strcmp((char*)cur_node->name, tagNameStr) == 0)
		{
			HTMLNode * node = [[HTMLNode alloc] initWithXMLNode:cur_node];
			[array addObject:node];
			
		}
		
		[self findChildTags:tagName inXMLNode:cur_node->children inArray:array];
	}	
}

-(NSArray*)findChildrenWithTag:(NSString*)tagName
{
	NSMutableArray * array = [NSMutableArray array];
	
	[self findChildTags:tagName inXMLNode:_node->children inArray:array];
	
	return array;
}

-(HTMLNode*)findChildTag:(NSString*)tagName inXMLNode:(xmlNode *)node
{
	xmlNode *cur_node = NULL;
	const char * tagNameStr =  [tagName UTF8String];
	
    for (cur_node = node; cur_node; cur_node = cur_node->next) 
	{				
		if (cur_node && cur_node->name && strcmp((char*)cur_node->name, tagNameStr) == 0)
		{
			return [[HTMLNode alloc] initWithXMLNode:cur_node];
		}
		
		HTMLNode * cNode = [self findChildTag:tagName inXMLNode:cur_node->children];
		if (cNode != NULL)
		{
			return cNode;
		}
	}	
	
	return NULL;
}

-(HTMLNode*)findChildWithTag:(NSString*)tagName
{
	return [self findChildTag:tagName inXMLNode:_node->children];
}
-(NSArray*)findChildrenWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial
{
	NSMutableArray * array = [NSMutableArray array];

	[self findChildrenWithAttribute:[attribute UTF8String] matchingName:[className UTF8String] inXMLNode:_node->children inArray:array allowPartial:partial];
	
	return array;
}

-(id)initWithXMLNode:(xmlNode*)xmlNode
{
	if ((self = [super init]))
	{
		_node = xmlNode;
	}
	return self;
}

@end
