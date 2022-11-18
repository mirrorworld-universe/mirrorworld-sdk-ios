#if 0
#elif defined(__x86_64__) && __x86_64__
// Generated by Apple Swift version 5.7.1 effective-4.1.50 (swiftlang-5.7.1.135.3 clang-1400.0.29.51)
#ifndef MIRRORWORLDSDK_SWIFT_H
#define MIRRORWORLDSDK_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wduplicate-method-match"
#pragma clang diagnostic ignored "-Wauto-import"
#if defined(__OBJC__)
#include <Foundation/Foundation.h>
#endif
#if defined(__cplusplus)
#include <cstdint>
#include <cstddef>
#include <cstdbool>
#else
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#endif

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if defined(__OBJC__)
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#endif
#if !defined(SWIFT_EXTERN)
# if defined(__cplusplus)
#  define SWIFT_EXTERN extern "C"
# else
#  define SWIFT_EXTERN extern
# endif
#endif
#if !defined(SWIFT_CALL)
# define SWIFT_CALL __attribute__((swiftcall))
#endif
#if defined(__cplusplus)
#if !defined(SWIFT_NOEXCEPT)
# define SWIFT_NOEXCEPT noexcept
#endif
#else
#if !defined(SWIFT_NOEXCEPT)
# define SWIFT_NOEXCEPT 
#endif
#endif
#if defined(__cplusplus)
#if !defined(SWIFT_CXX_INT_DEFINED)
#define SWIFT_CXX_INT_DEFINED
namespace swift {
using Int = ptrdiff_t;
using UInt = size_t;
}
#endif
#endif
#if defined(__OBJC__)
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#pragma clang diagnostic ignored "-Wdollar-in-identifier-extension"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="MirrorWorldSDK",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

#if defined(__OBJC__)
typedef SWIFT_ENUM(NSInteger, MWEnvironment, closed) {
  MWEnvironmentStagingDevNet = 0,
  MWEnvironmentStagingMainNet = 1,
  MWEnvironmentDevNet = 2,
  MWEnvironmentMainNet = 3,
};

@class NSString;

SWIFT_CLASS("_TtC14MirrorWorldSDK16MirrorAuthMoudle")
@interface MirrorAuthMoudle : NSObject
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable userInfo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14MirrorWorldSDK16MirrorBaseMoudle")
@interface MirrorBaseMoudle : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14MirrorWorldSDK23MirrorMarketplaceMoudle")
@interface MirrorMarketplaceMoudle : MirrorBaseMoudle
- (void)MintNewCollectionWithName:(NSString * _Nonnull)name symbol:(NSString * _Nonnull)symbol url:(NSString * _Nonnull)url confirmation:(NSString * _Nonnull)confirmation seller_fee_basis_points:(NSInteger)seller_fee_basis_points onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)FetchSingleNFTWithMint_Address:(NSString * _Nonnull)mint_Address onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)TransferNFTToAnotherSolanaWalletWithMint_address:(NSString * _Nonnull)mint_address to_wallet_address:(NSString * _Nonnull)to_wallet_address confirmation:(NSString * _Nonnull)confirmation onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)MintNewNFTWithCollection_mint:(NSString * _Nonnull)collection_mint name:(NSString * _Nonnull)name symbol:(NSString * _Nonnull)symbol url:(NSString * _Nonnull)url seller_fee_basis_points:(NSInteger)seller_fee_basis_points confirmation:(NSString * _Nonnull)confirmation onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)ListNFTWithMint_address:(NSString * _Nonnull)mint_address price:(double)price confirmation:(NSString * _Nonnull)confirmation onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)CancelNFTListingWithMint_address:(NSString * _Nonnull)mint_address price:(double)price onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)FetchNFTsByMintAddressesWithMint_address:(NSString * _Nonnull)mint_address onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)FetchNFTsByCreatorAddressesWithCreators:(NSArray<NSString *> * _Nonnull)creators limit:(double)limit offset:(double)offset onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)FetchNFTsByUpdateAuthoritiesWithUpdate_authorities:(NSArray<NSString *> * _Nonnull)update_authorities limit:(double)limit offset:(double)offset onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)FetchNFTsByOwnerAddressWithOwners:(NSArray<NSString *> * _Nonnull)owners limit:(double)limit offset:(double)offset onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)BuyNFTWithMint_address:(NSString * _Nonnull)mint_address price:(double)price onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIViewController;

SWIFT_CLASS("_TtC14MirrorWorldSDK18MirrorWalletMoudle")
@interface MirrorWalletMoudle : NSObject
- (void)openWalletWithController:(UIViewController * _Nullable)controller;
- (void)GetWalletTokensOnSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
- (void)GetWalletTransactionsWithLimit:(NSInteger)limit next_before:(NSString * _Nonnull)next_before onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
- (void)GetWalletTransactionBySignatureWithSignature:(NSString * _Nonnull)signature onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14MirrorWorldSDK25MirrorWorldHandleProtocol")
@interface MirrorWorldHandleProtocol : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14MirrorWorldSDK14MirrorWorldLog")
@interface MirrorWorldLog : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14MirrorWorldSDK18MirrorWorldNetWork")
@interface MirrorWorldNetWork : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class MirrorWorldSDKConfig;
@class NSURL;

SWIFT_CLASS("_TtC14MirrorWorldSDK14MirrorWorldSDK")
@interface MirrorWorldSDK : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) MirrorWorldSDK * _Nonnull share;)
+ (MirrorWorldSDK * _Nonnull)share SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, strong) MirrorWorldSDKConfig * _Nonnull sdkConfig;
@property (nonatomic, strong) MirrorWorldLog * _Nonnull sdkLog;
@property (nonatomic, strong) MirrorWorldHandleProtocol * _Nonnull sdkProtol;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
/// init SDK
- (void)initSDKWithEnv:(enum MWEnvironment)env apiKey:(NSString * _Nonnull)apiKey SWIFT_METHOD_FAMILY(none);
/// init SDK
/// config: MirrorWorldSDKConfig
- (void)initSDKWithConfig:(MirrorWorldSDKConfig * _Nonnull)config SWIFT_METHOD_FAMILY(none);
/// Calling this api would popup a dialog, user can finish login flow on it. In which dialog, user can login with third method like google, twitter. Or he can login with his email which registered on our website.
/// baseController： baseController will present of SFSafariViewController
- (void)StartLoginOnSuccess:(void (^ _Nonnull)(NSDictionary<NSString *, id> * _Nullable))onSuccess onFail:(void (^ _Nonnull)(void))onFail;
/// Logs out a user
- (void)loginOutOnSuccess:(void (^ _Nullable)(void))onSuccess onFail:(void (^ _Nullable)(void))onFail;
/// This method handles URLScheme. If you do not call this method, you will not be able to get the callback of login information
- (void)handleOpenWithUrl:(NSURL * _Nonnull)url;
/// Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.
- (void)CheckAuthenticated:(void (^ _Nullable)(BOOL))onBool;
/// Open a webview which would show the wallet page.
- (void)OpenWallet;
/// Check user’s info, then we can get user’s base information such as wallet address and so on.
- (void)QueryUserWithEmail:(NSString * _Nonnull)email onUserFetched:(void (^ _Nullable)(NSString * _Nullable))onUserFetched onFetchFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFetchFailed;
/// Get access token so that users can visit APIs.
- (void)GetAccessTokenWithCallBack:(void (^ _Nullable)(NSString * _Nonnull))callBack;
///
- (void)GetWalletTokensOnSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
///
- (void)GetWalletTransactionsWithLimit:(NSInteger)limit next_before:(NSString * _Nonnull)next_before onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
///
- (void)GetWalletTransactionsBySignature:(NSString * _Nonnull)signature onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
///
- (void)TransferSolToAnotherAddressTo_publickey:(NSString * _Nonnull)to_publickey amount:(NSInteger)amount onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
- (void)TransferTokenToAnotherAddressTo_publickey:(NSString * _Nonnull)to_publickey amount:(NSInteger)amount token_mint:(NSString * _Nonnull)token_mint decimals:(NSInteger)decimals onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(void))onFailed;
/// Mint a new NFT.
- (void)MintNewNFTWithCollection_mint:(NSString * _Nonnull)collection_mint name:(NSString * _Nonnull)name symbol:(NSString * _Nonnull)symbol url:(NSString * _Nonnull)url seller_fee_basis_points:(NSInteger)seller_fee_basis_points confirmation:(NSString * _Nonnull)confirmation onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)MintNewCollectionWithName:(NSString * _Nonnull)name symbol:(NSString * _Nonnull)symbol url:(NSString * _Nonnull)url confirmation:(NSString * _Nonnull)confirmation seller_fee_basis_points:(NSInteger)seller_fee_basis_points onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
/// Fetch the details of a NFT.
- (void)FetchSingleNFTWithMint_Address:(NSString * _Nonnull)mint_Address onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)TransferNFTToAnotherSolanaWalletWithMint_address:(NSString * _Nonnull)mint_address to_wallet_address:(NSString * _Nonnull)to_wallet_address confirmation:(NSString * _Nonnull)confirmation onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
/// Get list of NFT on market place.
- (void)ListNFTWithMint_address:(NSString * _Nonnull)mint_address price:(double)price confirmation:(NSString * _Nonnull)confirmation onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
/// Cancel listing of NFT.
- (void)CancelNFTListingWithMint_address:(NSString * _Nonnull)mint_address price:(double)price onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
- (void)FetchNFTsByMintAddressesWithMint_address:(NSString * _Nonnull)mint_address onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
/// Get a collection of NFT by creator addresses.
- (void)FetchNFTsByCreatorAddressesWithCreators:(NSArray<NSString *> * _Nonnull)creators limit:(double)limit offset:(double)offset onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
/// Get a collection of NFT by authority addresses.
- (void)FetchNFTsByUpdateAuthoritiesWithUpdate_authorities:(NSArray<NSString *> * _Nonnull)update_authorities limit:(double)limit offset:(double)offset onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
/// Get a collection of NFT by mint addresses.
- (void)FetchNFTsByOwnerAddressWithOwners:(NSArray<NSString *> * _Nonnull)owners limit:(double)limit offset:(double)offset onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
///
- (void)BuyNFTWithMint_address:(NSString * _Nonnull)mint_address price:(double)price onSuccess:(void (^ _Nullable)(NSString * _Nullable))onSuccess onFailed:(void (^ _Nullable)(NSInteger, NSString * _Nullable))onFailed;
@end


@interface MirrorWorldSDK (SWIFT_EXTENSION(MirrorWorldSDK))
+ (UIViewController * _Nullable)getBaseViewController SWIFT_WARN_UNUSED_RESULT;
@end




SWIFT_CLASS("_TtC14MirrorWorldSDK22MirrorWorldSDKAuthData")
@interface MirrorWorldSDKAuthData : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14MirrorWorldSDK20MirrorWorldSDKConfig")
@interface MirrorWorldSDKConfig : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

#endif
#if defined(__cplusplus)
#endif
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#else
#error unsupported Swift architecture
#endif
