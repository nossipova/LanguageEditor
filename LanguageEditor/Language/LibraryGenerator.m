//
//  LibraryGenerator.m
//  LanguageEditor
//
//  Created by Natalia Ossipova on 15.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "LibraryGenerator.h"
#import "LibraryTemplates.h"

@interface LibraryGenerator ()

@property (strong, nonatomic) LibraryTemplates *templates;

@end

@implementation LibraryGenerator

- (id)init {
    self = [super init];
    if (self) {
        _templates = [LibraryTemplates new];
    }
    return self;
}

- (void)generate:(NSDictionary *)model {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];

    NSLog(@"Document directory: %@", documentDirectory);

    NSSet *classNames = [self classNamesFromModel:model];

    for (NSString *className in classNames) {
        NSArray *objects = [self objectsWithClassName:className model:model];
        id object = objects[0];

        NSString *headerPath = [NSString stringWithFormat:@"%@/%@.h", documentDirectory, [className capitalizedString]];
        NSString *implementationPath = [NSString stringWithFormat:@"%@/%@.m", documentDirectory, [className capitalizedString]];
        [[NSFileManager defaultManager] createFileAtPath:headerPath contents:[[self.templates headerWithClassName:className model:object] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        if ([model.allKeys containsObject:className]) {
            [[NSFileManager defaultManager] createFileAtPath:implementationPath contents:[[self.templates implementationInitMethodWithClassName:className model:object] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        } else {
            [[NSFileManager defaultManager] createFileAtPath:implementationPath contents:[[self.templates implementationWithClassName:className model:object] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
    }
}

- (NSSet *)classNamesFromModel:(NSDictionary *)model {
    NSMutableSet *classNames = [NSMutableSet new];
    if ([model isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [model allKeys]) {
            id value = model[key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                [classNames addObject:key];
            }
            [classNames addObjectsFromArray:[[self classNamesFromModel:value] allObjects]];
        }
    } else if ([model isKindOfClass:[NSArray class]]) {
        for (id value in model) {
            [classNames addObjectsFromArray:[[self classNamesFromModel:value] allObjects]];
        }
    }
    return classNames;
}

- (NSArray *)objectsWithClassName:(NSString *)className model:(NSDictionary *)model {
    NSMutableArray *objects = [@[] mutableCopy];
    if ([model isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [model allKeys]) {
            if ([key isEqualToString:className]) {
                [objects addObject:model[key]];
            } else {
                [objects addObjectsFromArray:[self objectsWithClassName:className model:model[key]]];
            }
        }
    } else if ([model isKindOfClass:[NSArray class]]) {
        for (id object in model) {
            [objects addObjectsFromArray:[self objectsWithClassName:className model:object]];
        }
    }
    return objects;
}

@end
