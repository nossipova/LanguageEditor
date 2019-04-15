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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.inputView.text = @"";
    self.outputView.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backgroundTap:(id)sender {
    [self.inputView resignFirstResponder];
}

- (IBAction)generate:(id)sender {
    [self.inputView resignFirstResponder];

    NSString *input = self.inputView.text;

    LibraryAssembler *assembler = [LibraryAssembler new];
    LibraryParser *parser = [[LibraryParser alloc] initWithDelegate:assembler];
    NSError *error = nil;
    PKAssembly *result = [parser parseString:input error:&error];

    NSDictionary *model = assembler.model;
    
    LibraryGenerator *generator = [LibraryGenerator new];
    [generator generate:model];

    if (!result) {
        if (error) {
            NSLog(@"%@", error);
        }
        self.outputView.text = @"";
    } else {
        self.outputView.text = [NSString stringWithFormat:@"%@", result.stack];
    }
}

@end
