//
//  TXAssertion.m
//  POC2
//
//  Created by Mohammed Tillawy on 4/16/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "TXAssertion.h"
#import "XFAConstants.h"

@implementation TXAssertion


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"assertionType"        : @"type",
             @"assertionLevel"       : @"level",
             @"assertionSeverity"    : @"severity",
             @"assertionIndex"       : @"index",
             @"assertionValue"       : @"numberValue",
             @"message"              : @"message",
             @"failed"               : @"failed",
             };
}

-(void)evaluate:(NSValue *)value
{
    NSAssert(FALSE, @"calling abstract TXAssertion ");
}


+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"type"] != nil &&
        [JSONDictionary[@"type"] isEqualToString:@"nil"] ) {
        return NSClassFromString(@"TXNilAssertion");
    }
    
    if (JSONDictionary[@"type"] != nil &&
        [JSONDictionary[@"type"] isEqualToString:@"bool"] ) {
        return NSClassFromString(@"TXBoolAssertion");
    }
    
    if (JSONDictionary[@"type"] != nil &&
        [JSONDictionary[@"type"] isEqualToString:@"length-more-than"] ) {
        return NSClassFromString(@"TXLengthMoreThanAssertion");
    }
    
    NSAssert(NO, @"No matching TXAssertion class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}



-(void)reportFailure{
    self.failed = TRUE;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_METHOD_ASSERTION_FAILURE object:self userInfo:nil];
}


@end


