import 'package:flutter/material.dart';
import 'slider.dart';

class SliderWidget extends StatefulWidget {
  final double sliderHeight;

  final int min;
  final int max;
  static double myvalue =0;
  final fullWidth;

  SliderWidget(
      {this.sliderHeight = 55,
        this.max = 50,
        this.min = 8,
        this.fullWidth = true
      });

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> {


  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((this.widget.sliderHeight * .4)),
        ),
        gradient: const LinearGradient(
            colors: [

              Color(0xFFffcb47),
              Colors.orange

            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
            2, this.widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '${this.widget.min}',

              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "PoppinsRegular",
                letterSpacing: 1.6,
                fontSize: this.widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,

              ),
            ),
            SizedBox(
              width: this.widget.sliderHeight * .1,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(

                    valueIndicatorTextStyle: TextStyle(
                      fontFamily: "PoppinsRegular",
                      letterSpacing: 1.6,
                    ),
                    thumbColor: Color(0xFFa0acb8),
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(.5),

                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: this.widget.sliderHeight * .4,
                      min: this.widget.min,
                      max: this.widget.max,
                    ),
                    overlayColor: Colors.white.withOpacity(.4),
                    valueIndicatorColor: Colors.orange,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                  ),
                  child: Slider(
                      divisions: 15,
                      value: SliderWidget.myvalue ?? 0,
                      onChanged: (value) {

                        setState(() {
                          SliderWidget.myvalue= value;
                        });
                      }),
                ),
              ),
            ),
            SizedBox(
              width: this.widget.sliderHeight * .1,
            ),
            Text(
              '${this.widget.max}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "PoppinsRegular",
                letterSpacing: 1.6,
                fontSize: this.widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}