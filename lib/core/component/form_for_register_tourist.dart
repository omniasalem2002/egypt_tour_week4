import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guru/Screens/contact_tour_with_phone.dart';
import 'package:guru/Screens/profile.dart';
import 'package:guru/core/component/custom_text_form_field.dart';
import 'package:guru/core/utils/colors_app.dart';
import 'package:guru/core/utils/custom_text_button.dart';
import 'package:guru/core/utils/styles.dart';
import 'package:guru/logic/tourist/add_tourist_cubit.dart';
import 'package:guru/logic/tourist/add_tourist_state.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormForRegisterTourist extends StatefulWidget {
  final String tourGuideName;
  final String tourGuidePhoneNumber;

  const FormForRegisterTourist(
      {super.key,
      required this.tourGuideName,
      required this.tourGuidePhoneNumber});

  @override
  State<FormForRegisterTourist> createState() => _FormForRegisterTouristState();
}

class _FormForRegisterTouristState extends State<FormForRegisterTourist> {
  void saveData() async {

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Booking Page"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 1, 61, 58),
          foregroundColor: Colors.white,
        ),
        body: BlocListener<AddTouristCubit, TouristState>(
          listener: (context, state) {
            if (state is TouristLoading) {
              // Show loading indicator
              showDialog(
                context: context,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state is TouristSuccess) {
              // Hide loading indicator and show success message
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Profile( tourGuideName: widget.tourGuideName,
                  tourGuidePhoneNumber: widget.tourGuidePhoneNumber,)),
              );
// To dismiss the loading dialog
             /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ContactTourWithPhone(
                      tourGuideName: widget.tourGuideName,
                      tourGuidePhoneNumber: widget.tourGuidePhoneNumber,
                    );
                  },
                ),
              );*/
            } else if (state is TouristFailure) {
              // Hide loading indicator and show error message
              Navigator.pop(context); // To dismiss the loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Lottie.asset("images/reg.json", height: 250),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 1, 61, 58),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      widget.tourGuideName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: context.read<AddTouristCubit>().formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: context
                              .read<AddTouristCubit>()
                              .touristNameController,
                          hintText: "Enter Your Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: context.read<AddTouristCubit>().touristEmailController,
                          hintText: "Enter Your Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // Regex pattern to validate email addresses
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        IntlPhoneField(
                          controller: context.read<AddTouristCubit>().whatsAppNumberController,
                          decoration:  InputDecoration(
                            hintText: "WhatsApp Number",
                            filled: true,
                            hintStyle: Styles.font14BlueSemiBold(context),
                            fillColor:  ColorsApp.moreLightGrey,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'EG', // Default to Egypt
                          onChanged: (phone) {
                            print(phone.completeNumber); // Use this to get the full phone number
                          },
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                          },
                          validator: (phone) {
                            if (phone == null || phone.completeNumber.isEmpty) {
                              return 'Please enter your WhatsApp number';
                            }
                            return null;
                          },
                        ),
                        CustomTextFormField(
                          controller: context
                              .read<AddTouristCubit>()
                              .touristPhoneNumberController,
                          hintText: "Eg:- 01112345678",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }

                            // Check if the phone number starts with '01' and has exactly 11 digits in total
                            if (!RegExp(r'^01[0-9]{9}$').hasMatch(value)) {
                              return 'Please enter a valid Egyptian phone number starting with 01';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: AppTextButton(
                            buttonText: 'See your data',
                            textStyle: Styles.font14LightGreyRegular(context),
                            backgroundColor: ColorsApp.darkPrimary,
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('name',context
                                  .read<AddTouristCubit>()
                                  .touristNameController.text);
                              await prefs.setString('email',context
                                  .read<AddTouristCubit>()
                                  .touristEmailController.text);
                              await prefs.setString('phoneNumber',context
                                  .read<AddTouristCubit>()
                                  .touristPhoneNumberController.text);

                              // Navigate to Profile page after saving data
                              if (context
                                  .read<AddTouristCubit>()
                                  .formKey
                                  .currentState!
                                  .validate()) {
                                context.read<AddTouristCubit>().addTourist();

                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
