//
//  Library.h
//  LanguageEditor
//
//  Created by Natalia Ossipova on 09.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "Book.h"

@interface Library : NSObject

@property (strong, nonatomic) NSArray *books;

- (void)addBook:(Book *)book;

@end
