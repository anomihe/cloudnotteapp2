import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionBoxes extends StatefulWidget {
  const OptionBoxes(
      {super.key,
      this.optionText,
      this.optionImage,
      this.backgroundLetter,
      this.isSelected = false,
      this.onSelectOption,
      this.isCorrect = false,
      this.highlightColor});

  final String? optionText;
  final String? optionImage;
  final bool? isSelected;
  final bool? isCorrect;
  final Color? highlightColor;

  final String? backgroundLetter; // Optional background letter
  final void Function(String)? onSelectOption;
  @override
  State<OptionBoxes> createState() => _OptionBoxesState();
}

class _OptionBoxesState extends State<OptionBoxes> {
  void _showImageDialog(BuildContext context) {
    if (widget.optionImage != null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.6, // Adjustable height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.transparent,
                  ),
                  child: InteractiveViewer(
                    child: Image.network(
                      widget.optionImage!,
                      fit: BoxFit.contain, // Ensure the entire image is visible
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelectOption != null
          ? () => widget.onSelectOption!(widget.optionText!)
          : null,
      child: Container(
        width: 354.w,
        // height: 70.h,
        decoration: BoxDecoration(
          color: widget.highlightColor ??
              (widget.isSelected == true ? blueShades[1] : whiteShades[0]),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: (widget.isSelected == true)
            ? (widget.isCorrect == true ? greenShades[0] : redShades[0])
            : (widget.isCorrect == true ? greenShades[0] : whiteShades[0]),
            // color: Colors.transparent,
          ),
        ),
        child: Stack(
          children: [
            if (widget.backgroundLetter != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    widget.backgroundLetter!,
                    style: setTextTheme(
                      fontSize: 54.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0x08000000),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 19.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.optionText!,
                      style: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: widget.isSelected == true
                              ? whiteShades[0]
                              : Colors.black),
                      softWrap: true,
                    ),
                  ),
                  widget.optionImage != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 3.w),
                          child: GestureDetector(
                            onTap: () => _showImageDialog(context),
                            child: CircleAvatar(
                              backgroundImage: widget.optionImage != null
                                  ? NetworkImage(widget.optionImage!)
                                  : null,
                              radius: 20.r,
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 3.w),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 20,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
