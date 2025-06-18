import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:product_demo/features/products/data/datasources/product_remote_data_source.dart';
import 'package:product_demo/features/products/data/repositories/product_repository_impl.dart';
import 'package:product_demo/features/products/viewmodel/product_bloc.dart';
import 'package:product_demo/features/splash/splash_screen.dart';
import 'package:product_demo/utils/color_constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ProductBloc>(
              create: (context) => ProductBloc(
                repository: ProductRepositoryImpl(
                  remoteDataSource: ProductRemoteDataSourceImpl(
                    client: http.Client(),
                  ),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Product Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blueColor),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
