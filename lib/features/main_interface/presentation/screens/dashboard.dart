import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knob_widget/knob_widget.dart';
import '../widgets/knob_wheel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

const _minimum = 0.0;
const _maximum = 180.0;
const _size = 200.0;
const _labelOffset = 1.0;
const _tickOffset = 5.0;
const _minorTicksPerInterval = 9;
const _showMinorTickLabels = true;

const _minVerticalSeparation = _size / 2 + _labelOffset + _tickOffset;

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
      });
    }
  }

  void valueChangedListenerArmKnob(double value) {
    if (mounted) {
      setState(() {
        _armKnobValue = value;
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
      startAngle: 0,
      endAngle: 360,
      precision: 2,
    );
    _bodyKnobController.addOnValueChangedListener(valueChangedListenerBodyKnob);

    _armKnobValue = _minimum;
    _armKnobController = KnobController(
      initial: _armKnobValue,
      minimum: _minimum,
      maximum: _maximum,
      startAngle: 0,
      endAngle: 360,
      precision: 2,
    );
    _armKnobController.addOnValueChangedListener(valueChangedListenerArmKnob);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: _show3DModel,
                child: const SizedBox(
                  height: 300,
                  width: 300,
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
              const SizedBox(height: 10),
              Text('Body Knob Value: ${_bodyKnobValue.toString()}'),
              const SizedBox(height: 75),
              KnobWheel(
                controller: _bodyKnobController,
                size: _size,
                style: KnobStyle(
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  tickOffset: _tickOffset,
                  labelOffset: _labelOffset,
                  minorTicksPerInterval: _minorTicksPerInterval,
                  showMinorTickLabels: _showMinorTickLabels,
                ),
              ),
              const SizedBox(height: _minVerticalSeparation),
              Text('Arm Knob Value: ${_armKnobValue.toString()}'),
              const SizedBox(height: 75),
              KnobWheel(
                controller: _armKnobController,
                size: _size,
                style: KnobStyle(
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                  tickOffset: _tickOffset,
                  labelOffset: _labelOffset,
                  minorTicksPerInterval: _minorTicksPerInterval,
                  showMinorTickLabels: _showMinorTickLabels,
                ),
              ),
              const SizedBox(height: 75),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bodyKnobController.removeOnValueChangedListener(valueChangedListenerBodyKnob);
    super.dispose();
  }
}
