# Brightcove tvOS 1

## Steps to Reproduce

- Clone Repository
- Navigate to Root of Project
- Run `pod install` to Install Dependencies
- Build and Run Application in Simulator

## Problem

An exception is thrown when the view controller tries to set the external metadata of the current `AVPlayerItem` instance.

```language-bash
-[AVPlayerItem setExternalMetadata:]: unrecognized selector sent to instance 0x6000011e4280
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[AVPlayerItem setExternalMetadata:]: unrecognized selector sent to instance 0x6000011e4280'
*** First throw call stack:
(
	0   CoreFoundation                      0x000000010883371b __exceptionPreprocess + 331
	1   libobjc.A.dylib                     0x0000000107dd2735 objc_exception_throw + 48
	2   CoreFoundation                      0x00000001088524a4 -[NSObject(NSObject) doesNotRecognizeSelector:] + 132
	3   CoreFoundation                      0x0000000108838436 ___forwarding___ + 1446
	4   CoreFoundation                      0x000000010883a308 _CF_forwarding_prep_0 + 120
	5   AppleTV                             0x0000000106417efc $S7AppleTV14ViewControllerC08playbackD0_0E7Session10didReceiveySo012BCOVPlaybackD0_pSg_So0iF0_pSgSo0iF14LifecycleEventCSgtF + 1964
	6   AppleTV                             0x0000000106418116 $S7AppleTV14ViewControllerC08playbackD0_0E7Session10didReceiveySo012BCOVPlaybackD0_pSg_So0iF0_pSgSo0iF14LifecycleEventCSgtFTo + 102
	7   CoreFoundation                      0x000000010883a59c __invoking___ + 140
	8   CoreFoundation                      0x0000000108837a35 -[NSInvocation invoke] + 325
	9   BrightcovePlayerSDK                 0x0000000106bdfda9 +[BCOVPlaybackControllerCallbackDispatchCenter invokeCallbackSelector:onTarget:playbackController:parameters:] + 335
	10  BrightcovePlayerSDK                 0x0000000106bdfa2b -[BCOVPlaybackControllerCallbackDispatchCenter invokeCallbackSelector:playbackController:parameters:] + 231
	11  BrightcovePlayerSDK                 0x0000000106bc000a __51-[BCOVBasicPlaybackController invoke:withMapBlock:]_block_invoke + 100
	12  BrightcovePlayerSDK                 0x0000000106c575ff -[BCOV_RACSubscriber sendNext:] + 223
	13  BrightcovePlayerSDK                 0x0000000106c163c9 -[BCOV_RACPassthroughSubscriber sendNext:] + 425
	14  BrightcovePlayerSDK                 0x0000000106c4138a __40-[BCOV_RACSignal(Operations) deliverOn:]_block_invoke_3 + 42
	15  BrightcovePlayerSDK                 0x0000000106c1c523 -[BCOV_RACScheduler performAsCurrentScheduler:] + 595
	16  BrightcovePlayerSDK                 0x0000000106c174ca __35-[BCOV_RACQueueScheduler schedule:]_block_invoke + 74
	17  libdispatch.dylib                   0x000000010d5db595 _dispatch_call_block_and_release + 12
	18  libdispatch.dylib                   0x000000010d5dc602 _dispatch_client_callout + 8
	19  libdispatch.dylib                   0x000000010d5e3b0b _dispatch_lane_serial_drain + 791
	20  libdispatch.dylib                   0x000000010d5e47b8 _dispatch_lane_invoke + 480
	21  libdispatch.dylib                   0x000000010d5e97c4 _dispatch_main_queue_callback_4CF + 1071
	22  CoreFoundation                      0x0000000108798979 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 9
	23  CoreFoundation                      0x0000000108793006 __CFRunLoopRun + 2342
	24  CoreFoundation                      0x00000001087923a1 CFRunLoopRunSpecific + 625
	25  GraphicsServices                    0x000000010c7da1dd GSEventRunModal + 62
	26  UIKitCore                           0x00000001174149d0 UIApplicationMain + 140
	27  AppleTV                             0x000000010641b8c7 main + 71
	28  libdyld.dylib                       0x000000010d6527b1 start + 1
	29  ???                                 0x0000000000000001 0x0 + 1
)
libc++abi.dylib: terminating with uncaught exception of type NSException
```
