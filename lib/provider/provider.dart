import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_app/services/services.dart';

final serviceProvider = StateProvider<Services>((ref) => Services());
