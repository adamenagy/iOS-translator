//
//  ViewController.h
//  Translator
//
//  Created by Adam Nagy on 09/11/2012.
//  Copyright (c) 2012 Adam Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)translate:(id)sender;

@property (strong, nonatomic) NSArray * jsonLanguages;

@property (weak, nonatomic) IBOutlet UILabel * translation;
@property (weak, nonatomic) IBOutlet UITextField * original;
@property (weak, nonatomic) IBOutlet UIPickerView * languages;

- (IBAction)didEndOnExit:(UITextView *)sender;

@end
