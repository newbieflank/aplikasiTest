import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/viewmodels/login_viewmodel.dart';
import 'core/viewmodels/dashboard_viewmodel.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => LoginViewModel()),
  ChangeNotifierProvider(create: (context) => DashboardViewModel()),
];
