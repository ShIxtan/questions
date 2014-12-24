CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (follower_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  parent_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  liker_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (liker_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Aaron', 'Ulbricht'), ('Khulani', 'Malone'), ('Jeff', 'Fiddler');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('What?', 'What?', (SELECT id FROM users WHERE fname = 'Aaron')),
  ('Who?', 'Who?', (SELECT id FROM users WHERE fname = 'Khulani')),
  ('Why?', 'Why?', (SELECT id FROM users WHERE fname = 'Khulani'));

INSERT INTO
  question_followers (question_id, follower_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'What?'),
  (SELECT id FROM users WHERE fname = 'Khulani')),
  ((SELECT id FROM questions WHERE title = 'Why?'),
  (SELECT id FROM users WHERE fname = 'Aaron')),
  ((SELECT id FROM questions WHERE title = 'Who?'),
  (SELECT id FROM users WHERE fname = 'Jeff')),
  ((SELECT id FROM questions WHERE title = 'Who?'),
  (SELECT id FROM users WHERE fname = 'Aaron'));

INSERT INTO
  replies (body, question_id, author_id, parent_id)
VALUES
  ('Good question.', (SELECT id FROM questions WHERE title = 'What?'),
    (SELECT id FROM users WHERE fname = 'Khulani'), null),
  ("That's not helpful.", (SELECT id FROM questions WHERE title = 'What?'),
    (SELECT id FROM users WHERE fname = 'Jeff'),
    (SELECT id FROM replies WHERE body = 'Good question.'));

INSERT INTO
  question_likes (question_id, liker_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'What?'),
    (SELECT id FROM users WHERE fname = 'Khulani')),
  ((SELECT id FROM questions WHERE title = 'Why?'),
    (SELECT id FROM users WHERE fname = 'Aaron')),
  ((SELECT id FROM questions WHERE title = 'Who?'),
    (SELECT id FROM users WHERE fname = 'Jeff')),
  ((SELECT id FROM questions WHERE title = 'Who?'),
    (SELECT id FROM users WHERE fname = 'Aaron'));
