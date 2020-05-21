#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIView+XCProgressHUD.h"
#import "XCProgressHUDErrorIndicatorView.h"
#import "XCProgressHUDLoadingIndicatorView.h"
#import "XCProgressHUDSuccessIndicatorView.h"
#import "XCProgressHUDWarningIndicatorView.h"

FOUNDATION_EXPORT double XCProgressHUDVersionNumber;
FOUNDATION_EXPORT const unsigned char XCProgressHUDVersionString[];

