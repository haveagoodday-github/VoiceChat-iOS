//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
//

#import <AGConnectAuth/AGConnectAuth.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGCAuthThirdPartyConfig (QQ)

@property(nonatomic, strong) NSString *qqAppId;
@property(nonatomic, strong, nullable) NSArray *qqPermissions;
@property(nonatomic, strong, nullable) NSString *qqUniversalLink;

@end

NS_ASSUME_NONNULL_END
