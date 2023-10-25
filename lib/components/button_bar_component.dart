import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ButtonBarComponent extends StatefulWidget {
  int selectedIndex;
  ButtonBarComponent({
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);

  @override
  ButtonBarComponentState createState() => ButtonBarComponentState();
}

class ButtonBarComponentState extends State<ButtonBarComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          buildIconButton(
            icon: Icons.library_books_outlined,
            index: 0,
            onPressed: () => {
              setState(() {
                widget.selectedIndex = 0;
              }),
              Get.offNamed("/home_tarefa"),
            },
            context: context,
          ),
          buildIconButton(
            icon: Icons.attach_money,
            index: 1,
            onPressed: () => {
              setState(() {
                widget.selectedIndex = 1;
              }),
              Get.offNamed("/home_financas"),
            },
            context: context,
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    required int index,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    final isSelected = widget.selectedIndex == index;
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).colorScheme.background;

    return Container(
      width: 35,
      decoration: BoxDecoration(
        color: isSelected ? unselectedColor : null,
        borderRadius: BorderRadius.circular(40),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 22,
          color: isSelected ? selectedColor : unselectedColor,
        ),
      ),
    );
  }
}
