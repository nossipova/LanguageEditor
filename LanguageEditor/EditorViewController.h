//
//  EditorViewController.h
//  LanguageEditor
//
//  Created by Natalia Ossipova on 08.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

@interface EditorViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *inputView;
@property (nonatomic, strong) IBOutlet UITextView *outputView;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)generate:(id)sender;

@end
