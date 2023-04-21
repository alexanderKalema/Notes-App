import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import '../models/Sample_radio.dart';
import '../services/bloc/screening_bloc/screening_bloc.dart';

class IntroSliderView extends StatefulWidget {
  const IntroSliderView({Key? key}) : super(key: key);

  @override
  State<IntroSliderView> createState() => _IntroSliderViewState();
}

class _IntroSliderViewState extends State<IntroSliderView> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      ContentConfig(
        widgetTitle: SampleRadio(isLanguage: true),
        backgroundColor: Colors.white,
      ),
    );
    listContentConfig.add(
      ContentConfig(
        widgetTitle: SampleRadio(),
        backgroundColor:  Color(0xFF49426e),
      ),
    );
  }

  void onDonePress() async {
    context.read<ScreeningBloc>().add(FinishedOnBoardingEvent());
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.brown,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffF3B4BA),
    );
  }

  Widget renderPreviousBtn() {
    return Icon(
      Icons.navigate_before,
      color: Color(0xffF3B4BA),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      listContentConfig: listContentConfig,

      isShowSkipBtn: false,
//onNextPress: ,
      renderPrevBtn: this.renderPreviousBtn(),
      prevButtonStyle: myButtonStyle(),
      renderNextBtn: this.renderNextBtn(),
      nextButtonStyle: myButtonStyle(),
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      doneButtonStyle: myButtonStyle(),
      // colorDot: Color(0x33FFA8B0),
      // colorActiveDot: Color(0xffFFA8B0),
      // sizeDot: 13.0,
    );
  }
}
