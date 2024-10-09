// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class UpdateProfile extends StatefulWidget {
//   final bool fromAuthPage;

//   const UpdateProfile({super.key, this.fromAuthPage = false});

//   @override
//   State<UpdateProfile> createState() => _UpdateProfileState();
// }

// class _UpdateProfileState extends State<UpdateProfile> {

//   DateTime selectedDate = DateTime.now();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//   String? _selectedGender;
//   final TextEditingController dateController = TextEditingController();
//   File? _profileImage;
//   bool _isLoading = false;

//   void getUserData() async {
//     // final provider = Provider.of<UserUpdate>(context, listen: false);
//     // userData = await provider.getUserData();
//     // updateProfileData(userData);
//   }

//   // void updateProfileData(UserData2? userData) {
//   //   setState(() {
//   //     _nameController.text = userData?.name ?? '';
//   //     _emailController.text = userData?.phoneNumber ?? '';
//   //     _bioController.text = userData?.bio ?? '';
//   //     _selectedGender = userData?.gender != null ? userData!.gender! : "male";
//   //     if (userData?.dob != null) {
//   //       selectedDate = userData!.dob!;
//   //       dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//   //     }
//   //   });
//   // }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(1960, 8),
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }

//   // Future<void> _pickImage() async {
//   //   final pickedFile =
//   //       await ImagePicker().pickImage(source: ImageSource.gallery);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _profileImage = File(pickedFile.path);
//   //     });
//   //   }
//   // }

//   void _saveForm() async {
//     final name = _nameController.text;
//     final email = _emailController.text;
//     final dateOfBirth = dateController.text;
//     final gender = _selectedGender ?? '';
//     final bio = _bioController.text;

//     // if (name.isEmpty ||
//     //     email.isEmpty ||
//     //     dateOfBirth.isEmpty ||
//     //     gender.isEmpty ||
//     //     bio.isEmpty ||
//     //     (_profileImage == null && userData!.profilePicture == null)) {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(
//     //       content:
//     //           Text('All fields, including the profile picture, are required.'),
//     //     ),
//     //   );
//     //   return;
//     // }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // await context.read<UserUpdate>().updateProfile(
//       //       context: context,
//       //       name: name,
//       //       email: email,
//       //       dateOfBirth: dateOfBirth,
//       //       gender: gender,
//       //       bio: bio,
//       //       profilePicture: _profileImage,
//       //       fromAuthPage: widget.fromAuthPage,
//       //     );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile updated successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update profile: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//     dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: InkWell(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: const Color(0xFF6D53F4),
//         title: Text(
//           'Update Profile',
//           style: GoogleFonts.inter(
//               fontWeight: FontWeight.w500, color: Colors.white),
//         ),
//       ),
//       // extendBody: true,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Center(
//             child: Column(
//               children: [
//                 // Container(
//                 //   padding:
//                 //       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       InkWell(
//                 //         onTap: () {
//                 //           // Navigator.pop(context);
//                 //           // Navigator.of(context).pop();

//                 //           if (Navigator.canPop(context)) {
//                 //             Navigator.of(context).pop();
//                 //           }
//                 //         },
//                 //         child: const CircleAvatar(
//                 //           radius: 17,
//                 //           backgroundColor: Color.fromARGB(255, 237, 235, 243),
//                 //           child: Icon(
//                 //             Icons.arrow_back,
//                 //             color: Colors.black,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //       Text(
//                 //         "Update Profile",
//                 //         style: GoogleFonts.inter(
//                 //           fontSize: 18,
//                 //           fontWeight: FontWeight.w600,
//                 //           color: Colors.black,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),

//                 Container(
//                   margin: const EdgeInsets.only(top: 10, left: 30),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                           backgroundImage: _profileImage != null
//                               ? FileImage(_profileImage!)
//                               : userData?.profilePicture != null
//                                   ? NetworkImage(
//                                       ("$baseUrl/${userData!.profilePicture!}"))
//                                   : const AssetImage(
//                                       "assets/images/upload2.png",
//                                     ) as ImageProvider,
//                           backgroundColor: Colors.blue,
//                           radius: 50,
//                         ),
//                       ),
//                       Text(
//                         "Profile picture",
//                         style: GoogleFonts.inter(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 12.0),
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),
//                       TextField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Phone number',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 12.0),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       InkWell(
//                         onTap: () => _selectDate(context),
//                         child: TextFormField(
//                           controller: dateController,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: 'Date of Birth',
//                             border: OutlineInputBorder(),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16.0, vertical: 12.0),
//                           ),
//                           onTap: () => _selectDate(context),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<String>(
//                         value: _selectedGender,
//                         hint: const Text('Select Gender'),
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 12.0),
//                         ),
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedGender = newValue;
//                           });
//                         },
//                         items: ['male', 'female']
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: _bioController,
//                         maxLines: 3,
//                         decoration: const InputDecoration(
//                           labelText: 'Bio',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 12.0),
//                         ),
//                       ),
//                       const SizedBox(height: 32.0),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _saveForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6D53F4),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   )
//                                 : Text(
//                                     'Save',
//                                     style: GoogleFonts.inter(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String capitalizeFirstLetter(String input) {
//     if (input.isEmpty) {
//       return input;
//     }
//     return input[0].toUpperCase() + input.substring(1);
//   }
// }
