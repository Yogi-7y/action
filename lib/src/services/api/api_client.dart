import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_y/network_y.dart';

final apiClient = Provider((ref) => ApiClient(apiExecutor: DioApiExecutor()));
