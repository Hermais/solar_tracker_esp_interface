import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/widgets/switch.dart';
import '../bloc/data_cubit.dart';
import '../widgets/knob_wheel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _precisionDecimalDigits = 0;
const _startAngle = -45.0;
const _endAngle = 225.0;
const _minimum = 0.0;
const _maximum = 180.0;

const _labelOffset = -10.05;
const _tickOffset = 5.0;
const _minorTicksPerInterval = 12;
const _showMinorTickLabels = true;

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

  var _isModeSwitched = false;

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
      labelStyle: Theme.of(context).textTheme.bodySmall,
      tickOffset: _tickOffset,
      labelOffset: _labelOffset,
      minorTicksPerInterval: _minorTicksPerInterval,
      showMinorTickLabels: _showMinorTickLabels,
    );

    var knobSize = MediaQuery.of(context).size.width / 4.5;

    final intrinsicDeviceWidth = MediaQuery.of(context).size.width;
    final intrinsicDeviceHeight = MediaQuery.of(context).size.height;

    print("Intrinsic Device Width: $intrinsicDeviceWidth");
    print("Intrinsic Device Height: $intrinsicDeviceHeight");
    var modelWindowSize = intrinsicDeviceWidth * 0.95;

    const minHorizontalSeparation = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: BlocListener<DataCubit, DataState>(
        listener: (context, state) {
          if (state is DataFetchLoaded) {
            print("Data is loaded! Setting the Knob values.");

            try {
              _armKnobController.setCurrentValue(double.parse(
                (state).data!['VerticalAngle'].toString(),
              ));
              _bodyKnobController.setCurrentValue(double.parse(
                (state).data!['HorizontalAngle'].toString(),
              ));
              setState(() {
                _isModeSwitched = (state).data!['Mode'];
              });
            } catch (e) {
              print("Error setting knob values: $e");
              context.read<DataCubit>().emit(DataFetchError(error: e.toString()));
            }
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Data is updated from server successfully!'),
                  elevation: 10,
                ),
              );
          } else if (state is DataFetchError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Error fetching data from server!'),
                  elevation: 10,
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: modelWindowSize,
                  height: modelWindowSize,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _show3DModel
                      ? Visibility(
                          visible: _show3DModel,
                          child: SizedBox(
                            height: modelWindowSize,
                            width: modelWindowSize,
                            child: const ModelViewer(
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
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _show3DModel = !_show3DModel;
                            });
                          },
                          child: Icon(
                            Icons.threed_rotation_rounded,
                            size: 0.8 * modelWindowSize,
                            color: Colors.grey,
                          ),
                        ),
                ),
                SizedBox(height: intrinsicDeviceHeight * 0.01),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _show3DModel = !_show3DModel;
                    });
                  },
                  child: Text(_show3DModel ? "Hide 3D Model" : "Show 3D Model"),
                ),
                SizedBox(height: intrinsicDeviceHeight * 0.01),
                Container(
                    height: 1,
                    width: intrinsicDeviceWidth * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    )),
                SizedBox(height: intrinsicDeviceHeight * 0.01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: modelWindowSize,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: intrinsicDeviceWidth * 0.03),
                        KnobWheel(
                            controller: _bodyKnobController,
                            size: knobSize,
                            style: style,
                            label: 'Body Knob Value: ${_bodyKnobValue.toString()}'),
                        const SizedBox(width: minHorizontalSeparation),
                        //  vertical line
                        Column(
                          children: [
                            Container(
                              width: 1,
                              height: knobSize,
                              color: Colors.black,
                            ),
                            MyToggleSwitch(
                              isSwitched: _isModeSwitched,
                              onChanged: (val) {
                                context.read<DataCubit>().setMode(val);
                                setState(() {
                                  _isModeSwitched = val;
                                });
                              },
                            ),
                             Text("Current Mode",
                                style: TextStyle(
                                  fontSize: intrinsicDeviceWidth * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),),
                          ],
                        ),
                        const SizedBox(width: minHorizontalSeparation),

                        KnobWheel(
                          controller: _armKnobController,
                          size: knobSize,
                          style: style,
                          label: 'Arm Knob Value: ${_armKnobValue.toString()}',
                        ),
                        SizedBox(width: intrinsicDeviceWidth * 0.03),
                      ],
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    BlocProvider.of<DataCubit>(context).getDataSnapshot();
                  },
                  child: const Text("Update From Server"),
                ),
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
