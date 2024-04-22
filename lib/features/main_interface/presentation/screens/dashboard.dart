import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:knob_widget/knob_widget.dart';
import '../bloc/data_cubit.dart';
import '../widgets/knob_wheel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _precisionDecimalDigits = 2;
const _startAngle = -45.0;
const _endAngle = 225.0;
const _minimum = 0.0;
const _maximum = 180.0;
const _size = 150.0;
const _labelOffset = -10.05;
const _tickOffset = 5.0;
const _minorTicksPerInterval = 12;
const _showMinorTickLabels = true;

const _minHorizontalSeparation = 10.0;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});

  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _show3DModel = false;

  late KnobController _bodyKnobController;
  late double _bodyKnobValue;

  late KnobController _armKnobController;
  late double _armKnobValue;

  void valueChangedListenerBodyKnob(double value) {
    if (mounted) {
      setState(() {
        _bodyKnobValue = value;

        BlocProvider.of<DataCubit>(context).setHorizontalAngle(value);
      });
    }
  }

  void valueChangedListenerArmKnob(double value) {
    if (mounted) {
      setState(() {
        _armKnobValue = value;

        BlocProvider.of<DataCubit>(context).setVerticalAngle(value);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bodyKnobValue = _minimum;
    _bodyKnobController = KnobController(
      initial: _bodyKnobValue,
      minimum: _minimum,
      maximum: _maximum,
      startAngle: _startAngle,
      endAngle: _endAngle,
      precision: _precisionDecimalDigits,
    );
    _bodyKnobController.addOnValueChangedListener(valueChangedListenerBodyKnob);

    _armKnobValue = _minimum;
    _armKnobController = KnobController(
      initial: _armKnobValue,
      minimum: _minimum,
      maximum: _maximum,
      startAngle: _startAngle,
      endAngle: _endAngle,
      precision: _precisionDecimalDigits,
    );
    _armKnobController.addOnValueChangedListener(valueChangedListenerArmKnob);
  }

  @override
  Widget build(BuildContext context) {
    final KnobStyle style = KnobStyle(
      labelStyle: Theme
          .of(context)
          .textTheme
          .bodySmall,
      tickOffset: _tickOffset,
      labelOffset: _labelOffset,
      minorTicksPerInterval: _minorTicksPerInterval,
      showMinorTickLabels: _showMinorTickLabels,
    );


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: BlocListener<DataCubit, DataState>(
        listener: (context, state) {
          if(state is DataFetchLoaded){
            print("Data is loaded! Setting the Knob values.");

            _armKnobController.setCurrentValue(
                (state)
                    .data!['VerticalAngle']);
            _bodyKnobController.setCurrentValue(
                (state)
                    .data!['HorizontalAngle']);
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: _show3DModel,
                  child: const SizedBox(
                    height: 300,
                    width: 500,
                    child: ModelViewer(
                      backgroundColor: Colors.transparent,
                      src: 'assets/3d_models/solar_tracker_model.gltf',
                      alt: '3D Model',
                      autoRotate: true,
                      disableZoom: false,
                      loading: Loading.eager,
                      reveal: Reveal.auto,
                      cameraControls: true,
                      autoPlay: true,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _show3DModel = !_show3DModel;
                    });
                  },
                  child: Text(_show3DModel ? "Hide 3D Model" : "Show 3D Model"),
                ),
                const SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: _size * 4,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        KnobWheel(
                            controller: _bodyKnobController,
                            size: _size,
                            style: style,
                            label: 'Body Knob Value: ${_bodyKnobValue.toString()}'),
                        const SizedBox(width: _minHorizontalSeparation),
                        //  vertical line
                        Container(
                          width: 1,
                          height: _size,
                          color: Colors.black,
                        ),
                        const SizedBox(width: _minHorizontalSeparation),

                        KnobWheel(
                          controller: _armKnobController,
                          size: _size,
                          style: style,
                          label: 'Arm Knob Value: ${_armKnobValue.toString()}',
                        ),
                      ],
                    ),

                  ),
                ),
                OutlinedButton(onPressed: () {
                  BlocProvider.of<DataCubit>(context).getDataSnapshot();
                }, child: const Text("Update From Server"),),
              ],
            ),
          ),
        ),
      ),


    );
  }

  @override
  void dispose() {
    _bodyKnobController.removeOnValueChangedListener(valueChangedListenerBodyKnob);
    _bodyKnobController.dispose();
    _armKnobController.removeOnValueChangedListener(valueChangedListenerArmKnob);
    _armKnobController.dispose();
    super.dispose();
  }
}
