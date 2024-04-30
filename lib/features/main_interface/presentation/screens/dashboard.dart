import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/widgets/safe_icon.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/widgets/switch.dart';

import '../../../../core/constants.dart';
import '../bloc/data_cubit.dart';
import '../widgets/knob_wheel.dart';

const _precisionDecimalDigits = 0;
const _startAngle = -45.0;
const _endAngle = 225.0;
const _minimum = 0.0;
const _maximum = 180.0;

const _labelOffset = -5.0;
const _tickOffset = 5.0;
const _minorTicksPerInterval = 12;
const _showMinorTickLabels = true;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});

  final String title;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  bool _show3DModel = false;
  bool _isKnobBeingInteractedWith = false;

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
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: MediaQuery.of(context).size.width * 0.02,
          ),
      tickOffset: _tickOffset,
      labelOffset: _labelOffset,
      minorTicksPerInterval: _minorTicksPerInterval,
      showMinorTickLabels: _showMinorTickLabels,
    );

    var knobSize = MediaQuery.of(context).size.width / 4.5;

    final intrinsicDeviceWidth = MediaQuery.of(context).size.width;
    final intrinsicDeviceHeight = MediaQuery.of(context).size.height;

    var modelWindowSize = intrinsicDeviceWidth * 0.5;
    var knobsBoxSize = intrinsicDeviceWidth * 0.95;

    const minHorizontalSeparation = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<DataCubit>(context).getDataSnapshot();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: BlocListener<DataCubit, DataState>(
        listener: (context, state) {
          if (state is DataSendError || state is DataFetchError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Error fetching or sending data from server!'),
                  elevation: 10,
                  backgroundColor: Colors.red,
                ),
              );
          } else if (state is DataFetchLoaded) {
            print("Data is loaded! Setting the Knob values.");

            try {
              _armKnobController.setCurrentValue(double.parse(
                (state).data.verticalAngle.toString(),
              ));
              _bodyKnobController.setCurrentValue(double.parse(
                (state).data.horizontalAngle.toString(),
              ));
              setState(() {
                _isModeSwitched = (state).data.mode;
              });
            } catch (e) {
              print("Error setting knob values: $e");
              context.read<DataCubit>().forceFailure();
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
        child: SingleChildScrollView(
          physics: _isKnobBeingInteractedWith
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Model window
                SizedBox(
                  child: Stack(
                    children: [
                      Container(
                        width: modelWindowSize,
                        height: modelWindowSize,
                        decoration: borderDecorations,
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
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _show3DModel = !_show3DModel;
                          });
                        },
                        icon: SafeIcon(
                          icon: _show3DModel ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Show model button

                SizedBox(height: intrinsicDeviceHeight * 0.01),
                // Custom line divider
                Container(
                  height: 1,
                  width: intrinsicDeviceWidth * 0.8,
                  decoration: borderDecorations,
                ),
                SizedBox(height: intrinsicDeviceHeight * 0.01),
                // Knobs Box
                IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      // onTapDown: (_) {
                      //   setState(() {
                      //     _isKnobBeingInteractedWith = true;
                      //   });
                      // },
                      // onTapUp: (_) {
                      //   setState(() {
                      //     _isKnobBeingInteractedWith = false;
                      //   });
                      // },
                      onTap: () {
                        setState(() {
                          _isKnobBeingInteractedWith = !_isKnobBeingInteractedWith;
                        });
                      },
                      child: Container(
                        width: knobsBoxSize,
                        decoration: borderDecorations.copyWith(
                          color: _isKnobBeingInteractedWith ? Colors.grey[300] : null,
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
                            VerticalDivider(
                              color: lineColor,
                              thickness: 1,
                              width: 10,
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
                  ),
                ),
                SizedBox(height: intrinsicDeviceHeight * 0.01),

                /// Mode switch box
                Container(
                  decoration: borderDecorations,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        MyToggleSwitch(
                          isSwitched: _isModeSwitched,
                          onChanged: (val) {
                            context.read<DataCubit>().setMode(val);
                            setState(() {
                              _isModeSwitched = val;
                            });
                          },
                        ),
                        Text(
                          "Current Mode: ${_isModeSwitched ? "Auto" : "Manual"}",
                          style: TextStyle(
                            fontSize: intrinsicDeviceWidth * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: intrinsicDeviceHeight * 0.01),
                // Solar panel box
                Container(
                  width: knobsBoxSize,
                  decoration: borderDecorations,
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.solar_power,
                                  size: knobsBoxSize * 0.1,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text("Solar Panel Data",
                                  style: TextStyle(
                                    fontSize: knobsBoxSize * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                          color: lineColor,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.electric_bolt, size: knobsBoxSize * 0.04),
                                SizedBox(width: knobsBoxSize * 0.02),
                                Text("Solar Panel Voltage: ",
                                    style: TextStyle(
                                      fontSize: knobsBoxSize * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                BlocBuilder<DataCubit, DataState>(
                                  builder: (context, state) {
                                    if (state is DataFetchLoaded) {
                                      return Text(
                                        (state).data.cellVoltage.toStringAsFixed(3),
                                        style: TextStyle(
                                          fontSize: knobsBoxSize * 0.02,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),
                                VerticalDivider(
                                  color: lineColor,
                                  thickness: 1,
                                  width: 10,
                                ),
                                Icon(Icons.battery_4_bar_outlined,
                                    size: knobsBoxSize * 0.04),
                                SizedBox(width: knobsBoxSize * 0.02),
                                Text("Solar Panel Current: ",
                                    style: TextStyle(
                                      fontSize: knobsBoxSize * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                BlocBuilder<DataCubit, DataState>(
                                  builder: (context, state) {
                                    if (state is DataFetchLoaded) {
                                      return Text(
                                        (state).data.cellCurrent.toStringAsFixed(3),
                                        style: TextStyle(
                                          fontSize: knobsBoxSize * 0.02,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: intrinsicDeviceHeight * 0.01),
                // Update from server button.
                BlocBuilder<DataCubit, DataState>(
                  builder: (context, state) {
                    if (state is DataFetchLoading) {
                      return const CircularProgressIndicator();
                    }
                    return OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<DataCubit>(context).getDataSnapshot();
                      },
                      child: const Text("Update From Server"),
                    );
                  },
                ),
                SizedBox(height: intrinsicDeviceHeight * 0.05),
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
