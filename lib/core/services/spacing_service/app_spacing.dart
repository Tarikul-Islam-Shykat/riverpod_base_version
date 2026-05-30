import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  const AppSpacing._();

  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get xxl => 24.r;
  static double get xxxl => 32.r;

  static SizedBox get verticalXs => SizedBox(height: xs);
  static SizedBox get verticalSm => SizedBox(height: sm);
  static SizedBox get verticalMd => SizedBox(height: md);
  static SizedBox get verticalLg => SizedBox(height: lg);
  static SizedBox get verticalXl => SizedBox(height: xl);
  static SizedBox get verticalXxl => SizedBox(height: xxl);
  static SizedBox get verticalXxxl => SizedBox(height: xxxl);

  static SizedBox get horizontalXs => SizedBox(width: xs);
  static SizedBox get horizontalSm => SizedBox(width: sm);
  static SizedBox get horizontalMd => SizedBox(width: md);
  static SizedBox get horizontalLg => SizedBox(width: lg);
  static SizedBox get horizontalXl => SizedBox(width: xl);
  static SizedBox get horizontalXxl => SizedBox(width: xxl);
  static SizedBox get horizontalXxxl => SizedBox(width: xxxl);

  static EdgeInsets get screenPadding => EdgeInsets.all(lg);
  static EdgeInsets get cardPadding => EdgeInsets.all(lg);
  static EdgeInsets get sectionPadding => EdgeInsets.all(xxl);

  static BorderRadius get radiusSm => BorderRadius.circular(8.r);
  static BorderRadius get radiusMd => BorderRadius.circular(12.r);
  static BorderRadius get radiusLg => BorderRadius.circular(16.r);
  static BorderRadius get radiusXl => BorderRadius.circular(24.r);
}

class DialogSpacing {
  const DialogSpacing._();

  static double get inset => AppSpacing.xxl;
  static double get paddingHorizontal => 22.w;
  static double get paddingTop => 22.h;
  static double get paddingBottom => 18.h;

  static double get iconSize => 64.w;
  static double get iconInnerSize => 30.sp;
  static double get iconToTitle => 18.h;
  static double get titleToMessage => 10.h;
  static double get messageToActions => AppSpacing.xxl;
  static double get actionGap => AppSpacing.md;

  static double get buttonHeight => 48.h;
  static double get buttonRadius => 14.r;
  static double get dialogRadius => AppSpacing.xxl;
  static double get maxWidth => 420.w;

  static EdgeInsets get padding => EdgeInsets.fromLTRB(
        paddingHorizontal,
        paddingTop,
        paddingHorizontal,
        paddingBottom,
      );
}
