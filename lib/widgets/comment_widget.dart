// lib/widgets/comment_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/controllers/comments_controller.dart';
import 'package:test1/models/comment.dart';
import 'package:test1/service_locator.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final CommentsController controller;
  final Map<String, List<Comment>> replies;
  final int depth;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.controller,
    required this.replies,
    this.depth = 0,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final AuthController _authController = locator<AuthController>();
  bool _isEditing = false;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.comment.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_textEditingController.text.trim().isNotEmpty &&
        _textEditingController.text.trim() != widget.comment.text) {
      widget.controller
          .editComment(widget.comment.id, _textEditingController.text);
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final childReplies = widget.replies[widget.comment.id] ?? [];
    final currentUser = _authController.user.value;
    final bool isOwner = currentUser?.uid == widget.comment.userId;
    final bool isLiked = currentUser != null &&
        widget.comment.likedBy.contains(currentUser.uid);

    // Define theme-aware colors
    final baseCardColor = isDarkMode ? const Color.fromARGB(255, 30, 0, 70) : Colors.white;
    final replyCardColor = isDarkMode ? const Color.fromARGB(255, 45, 15, 85) : Colors.grey.shade100;
    final subtleTextColor = theme.textTheme.bodySmall?.color?.withOpacity(0.8);
    final iconColor = theme.iconTheme.color?.withOpacity(0.8);

    return Padding(
      padding: EdgeInsets.only(left: widget.depth * 12.0),
      child: Card(
        color: widget.depth == 0 ? baseCardColor : replyCardColor,
        elevation: isDarkMode ? 1 : 2,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: widget.comment.userPhotoUrl != null &&
                            widget.comment.userPhotoUrl!.isNotEmpty
                        ? NetworkImage(widget.comment.userPhotoUrl!)
                        : null,
                    child: widget.comment.userPhotoUrl == null ||
                            widget.comment.userPhotoUrl!.isEmpty
                        ? Icon(Icons.person, size: 16, color: iconColor)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.comment.username,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Text(
                              timeago.format(widget.comment.timestamp.toDate()),
                              style:
                                  TextStyle(color: subtleTextColor, fontSize: 12),
                            ),
                            if (widget.comment.lastEdited != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  '(${'edited'.tr})',
                                  style: TextStyle(
                                      color: subtleTextColor?.withOpacity(0.7),
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isOwner)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 20, color: iconColor),
                      onSelected: (value) {
                        if (value == 'edit') {
                          setState(() { _isEditing = true; });
                        } else if (value == 'delete') {
                          // ... delete dialog
                        }
                      },
                      itemBuilder: (context) => [ /* ... popup items */ ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _isEditing
                  ? Column(
                      // ... edit UI
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.comment.text,
                            style: theme.textTheme.bodyMedium),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => widget.controller.startReplying(
                                  widget.comment.id, widget.comment.username),
                              child: Text("Reply"),
                              style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: const Size(50, 30)),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                color:
                                    isLiked ? theme.primaryColor : iconColor,
                                size: 18,
                              ),
                              onPressed: () {
                                widget.controller
                                    .likeComment(widget.comment.id);
                              },
                            ),
                            if (widget.comment.likesCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  widget.comment.likesCount.toString(),
                                  style: TextStyle(
                                      color: subtleTextColor, fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
              if (childReplies.isNotEmpty)
                ...childReplies.map((reply) => CommentWidget(
                      comment: reply,
                      controller: widget.controller,
                      replies: widget.replies,
                      depth: widget.depth + 1,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}