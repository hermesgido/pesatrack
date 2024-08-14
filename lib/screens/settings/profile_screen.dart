import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesatrack/main.dart';
import 'package:pesatrack/screens/home_page.dart';
import 'package:pesatrack/utils/urls.dart';
import 'package:pesatrack/widgets/logout_bottom_modal.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profilePic;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MyApp();
            }));
          },
          child: Icon(
            Icons.arrow_back,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: theme.appBarTheme.foregroundColor),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundImage: profilePic != null
                            ? NetworkImage(("$baseUrl/${profilePic!}"))
                            : const AssetImage("assets/avator.png")
                                as ImageProvider,
                        backgroundColor: theme.colorScheme.secondary,
                        radius: 50,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "My Name",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 85,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: theme.colorScheme.secondary,
                      ),
                      child: const Icon(Icons.shield),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get Premium Plan",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          "Enjoy fantastic features Now",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      child: ProfileSettingItem(
                        iconName: Icons.person_outline,
                        name: "Your Profile",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      child: ProfileSettingItem(
                        iconName: Icons.payment_outlined,
                        name: "Your Pictures",
                      ),
                    ),
                    ProfileSettingItem(
                      iconName: Icons.settings_outlined,
                      name: "Settings",
                    ),
                    ProfileSettingItem(
                      iconName: Icons.info_outline_rounded,
                      name: "Help Center",
                    ),
                    ProfileSettingItem(
                      iconName: Icons.person_add_alt_outlined,
                      name: "Invite Friends",
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      child: ProfileSettingItem(
                        iconName: Icons.lock_open_outlined,
                        name: "Privacy Policy",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: LogoutBottomSheetWidget(),
                            );
                          },
                        );
                      },
                      child: ProfileSettingItem(
                        iconName: Icons.logout_outlined,
                        name: "Logout",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSettingItem extends StatelessWidget {
  final IconData iconName;
  final String name;

  ProfileSettingItem({required this.iconName, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      iconName,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 35),
          color: theme.dividerColor,
        ),
      ],
    );
  }
}
