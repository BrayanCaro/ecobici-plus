import 'package:ecobici_plus/core/di/injection_container_dio.dart';
import 'package:ecobici_plus/domain/entities/tag.dart';
import 'package:ecobici_plus/presentation/bloc/tag/tag_bloc.dart';
import 'package:ecobici_plus/presentation/bloc/tag/tag_event.dart';
import 'package:ecobici_plus/presentation/bloc/tag/tag_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/color_input.dart';

class TagManagementPage extends StatelessWidget {
  const TagManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => TagBloc(
            getTags: sl(),
            createTag: sl(),
            updateTag: sl(),
            deleteTag: sl(),
          )..add(TagStarted()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Tag Management'),
            ),
            body: const _TagManagementView(),
            floatingActionButton: FloatingActionButton(
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (_) => BlocProvider.value(
                          value: BlocProvider.of<TagBloc>(context),
                          child: _ManageTagDialog(),
                        ),
                  ),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

class _TagManagementView extends StatelessWidget {
  const _TagManagementView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TagBloc, TagState>(
      listener: (context, state) {
        if (state is TagOperationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is TagOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is TagsLoading || state is TagOperationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TagsLoaded || state is TagOperationSuccess) {
          final tags =
              state is TagsLoaded
                  ? state.tags
                  : (context.read<TagBloc>().state as TagsLoaded).tags;
          return _buildTagList(context, tags);
        } else if (state is TagsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildTagList(BuildContext context, List<Tag> tags) {
    if (tags.isEmpty) {
      return const Center(
        child: Text(
          'No tags available. Create some tags using the + button.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, index) {
        final tag = tags[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: tag.color),
            title: Text(tag.name),
            subtitle: Text('${tag.stationIds.length} stations'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditTagDialog(context, tag),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(context, tag),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditTagDialog(BuildContext context, Tag tag) {
    showDialog(
      context: context,
      builder:
          (_) => BlocProvider.value(
            value: BlocProvider.of<TagBloc>(context),
            child: _EditTagNameDialog(tag),
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Tag tag) {
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<TagBloc>(context),
          child: _ConfirmTagDelectionDialog(tag),
        );
      },
    );
  }
}

class _ConfirmTagDelectionDialog extends StatelessWidget {
  const _ConfirmTagDelectionDialog(this.tag);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Tag'),
      content: Text(
        'Are you sure you want to delete the tag "${tag.name}"? '
        'This will remove it from all stations.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            context.read<TagBloc>().add(TagDeleted(id: tag.id));
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class _ManageTagDialog extends StatelessWidget {
  const _ManageTagDialog();

  @override
  Widget build(BuildContext context) => _SaveTagDialog(
    title: const Text('Create new tag'),
    submitTitle: const Text('Create'),
    onSubmitted:
        (context, {required color, required label}) =>
            context.read<TagBloc>().add(TagCreated(name: label, color: color)),
  );
}

class _EditTagNameDialog extends StatelessWidget {
  const _EditTagNameDialog(this.tag);

  final Tag tag;

  @override
  Widget build(BuildContext context) => _SaveTagDialog(
    title: const Text('Edit Tag'),
    submitTitle: const Text('Update'),
    initialColor: tag.color,
    initialLabel: tag.name,
    onSubmitted:
        (context, {required color, required label}) =>
            context.read<TagBloc>().add(
              TagUpdated(
                tag: Tag(
                  id: tag.id,
                  name: label,
                  color: color,
                  stationIds: tag.stationIds,
                ),
              ),
            ),
  );
}

class _SaveTagDialog extends StatefulWidget {
  const _SaveTagDialog({
    required this.onSubmitted,
    required this.title,
    required this.submitTitle,
    this.initialLabel,
    this.initialColor = Colors.blue,
  });

  @override
  State<_SaveTagDialog> createState() => _SaveTagDialogState();

  final Widget title;
  final Widget submitTitle;
  final String? initialLabel;
  final Color initialColor;

  final void Function(
    BuildContext context, {
    required Color color,
    required String label,
  })
  onSubmitted;
}

class _SaveTagDialogState extends State<_SaveTagDialog> {
  late final TextEditingController _nameController;
  late Color selectedColor;

  @override
  void initState() {
    selectedColor = widget.initialColor;
    _nameController = TextEditingController(text: widget.initialLabel);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Tag Name',
              hintText: 'Enter a name for the tag',
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select Color:'),
          const SizedBox(height: 8),
          ColorInput(
            initial: selectedColor,
            onSelected: (color) => selectedColor = color,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onSubmitted(
                context,
                label: _nameController.text,
                color: selectedColor,
              );
              Navigator.pop(context);
            }
          },
          child: widget.submitTitle,
        ),
      ],
    );
  }
}
