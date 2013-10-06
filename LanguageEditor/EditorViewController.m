//
//  EditorViewController.m
//  LanguageEditor
//
//  Created by Natalia Ossipova on 08.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "EditorViewController.h"
#import "LibraryParser.h"
#import "LibraryAssembler.h"
#import "LibraryGenerator.h"

@implementation EditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.inputView.text = @"";
    self.outputView.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backgroundTap:(id)sender {
    [self.inputView resignFirstResponder];
}

- (IBAction)generate:(id)sender
{
    [self.inputView resignFirstResponder];

    NSString *input = self.inputView.text;

    LibraryParser *parser = [LibraryParser new];
    LibraryAssembler *assembler = [LibraryAssembler new];
    NSError *error = nil;
    PKAssembly *result = [parser parseString:input assembler:assembler error:&error];

    NSDictionary *model = assembler.model;
    
    LibraryGenerator *generator = [LibraryGenerator new];
    [generator generate:model];

    if (!result) {
        if (error) {
            NSLog(@"%@", error);
        }
        self.outputView.text = @"";
    } else {
//        self.outputView.text = [NSString stringWithFormat:@"%@", result.stack];
        NSError * error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model options:NSJSONWritingPrettyPrinted error:&error];
        self.outputView.text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
