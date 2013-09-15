//
//  LibraryTemplates.h
//  LanguageEditor
//
//  Created by Natalia Ossipova on 14.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

@interface LibraryTemplates : NSObject

- (NSString *)headerWithClassName:(NSString *)className model:(NSDictionary *)model;
- (NSString *)implementationWithClassName:(NSString *)className model:(NSDictionary *)model;
- (NSString *)implementationInitMethodWithClassName:(NSString *)className model:(NSDictionary *)model;

@end
