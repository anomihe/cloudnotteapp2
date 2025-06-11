import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomTextFormField extends StatelessWidget {
  final String? text;
  final String? rowText;
  final Widget? rowWidget;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final bool? obscureText;
  final bool? expands;
  final int? minLines;
  final int? maxLines;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final TextAlignVertical? textAlignVertical;
  final double? borderRadius;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? initialValue;
  final void Function(String)? onChanged;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomRightRadius;
  final double? bottomLeftRadius;
  final FocusNode? focusNode;
  // final double? height;
  final double? lineHeight;
  final bool? isDense;

  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.text,
    this.rowText,
    this.rowWidget,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.controller,
    this.obscureText,
    this.expands,
    this.minLines,
    this.maxLines,
    this.border,
    this.focusedBorder,
    this.textAlignVertical,
    this.borderRadius,
    this.fillColor,
    this.contentPadding,
    this.initialValue,
    this.onChanged,
    this.titleFontSize,
    this.titleFontWeight,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomRightRadius,
    this.bottomLeftRadius,
    this.focusNode,
    // this.height,
    this.lineHeight,
    this.isDense,
    this.onEditingComplete,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null)
          Text(
            '$text',
            style: setTextTheme(
              fontSize: titleFontSize ?? 14.sp,
              fontWeight: titleFontWeight ?? FontWeight.w700,
            ),
          ),
        if (rowText != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$rowText',
                style:
                    setTextTheme(fontSize: 14.sp, fontWeight: FontWeight.w700),
              ),
              if (rowWidget != null) rowWidget!,
            ],
          ),
        SizedBox(height: 5.h),
        TextFormField(
          controller: controller,
          expands: expands ?? false,
          maxLines: maxLines,
          minLines: minLines,
          initialValue: initialValue,
          focusNode: focusNode,
          textAlignVertical: textAlignVertical,
          style: setTextTheme(
            fontSize: 14.sp,
            lineHeight: lineHeight,
          ),
          decoration: InputDecoration(
            isDense: isDense,
            contentPadding: contentPadding,
            fillColor: fillColor ??
                (ThemeProvider().isDarkMode
                    ? blueShades[15]
                    : Colors.transparent) as Color?,
            filled: true,
            hintText: hintText,
            hintStyle: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: whiteShades[3],
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5.r),
              borderSide: BorderSide(
                color: ThemeProvider().isDarkMode
                    ? blueShades[21]
                    : blueShades[18],
              ),
            ),
            border: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 5.r),
                  borderSide: BorderSide(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[21]
                        : blueShades[18],
                  ),
                ),
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 5.r),
                  borderSide: BorderSide(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[21]
                        : blueShades[18],
                  ),
                ),
          ),
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CustomDropdownFormField<T> extends StatelessWidget {
  final String? hintText;
  final String? title;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged onChanged;
  final Color? fillColor;
  final dynamic value;
  final void Function(dynamic)? onSaved;
  final void Function()? onTap;
  final Widget? icon;
  final double? iconSize;
  final double? borderRadius;

  const CustomDropdownFormField({
    super.key,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.title,
    this.fillColor,
    this.value,
    this.onSaved,
    this.onTap,
    this.icon,
    this.iconSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.r,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        DropdownButtonFormField<T>(
          iconSize: iconSize ?? 24.0,
          icon: icon,
          hint: hintText == null
              ? SizedBox(
                  width: 100.w,
                  child: Text(
                    items.first.value.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: setTextTheme(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : SizedBox(
                  width: 100.w,
                  child: Text(
                    '$hintText',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: setTextTheme(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: whiteShades[3],
                    ),
                  ),
                ),
          style: setTextTheme(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5.r),
              borderSide: BorderSide(
                color: ThemeProvider().isDarkMode
                    ? blueShades[21]
                    : blueShades[18],
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5.r),
              borderSide: BorderSide(
                color: ThemeProvider().isDarkMode
                    ? blueShades[21]
                    : blueShades[18],
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 15.w,
            ),
            filled: true,
            fillColor: fillColor ??
                (ThemeProvider().isDarkMode
                    ? blueShades[15]
                    : Colors.transparent) as Color?,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          value: value,
          onSaved: onSaved,
          onChanged: onChanged,
          onTap: onTap,
          items: items,
        ),
      ],
    );
  }
}

class CustomIntlPhoneField extends StatelessWidget {
  const CustomIntlPhoneField({
    super.key,
    this.hintText,
    this.initialCountryCode,
  });

  final String? hintText;
  final String? initialCountryCode;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      style: setTextTheme(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: setTextTheme(
          fontSize: 14.sp,
          color: whiteShades[3],
          fontWeight: FontWeight.w700,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: ThemeProvider().isDarkMode ? blueShades[21] : blueShades[18],
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: ThemeProvider().isDarkMode ? blueShades[21] : blueShades[18],
          ),
        ),
      ),
      initialCountryCode: initialCountryCode, // Default country code
      // keyboardType: TextInputType.number,

      onChanged: (phone) {
        print(phone.completeNumber);
      },
    );
  }
}
