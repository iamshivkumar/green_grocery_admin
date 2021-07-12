import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/view_models/auth_view_model/auth_view_model_provider.dart';
import 'home/home_page.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    var authModel = watch(authViewModelProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Theme(
        data: ThemeData.dark().copyWith(
          accentColor: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Admin Login",
                  style: style.headline4!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: authModel.phoneNumberController,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          prefixText: "+91 ",
                        ),
                      ),
                    ),
                    authModel.phoneLoading
                        ? CircularProgressIndicator(
                          color: theme.cardColor,
                        )
                        : OutlinedButton(
                            onPressed: () {
                              authModel.startPhoneAuth(
                                onVerify: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Send OTP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: authModel.smsController,
                  enabled: authModel.otpSent,
                  autofocus: true,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "OTP",
                  ),
                ),
              ),
              authModel.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.cardColor,
                      ),
                    )
                  : Center(
                      child: MaterialButton(
                        color: Colors.white,
                        onPressed: authModel.otpSent
                            ? () async {
                                var user = await authModel.verifyOtp();
                                if (user != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Text(
                          "VERIFY",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
