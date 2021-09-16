//
//  VLKeyValue.h
//  mdm
//
//  Created by Vasyl Liutikov on 11.05.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VLKeyValue : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) BOOL forced;
@end

NS_ASSUME_NONNULL_END
