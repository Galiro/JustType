//
//  JTSyntaxSeperatorWord.m
//  JustType
//
//  Created by Alexander Koglin on 27.12.13.
//  Copyright (c) 2013 Alexander Koglin. All rights reserved.
//

#import "JTSyntaxSeperatorWord.h"
#import "NSString+JTExtension.h"

@interface JTSyntaxSeperatorWord ()

@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSArray *allSuggestions;

@end


@implementation JTSyntaxSeperatorWord
@synthesize word = _word;
@synthesize allSuggestions = _allSuggestions;

+ (BOOL)doesMatchWord:(NSString *)word {
    return [self doesMatchWordInText:word range:[word range]];
}

+ (BOOL)doesMatchWordInText:(NSString *)text range:(NSRange)range {
    static NSRegularExpression *sharedSeperatorExpression;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSeperatorExpression = [NSRegularExpression regularExpressionWithPattern:@"^[^\\w]+$" options:0 error:NULL];
    });
    
    NSArray *matches = [sharedSeperatorExpression matchesInString:text options:0 range:range];
    return (matches.count > 0);
}

+ (NSArray *)possibleSuggestions {
    static NSArray *sharedSeperatorSuggestions;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSeperatorSuggestions = [NSArray arrayWithObjects:@".", @"?", @"!", @",", @";", nil];
    });
    
    return sharedSeperatorSuggestions;
}

- (id)initWithText:(NSString *)text inRange:(NSRange)range useSuggestions:(BOOL)shouldUseSuggestions textInputMode:(UITextInputMode *)textInputMode {
    self = [super init];
    if (self) {
        self.word = [text substringWithRange:range];
        
        if (shouldUseSuggestions) {
            NSMutableArray *mutableSuggestions = [NSMutableArray arrayWithArray:[[self class] possibleSuggestions]];
            [mutableSuggestions removeObject:self.word];
            _allSuggestions = mutableSuggestions;
        } else {
            _allSuggestions = [NSArray array];
        }

    }
    return self;
}

- (void)dealloc {
    self.word = nil;
}

@end
