import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/values/app_strings.dart';
import '../../../core/values/images_paths.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 10,
          children: [
            SvgPicture.asset(Assets.onBoarding),
            Text(AppStrings.onBoardingText,
            style: TextStyles.appBarTextStyle),
            SizedBox(
              width: double.infinity,
                child: ElevatedButton(onPressed: (){},

                    child: Text(AppStrings.login) )),
            SizedBox(
              width: double.infinity,
                child: ElevatedButton(onPressed: (){},

                    child: Text(AppStrings.applyNow) )),

          ]
        ),
      ),
    );
  }
}
