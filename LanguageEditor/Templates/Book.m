//
//  Book.m
//  LanguageEditor
//
//  Created by Natalia Ossipova on 09.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "Book.h"

@interface Book () {
    NSMutableArray *_authors;
    NSMutableArray *_chapters;
}

@end

@implementation Book

- (void)addAuthor:(Author *)author
{
    if (!_authors) {
        _authors = [@[] mutableCopy];
    }
    _authors[[_authors count]] = author;
}

- (void)addChapter:(NSString *)chapter
{
    if (!_chapters) {
        _chapters = [@[] mutableCopy];
    }
    _chapters[[_chapters count]] = chapter;
}

@end
