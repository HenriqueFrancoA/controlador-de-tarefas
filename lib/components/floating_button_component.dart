import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FloatingButtonMenu extends StatefulWidget {
  final List<IconData> icons;
  final List<VoidCallback> onPresseds;
  final List<String> nomesBotoes;

  const FloatingButtonMenu({
    super.key,
    required this.icons,
    required this.onPresseds,
    required this.nomesBotoes,
  });

  @override
  FloatingButtonMenuState createState() => FloatingButtonMenuState();
}

class FloatingButtonMenuState extends State<FloatingButtonMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      isOpened = !isOpened;
      if (isOpened) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(
      const SizedBox(
        height: 30,
      ),
    );

    for (int i = 0; i < widget.icons.length; i++) {
      children.add(
        ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: const Interval(
                0.0,
                0.5,
                curve: Curves.linear,
              ),
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: widget.onPresseds[i],
                child: Container(
                  height: 50,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 2.h,
                      ),
                      Text(
                        widget.nomesBotoes[i],
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(
                          widget.icons[i],
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        ),
      );
    }

    children.add(
      FloatingActionButton(
        heroTag: null,
        backgroundColor:
            isOpened ? Colors.white : Theme.of(context).colorScheme.background,
        shape: const CircleBorder(),
        onPressed: toggle,
        child: Icon(
          isOpened ? Icons.close : Icons.add,
          color: Colors.black,
        ),
      ),
    );

    return Stack(
      children: [
        if (isOpened)
          GestureDetector(
            onTap: toggle,
            child: Container(
              color: Colors.white.withOpacity(0),
              width: 100.w,
              height: 100.h,
            ),
          ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children,
          ),
        ),
      ],
    );
  }
}
