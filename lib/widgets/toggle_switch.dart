import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool isOn;
  final Function(bool) onChanged;

  const CustomToggleSwitch({
    Key? key,
    required this.isOn,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final newValue = !isOn;
        onChanged(newValue);
      },
      child: Container(
        width: 51,
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isOn ? const Color(0xff59BC6C) : const Color(0xffE9E9EA),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      blurRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}