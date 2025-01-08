class ChatTheme {
  final String name;
  final String description;
  final String command;
  final String imagePath;

  const ChatTheme({required this.name, required this.command, required this.description, required String imgPath})
      : imagePath = 'assets/images/$imgPath';
}

ChatTheme ai = const ChatTheme(
    name: 'AI 聊天',
    description: '一個樂於陪你談天說地的 AI。無論是分享日常趣事、解答問題，還是陪你聊聊心事，我都樂於傾聽。',
    command: 'open to chat with all kinds of topics, respond like a real human and respond at most 3 sentences per time',
    imgPath: 'ai.png');
ChatTheme emergencyWork =
    const ChatTheme(name: '緊急工作', description: '遇見強迫推銷，接電話假裝有事要忙', command: '假裝現在你有急事要打電話找我，是關於家裡的水龍頭沒關。用口語方式和我對話，一次最多兩句話', imgPath: 'work.png');
ChatTheme socialRelief = const ChatTheme(
    name: '飯局解圍', description: '參加一場飯局，共同朋友暫時離開，接電話避免尷尬', command: '假裝現在你有急事要打電話找我，是關於你想要找我出去吃飯。用口語方式和我對話，一次最多一句話', imgPath: 'meal.png');
ChatTheme nightCompanionship = const ChatTheme(
    name: '深夜相伴',
    description: '夜深人靜，想要有人打電話給你，但你只是一隻哥布林',
    command: '假裝現在夜深人靜，你想打電話找我聊天。你是我研究所學姊，我們互有好感但還沒確認關係。用口語方式和我對話，一次最多兩句話',
    imgPath: 'girl.png');
