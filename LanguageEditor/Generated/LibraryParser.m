#import "LibraryParser.h"
#import <PEGKit/PEGKit.h>


@interface LibraryParser ()

@property (nonatomic, retain) NSMutableDictionary *start_memo;
@property (nonatomic, retain) NSMutableDictionary *library_memo;
@property (nonatomic, retain) NSMutableDictionary *books_memo;
@property (nonatomic, retain) NSMutableDictionary *book_memo;
@property (nonatomic, retain) NSMutableDictionary *bookToken_memo;
@property (nonatomic, retain) NSMutableDictionary *title_memo;
@property (nonatomic, retain) NSMutableDictionary *authorsToken_memo;
@property (nonatomic, retain) NSMutableDictionary *authors_memo;
@property (nonatomic, retain) NSMutableDictionary *author_memo;
@property (nonatomic, retain) NSMutableDictionary *firstname_memo;
@property (nonatomic, retain) NSMutableDictionary *lastname_memo;
@property (nonatomic, retain) NSMutableDictionary *isbnToken_memo;
@property (nonatomic, retain) NSMutableDictionary *isbn_memo;
@property (nonatomic, retain) NSMutableDictionary *chapters_memo;
@property (nonatomic, retain) NSMutableDictionary *chapter_memo;
@property (nonatomic, retain) NSMutableDictionary *chapterToken_memo;
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@property (nonatomic, retain) NSMutableDictionary *endToken_memo;
@end

@implementation LibraryParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"start";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@","] = @(LIBRARYPARSER_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"end"] = @(LIBRARYPARSER_TOKEN_KIND_ENDTOKEN);
        self.tokenKindTab[@"ISBN"] = @(LIBRARYPARSER_TOKEN_KIND_ISBNTOKEN);
        self.tokenKindTab[@"book"] = @(LIBRARYPARSER_TOKEN_KIND_BOOKTOKEN);
        self.tokenKindTab[@"authors"] = @(LIBRARYPARSER_TOKEN_KIND_AUTHORSTOKEN);
        self.tokenKindTab[@"chapter"] = @(LIBRARYPARSER_TOKEN_KIND_CHAPTERTOKEN);

        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_ENDTOKEN] = @"end";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_ISBNTOKEN] = @"ISBN";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_BOOKTOKEN] = @"book";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_AUTHORSTOKEN] = @"authors";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_CHAPTERTOKEN] = @"chapter";

        self.start_memo = [NSMutableDictionary dictionary];
        self.library_memo = [NSMutableDictionary dictionary];
        self.books_memo = [NSMutableDictionary dictionary];
        self.book_memo = [NSMutableDictionary dictionary];
        self.bookToken_memo = [NSMutableDictionary dictionary];
        self.title_memo = [NSMutableDictionary dictionary];
        self.authorsToken_memo = [NSMutableDictionary dictionary];
        self.authors_memo = [NSMutableDictionary dictionary];
        self.author_memo = [NSMutableDictionary dictionary];
        self.firstname_memo = [NSMutableDictionary dictionary];
        self.lastname_memo = [NSMutableDictionary dictionary];
        self.isbnToken_memo = [NSMutableDictionary dictionary];
        self.isbn_memo = [NSMutableDictionary dictionary];
        self.chapters_memo = [NSMutableDictionary dictionary];
        self.chapter_memo = [NSMutableDictionary dictionary];
        self.chapterToken_memo = [NSMutableDictionary dictionary];
        self.text_memo = [NSMutableDictionary dictionary];
        self.endToken_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearMemo {
    [_start_memo removeAllObjects];
    [_library_memo removeAllObjects];
    [_books_memo removeAllObjects];
    [_book_memo removeAllObjects];
    [_bookToken_memo removeAllObjects];
    [_title_memo removeAllObjects];
    [_authorsToken_memo removeAllObjects];
    [_authors_memo removeAllObjects];
    [_author_memo removeAllObjects];
    [_firstname_memo removeAllObjects];
    [_lastname_memo removeAllObjects];
    [_isbnToken_memo removeAllObjects];
    [_isbn_memo removeAllObjects];
    [_chapters_memo removeAllObjects];
    [_chapter_memo removeAllObjects];
    [_chapterToken_memo removeAllObjects];
    [_text_memo removeAllObjects];
    [_endToken_memo removeAllObjects];
}

- (void)start {

    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [self start_]; 
        [self matchEOF:YES]; 
    } completion:^{
        [self matchEOF:YES];
    }];

}

- (void)__start {
    
    [self library_]; 

    [self fireDelegateSelector:@selector(parser:didMatchStart:)];
}

- (void)start_ {
    [self parseRule:@selector(__start) withMemo:_start_memo];
}

- (void)__library {
    
    [self books_]; 

    [self fireDelegateSelector:@selector(parser:didMatchLibrary:)];
}

- (void)library_ {
    [self parseRule:@selector(__library) withMemo:_library_memo];
}

- (void)__books {
    
    do {
        [self book_]; 
    } while ([self speculate:^{ [self book_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchBooks:)];
}

- (void)books_ {
    [self parseRule:@selector(__books) withMemo:_books_memo];
}

- (void)__book {
    
    [self bookToken_]; 
    [self tryAndRecover:LIBRARYPARSER_TOKEN_KIND_AUTHORSTOKEN block:^{ 
        [self title_]; 
        [self authorsToken_]; 
    } completion:^{ 
        [self authorsToken_]; 
    }];
    [self tryAndRecover:LIBRARYPARSER_TOKEN_KIND_ISBNTOKEN block:^{ 
        [self authors_]; 
        [self isbnToken_]; 
    } completion:^{ 
        [self isbnToken_]; 
    }];
    [self tryAndRecover:LIBRARYPARSER_TOKEN_KIND_ENDTOKEN block:^{ 
        [self isbn_]; 
        [self chapters_]; 
        [self endToken_]; 
    } completion:^{ 
        [self endToken_]; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchBook:)];
}

- (void)book_ {
    [self parseRule:@selector(__book) withMemo:_book_memo];
}

- (void)__bookToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_BOOKTOKEN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBookToken:)];
}

- (void)bookToken_ {
    [self parseRule:@selector(__bookToken) withMemo:_bookToken_memo];
}

- (void)__title {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTitle:)];
}

- (void)title_ {
    [self parseRule:@selector(__title) withMemo:_title_memo];
}

- (void)__authorsToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_AUTHORSTOKEN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAuthorsToken:)];
}

- (void)authorsToken_ {
    [self parseRule:@selector(__authorsToken) withMemo:_authorsToken_memo];
}

- (void)__authors {
    
    [self author_]; 
    while ([self speculate:^{ [self match:LIBRARYPARSER_TOKEN_KIND_COMMA discard:NO]; [self author_]; }]) {
        [self match:LIBRARYPARSER_TOKEN_KIND_COMMA discard:NO]; 
        [self author_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAuthors:)];
}

- (void)authors_ {
    [self parseRule:@selector(__authors) withMemo:_authors_memo];
}

- (void)__author {
    
    [self firstname_]; 
    [self lastname_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAuthor:)];
}

- (void)author_ {
    [self parseRule:@selector(__author) withMemo:_author_memo];
}

- (void)__firstname {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFirstname:)];
}

- (void)firstname_ {
    [self parseRule:@selector(__firstname) withMemo:_firstname_memo];
}

- (void)__lastname {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLastname:)];
}

- (void)lastname_ {
    [self parseRule:@selector(__lastname) withMemo:_lastname_memo];
}

- (void)__isbnToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_ISBNTOKEN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIsbnToken:)];
}

- (void)isbnToken_ {
    [self parseRule:@selector(__isbnToken) withMemo:_isbnToken_memo];
}

- (void)__isbn {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIsbn:)];
}

- (void)isbn_ {
    [self parseRule:@selector(__isbn) withMemo:_isbn_memo];
}

- (void)__chapters {
    
    do {
        [self chapter_]; 
    } while ([self speculate:^{ [self chapter_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchChapters:)];
}

- (void)chapters_ {
    [self parseRule:@selector(__chapters) withMemo:_chapters_memo];
}

- (void)__chapter {
    
    [self chapterToken_]; 
    [self text_]; 

    [self fireDelegateSelector:@selector(parser:didMatchChapter:)];
}

- (void)chapter_ {
    [self parseRule:@selector(__chapter) withMemo:_chapter_memo];
}

- (void)__chapterToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_CHAPTERTOKEN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchChapterToken:)];
}

- (void)chapterToken_ {
    [self parseRule:@selector(__chapterToken) withMemo:_chapterToken_memo];
}

- (void)__text {
    
    [self matchQuotedString:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchText:)];
}

- (void)text_ {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

- (void)__endToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_ENDTOKEN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEndToken:)];
}

- (void)endToken_ {
    [self parseRule:@selector(__endToken) withMemo:_endToken_memo];
}

@end