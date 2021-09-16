//
//  NSUserDefaults+DefaultValue.h
//  mdm
//
//  Created by Vasyl Liutikov on 19.04.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (DefaultValue)
- (NSString *)stringForKey:(NSString *)key withDefaultValue:(NSString*)defaultValue;
- (BOOL)boolForKey:(NSString *)key withDefaultValue:(BOOL)defaultValue;
@end

NS_ASSUME_NONNULL_END
