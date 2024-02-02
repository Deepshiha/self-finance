import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_finance/constants/routes.dart';
import 'package:self_finance/fonts/body_text.dart';
import 'package:self_finance/fonts/strong_heading_one_text.dart';
import 'package:self_finance/models/user_model.dart';
import 'package:self_finance/providers/user_provider.dart';
import 'package:self_finance/util.dart';
import 'package:self_finance/widgets/app_icon.dart';
import 'package:self_finance/widgets/pin_input_widget.dart';
import 'package:self_finance/widgets/round_corner_button.dart';

class PinAuthView extends ConsumerStatefulWidget {
  const PinAuthView({super.key});

  @override
  ConsumerState<PinAuthView> createState() => _PinAuthViewState();
}

class _PinAuthViewState extends ConsumerState<PinAuthView> {
  final TextEditingController pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void getLogin(User user) {
      if (user.userPin == pinController.text) {
        Routes.navigateToDashboard(context: context);
      } else {
        pinController.clear();
      }
    }

    return ref.watch(asyncUserProvider).when(
          data: (data) {
            return Scaffold(
              body: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20.sp),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        data.first.profilePicture != ""
                            ? Hero(tag: "User-image", child: Utility.imageFromBase64String(data.first.profilePicture))
                            : const AppIcon(),
                        SizedBox(height: 20.sp),
                        const StrongHeadingOne(
                          bold: true,
                          text: "Enter your app PIN",
                        ),
                        SizedBox(height: 20.sp),
                        PinInputWidget(
                          pinController: pinController,
                          obscureText: true,
                          validator: (String? p0) {
                            if (p0 != data.first.userPin) {
                              pinController.clear();
                              return "Please enter the correct pin";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.sp),
                        RoundedCornerButton(text: "Login", onPressed: () => getLogin(data.first)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => const Center(
            child: BodyOneDefaultText(text: 'Error fetching user data please restart the app'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}
