import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_transport_budget_95t/bottom_route.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              child: const Icon(Icons.close),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ButtomRoute(),
                  ),
                  (context) => false,
                );
              },
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/illustration paywall (1).png',
              fit: BoxFit.contain,
              height: 340,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Controlling transportation costs\nhas become easier",
            style: TextStyle(
              color: const Color(0xffFFFFFF),
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            "Unlock all the app's features\njust for \$0.99",
            style: TextStyle(
              color: const Color(0xffFFFFFF),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Container(
            width: 319.w,
            height: 56.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xff000DFF),
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                color: const Color(0xffFFFFFF),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "Terms of use",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Restore",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
