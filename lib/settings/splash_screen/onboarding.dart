import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_transport_budget_95t/settings/splash_screen/premium.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/illustration1.png",
      "title": "Control your spending on transportation",
      "description":
          "Make expenses for transportation every day and keep track of your expenses"
    },
    {
      "image": "assets/images/illustration 2.png",
      "title": "Create your\nfavorite routes",
      "description":
          "Add your favorite and popular routes so you don't forget about your daily expenses"
    },
    {
      "image": "assets/images/illustration 3.png",
      "title": "Plan your routes\nin advance",
      "description": "Create goals to save money for expensive routes"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff070707),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => OnboardingContent(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 24.h),
            child: GestureDetector(
              child: Container(
                width: 319.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: const Color(0xff000DFF),
                  borderRadius: BorderRadius.circular(1000),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: const Color(0xffFFFFFF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                if (currentPage == onboardingData.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PremiumScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Terms of Use",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF).withOpacity(0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Restore",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF).withOpacity(0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: const Color(0xffFFFFFF).withOpacity(0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 8.w),
      height: 8.h,
      width: currentPage == index ? 40 : 16,
      decoration: BoxDecoration(
        color: currentPage == index ? Color(0xff1E6CFF) : Color(0xff7D7D7D),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              image,
              width: double.infinity,
              height: 540.h,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            description,
            style: TextStyle(
              color: const Color(0xffFFFFFF).withOpacity(0.6),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
