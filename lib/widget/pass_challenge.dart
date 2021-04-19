import 'package:flutter/material.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/utils.dart';

class PassChallenge extends StatefulWidget {
  final bool editMode;
  final ValueChanged<String>? onSave;
  final VoidCallback? onChallengeSuccess;
  final String? description;

  const PassChallenge({
    this.editMode = false,
    this.onSave,
    this.onChallengeSuccess,
    this.description,
  });

  @override
  _PassChallengeState createState() => _PassChallengeState();
}

class _PassChallengeState extends State<PassChallenge> {
  late TextEditingController controller;

  bool showPass = false;
  String? status;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.editMode ? prefs.masterPass : "",
    );

    controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.editMode
                  ? LocaleStrings.common.masterPassModify
                  : LocaleStrings.common.masterPassConfirm,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (widget.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(widget.description!),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: controller,
              obscureText: !showPass,
              onChanged: (_) => setState(() => status = null),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(showPass
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => showPass = !showPass),
                ),
                errorText: status,
              ),
              onFieldSubmitted:
                  controller.text.length >= 4 ? (_) => _onConfirm() : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: controller.text.length >= 4 ? _onConfirm : null,
                  child: Text(widget.editMode ? "Save" : "Confirm"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    if (widget.editMode) {
      widget.onSave?.call(controller.text);
    } else {
      final String controllerHash = Utils.hashedPass(controller.text);

      if (controllerHash == prefs.masterPass) {
        setState(() => status = null);
        widget.onChallengeSuccess?.call();
      } else {
        setState(() => status = "Incorrect master pass");
      }
    }
  }
}
