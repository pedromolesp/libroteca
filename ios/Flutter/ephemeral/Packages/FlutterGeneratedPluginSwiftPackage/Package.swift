// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "app_tracking_transparency", path: "../.packages/app_tracking_transparency-2.0.7"),
        .package(name: "cloud_firestore", path: "../.packages/cloud_firestore-6.9.0"),
        .package(name: "cloud_functions", path: "../.packages/cloud_functions-6.4.0"),
        .package(name: "file_picker_darwin", path: "../.packages/file_picker_darwin-1.0.4"),
        .package(name: "firebase_analytics", path: "../.packages/firebase_analytics-12.5.0"),
        .package(name: "firebase_app_check", path: "../.packages/firebase_app_check-0.4.7"),
        .package(name: "firebase_auth", path: "../.packages/firebase_auth-6.6.1"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.14.0"),
        .package(name: "firebase_crashlytics", path: "../.packages/firebase_crashlytics-5.3.0"),
        .package(name: "fluttertoast", path: "../.packages/fluttertoast-10.0.0"),
        .package(name: "google_mobile_ads", path: "../.packages/google_mobile_ads-9.1.0"),
        .package(name: "google_sign_in_ios", path: "../.packages/google_sign_in_ios-6.3.3"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.7"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin-2.4.3+1"),
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview-3.26.1"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "app-tracking-transparency", package: "app_tracking_transparency"),
                .product(name: "cloud-firestore", package: "cloud_firestore"),
                .product(name: "cloud-functions", package: "cloud_functions"),
                .product(name: "file-picker-darwin", package: "file_picker_darwin"),
                .product(name: "firebase-analytics", package: "firebase_analytics"),
                .product(name: "firebase-app-check", package: "firebase_app_check"),
                .product(name: "firebase-auth", package: "firebase_auth"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-crashlytics", package: "firebase_crashlytics"),
                .product(name: "fluttertoast", package: "fluttertoast"),
                .product(name: "google-mobile-ads", package: "google_mobile_ads"),
                .product(name: "google-sign-in-ios", package: "google_sign_in_ios"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
