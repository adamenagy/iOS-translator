//
//  ViewController.m
//  Translator
//
//  Created by Adam Nagy on 09/11/2012.
//  Copyright (c) 2012 Adam Nagy. All rights reserved.
//

#import "ViewController.h"
#import "credentials.h"

#import "XmlParser.h"

@interface ViewController ()

@end

@implementation ViewController


@synthesize jsonLanguages;

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  // Do any additional setup after loading the view, typically from a nib.
  
  [self updateLanguages];
}

- (void)updateLanguages
{
  // Get the supported languages
  
  NSError * err = nil;

  // URL can be checked in browser
  NSString * urlString = [NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2/languages?key=%@&target=en",
    GOOGLE_API_KEY];

  NSURL * url = [NSURL URLWithString:urlString];
  NSMutableURLRequest * req =
    [NSMutableURLRequest requestWithURL:url];
  
  // Using synchronous request just to keep things simple
  NSData * data = [NSURLConnection sendSynchronousRequest:req
    returningResponse:nil error:&err];
  
  // only for debugging
  NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
  NSDictionary * json = [NSJSONSerialization
                              JSONObjectWithData:data 
                              options:NSJSONReadingMutableContainers 
                              error:&err];
  
  jsonLanguages =
    [[json objectForKey:@"data"] objectForKey:@"languages"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)translateGoogle
{
  NSError * err = nil;
  
  NSInteger selection = [self.languages selectedRowInComponent:0];
  NSDictionary * language = [jsonLanguages objectAtIndex:selection];
  NSString * languageCode = [language objectForKey:@"language"];

  NSString * urlString = [NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&target=%@&q=%@",
    GOOGLE_API_KEY,
    languageCode,
    [self.original.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
  ];

  NSURL * url = [NSURL URLWithString:urlString];
  NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];
  
  NSData * data = [NSURLConnection sendSynchronousRequest:req
    returningResponse:nil error:&err];
  
  NSDictionary * json = [NSJSONSerialization
                              JSONObjectWithData:data 
                              options:NSJSONReadingMutableContainers 
                              error:&err];
}
*/

- (IBAction)translate:(id)sender
{
  NSError * err = nil;
  
  NSInteger selection = [self.languages selectedRowInComponent:0];
  NSDictionary * language = [jsonLanguages objectAtIndex:selection];
  NSString * languageCode = [language objectForKey:@"language"];

  NSString * urlString = [NSString stringWithFormat:@"http://www.syslang.com/frengly/controller?action=translateREST&src=en&dest=%@&text=%@&username=%@&password=%@",
    languageCode,
    [self.original.text
      stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
    SYSLANG_USER_NAME,
    SYSLANG_PASSWORD
  ];

  NSURL * url = [NSURL URLWithString:urlString];
  NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];
  
  NSData * data = [NSURLConnection sendSynchronousRequest:req
    returningResponse:nil error:&err];
  
  // only for debugging
  NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
  // Create and init NSXMLParser object
  NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];

  // Create and init our delegate
  XmlParser * parser = [XmlParser alloc];

  // Set delegate
  [nsXmlParser setDelegate:parser];

  // Parsing...
  BOOL success = [nsXmlParser parse];

  // Test the result
  if (success)
    self.translation.text = parser.translation;
}

// @protocol UIPickerViewDataSource<NSObject> ////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
  return jsonLanguages.count;
}

// @protocol UIPickerViewDelegate<NSObject>
// @optional

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSDictionary * language = [jsonLanguages objectAtIndex:row];
  
  return [language objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView
didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

//@end

- (IBAction)didEndOnExit:(UITextView *)sender
{
  [sender resignFirstResponder];
}
@end
