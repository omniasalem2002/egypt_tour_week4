import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guru/Screens/contact_tour_with_phone.dart';
import 'package:guru/core/component/custom_text_form_field.dart';
import 'package:guru/core/utils/colors_app.dart';
import 'package:guru/core/utils/custom_text_button.dart';
import 'package:guru/core/utils/styles.dart';
import 'package:guru/logic/tourist/add_tourist_cubit.dart';
import 'package:guru/logic/tourist/add_tourist_state.dart';
import 'package:lottie/lottie.dart';

class FormForRegisterTourist extends StatelessWidget {
  final String tourGuideName;
  final String tourGuidePhoneNumber;

  const FormForRegisterTourist(
      {super.key,
      required this.tourGuideName,
      required this.tourGuidePhoneNumber});

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
              Navigator.pop(context); // To dismiss the loading dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ContactTourWithPhone(
                      tourGuideName: tourGuideName,
                      tourGuidePhoneNumber: tourGuidePhoneNumber,
                    );
                  },
                ),
              );
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
                      tourGuideName,
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
                            buttonText: 'Send Information to Guide',
                            textStyle: Styles.font14LightGreyRegular(context),
                            backgroundColor: ColorsApp.darkPrimary,
                            onPressed: () {
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
