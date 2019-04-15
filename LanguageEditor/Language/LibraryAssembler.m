//
//  LibraryAssembler.m
//  LanguageEditor
//
//  Created by Natalia Ossipova on 09.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "LibraryAssembler.h"

NSString * const LELibraryToken = @"library";
NSString * const LEBooksToken = @"books";
NSString * const LEBookToken = @"book";
NSString * const LETitleToken = @"title";
NSString * const LEAuthorsToken = @"authors";
NSString * const LEAuthorToken = @"author";
NSString * const LEISBNToken = @"isbn";
NSString * const LEChaptersToken = @"chapters";
NSString * const LEFirstNameToken = @"firstName";
NSString * const LELastNameToken = @"lastName";

@interface LibraryAssembler () {
    NSMutableDictionary *_model;
}

@property (strong, nonatomic) NSMutableDictionary *currentBook;

@end

@implementation LibraryAssembler

- (id)init {
    self = [super init];
    if (self) {
        _model = [@{} mutableCopy];
    }
    return self;
}

- (void)parser:(PKParser *)parser didMatchLibrary:(PKAssembly *)assembly {
//    NSLog(@"Library: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchBooks:(PKAssembly *)assembly {
//    NSLog(@"Books: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchBook:(PKAssembly *)assembly {
//    NSLog(@"Book: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchBookToken:(PKAssembly *)assembly {
//    NSLog(@"Book token: %@", [assembly.stack lastObject]);

    NSMutableDictionary *library = self.model[LELibraryToken];
    if (!library) {
        library = [@{} mutableCopy];
        library[LEBooksToken] = [@[] mutableCopy];
        _model[LELibraryToken] = library;
    }
    NSMutableDictionary *book = [@{} mutableCopy];
    book[LEBookToken] = [@{} mutableCopy];
    [library[LEBooksToken] addObject:book];
    self.currentBook = book[LEBookToken];
}

- (void)parser:(PKParser *)parser didMatchTitleToken:(PKAssembly *)assembly {
//    NSLog(@"Title token: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchTitle:(PKAssembly *)assembly {
//    NSLog(@"Title: %@", [assembly.stack lastObject]);

    self.currentBook[LETitleToken] = [[[assembly.stack lastObject] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
}

- (void)parser:(PKParser *)parser didMatchAuthorsToken:(PKAssembly *)assembly {
//    NSLog(@"Author token: %@", [assembly.stack lastObject]);

    self.currentBook[LEAuthorsToken] = [@[] mutableCopy];
}

- (void)parser:(PKParser *)parser didMatchAuthor:(PKAssembly *)assembly {
//    NSLog(@"Author: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchAuthors:(PKAssembly *)assembly {
//    NSLog(@"Authors: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchFirstname:(PKAssembly *)assembly {
//    NSLog(@"Firstname: %@", [assembly.stack lastObject]);

    NSString *firstName = [[assembly.stack lastObject] stringValue];
    NSMutableArray *authors = self.currentBook[LEAuthorsToken];
    NSMutableDictionary *author = [@{} mutableCopy];
    author[LEAuthorToken] = [@{} mutableCopy];
    author[LEAuthorToken][LEFirstNameToken] = firstName;
    authors[[authors count]] = author;
}

- (void)parser:(PKParser *)parser didMatchLastname:(PKAssembly *)assembly {
//    NSLog(@"Lastname: %@", [assembly.stack lastObject]);

    NSString *lastName = [[assembly.stack lastObject] stringValue];
    NSMutableDictionary *author = [self.currentBook[LEAuthorsToken] lastObject];
    author[LEAuthorToken][LELastNameToken] = lastName;
}

- (void)parser:(PKParser *)parser didMatchIsbnToken:(PKAssembly *)assembly {
//    NSLog(@"ISBN token: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchIsbn:(PKAssembly *)assembly {
//    NSLog(@"ISBN: %@", [assembly.stack lastObject]);

    self.currentBook[LEISBNToken] = [[assembly.stack lastObject] stringValue];
}

- (void)parser:(PKParser *)parser didMatchChapters:(PKAssembly *)assembly {
//    NSLog(@"Chapters: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchChapter:(PKAssembly *)assembly {
//    NSLog(@"Chapter: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchChapterToken:(PKAssembly *)assembly {
//    NSLog(@"Chapter token: %@", [assembly.stack lastObject]);

    // nothing to do
}

- (void)parser:(PKParser *)parser didMatchText:(PKAssembly *)assembly {
//    NSLog(@"Text: %@", [assembly.stack lastObject]);

    NSMutableArray *chapters = self.currentBook[LEChaptersToken];
    if (!chapters) {
        chapters = [@[] mutableCopy];
        self.currentBook[LEChaptersToken] = chapters;
    }
    chapters[[chapters count]] = [[[assembly.stack lastObject] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
}

@end
