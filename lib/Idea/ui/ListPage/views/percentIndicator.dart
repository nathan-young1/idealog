import 'package:flutter/material.dart';
import 'package:idealog/design/colors.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PercentageIncidator extends StatelessWidget {
  const PercentageIncidator({
    Key? key,
    required this.percent,
  }) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
    message: 'Completed tasks in percent',
    child: IgnorePointer(
      child: Container(
        height: 52,
        width: 52,
        child: SleekCircularSlider(
          initialValue: percent,
          innerWidget: (double percent)=> Center(
            child: Text('${percent.toInt()}%',
            style: TextStyle(fontSize: 15))),
          appearance: CircularSliderAppearance(
            animationEnabled: false,
            angleRange: 360,
            customWidths: CustomSliderWidths(
              progressBarWidth: 5,
              trackWidth: 5
            ),
            customColors: CustomSliderColors(
              dotColor: Colors.transparent,
              progressBarColor: AddToExistingLight,
              trackColor: LightGray
            )
          ),
        )),
    ),
                      );
  }
}