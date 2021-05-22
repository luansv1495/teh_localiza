import 'package:flutter/material.dart';

class ContainerGradient extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  const ContainerGradient({Key key, this.child, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: this.colors,
        ),
      ),
      child: this.child,
    );
  }
}
