import 'package:avatar_course2_5_shop/core/resources/manager_colors.dart';
import 'package:avatar_course2_5_shop/core/resources/manager_font_sizes.dart';
import 'package:avatar_course2_5_shop/core/resources/manager_height.dart';
import 'package:avatar_course2_5_shop/core/resources/manager_strings.dart';
import 'package:avatar_course2_5_shop/core/resources/manager_text_styles.dart';
import 'package:avatar_course2_5_shop/core/resources/manager_width.dart';
import 'package:avatar_course2_5_shop/features/home/presentation/controller/home_controller.dart';
import 'package:avatar_course2_5_shop/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_drawer/slide_drawer.dart';

class SliderDrawer extends StatelessWidget {
  const SliderDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ManagerColors.primaryColor,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: ManagerHeight.h50,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  onPressed: () {
                    SlideDrawer.of(context)?.close();
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                  ),
                ),
              ),
              Text(
                controller.appSettingsSharedPreferences.userName,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSizes.s20,
                  color: ManagerColors.white,
                ),
              ),
              SizedBox(height: ManagerHeight.h14),
              Text(
                controller.appSettingsSharedPreferences.userEmail,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSizes.s18,
                  color: ManagerColors.white,
                ),
              ),
              SizedBox(height: ManagerHeight.h14),
              Column(
                children: [
                  // Home
                  drawerItem(
                    icon: Icons.home,
                    title: ManagerStrings.home,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.homeView);
                    },
                  ),

                  // Notification
                  drawerItem(
                    icon: Icons.notifications,
                    title: ManagerStrings.notifications,
                    onPressed: () {},
                  ),

                  // Profile
                  drawerItem(
                    icon: Icons.person,
                    title: ManagerStrings.profile,
                    onPressed: () {},
                  ),

                  // My Orders
                  drawerItem(
                    icon: Icons.book,
                    title: 'My Orders',
                    onPressed: () {},
                  ),

                  // Payment
                  drawerItem(
                    icon: Icons.payment,
                    title: 'My Payment',
                    onPressed: () {},
                  ),

                  // My Wishlist
                  drawerItem(
                    icon: Icons.star_border,
                    title: 'My Wishlist',
                    onPressed: () {},
                  ),

                  // My Address
                  drawerItem(
                    icon: Icons.add_location,
                    title: 'My Address',
                    onPressed: () {},
                  ),

                  // Support
                  drawerItem(
                    icon: Icons.support_agent_outlined,
                    title: 'Support',
                    onPressed: () {},
                  ),

                  // Language
                  drawerItem(
                    icon: Icons.language,
                    title: 'Language',
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.language);
                    },
                  ),

                  // About
                  drawerItem(
                    icon: Icons.question_mark,
                    title: 'About',
                    onPressed: () {},
                  ),

                  // Logout
                  drawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onPressed: () {
                      controller.performLogout();
                    },
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }

  Widget drawerItem({
    required IconData icon,
    required String title,
    required void Function() onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          SizedBox(width: ManagerWidth.w40),
          Icon(
            icon,
            color: ManagerColors.white,
          ),
          SizedBox(width: ManagerWidth.w20),
          Text(
            title,
            style: getRegularTextStyle(
              color: ManagerColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
