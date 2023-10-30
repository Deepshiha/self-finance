import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_finance/constants/routes.dart';
import 'package:self_finance/constants/terms_and_conditions_api.dart';
import 'package:self_finance/fonts/body_small_text.dart';
import 'package:self_finance/fonts/body_two_default_text.dart';
import 'package:self_finance/theme/colors.dart';
import 'package:self_finance/fonts/strong_heading_one_text.dart';
import 'package:self_finance/widgets/app_icon.dart';
import 'package:self_finance/widgets/round_corner_button.dart';

class TermsAndConditons extends StatefulWidget {
  const TermsAndConditons({super.key});

  @override
  State<TermsAndConditons> createState() => _TermsAndConditonsState();
}

class _TermsAndConditonsState extends State<TermsAndConditons> {
  bool ticked = false;
  @override
  void initState() {
    ticked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24.sp),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getIcon(),
              _getHeading(),
              _space(),
              _getTermsAndConditions(),
              _getNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  _getNextButton() {
    return Container(
      margin: EdgeInsets.only(top: 20.sp),
      width: double.infinity,
      child: RoundedCornerButton(
        text: "Next",
        onPressed: ticked ? () => Routes.navigateToPinCreationView(context) : null,
      ),
    );
  }

  Container _getTermsAndConditions() {
    return Container(
      height: 88.sp,
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 90.sp,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getTerms(),
              ),
              SizedBox(height: 16.sp),
              _getCheckBoxWithDescription(),
              SizedBox(height: 16.sp),
            ],
          ),
        ),
      ),
    );
  }

  _getTerms() {
    List<Widget> result = [];
    for (var element in termsAndConditionsMap.entries) {
      result.add(BodyTwoDefaultText(text: element.key, bold: true));
      result.add(SizedBox(height: 16.sp));
      for (var element in element.value) {
        result.add(BodyTwoDefaultText(text: element));
        result.add(SizedBox(height: 16.sp));
      }
    }
    return result;
  }

  InkWell _getCheckBoxWithDescription() {
    return InkWell(
      onTap: () => setState(() => ticked = !ticked),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: ticked,
            onChanged: (value) => _getClicked(),
            activeColor: getPrimaryColor,
          ),
          SizedBox(width: 10.sp),
          SizedBox(
            width: 66.sp,
            height: 30.sp,
            child: const BodySmallText(
              text:
                  "By using the Self-Finance App, you acknowledge that you have read, understood, and agreed to these Terms and Conditions. ",
            ),
          )
        ],
      ),
    );
  }

  dynamic _getClicked() {
    setState(() {
      ticked = !ticked;
    });
  }

  Container _getHeading() {
    return Container(
      alignment: Alignment.topLeft,
      child: const StrongHeadingOne(
        text: "Term & Conditions",
        bold: true,
        textAlign: TextAlign.justify,
      ),
    );
  }

  SizedBox _space() {
    return SizedBox(height: 24.sp);
  }

  Center _getIcon() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 24.sp, bottom: 24.sp),
        child: const AppIcon(),
      ),
    );
  }
}