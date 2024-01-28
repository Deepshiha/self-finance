import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_finance/constants/routes.dart';
import 'package:self_finance/fonts/body_text.dart';
import 'package:self_finance/widgets/pin_input_widget.dart';
import 'package:self_finance/widgets/round_corner_button.dart';

class PinCreatingView extends StatelessWidget {
  const PinCreatingView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController p2 = TextEditingController();
    final TextEditingController p1 = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    bool validateAndSave() {
      final FormState? form = formKey.currentState;
      if (form!.validate()) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.sp),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.sp),
                const BodyOneDefaultText(
                  bold: true,
                  text: "Please create your login pin",
                ),
                SizedBox(height: 20.sp),
                PinInputWidget(pinController: p1, obscureText: false),
                SizedBox(height: 20.sp),
                PinInputWidget(
                  pinController: p2,
                  obscureText: false,
                  validator: (p0) => p1.text == p2.text ? null : "Please provide the same pin",
                ),
                SizedBox(height: 20.sp),
                RoundedCornerButton(
                  onPressed: () {
                    if (validateAndSave()) {
                      Routes.navigateToUserCreationView(context, p1.text);
                    }
                  },
                  text: "save",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
