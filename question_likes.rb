require_relative 'questions_database.rb'
require_relative 'question.rb'
class QuestionLikes
    def initialize(hash)
        @id = hash['id']
        @user_id = hash['user_id']
        @question_id = hash['question_id']
    end

    def self.find_by_id(id)
        id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM 
            question_likes
            WHERE
            id = ?
        SQL
        return nil unless id.length > 0
        Reply.new(id.first)
    end     
    
    def self.likers_for_question_id(question_id)
        likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
        u.*
        FROM
        users u
        LEFT JOIN
        question_likes ql on u.id = ql.user_id
        WHERE
        ql.question_id = ?
        SQL
        likers.map do |hash|
            User.new(hash)
        end
    end

    def self.num_likers_for_question_id(question_id)
        num_likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
        count(*) as total
        FROM
        users u
        LEFT JOIN
        question_likes ql on u.id = ql.user_id
        WHERE
        ql.question_id = ?
        SQL
        return num_likers.first['total']
    end

    def self.find_by_user_id(user_id)
        user_id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
            *
            FROM 
            question_likes
            WHERE
            user_id = ?
        SQL
        return nil unless user_id.length > 0
        Reply.new(user_id.first)
    end
    
    def self.liked_questions_for_user_id(user_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
            ql.question_id
            FROM
            question_likes ql
            LEFT JOIN
            users u ON ql.user_id = u.id
            WHERE
            u.id = ?
        SQL
        arr = []
        questions.each do |hash|
            arr << Question.find_by_id(hash['question_id'])
        end
        arr

    end

    def self.find_by_question_id(question_id)
        question_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
            *
            FROM 
            question_likes
            WHERE
            question_id = ?
        SQL
        return nil unless question_id.length > 0
        Reply.new(question_id.first)
    end

    def self.most_liked_questions(n=1)
        most_liked = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
        q.id
        FROM
        questions q
        LEFT JOIN
        question_likes ql on q.id = ql.question_id
        GROUP BY
        1
        ORDER BY
        COUNT(*) desc
        LIMIT ?
        SQL
        arr = []
        most_liked.each do |hash|
            arr << Question.find_by_id(hash['id'])
        end
        arr
    end
end