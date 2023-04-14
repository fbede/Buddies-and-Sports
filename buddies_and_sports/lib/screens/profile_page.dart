import 'package:buddies_and_sports/models/interests.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final _coverHeight = 280.0;
  final _profileRadius = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildTop(),
          SizedBox(height: _profileRadius + 16),
          _buildUserName(context),
          _buildPhoneNumber(),
          _buildEmail(),
          const SizedBox(height: 16),
          _buildTitle(context),
          ..._buildInterest(),
        ],
      ),
    );
  }

  List<ListTile> _buildInterest() {
    final prefs = GetIt.I<SharedPreferences>();
    final interestIndexesAsStrings =
        prefs.getStringList(PrefKeys.interestKey) ?? [];

    if (interestIndexesAsStrings.isEmpty) {
      return [];
    }

    return interestIndexesAsStrings.map((e) {
      final index = int.parse(e);
      final interest = Interest.values[index];
      return ListTile(
        leading: Icon(interest.icon),
        title: Text(interest.name),
      );
    }).toList();
  }

  Padding _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Interests',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildEmail() {
    final email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      return const SizedBox.shrink();
    }

    return Text(
      email,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPhoneNumber() {
    final email = FirebaseAuth.instance.currentUser?.email;
    final phone = FirebaseAuth.instance.currentUser?.phoneNumber;

    if (email == null) {
      return const SizedBox.shrink();
    }
    if (phone == null || phone.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      phone,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserName(BuildContext context) {
    final displayName = FirebaseAuth.instance.currentUser?.displayName;
    final email = FirebaseAuth.instance.currentUser?.email;
    final phone = FirebaseAuth.instance.currentUser?.phoneNumber;
    String name = '';
    final emailStringList = email?.split('@') ?? [];

    if (email == null && phone == null && displayName == null) {
      return const SizedBox.shrink();
    }

    if (email == null || emailStringList.length < 2) {
      name = phone!;
    } else {
      name = emailStringList.first;
    }

    if (displayName != null && displayName.isNotEmpty) {
      name = displayName;
    }

    return Text(
      name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Stack _buildTop() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        _buildCoverPage(),
        Positioned(
          top: _coverHeight - _profileRadius,
          child: _buildProfilePicture(),
        )
      ],
    );
  }

  Widget _buildCoverPage() {
    return FadeInImage.assetNetwork(
      image:
          'https://images.unsplash.com/photo-1562920618-af1f5f02f0be?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',
      placeholder: 'assets/images/texture.jpeg',
      width: double.infinity,
      height: 280,
      fit: BoxFit.cover,
    );
  }

  Widget _buildProfilePicture() {
    return const CircleAvatar(
      radius: 70,
      foregroundImage: NetworkImage(
          'https://images.unsplash.com/photo-1522542194-2c2e6ffcf7d8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80'),
      backgroundImage: AssetImage('assets/images/user.png'),
    );
  }
}
