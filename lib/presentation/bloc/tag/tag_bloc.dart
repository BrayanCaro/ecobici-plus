import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/create_tag.dart';
import '../../../domain/use_cases/delete_tag.dart';
import '../../../domain/use_cases/get_tags.dart';
import '../../../domain/use_cases/update_tag.dart';
import 'tag_event.dart';
import 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final GetTags getTags;
  final CreateTag createTag;
  final UpdateTag updateTag;
  final DeleteTag deleteTag;

  TagBloc({
    required this.getTags,
    required this.createTag,
    required this.updateTag,
    required this.deleteTag,
  }) : super(TagInitial()) {
    on<TagStarted>(_onTagStarted);
    on<TagCreated>(_onTagCreated);
    on<TagUpdated>(_onTagUpdated);
    on<TagDeleted>(_onTagDeleted);
  }

  Future<void> _onTagStarted(TagStarted event, Emitter<TagState> emit) async {
    emit(TagsLoading());
    try {
      final tags = await getTags();
      emit(TagsLoaded(tags: tags));
    } catch (e) {
      emit(TagsError(message: e.toString()));
    }
  }

  Future<void> _onTagCreated(TagCreated event, Emitter<TagState> emit) async {
    emit(TagOperationLoading());
    try {
      await createTag(event.name, event.color.toARGB32());
      emit(const TagOperationSuccess(message: 'Tag created successfully'));
      add(TagStarted());
    } catch (e) {
      emit(TagOperationError(message: e.toString()));
    }
  }

  Future<void> _onTagUpdated(TagUpdated event, Emitter<TagState> emit) async {
    emit(TagOperationLoading());
    try {
      await updateTag(event.tag);
      emit(const TagOperationSuccess(message: 'Tag updated successfully'));
      add(TagStarted());
    } catch (e) {
      emit(TagOperationError(message: e.toString()));
    }
  }

  Future<void> _onTagDeleted(TagDeleted event, Emitter<TagState> emit) async {
    emit(TagOperationLoading());
    try {
      await deleteTag(event.id);
      emit(const TagOperationSuccess(message: 'Tag deleted successfully'));
      add(TagStarted());
    } catch (e) {
      emit(TagOperationError(message: e.toString()));
    }
  }
}
