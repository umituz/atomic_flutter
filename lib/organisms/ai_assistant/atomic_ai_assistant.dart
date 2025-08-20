
import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../atoms/buttons/atomic_button.dart';
import '../../atoms/buttons/atomic_icon_button.dart';
import '../../atoms/feedback/atomic_toast.dart';
import '../../atoms/feedback/atomic_dot_loading.dart';
import '../../atoms/overlays/atomic_dialog.dart';
import '../../tokens/animations/atomic_animations.dart';

class AtomicAIMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? id;
  final Map<String, dynamic>? metadata;

  AtomicAIMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.id,
    this.metadata,
  });
}

class AtomicAIAssistantConfig {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<AtomicAIAction>? headerActions;
  final List<AtomicAISuggestion>? suggestions;
  final AtomicAIResponseGenerator? responseGenerator;
  final VoidCallback? onClearChat;
  final bool showClearButton;
  final String? emptyStateTitle;
  final String? emptyStateSubtitle;
  final String? inputPlaceholder;
  final bool showClearButtonAlways;

  const AtomicAIAssistantConfig({
    this.title = 'AI Assistant',
    this.subtitle = 'Your intelligent helper',
    this.icon = Icons.auto_awesome,
    this.headerActions,
    this.suggestions,
    this.responseGenerator,
    this.onClearChat,
    this.showClearButton = true,
    this.showClearButtonAlways = false,
    this.emptyStateTitle = 'Welcome to AI Assistant',
    this.emptyStateSubtitle = 'Ask me anything',
    this.inputPlaceholder = 'Type a message...',
  });
}

class AtomicAIAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool showLabel;

  const AtomicAIAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.showLabel = true,
  });
}

class AtomicAISuggestion {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  const AtomicAISuggestion({
    required this.text,
    required this.icon,
    this.onTap,
  });
}

typedef AtomicAIResponseGenerator = Future<String> Function(String message);

class AtomicAIAssistant extends StatefulWidget {
  final AtomicAIAssistantConfig config;
  final Function(String message)? onSendMessage;
  final Function(AtomicAIMessage message)? onMessageAdded;
  final List<AtomicAIMessage>? initialMessages;
  final Widget? customHeader;
  final Widget? customInput;
  final Widget Function(AtomicAIMessage message, bool isUser)? messageBuilder;

  const AtomicAIAssistant({
    super.key,
    required this.config,
    this.onSendMessage,
    this.onMessageAdded,
    this.initialMessages,
    this.customHeader,
    this.customInput,
    this.messageBuilder,
  });

  @override
  State<AtomicAIAssistant> createState() => _AtomicAIAssistantState();
}

class _AtomicAIAssistantState extends State<AtomicAIAssistant> 
    with SingleTickerProviderStateMixin {
  final List<AtomicAIMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isTyping = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AtomicAnimations.normal,
      vsync: this,
    );
    
    if (widget.initialMessages != null) {
      _messages.addAll(widget.initialMessages!);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _inputFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = AtomicAIMessage(
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _scrollToBottom();
    widget.onMessageAdded?.call(userMessage);
    widget.onSendMessage?.call(message);

    if (widget.config.responseGenerator != null) {
      try {
        final response = await widget.config.responseGenerator!(message);
        
        if (mounted) {
          final aiMessage = AtomicAIMessage(
            content: response,
            isUser: false,
            timestamp: DateTime.now(),
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          );

          setState(() {
            _messages.add(aiMessage);
            _isTyping = false;
          });

          _scrollToBottom();
          widget.onMessageAdded?.call(aiMessage);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isTyping = false);
          AtomicToast.error(
            context: context,
            message: 'Failed to get response',
          );
        }
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (mounted) {
        final aiMessage = AtomicAIMessage(
          content: _getDefaultResponse(message),
          isUser: false,
          timestamp: DateTime.now(),
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        setState(() {
          _messages.add(aiMessage);
          _isTyping = false;
        });

        _scrollToBottom();
        widget.onMessageAdded?.call(aiMessage);
      }
    }
  }

  String _getDefaultResponse(String message) {
    final msg = message.toLowerCase();
    
    if (msg.contains('hello') || msg.contains('hi')) {
      return "Hello! How can I assist you today?";
    } else if (msg.contains('help')) {
      return "I'm here to help! What do you need assistance with?";
    } else {
      return "I understand you're asking about '\$message'. Let me help you with that.";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AtomicAnimations.fast,
          curve: AtomicAnimations.standardEasing,
        );
      }
    });
  }

  void _clearChat() async {
    final shouldClear = await AtomicDialog.showConfirmation(
      context: context,
      title: 'Clear Chat History',
      content: 'Are you sure you want to clear all messages?',
      confirmLabel: 'Clear',
      cancelLabel: 'Cancel',
      titleIcon: Icons.cleaning_services_rounded,
    );
    
    if (shouldClear == true && mounted) {
      setState(() {
        _messages.clear();
        _isTyping = false;
        _messageController.clear();
      });
      
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      
      widget.config.onClearChat?.call();
      
      AtomicToast.success(
        context: context,
        message: 'Chat history cleared',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return Column(
      children: [
        widget.customHeader ?? _buildDefaultHeader(theme),
        
        Expanded(
          child: _messages.isEmpty 
              ? _buildEmptyState(theme)
              : _buildMessageList(theme),
        ),
        
        widget.customInput ?? _buildDefaultInput(theme),
      ],
    );
  }

  Widget _buildDefaultHeader(AtomicThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colors.gray900.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.md,
            vertical: theme.spacing.sm,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(theme.spacing.xs),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colors.primary,
                      theme.colors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.config.icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: theme.spacing.sm),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.config.title,
                      style: theme.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.config.subtitle.isNotEmpty)
                      Text(
                        widget.config.subtitle,
                        style: theme.typography.bodySmall.copyWith(
                          color: theme.colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              
              if (widget.config.headerActions != null)
                ...widget.config.headerActions!.map((action) {
                  if (action.showLabel) {
                    return Padding(
                      padding: EdgeInsets.only(left: theme.spacing.xs),
                      child: AtomicButton(
                        label: action.label,
                        onPressed: action.onPressed,
                        variant: AtomicButtonVariant.primary,
                        size: AtomicButtonSize.small,
                        icon: action.icon,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(left: theme.spacing.xs),
                      child: AtomicIconButton(
                        icon: action.icon,
                        onPressed: action.onPressed,
                        variant: AtomicIconButtonVariant.filled,
                        size: AtomicIconButtonSize.medium,
                        tooltip: action.label,
                      ),
                    );
                  }
                }),
              
              if (widget.config.showClearButton && 
                  (widget.config.showClearButtonAlways || _messages.isNotEmpty)) ...[
                SizedBox(width: theme.spacing.xs),
                AtomicIconButton(
                  icon: Icons.cleaning_services_rounded,
                  onPressed: _clearChat,
                  variant: AtomicIconButtonVariant.ghost,
                  size: AtomicIconButtonSize.medium,
                  color: theme.colors.textSecondary,
                  tooltip: 'Clear chat',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AtomicThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: theme.spacing.lg,
            right: theme.spacing.lg,
            top: theme.spacing.md,
            bottom: theme.spacing.md + MediaQuery.of(context).padding.bottom,
          ),
                      child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - theme.spacing.md * 2,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: AtomicAnimations.normal,
                  curve: AtomicAnimations.standardEasing,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: EdgeInsets.all(theme.spacing.lg),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colors.primary.withValues(alpha: 0.1),
                              theme.colors.primary.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.config.icon,
                          size: 48,
                          color: theme.colors.primary,
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: theme.spacing.md),
                
                if (widget.config.emptyStateTitle != null)
                  Text(
                    widget.config.emptyStateTitle!,
                    style: theme.typography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                
                if (widget.config.emptyStateSubtitle != null) ...[
                  SizedBox(height: theme.spacing.xs),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                    child: Text(
                      widget.config.emptyStateSubtitle!,
                      style: theme.typography.bodyMedium.copyWith(
                        color: theme.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                
                if (widget.config.suggestions != null) ...[
                  SizedBox(height: theme.spacing.lg),
                  Flexible(
                    child: _buildSuggestions(theme),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestions(AtomicThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.config.suggestions!.take(4).map((suggestion) {
        return Padding(
          padding: EdgeInsets.only(bottom: theme.spacing.xs),
          child: InkWell(
            onTap: suggestion.onTap ?? 
                () => _handleSendMessage(suggestion.text),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.md,
                vertical: theme.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: theme.colors.surface,
                border: Border.all(
                  color: theme.colors.primary.withValues(alpha: 0.15),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(theme.spacing.xxs),
                    decoration: BoxDecoration(
                      color: theme.colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      suggestion.icon,
                      color: theme.colors.primary,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: theme.spacing.sm),
                  Expanded(
                    child: Text(
                      suggestion.text,
                      style: theme.typography.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colors.textTertiary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessageList(AtomicThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.md,
      ),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _messages.length) {
          final message = _messages[index];
          return widget.messageBuilder?.call(message, message.isUser) ??
              _buildDefaultMessage(theme, message);
        } else {
          return _buildTypingIndicator(theme);
        }
      },
    );
  }

  Widget _buildDefaultMessage(AtomicThemeData theme, AtomicAIMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.md),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.md,
            vertical: theme.spacing.sm,
          ),
          decoration: BoxDecoration(
            color: message.isUser
                ? theme.colors.primary
                : theme.colors.gray100,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(message.isUser ? 18 : 4),
              bottomRight: Radius.circular(message.isUser ? 4 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: theme.typography.bodyMedium.copyWith(
                  color: message.isUser 
                      ? Colors.white 
                      : theme.colors.textPrimary,
                ),
              ),
              SizedBox(height: theme.spacing.xs),
              Text(
                _formatTime(message.timestamp),
                style: theme.typography.bodySmall.copyWith(
                  color: message.isUser 
                      ? Colors.white.withValues(alpha: 0.7)
                      : theme.colors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(AtomicThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.md),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AtomicDotLoading(
              dotSize: AtomicDotLoadingSize.small,
              activeColor: theme.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultInput(AtomicThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colors.gray900.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.all(theme.spacing.md),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colors.gray100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _messageController,
                    focusNode: _inputFocusNode,
                    onSubmitted: (value) {
                      final message = value.trim();
                      if (message.isNotEmpty) {
                        _handleSendMessage(message);
                        _messageController.clear();
                      }
                    },
                    style: theme.typography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: widget.config.inputPlaceholder,
                      hintStyle: theme.typography.bodyMedium.copyWith(
                        color: theme.colors.textTertiary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.lg,
                        vertical: theme.spacing.sm,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: theme.spacing.sm),
              
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        _handleSendMessage(message);
                        _messageController.clear();
                      }
                    },
                    child: Center(
                      child: Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
