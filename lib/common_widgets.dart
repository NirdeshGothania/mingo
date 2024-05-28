import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0
  final Widget title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: const Color(0xff2b2d7f),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.iconData,
    this.obscureText = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData? iconData;
  final bool obscureText;
  final Function(String)? onSubmitted;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText && !isVisible,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.iconData),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        suffixIcon: (widget.obscureText)
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon((isVisible)
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye),
                  tooltip: (isVisible)
                      ? 'Hide ${widget.hintText}'
                      : 'Show ${widget.hintText}',
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              )
            : null,
      ),
    );
  }
}
