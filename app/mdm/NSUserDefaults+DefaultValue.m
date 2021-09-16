//
//  NSUserDefaults+DefaultValue.m
//  mdm
//
//  Created by Vasyl Liutikov on 19.04.21.
//

#import "NSUserDefaults+DefaultValue.h"

@implementation NSUserDefaults (DefaultValue)
- (NSString *)stringForKey:(NSString *)key withDefaultValue:(NSString*)defaultValue
{
    return [self stringForKey:key] ?: defaultValue;
}

- (BOOL)boolForKey:(NSString *)key withDefaultValue:(BOOL)defaultValue
{
    return [self objectForKey:key];
}
@end
