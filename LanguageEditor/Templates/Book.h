//
//  Book.h
//  LanguageEditor
//
//  Created by Natalia Ossipova on 09.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "Author.h"

@interface Book : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *isbn;
@property (strong, nonatomic) NSArray *authors;
@property (strong, nonatomic) NSArray *chapters;

- (void)addAuthor:(Author *)author;
- (void)addChapter:(NSString *)chapter;

@end
