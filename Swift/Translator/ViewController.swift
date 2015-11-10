//
//  ViewController.swift
//  Translator
//
//  Created by Adam Nagy on 21/10/2015.
//  Copyright © 2015 Adam Nagy. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,
UIPickerViewDelegate, UIPickerViewDataSource {
  
  var jsonLanguages: NSArray?
  @IBOutlet weak var languages: UIPickerView!
  
  @IBOutlet weak var original: UITextField!
  
  @IBOutlet weak var translation: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    do {
      try updateLanguages()
    } catch {
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateLanguages() throws {
    // Get the supported languages
    
    // URL can be checked in browser
    let urlString = "https://www.googleapis.com/language/translate/v2/languages?key=\(Credentials.GOOGLE_API_KEY)&target=en"
    let url = NSURL(string: urlString)!
    
    let session = NSURLSession.sharedSession()
    session.dataTaskWithURL(url, completionHandler: {
      (data, response, error) in
      if data == nil {
        return
      }
      
      // only for debugging
      let str: String = String(data: data!, encoding: NSUTF8StringEncoding)!
      NSLog(str)
      do {
        let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let dataDict = json["data"] as! NSDictionary
        let langsDict = dataDict["languages"] as! NSArray
        self.jsonLanguages = langsDict
        dispatch_async(dispatch_get_main_queue(), {
          self.languages.reloadAllComponents()
        })
      } catch {
      }
    }).resume()
  }
  
  /*
  - (void)translateGoogle
  {
  NSError * err = nil;
  
  NSInteger selection = [self.languages selectedRowInComponent:0];
  NSDictionary * language = [jsonLanguages objectAtIndex:selection];
  NSString * languageCode = [language objectForKey:@"language"];
  
  NSString * urlString = [NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&target=%@&q=%@",
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
  
  @IBAction func translate(sender: UIButton) {
    //var err: NSError = nil
    let selection: Int = languages.selectedRowInComponent(0)
    let language: NSDictionary = jsonLanguages![selection] as! NSDictionary
    let languageCode: String = (language["language"] as? String)!
    let text = original.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSMutableCharacterSet.alphanumericCharacterSet())
    let urlString = "http://frengly.com/frengly/controller?action=translateREST&src=en&dest=\(languageCode)&text=\(text!)&username=\(Credentials.SYSLANG_USER_NAME)&password=\(Credentials.SYSLANG_PASSWORD)"
    let url: NSURL = NSURL(string: urlString)!
    
    let session = NSURLSession.sharedSession()
    session.dataTaskWithURL(url, completionHandler: {
      (data, response, error) in
      
      // only for debugging
      let str = String(data: data!, encoding: NSUTF8StringEncoding)!
      NSLog(str)
      
      // Create and init NSXMLParser object
      let nsXmlParser: NSXMLParser = NSXMLParser(data: data!)
      // Create and init our delegate
      let parser = XmlParser()
      // Set delegate
      nsXmlParser.delegate = parser
      // Parsing...
      let success: Bool = nsXmlParser.parse()
      // Test the result
      if success {
        dispatch_async(dispatch_get_main_queue(), {
          self.translation.text = parser.translation
        })
      }
    }).resume()
  }
  
  // - protocol: UIPickerViewDataSource<NSObject> ////////////////////////
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // returns the # of rows in each component..
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if let langs = jsonLanguages {
      return langs.count
    }
    
    return 0
  }
  
  // - protocol: UIPickerViewDelegate<NSObject>
  // - optional:
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let language: NSDictionary = jsonLanguages![row] as! NSDictionary
    return language["name"] as? String
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  }
  
  //- end:
  @IBAction func didEndOnExit(sender: UITextView) {
    sender.resignFirstResponder()
  }
}

