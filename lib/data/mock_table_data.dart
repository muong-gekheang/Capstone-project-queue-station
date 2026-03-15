/// This file provides a convenient export of mock table data for legacy UI screens.
/// It re‑exports the `mockTables` list from the queue table repository mock.
library;

import 'package:queue_station_app/data/repositories/queue_table/queue_table_repository_mock.dart'
    show mockTables;
import 'package:queue_station_app/models/restaurant/queue_table.dart';

/// A list of mock [QueueTable] objects used throughout the app.
///
/// This is a direct reference to `mockTables` from the repository mock.
/// Prefer using repositories/viewmodels for new code; this file exists
/// to keep older UI screens (e.g., [ManageStorePage]) compiling.
final List<QueueTable> tableData = mockTables;
