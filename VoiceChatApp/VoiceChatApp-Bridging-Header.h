//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

//#import <UIKit/UIKit.h>
//#import <WXApi.h>
//
//@interface AppDelegate : UIResponder<UIApplicationDelegate, WXApiDelegate>
//
//@property (strong, nonatomic) UIWindow *window;
//
//@end


#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "TencentOAuth.h"
#import "TencentOpenApiUmbrellaHeader.h"
#import "sdkdef.h"
#import <AlipaySDK/AlipaySDK.h>


// MARK: 一键登陆【阿里云】
#import "View/login/OneClickLogin/SDK/ACMLogger.h"
#import "View/login/OneClickLogin/SDK/ACMManager.h"
#import "View/login/OneClickLogin/SDK/ACMMonitor.h"
#import "View/login/OneClickLogin/SDK/ACMProtocol.h"
#import "View/login/OneClickLogin/SDK/YTXMonitor.h"
#import "View/login/OneClickLogin/SDK/YTXNetUtils.h"
#import "View/login/OneClickLogin/SDK/YTXOperators.h"
#import "View/login/OneClickLogin/SDK/YTXVendorService.h"
#import "View/login/OneClickLogin/SDK/ATAuthSDK.h"
#import "View/login/OneClickLogin/SDK/PNSReporter.h"
#import "View/login/OneClickLogin/SDK/PNSReturnCode.h"
#import "View/login/OneClickLogin/SDK/TXCommonHandler.h"
#import "View/login/OneClickLogin/SDK/TXCommonUtils.h"
#import "View/login/OneClickLogin/SDK/TXCustomModel.h"



// MARK: 阿里实人认证
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>
//#import "View/Authentication/SDK/AliyunFaceAuthFacade.h"



#import "SVGARePlayer.h"
#import "SVGAParser.h"


@interface AppDelegate : UIResponder<UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

