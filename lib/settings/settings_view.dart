import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    double adaptiveHeight = 575.h;
    if (ScreenUtil().screenHeight <= 667) {
      adaptiveHeight = 590.h;
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 143.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 40.h, 0, 0),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: const Color(0xffFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontSize: 28.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/Line.png',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: adaptiveHeight,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff252525),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 24.w,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/svg/notification.svg'),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Notifications',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 0),
                        card(
                          svg: 'assets/svg/Frame.svg',
                          text: 'Your information',
                          onTap: () {},
                        ),
                        const Divider(height: 0),
                        card(
                          svg: 'assets/svg/Frame (1).svg',
                          text: 'Categories',
                          onTap: () {},
                        ),
                        const Divider(height: 0),
                        card(
                          svg: 'assets/svg/Group 1000003248.svg',
                          text: 'Privacy Policy',
                          onTap: () {},
                        ),
                        const Divider(height: 0),
                        card(
                          svg: 'assets/svg/Frame (2).svg',
                          text: 'Terms of Use',
                          onTap: () {},
                        ),
                        const Divider(height: 0),
                        card(
                          svg: 'assets/svg/Group 1000003250.svg',
                          text: 'Support',
                          onTap: () {},
                        ),
                        const Divider(height: 0),
                        card(
                          svg: 'assets/svg/Frame (3).svg',
                          text: 'Share',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector card({
    required String svg,
    required String text,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 16.w,
          ),
          child: Row(
            children: [
              SvgPicture.asset(svg),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xff7D7D7D),
              )
            ],
          ),
        ),
      ),
    );
  }
}
