import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guru/Screens/home_screen.dart';
import 'package:guru/data/models/tourist/TouristModel.dart';
import 'package:guru/data/repos/fire_store_services_for_tourist.dart';
import 'package:guru/logic/tourist/add_tourist_state.dart';

class AddTouristCubit extends Cubit<TouristState> {
  final FireStoreServicesForTourist _fireStoreServices;

  AddTouristCubit(this._fireStoreServices) : super(TouristInitial());

  TextEditingController touristNameController = TextEditingController();
  TextEditingController touristPhoneNumberController = TextEditingController();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addTourist() async {
    emit(TouristLoading());

    try {
      await _fireStoreServices.addTourist(TourisModel(
        name: touristNameController.text,
        phoneNumber: touristPhoneNumberController.text,
      ));
      emit(TouristSuccess());
    } catch (e) {
      emit(TouristFailure(error: e.toString()));
    }
  }

 /* Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Fetch additional user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('tourist')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        print('User Data: $userData');
        // You can navigate to the home screen and pass user data
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        print('No user data found');
        _showErrorDialog(context, 'No user data found.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog(context, 'Wrong password provided.');
      } else if (e.code == 'invalid-email') {
        _showErrorDialog(context, 'Invalid email format.');
      } else {
        _showErrorDialog(context, 'Error: ${e.message}');
      }
    } catch (e) {
      _showErrorDialog(context, 'An unexpected error occurred. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }*/
}
