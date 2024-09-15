import 'package:flutter/material.dart';

@immutable
sealed class PaginationStrategyParams {
  const PaginationStrategyParams({required this.limit});

  final int limit;
}

@immutable
class CursorBasedStrategyParams extends PaginationStrategyParams {
  const CursorBasedStrategyParams({required super.limit, this.cursor});

  final String? cursor;
}

@immutable
class OffsetBasedStrategyParams extends PaginationStrategyParams {
  const OffsetBasedStrategyParams({required super.limit, this.offset});

  final int? offset;
}

@immutable
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.results,
    required this.hasMore,
    required this.paginationParams,
  });

  final List<T> results;

  final bool hasMore;

  final PaginationStrategyParams paginationParams;
}
