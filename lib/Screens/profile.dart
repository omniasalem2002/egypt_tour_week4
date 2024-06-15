import 'package:flutter/material.dart';
import 'package:guru/Screens/contact_tour_with_phone.dart';
import 'package:guru/core/utils/colors_app.dart';
import 'package:guru/core/utils/custom_text_button.dart';
import 'package:guru/core/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final tourGuideName;
  final tourGuidePhoneNumber;


  const Profile({Key? key,required this.tourGuideName,required this.tourGuidePhoneNumber}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Initialize variables to store retrieved data
  String name = '';
  String email = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    // Call method to load data from SharedPreferences when widget initializes
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve data from SharedPreferences
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phoneNumber = prefs.getString('phoneNumber') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 61, 58),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
           /* Padding(
              padding: const EdgeInsets.all(3),
              child: AppTextButton(
                buttonText: 'Send Information to Guide',
                textStyle: Styles.font14LightGreyRegular(context),
                backgroundColor: ColorsApp.darkPrimary,
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ContactTourWithPhone(
                          tourGuideName: widget.tourGuideName,
                          tourGuidePhoneNumber: widget.tourGuidePhoneNumber,
                        );
                      },
                    ),
                  );
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
