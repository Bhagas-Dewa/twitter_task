// import 'package:flutter/material.dart';

// extension StringCasingExtension on String {
//   String toCapitalized() =>
//       length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
//   String toTitleCase() => replaceAll(RegExp(' +'), ' ')
//       .split(' ')
//       .map((str) => str.toCapitalized())
//       .join(' ');
// }

// class Font {
//   static var w100 = FontWeights(const TextStyle(fontWeight: FontWeight.w100));
//   static var thin = FontWeights(const TextStyle(fontWeight: FontWeight.w100));
//   static var w200 = FontWeights(const TextStyle(fontWeight: FontWeight.w200));
//   static var extraLight =
//       FontWeights(const TextStyle(fontWeight: FontWeight.w200));
//   static var w300 = FontWeights(const TextStyle(fontWeight: FontWeight.w300));
//   static var light = FontWeights(const TextStyle(fontWeight: FontWeight.w300));
//   static var w400 = FontWeights(const TextStyle(fontWeight: FontWeight.w400));
//   static var regular =
//       FontWeights(const TextStyle(fontWeight: FontWeight.w400));
//   static var normal =
//       FontWeights(const TextStyle(fontWeight: FontWeight.normal));
//   static var w500 = FontWeights(const TextStyle(fontWeight: FontWeight.w500));
//   static var medium = FontWeights(const TextStyle(fontWeight: FontWeight.w500));
//   static var w600 = FontWeights(const TextStyle(fontWeight: FontWeight.w600));
//   static var semiBold =
//       FontWeights(const TextStyle(fontWeight: FontWeight.w600));
//   static var w700 = FontWeights(const TextStyle(fontWeight: FontWeight.w700));
//   static var bold = FontWeights(const TextStyle(fontWeight: FontWeight.w700));
//   static var w800 = FontWeights(const TextStyle(fontWeight: FontWeight.w800));
//   static var extraBold =
//       FontWeights(const TextStyle(fontWeight: FontWeight.w800));
//   static var w900 = FontWeights(const TextStyle(fontWeight: FontWeight.w900));
//   static var black = FontWeights(const TextStyle(fontWeight: FontWeight.w900));

//   TextStyle call(
//       {Color color = Colors.black,
//       double size = 12,
//       String? family,
//       FontWeight weight = FontWeight.normal}) {
//     return TextStyle(
//         color: color, fontSize: size, fontFamily: family, fontWeight: weight);
//   }

//   static TextStyle style(
//       {Color clr = Colors.black,
//       double size = 12,
//       String? family,
//       FontWeight weight = FontWeight.normal}) {
//     return TextStyle(
//         color: clr, fontSize: size, fontFamily: family, fontWeight: weight);
//   }
// }

// class Bold {
//   TextStyle test = Font.bold.fs1.black.family('');
// }

// class FontWeights {
//   FontWeights(this.style);
//   TextStyle style;
//   TextStyle call() {
//     return style;
//   }

//   late Fs1 fs1 = Fs1(style.copyWith(fontSize: 1));
//   late Fs2 fs2 = Fs2(style.copyWith(fontSize: 2));
//   late Fs3 fs3 = Fs3(style.copyWith(fontSize: 3));
//   late Fs4 fs4 = Fs4(style.copyWith(fontSize: 4));
//   late Fs5 fs5 = Fs5(style.copyWith(fontSize: 5));
//   late Fs6 fs6 = Fs6(style.copyWith(fontSize: 6));
//   late Fs7 fs7 = Fs7(style.copyWith(fontSize: 7));
//   late Fs8 fs8 = Fs8(style.copyWith(fontSize: 8));
//   late Fs9 fs9 = Fs9(style.copyWith(fontSize: 9));
//   late Fs10 fs10 = Fs10(style.copyWith(fontSize: 10));
//   late Fs11 fs11 = Fs11(style.copyWith(fontSize: 11));
//   late Fs12 fs12 = Fs12(style.copyWith(fontSize: 12));
//   late Fs13 fs13 = Fs13(style.copyWith(fontSize: 13));
//   late Fs14 fs14 = Fs14(style.copyWith(fontSize: 14));
//   late Fs15 fs15 = Fs15(style.copyWith(fontSize: 15));
//   late Fs16 fs16 = Fs16(style.copyWith(fontSize: 16));
//   late Fs17 fs17 = Fs17(style.copyWith(fontSize: 17));
//   late Fs18 fs18 = Fs18(style.copyWith(fontSize: 18));
//   late Fs19 fs19 = Fs19(style.copyWith(fontSize: 19));
//   late Fs20 fs20 = Fs20(style.copyWith(fontSize: 20));
//   late Fs21 fs21 = Fs21(style.copyWith(fontSize: 21));
//   late Fs22 fs22 = Fs22(style.copyWith(fontSize: 22));
//   late Fs23 fs23 = Fs23(style.copyWith(fontSize: 23));
//   late Fs24 fs24 = Fs24(style.copyWith(fontSize: 24));
//   late Fs25 fs25 = Fs25(style.copyWith(fontSize: 25));
//   late Fs26 fs26 = Fs26(style.copyWith(fontSize: 26));
//   late Fs27 fs27 = Fs27(style.copyWith(fontSize: 27));
//   late Fs28 fs28 = Fs28(style.copyWith(fontSize: 28));
//   late Fs29 fs29 = Fs29(style.copyWith(fontSize: 29));
//   late Fs30 fs30 = Fs30(style.copyWith(fontSize: 30));
//   late Fs31 fs31 = Fs31(style.copyWith(fontSize: 31));
//   late Fs32 fs32 = Fs32(style.copyWith(fontSize: 32));
//   late Fs33 fs33 = Fs33(style.copyWith(fontSize: 33));
//   late Fs34 fs34 = Fs34(style.copyWith(fontSize: 34));
//   late Fs35 fs35 = Fs35(style.copyWith(fontSize: 35));
//   late Fs36 fs36 = Fs36(style.copyWith(fontSize: 36));
//   late Fs37 fs37 = Fs37(style.copyWith(fontSize: 37));
//   late Fs38 fs38 = Fs38(style.copyWith(fontSize: 38));
//   late Fs39 fs39 = Fs39(style.copyWith(fontSize: 39));
//   late Fs40 fs40 = Fs40(style.copyWith(fontSize: 40));
//   late Fs41 fs41 = Fs41(style.copyWith(fontSize: 41));
//   late Fs42 fs42 = Fs42(style.copyWith(fontSize: 42));
//   late Fs43 fs43 = Fs43(style.copyWith(fontSize: 43));
//   late Fs44 fs44 = Fs44(style.copyWith(fontSize: 44));
//   late Fs45 fs45 = Fs45(style.copyWith(fontSize: 45));
//   late Fs46 fs46 = Fs46(style.copyWith(fontSize: 46));
//   late Fs47 fs47 = Fs47(style.copyWith(fontSize: 47));
//   late Fs48 fs48 = Fs48(style.copyWith(fontSize: 48));
//   late Fs49 fs49 = Fs49(style.copyWith(fontSize: 49));
//   late Fs50 fs50 = Fs50(style.copyWith(fontSize: 50));
//   late Fs50 fs51 = Fs50(style.copyWith(fontSize: 51));
//   late Fs50 fs52 = Fs50(style.copyWith(fontSize: 52));
//   late Fs50 fs53 = Fs50(style.copyWith(fontSize: 53));
//   late Fs50 fs54 = Fs50(style.copyWith(fontSize: 54));
//   late Fs50 fs55 = Fs50(style.copyWith(fontSize: 55));
//   late Fs50 fs56 = Fs50(style.copyWith(fontSize: 56));
//   late Fs50 fs57 = Fs50(style.copyWith(fontSize: 57));
//   late Fs50 fs58 = Fs50(style.copyWith(fontSize: 58));
//   late Fs50 fs59 = Fs50(style.copyWith(fontSize: 59));
//   late Fs50 fs60 = Fs50(style.copyWith(fontSize: 60));
// }

// class Regular {
//   TextStyle call() {
//     return const TextStyle(fontWeight: FontWeight.w500);
//   }

//   Fs12 fs12 = Fs12(const TextStyle(fontWeight: FontWeight.w500));
// }

// class FontColors {
//   FontColors(this.style);
//   final TextStyle style;
//   late FontColor black = FontColor(color: Colors.black, style: style);
//   late FontColor customBlack = FontColor(color: BaseColor.black, style: style);
//   late FontColor white = FontColor(color: Colors.white, style: style);
//   late FontColor grey = FontColor(color: BaseColor.grey, style: style);
//   late FontColor blackHome =
//       FontColor(color: BaseColor.blackHome, style: style);
//   late FontColor customGrey =
//       FontColor(color: BaseColor.customGrey, style: style);
//   late FontColor blackHome2 =
//       FontColor(color: BaseColor.blackHome2, style: style);
//   late FontColor greyNavbar =
//       FontColor(color: BaseColor.greyNavbar, style: style);
//   late FontColor customPink =
//       FontColor(color: BaseColor.customPink, style: style);
//   late FontColor customPinkMuda =
//       FontColor(color: BaseColor.customPinkMuda, style: style);
//   late FontColor softPink = FontColor(color: BaseColor.softPink, style: style);
//   late FontColor whiteBeige =
//       FontColor(color: BaseColor.whiteBeige, style: style);

//   FontColor color(int color) {
//     return FontColor(
//         color: Color(color), style: style.copyWith(color: Color(color)));
//   }
// }

// class FontColor {
//   FontColor({required this.color, required this.style});
//   Color color;
//   TextStyle style;
//   TextStyle call() {
//     return style.copyWith(color: color);
//   }

//   late FontFamily family = FontFamily(style.copyWith(color: color));
// }

// class FontFamily {
//   FontFamily(this.style);
//   TextStyle style;
//   TextStyle call(String family) {
//     return style.copyWith(fontFamily: family);
//   }
// }

// class Fs1 extends FontColors {
//   Fs1(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs2 extends FontColors {
//   Fs2(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs3 extends FontColors {
//   Fs3(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs4 extends FontColors {
//   Fs4(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs5 extends FontColors {
//   Fs5(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs6 extends FontColors {
//   Fs6(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs7 extends FontColors {
//   Fs7(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs8 extends FontColors {
//   Fs8(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs9 extends FontColors {
//   Fs9(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs10 extends FontColors {
//   Fs10(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs11 extends FontColors {
//   Fs11(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs12 extends FontColors {
//   Fs12(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs13 extends FontColors {
//   Fs13(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs14 extends FontColors {
//   Fs14(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs15 extends FontColors {
//   Fs15(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs16 extends FontColors {
//   Fs16(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs17 extends FontColors {
//   Fs17(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs18 extends FontColors {
//   Fs18(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs19 extends FontColors {
//   Fs19(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs20 extends FontColors {
//   Fs20(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs21 extends FontColors {
//   Fs21(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs22 extends FontColors {
//   Fs22(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs23 extends FontColors {
//   Fs23(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs24 extends FontColors {
//   Fs24(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs25 extends FontColors {
//   Fs25(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs26 extends FontColors {
//   Fs26(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs27 extends FontColors {
//   Fs27(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs28 extends FontColors {
//   Fs28(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs29 extends FontColors {
//   Fs29(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs30 extends FontColors {
//   Fs30(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs31 extends FontColors {
//   Fs31(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs32 extends FontColors {
//   Fs32(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs33 extends FontColors {
//   Fs33(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs34 extends FontColors {
//   Fs34(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs35 extends FontColors {
//   Fs35(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs36 extends FontColors {
//   Fs36(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs37 extends FontColors {
//   Fs37(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs38 extends FontColors {
//   Fs38(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs39 extends FontColors {
//   Fs39(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs40 extends FontColors {
//   Fs40(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs41 extends FontColors {
//   Fs41(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs42 extends FontColors {
//   Fs42(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs43 extends FontColors {
//   Fs43(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs44 extends FontColors {
//   Fs44(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs45 extends FontColors {
//   Fs45(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs46 extends FontColors {
//   Fs46(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs47 extends FontColors {
//   Fs47(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs48 extends FontColors {
//   Fs48(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs49 extends FontColors {
//   Fs49(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }

// class Fs50 extends FontColors {
//   Fs50(super.styles);
//   TextStyle call() {
//     return super.style;
//   }
// }
