# 🤖 AtomicAIAssistant Component

A fully customizable, reusable AI chat interface component for Flutter applications.

## Features

- 💬 **Complete Chat Interface**: Message history, typing indicators, timestamps
- 🎨 **Fully Customizable**: Headers, inputs, message bubbles, empty states
- 🔧 **Dynamic Suggestions**: Configurable suggestion cards with custom actions
- 🧹 **Clear Chat**: Built-in clear chat functionality with confirmation dialog
- 🎯 **Header Actions**: Add custom action buttons to the header
- 🌈 **Theme Integration**: Seamlessly integrates with Atomic Design System themes
- 📱 **Mobile Optimized**: Smooth animations and responsive design

## Basic Usage

```dart
import 'package:atomic_flutter/atomic_flutter.dart';

AtomicAIAssistant(
  config: AtomicAIAssistantConfig(
    title: 'AI Assistant',
    subtitle: 'Your intelligent helper',
    icon: Icons.auto_awesome,
    showClearButton: true,
    showClearButtonAlways: true,
    emptyStateTitle: 'Welcome!',
    emptyStateSubtitle: 'How can I help you today?',
    inputPlaceholder: 'Ask me anything...',
  ),
)
```

## Advanced Configuration

### Custom Suggestions

```dart
AtomicAIAssistant(
  config: AtomicAIAssistantConfig(
    suggestions: [
      AtomicAISuggestion(
        text: 'How can you help me?',
        icon: Icons.help_outline,
        onTap: null, // Uses default behavior (sends text as message)
      ),
      AtomicAISuggestion(
        text: 'Create a task',
        icon: Icons.add_task,
        onTap: () {
          // Custom behavior
          showCreateTaskDialog();
        },
      ),
    ],
  ),
)
```

### Custom Response Generator

```dart
AtomicAIAssistant(
  config: AtomicAIAssistantConfig(
    responseGenerator: (String message) async {
      // Your AI logic here
      final response = await myAIService.generateResponse(message);
      return response;
    },
  ),
)
```

### Header Actions

```dart
AtomicAIAssistant(
  config: AtomicAIAssistantConfig(
    headerActions: [
      AtomicAIAction(
        label: 'Settings',
        icon: Icons.settings,
        onPressed: () => navigateToSettings(),
        showLabel: true, // Show both icon and label
      ),
      AtomicAIAction(
        label: 'Export',
        icon: Icons.download,
        onPressed: () => exportChat(),
        showLabel: false, // Icon only
      ),
    ],
  ),
)
```

### Custom Callbacks

```dart
AtomicAIAssistant(
  config: AtomicAIAssistantConfig(
    onClearChat: () {
      // Called when chat is cleared
      print('Chat cleared!');
    },
  ),
  onSendMessage: (String message) {
    // Called when user sends a message
    print('User sent: $message');
  },
  onMessageAdded: (AtomicAIMessage message) {
    // Called when any message is added (user or AI)
    print('Message added: ${message.content}');
  },
)
```

### Custom Message Builder

```dart
AtomicAIAssistant(
  messageBuilder: (AtomicAIMessage message, bool isUser) {
    return MyCustomMessageBubble(
      message: message,
      isUser: isUser,
    );
  },
)
```

## Configuration Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | String | 'AI Assistant' | Header title |
| `subtitle` | String | 'Your intelligent helper' | Header subtitle |
| `icon` | IconData | Icons.auto_awesome | Header icon |
| `headerActions` | List<AtomicAIAction>? | null | Custom header action buttons |
| `suggestions` | List<AtomicAISuggestion>? | null | Suggestion cards for empty state |
| `responseGenerator` | AtomicAIResponseGenerator? | null | Custom AI response logic |
| `onClearChat` | VoidCallback? | null | Callback when chat is cleared |
| `showClearButton` | bool | true | Show clear chat button |
| `showClearButtonAlways` | bool | false | Show clear button even when chat is empty |
| `emptyStateTitle` | String? | 'Welcome to AI Assistant' | Empty state title |
| `emptyStateSubtitle` | String? | 'Ask me anything' | Empty state subtitle |
| `inputPlaceholder` | String? | 'Type a message...' | Input field placeholder |

## Message Model

```dart
class AtomicAIMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? id;
  final Map<String, dynamic>? metadata;
}
```

## Examples

### Simple Chatbot

```dart
AtomicAIAssistant(
  config: AtomicAIAssistantConfig(
    title: 'Support Bot',
    subtitle: 'Available 24/7',
    responseGenerator: (message) async {
      // Simple keyword-based responses
      if (message.toLowerCase().contains('help')) {
        return 'I can help you with account issues, billing, and technical support.';
      }
      return 'Thank you for your message. How can I assist you?';
    },
  ),
)
```

### Project Assistant with Actions

```dart
AtomicAIAssistant(
  config: AtomicAIAssistantConfig(
    title: 'Project Assistant',
    subtitle: 'Manage your tasks',
    showClearButtonAlways: true,
    suggestions: [
      AtomicAISuggestion(
        text: 'Create new task',
        icon: Icons.add_task,
        onTap: () => createTask(),
      ),
      AtomicAISuggestion(
        text: 'View project status',
        icon: Icons.analytics,
        onTap: () => viewProjectStatus(),
      ),
    ],
    headerActions: [
      AtomicAIAction(
        label: 'Export',
        icon: Icons.download,
        onPressed: () => exportChat(),
      ),
    ],
  ),
)
```

## Best Practices

1. **Provide Clear Suggestions**: Help users understand what the AI can do
2. **Handle Errors Gracefully**: Use try-catch in responseGenerator
3. **Show Loading States**: The component automatically shows typing indicators
4. **Customize for Your Use Case**: Use the configuration options to match your app's needs
5. **Test on Different Screen Sizes**: The component is responsive but verify on your target devices

## Troubleshooting

### Chat not clearing properly
- Make sure `showClearButton` is set to `true`
- If you want the button always visible, set `showClearButtonAlways` to `true`
- Check if `onClearChat` callback is interfering

### Custom suggestions not working
- Ensure `onTap` is properly defined or set to `null` for default behavior
- Check that the suggestion text is not empty

### Response generator errors
- Always handle errors in your `responseGenerator` function
- Return a user-friendly error message if something goes wrong 