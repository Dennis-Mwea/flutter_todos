import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:todos_repository/todos_repository.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  static Route<void> route({Todo? initialTodo}) => MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => BlocProvider(
          child: const EditTodoPage(),
          create: (BuildContext context) => EditTodoBloc(todosRepository: context.read<TodosRepository>(), initialTodo: initialTodo),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select((EditTodoBloc bloc) => bloc.state.isNewTodo);

    return BlocListener<EditTodoBloc, EditTodoState>(
      listener: (context, state) => Navigator.of(context).pop(),
      listenWhen: (previous, current) => previous.status != current.status && current.status == EditTodoStatus.success,
      child: Scaffold(
        appBar: AppBar(title: Text(isNewTodo ? context.l10n.editTodoAddAppBarTitle : context.l10n.editTodoEditAppBarTitle)),
        floatingActionButton: FloatingActionButton(
          tooltip: context.l10n.editTodoSaveButtonTooltip,
          shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
          onPressed: status.isLoadingOrSuccess ? null : () => context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
          child: status.isLoadingOrSuccess ? const CupertinoActivityIndicator() : const Icon(Icons.check_rounded),
        ),
        body: CupertinoScrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: <Widget>[
              TextFormField(
                maxLength: 50,
                key: const Key('editTodoView_title_textFormField'),
                initialValue: context.watch<EditTodoBloc>().state.title,
                onChanged: (value) => context.read<EditTodoBloc>().add(EditTodoTitleChanged(value)),
                inputFormatters: [LengthLimitingTextInputFormatter(50), FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))],
                decoration: InputDecoration(
                  labelText: context.l10n.editTodoTitleLabel,
                  hintText: context.watch<EditTodoBloc>().state.initialTodo?.title ?? '',
                  enabled: !context.watch<EditTodoBloc>().state.status.isLoadingOrSuccess,
                ),
              ),
              TextFormField(
                maxLines: 7,
                maxLength: 300,
                key: const Key('editTodoView_description_textFormField'),
                inputFormatters: [LengthLimitingTextInputFormatter(300)],
                initialValue: context.watch<EditTodoBloc>().state.description,
                onChanged: (value) => context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value)),
                decoration: InputDecoration(
                  labelText: context.l10n.editTodoDescriptionLabel,
                  enabled: !context.watch<EditTodoBloc>().state.status.isLoadingOrSuccess,
                  hintText: context.watch<EditTodoBloc>().state.initialTodo?.description ?? '',
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
