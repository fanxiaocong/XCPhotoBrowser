# XCProgressHUD

[![CI Status](https://img.shields.io/travis/fanxiaocong/XCProgressHUD.svg?style=flat)](https://travis-ci.org/fanxiaocong/XCProgressHUD)
[![Version](https://img.shields.io/cocoapods/v/XCProgressHUD.svg?style=flat)](https://cocoapods.org/pods/XCProgressHUD)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://cocoapods.org/pods/XCProgressHUD)
[![Platform](https://img.shields.io/badge/platform-iOS-green.svg?style=flat)](https://cocoapods.org/pods/XCProgressHUD)
[![Support](https://img.shields.io/badge/support-iOS%209%2B%20-green.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

***
|Author|小小聪明屋|
|---|---|
|E-mail|1016697223@qq.com|
|GitHub|https://github.com/fanxiaocong|
|Blog|http://www.cnblogs.com/fanxiaocong|
***


## Example
基于 JGProgressHUD，在此基础上封装了几款简单的提示框， 通过分类的形式调用，使用简单。

### 加载HUD
- 示例

![Loading](Example/Screenshots/hud_loading.gif)

- 代码

```objc
[self.view showHUDWithText:@"正在发送..."];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	[self.view showSuccess:@"操作成功..."];
});
```
### 文本HUD
- 示例

![Loading](Example/Screenshots/hud_text.gif)

- 代码

```objc
 [self.view showText:@"这是文本提示"];
```
### 成功HUD
- 示例

![Loading](Example/Screenshots/hud_success.gif)

- 代码

```objc
[self.view showSuccess:@"操作成功..."];
```
### 失败HUD
- 示例

![Loading](Example/Screenshots/hud_failure.gif)

- 代码

```objc
 [self.view showError:@"加载失败..."];
```
### 警告HUD
- 示例

![Loading](Example/Screenshots/hud_warning.gif)

- 代码

```objc
[self.view showWarning:@"非法操作..."];
```
### 进度HUD
- 示例

![Loading](Example/Screenshots/hud_progress.gif)

- 代码

```objc
/// 模拟进度显示
- (void)showProgressHUD:(int)progress
{
    progress += 1;
    [self.view updateProgress:progress/100.0];
    
    if (progress == 100) {
        [self.view showSuccess:@"下载完成"];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showProgressHUD:progress];
        });
    }
}
```



## Installation

### CocoaPods
```objc
pod 'XCProgressHUD'
```
