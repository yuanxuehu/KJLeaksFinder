# KJLeaksFinder
iOS自动检测内存泄漏，支持Objective-C和Swift

iOS 在pod管理的第三方库中, 引用另一个pod管理的第三方库
AMLeaksFinder依赖FBRetainCycleDetector
## 第一步
在pod中 找到AMLeaksFinder, 在Build Phases 中 导入FBRetainCycleDetector.Framework

## 第二步
在pod的AMLeaksFinder.Framework 中, 找到Build Settings 配置Framework Search Paths 的 Debug 和 Release, 添加 $(inherited) 和 "$PODS_CONFIGURATION_BUILD_DIR/FBRetainCycleDetector"

## 第三步
在pod的AMLeaksFinder.xcconfig中 添加 
FRAMEWORK_SEARCH_PATHS = $(inherited) "$PODS_CONFIGURATION_BUILD_DIR/FBRetainCycleDetector"
