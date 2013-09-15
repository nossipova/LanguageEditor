//
//  Library.m
//  LanguageEditor
//
//  Created by Natalia Ossipova on 09.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "Library.h"
#import "Author.h"

@interface Library () {
    NSMutableArray *_books;
}

@end

@implementation Library

- (id)init
{
    self = [super init];
    if (self) {
        _books = [@[] mutableCopy];
        Book *book = [Book new];
        book.title = @"Test-Driven iOS Development";
        book.isbn = @"0321774183";
        Author *author = [Author new];
        author.firstName = @"Graham";
        author.lastName = @"Lee";
        [book addAuthor:author];
        [book addChapter:@"Chapter 1"];
        [book addChapter:@"Chapter 2"];
        _books[[_books count]] = book;
    }
    return self;
}

- (void)addBook:(Book *)book
{
    if (!_books) {
        _books = [@[] mutableCopy];
    }
    _books[[_books count]] = book;
}

@end
