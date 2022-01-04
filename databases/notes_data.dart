import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class NotesDatabase {
  Box _box = Hive.box("Quick_Notes");

  void addNote(String title, String content, String subject, var createdAt) {
    _box.put("$title for $subject", {
      "title": title,
      "content": content,
      "subject": subject,
      "createdAt": createdAt
    });
  }

  void updateNote(String title, String subject, String content, var updatedAt,
      {String updatedTitle, String updatedContent}) {
    _box.put("$title for $subject", {
      "title": updatedTitle.isEmpty ? title : updatedTitle,
      "content": updatedContent.isEmpty ? content : updatedContent,
      "subject": subject,
      "updatedAt": updatedAt
    });
  }

  void deleteNote(String title, String subject) {
    _box.delete("$title for $subject");
  }
}
