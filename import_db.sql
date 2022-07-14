DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions_follows;
DROP TABLE IF EXISTS questions; 
DROP TABLE IF EXISTS users; 
PRAGMA foreign_keys = ON;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE questions_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id), 
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    parent_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)
);

create TABLE question_likes(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
    users(fname, lname)
VALUES
    ('Tianshu', 'Xiao'),
    ('Garret', 'Grant');

INSERT INTO
    questions(title, body, user_id)
VALUES
    ('Confused', 'What title should we pick?', (SELECT id FROM users WHERE fname = 'Tianshu')),
    ('Test', 'What happens when I author 2', (SELECT id FROM users WHERE fname = 'Tianshu')),
    ('IDK','What do we do?',(SELECT id FROM users WHERE fname = 'Garret' AND lname = 'Grant'));

INSERT INTO
    questions_follows(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Tianshu'), (SELECT id FROM questions WHERE id = 1)),
     ((SELECT id FROM users WHERE fname = 'Garret'), (SELECT id FROM questions WHERE id = 1)),
    ((SELECT id FROM users WHERE fname = 'Garret' AND lname = 'Grant'),(SELECT id FROM questions WHERE id = 2));

INSERT INTO
    replies(user_id, question_id, body, parent_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Tianshu'), (SELECT id FROM questions WHERE id = 1), 'Here is my reply', NULL),
    ((SELECT id FROM users WHERE fname = 'Garret' AND lname = 'Grant'),(SELECT id FROM questions WHERE id = 2), 'Wow, nice reply', 1);

INSERT INTO
    question_likes(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Tianshu'), (SELECT id FROM questions WHERE id = 1)),
    ((SELECT id FROM users WHERE fname = 'Garret' AND lname = 'Grant'),(SELECT id FROM questions WHERE id = 2));