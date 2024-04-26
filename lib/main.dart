import 'package:flutter/material.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/bloc/auth_cubit.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/bloc/network_cubit.dart';
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
        ),
        BlocProvider(
          create: (context) => sl<NetworkCubit>()..monitorInternetConnection(),
          lazy: false,
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Tracker Interface',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: BlocConsumer<NetworkCubit, NetworkState>(
        listener: (context, state) {
          if (state is NetworkDisconnected) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('No Internet Connection'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.red,
                ),
              );
          }else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Internet Connection Restored!'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.green,
                ),
              );
          }

        },
        builder: (context, state) {
          if (state is NetworkConnected) {
            return BlocConsumer<AuthCubit, AuthState>(
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
                  return const Dashboard(title: 'Solar Tracker Interface');
                }
                return const Splash();
              },
            );
          }else if (state is NetworkInitial) {
            return const Splash(message: "Checking for network availability...",);
          } else {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 100,
                      color: Colors.red,
                    ),
                    Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
