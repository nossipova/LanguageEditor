#import "LibraryParser.h"
#import <ParseKit/ParseKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LF:(i)]

#define POP()       [self.assembly pop]
#define POP_STR()   [self popString]
#define POP_TOK()   [self popToken]
#define POP_BOOL()  [self popBool]
#define POP_INT()   [self popInteger]
#define POP_FLOAT() [self popDouble]

#define PUSH(obj)     [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn) [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)   [self pushInteger:(NSInteger)(i)]
#define PUSH_FLOAT(f) [self pushDouble:(double)(f)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PEGParser ()
@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
@property (nonatomic, retain) NSString *startRuleName;
@property (nonatomic, retain) NSString *statementTerminator;
@property (nonatomic, retain) NSString *singleLineCommentMarker;
@property (nonatomic, retain) NSString *blockStartMarker;
@property (nonatomic, retain) NSString *blockEndMarker;

- (BOOL)popBool;
- (NSInteger)popInteger;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushDouble:(double)d;
@end

@interface LibraryParser ()
@property (nonatomic, retain) NSMutableDictionary *library_memo;
@property (nonatomic, retain) NSMutableDictionary *books_memo;
@property (nonatomic, retain) NSMutableDictionary *book_memo;
@property (nonatomic, retain) NSMutableDictionary *bookToken_memo;
@property (nonatomic, retain) NSMutableDictionary *titleToken_memo;
@property (nonatomic, retain) NSMutableDictionary *title_memo;
@property (nonatomic, retain) NSMutableDictionary *authorsToken_memo;
@property (nonatomic, retain) NSMutableDictionary *authors_memo;
@property (nonatomic, retain) NSMutableDictionary *author_memo;
@property (nonatomic, retain) NSMutableDictionary *firstName_memo;
@property (nonatomic, retain) NSMutableDictionary *lastName_memo;
@property (nonatomic, retain) NSMutableDictionary *isbnToken_memo;
@property (nonatomic, retain) NSMutableDictionary *isbn_memo;
@property (nonatomic, retain) NSMutableDictionary *chapters_memo;
@property (nonatomic, retain) NSMutableDictionary *chapter_memo;
@property (nonatomic, retain) NSMutableDictionary *chapterToken_memo;
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@end

@implementation LibraryParser

- (id)init {
    self = [super init];
    if (self) {
        self.startRuleName = @"library";
        self.enableAutomaticErrorRecovery = YES;

        self.tokenKindTab[@","] = @(LIBRARYPARSER_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"title"] = @(LIBRARYPARSER_TOKEN_KIND_TITLETOKEN);
        self.tokenKindTab[@"ISBN"] = @(LIBRARYPARSER_TOKEN_KIND_ISBNTOKEN);
        self.tokenKindTab[@"book"] = @(LIBRARYPARSER_TOKEN_KIND_BOOKTOKEN);
        self.tokenKindTab[@"authors"] = @(LIBRARYPARSER_TOKEN_KIND_AUTHORSTOKEN);
        self.tokenKindTab[@"chapter"] = @(LIBRARYPARSER_TOKEN_KIND_CHAPTERTOKEN);

        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_TITLETOKEN] = @"title";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_ISBNTOKEN] = @"ISBN";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_BOOKTOKEN] = @"book";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_AUTHORSTOKEN] = @"authors";
        self.tokenKindNameTab[LIBRARYPARSER_TOKEN_KIND_CHAPTERTOKEN] = @"chapter";

        self.library_memo = [NSMutableDictionary dictionary];
        self.books_memo = [NSMutableDictionary dictionary];
        self.book_memo = [NSMutableDictionary dictionary];
        self.bookToken_memo = [NSMutableDictionary dictionary];
        self.titleToken_memo = [NSMutableDictionary dictionary];
        self.title_memo = [NSMutableDictionary dictionary];
        self.authorsToken_memo = [NSMutableDictionary dictionary];
        self.authors_memo = [NSMutableDictionary dictionary];
        self.author_memo = [NSMutableDictionary dictionary];
        self.firstName_memo = [NSMutableDictionary dictionary];
        self.lastName_memo = [NSMutableDictionary dictionary];
        self.isbnToken_memo = [NSMutableDictionary dictionary];
        self.isbn_memo = [NSMutableDictionary dictionary];
        self.chapters_memo = [NSMutableDictionary dictionary];
        self.chapter_memo = [NSMutableDictionary dictionary];
        self.chapterToken_memo = [NSMutableDictionary dictionary];
        self.text_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_library_memo removeAllObjects];
    [_books_memo removeAllObjects];
    [_book_memo removeAllObjects];
    [_bookToken_memo removeAllObjects];
    [_titleToken_memo removeAllObjects];
    [_title_memo removeAllObjects];
    [_authorsToken_memo removeAllObjects];
    [_authors_memo removeAllObjects];
    [_author_memo removeAllObjects];
    [_firstName_memo removeAllObjects];
    [_lastName_memo removeAllObjects];
    [_isbnToken_memo removeAllObjects];
    [_isbn_memo removeAllObjects];
    [_chapters_memo removeAllObjects];
    [_chapter_memo removeAllObjects];
    [_chapterToken_memo removeAllObjects];
    [_text_memo removeAllObjects];
}

- (void)start {
    [self library_];
}

- (void)__library {
    
    [self tryAndRecover:TOKEN_KIND_BUILTIN_EOF block:^{
        [self books_]; 
        [self matchEOF:YES]; 
    } completion:^{
        [self matchEOF:YES];
    }];

    [self fireAssemblerSelector:@selector(parser:didMatchLibrary:)];
}

- (void)library_ {
    [self parseRule:@selector(__library) withMemo:_library_memo];
}

- (void)__books {
    
    do {
        [self book_]; 
    } while ([self speculate:^{ [self book_]; }]);

    [self fireAssemblerSelector:@selector(parser:didMatchBooks:)];
}

- (void)books_ {
    [self parseRule:@selector(__books) withMemo:_books_memo];
}

- (void)__book {
    
    [self bookToken_]; 
    [self tryAndRecover:LIBRARYPARSER_TOKEN_KIND_TITLETOKEN block:^{ 
        [self titleToken_]; 
    } completion:^{ 
        [self titleToken_]; 
    }];
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
        [self isbn_]; 
        [self chapters_]; 

    [self fireAssemblerSelector:@selector(parser:didMatchBook:)];
}

- (void)book_ {
    [self parseRule:@selector(__book) withMemo:_book_memo];
}

- (void)__bookToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_BOOKTOKEN discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchBookToken:)];
}

- (void)bookToken_ {
    [self parseRule:@selector(__bookToken) withMemo:_bookToken_memo];
}

- (void)__titleToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_TITLETOKEN discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchTitleToken:)];
}

- (void)titleToken_ {
    [self parseRule:@selector(__titleToken) withMemo:_titleToken_memo];
}

- (void)__title {
    
    [self matchQuotedString:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchTitle:)];
}

- (void)title_ {
    [self parseRule:@selector(__title) withMemo:_title_memo];
}

- (void)__authorsToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_AUTHORSTOKEN discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchAuthorsToken:)];
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

    [self fireAssemblerSelector:@selector(parser:didMatchAuthors:)];
}

- (void)authors_ {
    [self parseRule:@selector(__authors) withMemo:_authors_memo];
}

- (void)__author {
    
    [self firstName_]; 
    [self lastName_]; 

    [self fireAssemblerSelector:@selector(parser:didMatchAuthor:)];
}

- (void)author_ {
    [self parseRule:@selector(__author) withMemo:_author_memo];
}

- (void)__firstName {
    
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchFirstName:)];
}

- (void)firstName_ {
    [self parseRule:@selector(__firstName) withMemo:_firstName_memo];
}

- (void)__lastName {
    
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchLastName:)];
}

- (void)lastName_ {
    [self parseRule:@selector(__lastName) withMemo:_lastName_memo];
}

- (void)__isbnToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_ISBNTOKEN discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchIsbnToken:)];
}

- (void)isbnToken_ {
    [self parseRule:@selector(__isbnToken) withMemo:_isbnToken_memo];
}

- (void)__isbn {
    
    [self matchNumber:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchIsbn:)];
}

- (void)isbn_ {
    [self parseRule:@selector(__isbn) withMemo:_isbn_memo];
}

- (void)__chapters {
    
    do {
        [self chapter_]; 
    } while ([self speculate:^{ [self chapter_]; }]);

    [self fireAssemblerSelector:@selector(parser:didMatchChapters:)];
}

- (void)chapters_ {
    [self parseRule:@selector(__chapters) withMemo:_chapters_memo];
}

- (void)__chapter {
    
    [self chapterToken_]; 
    [self text_]; 

    [self fireAssemblerSelector:@selector(parser:didMatchChapter:)];
}

- (void)chapter_ {
    [self parseRule:@selector(__chapter) withMemo:_chapter_memo];
}

- (void)__chapterToken {
    
    [self match:LIBRARYPARSER_TOKEN_KIND_CHAPTERTOKEN discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchChapterToken:)];
}

- (void)chapterToken_ {
    [self parseRule:@selector(__chapterToken) withMemo:_chapterToken_memo];
}

- (void)__text {
    
    [self matchQuotedString:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchText:)];
}

- (void)text_ {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

@end