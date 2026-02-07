# 🚀 Ultimate Android App Release Checklist for AI-Assisted Developers

> **Status:** Ready
> **App Name:** Cyber Tetris
> **Version:** 1.0.0+1
> **Date:** 2026-02-07

---

## ⚠️ CRITICAL: IRREVERSIBLE & HIGH-RISK DECISIONS
- [ ] **Package Name**: Confirm `com.gamestudio.cybertetris` is final and unique.
- [ ] **App Signing Key**: Confirm Play App Signing strategy (recommended) and backup upload key.
- [ ] **Application ID**: Verify `applicationId` matches `com.gamestudio.cybertetris` in `android/app/build.gradle`.
- [ ] **Restricted Countries**: Confirm any geo restrictions are intentional.

---

## 1. PROJECT FOUNDATION
- [ ] **Project Name Check**: Folder name has no spaces/special chars.
- [ ] **Package Name Verification**: Not `com.example.*` and matches intended ID.
- [ ] **Folder Structure**: `android/` exists and matches package path in `android/app/src/main/kotlin` or `java`.
- [ ] **.gitignore Check**: `key.properties`, `*.jks`, `*.keystore` are ignored.

---

## 2. ANDROID APP IDENTITY
- [ ] **App Label**: `android/app/src/main/AndroidManifest.xml` has correct `android:label`.
- [ ] **Package Name**: `android/app/build.gradle` `defaultConfig { applicationId }` correct.
- [ ] **Versioning**: `pubspec.yaml` `version: x.y.z+code` correct and incrementing.

---

## 3. FIREBASE / BACKEND CONFIGURATION
- [ ] **Firebase**: Not used (skip `google-services.json`).
- [ ] **Local Storage**: Last score persistence verified (SharedPreferences).

---

## 4. PLAY APP SIGNING & KEY MANAGEMENT
- [ ] **Play App Signing**: Decide if enabling Play App Signing.
- [ ] **Release Keystore**: Upload key generated and backed up.
- [ ] **key.properties**: Present and ignored by git.
- [ ] **build.gradle**: Release signing config uses `key.properties` safely.

---

## 5. ANDROID VERSION & TARGET SDK COMPLIANCE
- [ ] **Clean Build**: `flutter clean` run.
- [ ] **Dependencies**: `flutter pub get` clean.
- [ ] **Target SDK**: `targetSdkVersion` meets Play Store requirements.
- [ ] **Android 12+ Exported**: `android:exported` set for all components with intent-filters.
- [ ] **Gradle Compatibility**: AGP/Kotlin versions compatible.
- [ ] **R8 / Proguard**: Release minify/shrink settings confirmed and rules present if needed.

---

## 6. AI-SPECIFIC SAFETY CHECKS
- [ ] **AI Gaps**: Review missing functionality or TODOs.
- [ ] **Structure Validation**: No unexpected folders or duplicated logic files.
- [ ] **Naming Consistency**: File naming and paths consistent.
- [ ] **TODO/FIXME/REPLACE_ME**: Search and resolve.
- [ ] **Secrets**: No API keys or passwords in `lib/`.
- [ ] **Build Files**: No invalid Gradle/plugin changes.
- [ ] **Debug Banner**: `debugShowCheckedModeBanner: false` in `MaterialApp`.

---

## 7. FLUTTER-SPECIFIC CHECKS
- [ ] **Dependency Audit**: No local path deps or unstable git deps.
- [ ] **Assets**: All assets in `pubspec.yaml` exist.
- [ ] **Permissions**: `AndroidManifest.xml` contains only needed permissions.
- [ ] **Internet Permission**: Added if required.

---

## 8. RELEASE BUILD VERIFICATION
- [ ] **Build AAB**: `flutter build appbundle --release` succeeds.
- [ ] **Build APK**: `flutter build apk --release` succeeds.
- [ ] **Install & Run**: App launches and works in release mode.
- [ ] **Size Check**: APK size reasonable.

---

## 9. PLAY STORE COMPLIANCE & IDENTITY
- [ ] **Developer Email**: Support email ready for listing.
- [ ] **Privacy Policy**: URL available (even if no login).
- [ ] **App Access**: No login required (guest-only).
- [ ] **Data Safety**: Declare shared preferences only; no ads, no tracking.

---

## 9a. MONETIZATION DECLARATIONS
- [ ] **Ads**: Confirm NO ad SDKs in Gradle dependencies.
- [ ] **Ad ID Permission**: Ensure not included if no ads.

---

## 10. PRE-SUBMISSION FINAL CHECK
- [ ] **Icon**: Updated launcher icons + adaptive icon.
- [ ] **Screenshots**: 4-5 high quality screenshots.
- [ ] **Feature Graphic**: 1024x500 ready.
- [ ] **Short Description**: 80 chars.
- [ ] **Full Description**: SEO-friendly but accurate.

---

## 11. POST-SUBMISSION SAFETY
- [ ] **Monitor Email**: Watch for Play Console issues.
- [ ] **Crashes/Vitals**: Check after release.
- [ ] **Update Plan**: Version increment strategy ready.

---

## 🚦 FINAL GO / NO-GO
- [ ] **Build AAB** succeeds.
- [ ] **Release APK** runs without crashing.
- [ ] **Keys** backed up.
- [ ] **No hardcoded secrets**.

**If all checked -> 🚀 Upload to Play Console**
