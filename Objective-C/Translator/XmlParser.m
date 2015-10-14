//
//  XmlParser.m
//  MyAWS
//
//  Created by Adam Nagy on 06/11/2012.
//  Copyright (c) 2012 Adam Nagy. All rights reserved.
//

#import "XmlParser.h"

@implementation XmlParser

@synthesize translation;

static bool translationTag = false;

- (void)parser:(NSXMLParser *)parser 
               didStartElement:(NSString *)elementName 
               namespaceURI:(NSString *)namespaceURI 
               qualifiedName:(NSString *)qualifiedName 
	       attributes:(NSDictionary *)attributeDict {
	
  if ([elementName isEqualToString:@"translation"])
    translationTag = true;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  
  if (translationTag)
  {
    if (!translation)
      translation = [NSString stringWithFormat:@""];
    
    translation =  [translation stringByAppendingString:string];
  }
}

- (void)parser:(NSXMLParser *)parser 
               didEndElement:(NSString *)elementName
               namespaceURI:(NSString *)namespaceURI 
               qualifiedName:(NSString *)qName {

  if ([elementName isEqualToString:@"translation"])
    translationTag = false;
}

@end
