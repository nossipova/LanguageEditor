//
//  LibraryTemplates.m
//  LanguageEditor
//
//  Created by Natalia Ossipova on 14.09.2013.
//  Copyright (c) 2013 Natalia Ossipova. All rights reserved.
//

#import "LibraryTemplates.h"

@interface LibraryTemplates ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *yearFormatter;
@property (strong, nonatomic) NSMutableSet *headerImports;
@property (strong, nonatomic) NSMutableSet *implementationImports;

@end

@implementation LibraryTemplates

- (NSString *)formatDate:(NSDate *)date {
    if (!self.dateFormatter) {
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)formatYear:(NSDate *)date {
    if (!self.yearFormatter) {
        self.yearFormatter = [NSDateFormatter new];
        [self.yearFormatter setDateFormat:@"yyyy"];
    }
    return [self.yearFormatter stringFromDate:date];
}

- (NSString *)headerWithClassName:(NSString *)className model:(NSDictionary *)model; {
    self.headerImports = [NSMutableSet new];
    self.implementationImports = [NSMutableSet new];
    
    NSString *classNameCapitalized = [className capitalizedString];
    NSMutableString *result = [NSMutableString new];
    [result appendString:[self commentsWithFilename:[NSString stringWithFormat:@"%@.h", classNameCapitalized]]];
    NSInteger index = [result length];
    [result appendFormat:@"@interface %@ : NSObject\n", classNameCapitalized];
    [result appendString:@"\n"];
    [result appendString:[self headerPropertiesWithModel:model]];
    [result appendString:@"\n"];
    [result appendString:[self headerArrayMethodsWithModel:model]];
    [result appendString:@"\n"];
    [result appendString:@"@end\n"];
    [result insertString:[self importStringWithImports:self.headerImports] atIndex:index];
    return result;
}

- (NSString *)implementationWithClassName:(NSString *)className model:(NSDictionary *)model; {
    self.implementationImports = [NSMutableSet new];

    NSString *classNameCapitalized = [className capitalizedString];
    NSMutableString *result = [NSMutableString new];
    [result appendString:[self commentsWithFilename:[NSString stringWithFormat:@"%@.m", classNameCapitalized]]];
    [result appendFormat:@"#import \"%@.h\"\n", classNameCapitalized];
    NSInteger index = [result length];
    [result appendString:@"\n"];
    [result appendString:[self implementationClassExtensionWithClassName:className model:model]];
    [result appendFormat:@"@implementation %@\n", classNameCapitalized];
    [result appendString:@"\n"];
    [result appendString:[self implementationArrayMethodsWithModel:model]];
    [result appendString:@"\n"];
    [result appendString:@"@end\n"];
    [result appendString:@"\n"];
    [result insertString:[self importStringWithImports:[self.implementationImports filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", self.headerImports]]] atIndex:index];
    return result;
}

- (NSString *)implementationInitMethodWithClassName:(NSString *)className model:(NSDictionary *)model {
    self.implementationImports = [NSMutableSet new];

    NSString *classNameCapitalized = [className capitalizedString];
    NSMutableString *result = [NSMutableString new];
    [result appendString:[self commentsWithFilename:[NSString stringWithFormat:@"%@.m", classNameCapitalized]]];
    [result appendFormat:@"#import \"%@.h\"\n", classNameCapitalized];
    NSInteger index = [result length];
    [result appendString:@"\n"];
    [result appendString:[self implementationClassExtensionWithClassName:className model:model]];
    [result appendFormat:@"@implementation %@\n", classNameCapitalized];
    [result appendString:@"\n"];
    [result appendString:[self implementationInitMethodWithModel:model]];
    [result appendString:@"\n"];
    [result appendString:[self implementationArrayMethodsWithModel:model]];
    [result appendString:@"\n"];
    [result appendString:@"@end\n"];
    [result appendString:@"\n"];
    [result insertString:[self importStringWithImports:[self.implementationImports filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", self.headerImports]]] atIndex:index];
    return result;
}

- (NSString *)commentsWithFilename:(NSString *)filename {
    NSMutableString *result = [NSMutableString new];
    [result appendString:@"//\n"];
    [result appendFormat:@"//  %@\n", filename];
    [result appendString:@"//  LanguageEditor\n"];
    [result appendString:@"//\n"];
    [result appendFormat:@"//  Created by Natalia Ossipova on %@.\n", [self formatDate:[NSDate date]]];
    [result appendFormat:@"//  Copyright (c) %@ Natalia Ossipova. All rights reserved.\n", [self formatYear:[NSDate date]]];
    [result appendString:@"//\n"];
    [result appendString:@"\n"];
    return result;
}

- (NSString *)headerPropertiesWithModel:(NSDictionary *)model {
    NSMutableString *result = [NSMutableString new];
    NSArray *allKeys = [model allKeys];
    for (NSString *key in allKeys) {
        id value = model[key];
        NSString *typeName;
        if ([value isKindOfClass:[NSArray class]]) {
            typeName = NSStringFromClass([NSArray class]);
        } else {
            typeName = NSStringFromClass([NSString class]);
        }
        [result appendFormat:@"@property (strong, nonatomic) %@ %@%@;\n", typeName, @"*", key];
    }
    return result;
}

- (NSString *)headerArrayMethodsWithModel:(NSDictionary *)model {
    NSMutableString *result = [NSMutableString new];
    NSArray *allKeys = [model allKeys];
    for (NSString *key in allKeys) {
        id value = model[key];
        if ([value isKindOfClass:[NSArray class]] && ((NSArray *)value).count > 0) {
            id object = value[0];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *className = [object allKeys][0];
                NSString *classNameCapitalized = [className capitalizedString];
                [self.headerImports addObject:classNameCapitalized];
                [result appendFormat:@"- (void)add%@:(%@ *)%@;\n", classNameCapitalized, classNameCapitalized, className];
            } else {
                NSString *className = [key substringToIndex:[key length] - 1];
                [result appendFormat:@"- (void)add%@:(%@ *)%@;\n", [className capitalizedString], NSStringFromClass([NSString class]), className];
            }
        }
    }
    return result;
}

- (NSString *)implementationArrayMethodsWithModel:(NSDictionary *)model {
    NSMutableString *result = [NSMutableString new];
    NSArray *allKeys = [model allKeys];
    for (NSString *key in allKeys) {
        id value = model[key];
        if ([value isKindOfClass:[NSArray class]] && ((NSArray *)value).count > 0) {
            id object = value[0];
            NSString *className;
            if ([result length] > 0) {
                [result appendString:@"\n"];
            }
            if ([object isKindOfClass:[NSDictionary class]]) {
                className = [object allKeys][0];
                NSString *classNameCapitalized = [className capitalizedString];
                [self.implementationImports addObject:classNameCapitalized];
                [result appendFormat:@"- (void)add%@:(%@ *)%@\n", classNameCapitalized, classNameCapitalized, className];
            } else {
                className = [key substringToIndex:[key length] - 1];
                [result appendFormat:@"- (void)add%@:(%@ *)%@\n", [className capitalizedString], NSStringFromClass([NSString class]), className];
            }
            [result appendString:@"{\n"];
            [result appendFormat:@"    if (!_%@) {\n", key];
            [result appendFormat:@"        _%@ = [@[] mutableCopy];\n", key];
            [result appendString:@"    }\n"];
            [result appendFormat:@"    _%@[[_%@ count]] = %@;\n", key, key, className];
            [result appendString:@"}\n"];
        }
    }
    return result;
}

- (NSString *)implementationClassExtensionWithClassName:(NSString *)className model:(NSDictionary *)model {
    NSMutableString *result = [NSMutableString new];
    NSArray *allKeys = [model allKeys];
    for (NSString *key in allKeys) {
        id value = model[key];
        if ([value isKindOfClass:[NSArray class]]) {
            if ([result length] == 0) {
                [result appendFormat:@"@interface %@ () {\n", [className capitalizedString]];
            }
            [result appendFormat:@"    NSMutableArray *_%@;\n", key];
        }
    }
    if ([result length] > 0) {
        [result appendString:@"}\n"];
        [result appendString:@"\n"];
        [result appendString:@"@end\n"];
        [result appendString:@"\n"];
    }
    return result;

}

- (NSString *)importStringWithImports:(NSSet *)imports {
    NSMutableString *result = [NSMutableString new];
    for (NSString *import in imports) {
        [result appendFormat:@"#import \"%@.h\"\n", import];
    }
    if ([result length] > 0) {
        [result appendString:@"\n"];
    }
    return result;
}

- (NSString *)implementationInitMethodWithModel:(NSDictionary *)model {
    NSMutableString *result = [NSMutableString new];
    [result appendString:@"- (id)init\n"];
    [result appendString:@"{\n"];
    [result appendString:@"    self = [super init];\n"];
    [result appendString:@"    if (self) {\n"];
    NSArray *allKeys = model.allKeys;
    for (NSString *key in allKeys) {
        id object = model[key];
        [result appendFormat:@"        _%@ = [@[] mutableCopy];\n", key];
        if ([object isKindOfClass:[NSArray class]]) {
            for (id value in object) {
                NSString *suffix = [NSString stringWithFormat:@"%lu", (unsigned long)[(NSArray *)object indexOfObject:value]];
                [result appendString:[self implementationInitModel:value suffix:suffix]];
                [result appendFormat:@"        _%@[[_%@ count]] = %@%@;\n", key, key, [key substringToIndex:[key length] - 1], suffix];
            }
        }
    }
    [result appendString:@"    }\n"];
    [result appendString:@"    return self;\n"];
    [result appendString:@"}\n"];
    return result;
}

- (NSString *)implementationInitModel:(NSDictionary *)model suffix:(NSString *)suffix {
    NSMutableString *result = [NSMutableString new];
    if ([model isKindOfClass:[NSDictionary class]]) {
        NSArray *allKeys = [model allKeys];
        for (NSString *className in allKeys) {
            NSString *classNameCapitalized = [className capitalizedString];
            [self.implementationImports addObject:classNameCapitalized];
            [result appendFormat:@"        %@ *%@%@ = [%@ new];\n", classNameCapitalized, className, suffix, classNameCapitalized];
            id object = model[className];
            NSArray *attributeNames = [object allKeys];
            for (NSString *attributeName in attributeNames) {
                id attributeValue = object[attributeName];
                if ([attributeValue isKindOfClass:[NSArray class]]) {
                    for (id value in attributeValue) {
                        NSString *attributeNameString = [[attributeName substringToIndex:[attributeName length] - 1] capitalizedString];
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            NSString *suffixInner = [NSString stringWithFormat:@"%@%lu", suffix, (unsigned long)[attributeValue indexOfObject:value]];
                            [result appendString:[self implementationInitModel:value suffix:suffixInner]];
                            [result appendFormat:@"        [%@%@ add%@:%@%@];\n", className, suffix, attributeNameString, [attributeName substringToIndex:[attributeName length] - 1], suffixInner];
                        } else {
                            [result appendFormat:@"        [%@%@ add%@:@\"%@\"];\n", className, suffix, attributeNameString, value];
                        }
                    }
                } else {
                    [result appendFormat:@"        %@%@.%@ = @\"%@\";\n", className, suffix, attributeName, attributeValue];
                }
            }
        }
    } else if ([model isKindOfClass:[NSArray class]]) {
        for (id object in model) {
            [result appendString:[self implementationInitModel:object suffix:[NSString stringWithFormat:@"%lu", (unsigned long)[(NSArray *)model indexOfObject:object]]]];
        }
    }
    return result;
}

@end
