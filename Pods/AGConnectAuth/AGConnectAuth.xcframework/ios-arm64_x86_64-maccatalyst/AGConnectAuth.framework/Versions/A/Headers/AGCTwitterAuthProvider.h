//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
//
#import <Foundation/Foundation.h>
#import "AGCAuthCredential.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *Twitter登录参数对象
 **/
@interface AGCTwitterAuthParam : NSObject

// 回调地址
@property (nonatomic, copy) NSString *redirectUrl;

// authcode
@property (nonatomic, copy) NSString *authCode;

// twitter的clientid
@property (nonatomic, copy) NSString *clientId;

// 授权请求的codeverifier
@property (nonatomic, copy) NSString *codeVerifier;


- (instancetype)initWithClientId:(NSString *)clientId authCode:(NSString *)authCode codeVerifier:(NSString *)codeVerifier redirectUrl:(NSString *)redirectUrl;

@end

/**
 * Twitter凭证提供者
 */
@interface AGCTwitterAuthProvider : NSObject
/**
 * 登录凭证构造器
 *
 * @param token 由Twitter授权后获得的accessToken
 * @param secret 由Twitter平台后获得的secret
 * @return 用于登录的凭证
 */
+ (AGCAuthCredential *)credentialWithToken:(NSString *)token secret:(NSString *)secret;
/**
 * 登录凭证构造器
 *
 * @param token 由Twitter授权后获得的accessToken
 * @param secret 由Twitter平台后获得的secret
 * @param autoCreateUser 是否创建账户
 * @return 用于登录的凭证
 */
+ (AGCAuthCredential *)credentialWithToken:(NSString *)token
                                    secret:(NSString *)secret
                            autoCreateUser:(BOOL)autoCreateUser;

/**
 * 登录凭证构造器V2
 *
 * @param param 传给后台的参数对象
 * @return 用于登录的凭证
*/
+ (AGCAuthCredential *)credentialWithAuthParam:(AGCTwitterAuthParam *)param
                            autoCreateUser:(BOOL)autoCreateUser;

@end

NS_ASSUME_NONNULL_END
