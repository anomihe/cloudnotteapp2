import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AiProfileScreen extends StatelessWidget {
  static const String routeName = '/ai_profile';
  const AiProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: customAppBarLeadingIcon(context)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38.r,
                    child: Image.asset('assets/app/logo_cloudnottapp2.png'),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'cloudnottapp2 Ai',
                    style: setTextTheme(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: ThemeProvider().isDarkMode
                    ? blueShades[15]
                    : whiteShades[7],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  width: 0.5,
                  color: ThemeProvider().isDarkMode
                      ? blueShades[10]
                      : whiteShades[3],
                ),
              ),
              child: Material(
                child: InkWell(
                  onTap: () {
                    _showMediaBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/gallery_icon.svg'),
                      SizedBox(width: 10.w),
                      Text(
                        'Media, links and docs',
                        style: setTextTheme(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded, size: 20)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            _buildSection(
              title: 'Description',
              content:
                  'I am an AI assistant powered by Claudnotte. I can help you with various tasks including answering questions, writing, analysis, and lots more.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: 'Capabilities',
              content: '''
• Natural language processing and understanding
• Document analysis and summarization
• Mathematical calculations
• Writing assistance
• Translation services''',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: 'Version Info',
              content: 'Model: Claude 3.5 Sonnet (Preview)\nVersion: 2025.1',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: setTextTheme(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: ThemeProvider().isDarkMode ? blueShades[15] : whiteShades[7],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              width: 0.5,
              color:
                  ThemeProvider().isDarkMode ? blueShades[10] : whiteShades[3],
            ),
          ),
          child: Text(
            content,
            style: setTextTheme(
              fontSize: 10.sp,
              // height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

void _showMediaBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => DefaultTabController(
      length: 3,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeProvider().isDarkMode
                    ? blueShades[15]
                    : whiteShades[7],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'Media',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Documents',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Links',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Media Grid
                  GridView.builder(
                    padding: EdgeInsets.all(16.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/app/mock_person_image.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),

                  // Documents List
                  ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.insert_drive_file),
                        title: Text(
                          'No documents',
                          style: setTextTheme(fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          'No files shared yet',
                          style: setTextTheme(
                            fontSize: 12.sp,
                            color: ThemeProvider().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),

                  // Links List
                  ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.link),
                        title: Text(
                          'No links',
                          style: setTextTheme(fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          'No links shared yet',
                          style: setTextTheme(
                            fontSize: 12.sp,
                            color: ThemeProvider().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
