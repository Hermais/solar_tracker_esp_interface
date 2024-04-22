import 'package:flutter/material.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/bloc/auth_cubit.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/screens/splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_tracker_esp_interface/init_dependencies.dart';
import 'features/main_interface/presentation/bloc/data_cubit.dart';
import 'features/main_interface/presentation/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>()..signInAnonymously(),
        ),
        BlocProvider(
          create: (context) => sl<DataCubit>()..getDataSnapshot(),
          lazy: false,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Knob Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Welcome! Signed in successfully!'),
                ),
              );

          }
        },
        builder: (context, state) {
          if (state is AuthLoaded) {
            return const Dashboard(title: 'Flutter Knob Demo');
          }
          return Splash();
        },
      ),
    );
  }
}
