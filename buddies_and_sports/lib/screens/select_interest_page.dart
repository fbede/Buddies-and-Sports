import 'package:buddies_and_sports/models/interests.dart';
import 'package:buddies_and_sports/router/route_names.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectInterestPage extends StatefulWidget {
  const SelectInterestPage({super.key});

  @override
  State<SelectInterestPage> createState() => _SelectInterestPageState();
}

class _SelectInterestPageState extends State<SelectInterestPage> {
  List<String> selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UserText.Select_Your_Interests),
      ),
      body: Stack(
        children: [
          GridView.builder(
              itemCount: Interest.values.length,
              gridDelegate: getGridDelegate(),
              itemBuilder: (context, index) {
                return _GridItem(
                  interest: Interest.values[index],
                  isSelected: (bool value) => onSelect(value, index),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => saveInterest(),
                child: const Text(UserText.Save_Your_Interests),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveInterest() async {
    final prefs = GetIt.I<SharedPreferences>();
    final router = GoRouter.of(context);

    if (selectedList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(UserText.Please_Select_at_least_one_Interest_Error),
      ));
      return;
    }
    await prefs.setStringList(PrefKeys.interestKey, selectedList);
    await prefs.setBool(PrefKeys.onboardingKey, true);
    router.goNamed(Routes.home);
  }

  void onSelect(bool value, int index) {
    if (value) {
      selectedList.add(index.toString());
    } else {
      selectedList.remove(index.toString());
    }
    setState(() {});
    //print(selectedList);
  }

  SliverGridDelegateWithMaxCrossAxisExtent getGridDelegate() {
    return const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 150,
      childAspectRatio: 1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    );
  }
}

class _GridItem extends StatefulWidget {
  final Interest interest;
  final ValueChanged<bool> isSelected;

  const _GridItem({
    required this.interest,
    required this.isSelected,
  });

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(widget.interest.icon),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.interest.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          isSelected
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
