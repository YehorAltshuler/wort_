import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';

class CitizenshipQuestionListSheet extends StatefulWidget {
  const CitizenshipQuestionListSheet({
    required this.questions,
    required this.currentIndex,
    required this.progress,
    required this.onSelected,
    super.key,
  });

  final List<CitizenshipQuestion> questions;
  final int currentIndex;
  final List<QuestionProgressRecord> progress;
  final ValueChanged<int> onSelected;

  @override
  State<CitizenshipQuestionListSheet> createState() =>
      _CitizenshipQuestionListSheetState();
}

class _CitizenshipQuestionListSheetState
    extends State<CitizenshipQuestionListSheet> {
  static const itemExtent = 80.0;

  late final TextEditingController _numberController;
  late final ScrollController _scrollController;
  var _invalidNumber = false;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _scrollController = ScrollController(
      initialScrollOffset: widget.currentIndex * itemExtent,
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressById = {
      for (final item in widget.progress) item.questionId: item,
    };
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.go,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: context.l10n.lidQuestionNumberInput,
              prefixIcon: const Icon(Icons.tag),
              hintText: '1–${widget.questions.length}',
              errorText: _invalidNumber
                  ? context.l10n.lidQuestionNumberInvalid(
                      widget.questions.length,
                    )
                  : null,
              suffixIcon: IconButton(
                tooltip: context.l10n.lidGoToQuestion,
                onPressed: _openEnteredQuestion,
                icon: const Icon(Icons.arrow_forward),
              ),
            ),
            onChanged: (_) {
              if (_invalidNumber) setState(() => _invalidNumber = false);
            },
            onSubmitted: (_) => _openEnteredQuestion(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            itemExtent: itemExtent,
            itemCount: widget.questions.length,
            itemBuilder: (context, index) => _QuestionListTile(
              question: widget.questions[index],
              position: index + 1,
              selected: index == widget.currentIndex,
              progress: progressById[widget.questions[index].id],
              onTap: () => widget.onSelected(index),
            ),
          ),
        ),
      ],
    );
  }

  void _openEnteredQuestion() {
    final number = int.tryParse(_numberController.text);
    if (number == null || number < 1 || number > widget.questions.length) {
      setState(() => _invalidNumber = true);
      return;
    }
    widget.onSelected(number - 1);
  }
}

class _QuestionListTile extends StatelessWidget {
  const _QuestionListTile({
    required this.question,
    required this.position,
    required this.selected,
    required this.progress,
    required this.onTap,
  });

  final CitizenshipQuestion question;
  final int position;
  final bool selected;
  final QuestionProgressRecord? progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final answered = progress?.lastSelectedAnswer != null;
    final color = !answered
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : progress!.isMastered
        ? TrainingAnswerChip.correctColor(context)
        : Theme.of(context).colorScheme.error;
    return ListTile(
      selected: selected,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Text('$position'),
      ),
      title: Text(question.text, maxLines: 2),
      trailing: answered
          ? Icon(
              progress!.isMastered ? Icons.check_circle : Icons.cancel,
              color: color,
            )
          : const Icon(Icons.radio_button_unchecked),
      onTap: onTap,
    );
  }
}
