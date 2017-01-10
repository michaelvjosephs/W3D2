CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  subject_question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

--users
INSERT INTO
  users (fname, lname)
VALUES
  ('Jon', 'Smith'),
  ('Yohanan', 'Radchenko'),
  ('Michael', 'Josephs');

--questions
INSERT INTO
  questions (title, body, author_id)
VALUES
  ("SQL", "How to write code in SQL?", (SELECT id FROM users WHERE fname = 'Jon' AND lname = 'Smith')),
  ("Ruby", "How to write code in Ruby?", (SELECT id FROM users WHERE fname = 'Yohanan' AND lname = 'Radchenko')),
  ("Gem", "We need an extra question", 1);

--followers
  INSERT INTO
    question_follows (user_id, question_id)
  VALUES
    ((SELECT id FROM users WHERE fname = 'Jon' AND lname = 'Smith'), 1),
    ((SELECT id FROM users WHERE fname = 'Jon' AND lname = 'Smith'), 2), --(SELECT id FROM questions WHERE author_id = 2)) Want to select Yohanan's question.
    ((SELECT id FROM users WHERE fname = 'Michael' AND lname = 'Josephs'), 1);

--replies
  INSERT INTO
    replies (body, subject_question_id, parent_reply_id, author_id)
  VALUES
    ('I don''t know', (SELECT id FROM questions WHERE title = 'SQL'), NULL, (SELECT id FROM users WHERE fname = 'Michael' AND lname = 'Josephs'));

  INSERT INTO
    replies (body, subject_question_id, parent_reply_id, author_id)
  VALUES
    ('Me neither',  (SELECT id FROM questions WHERE title = 'SQL'), (SELECT id FROM replies WHERE body = 'I don''t know'), (SELECT id FROM users WHERE fname = 'Yohanan' AND lname = 'Radchenko'));

--question likes
  INSERT INTO
    question_likes(user_id, question_id)
  VALUES
    ((SELECT id FROM users WHERE fname = 'Jon' AND lname = 'Smith'), (SELECT id FROM questions WHERE title = 'Ruby')),
    ((SELECT id FROM users WHERE fname = 'Michael' AND lname = 'Josephs'), (SELECT id FROM questions WHERE title = 'Ruby'));
