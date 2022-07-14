require_relative 'questions_database.rb'
require_relative 'user.rb'
class QuestionsFollows
    attr_accessor :id, :user_id, :question_id
    def initialize(hash)
        @id = hash['id']
        @user_id = hash['user_id']
        @question_id = hash['question_id']
    end

    def self.most_followed_questions(n = 1)
        most_followed = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
        q.id
        FROM
        questions q
        LEFT JOIN
        questions_follows qf on q.id = qf.question_id
        GROUP BY
        1
        ORDER BY
        COUNT(*) desc
        LIMIT ?
    SQL
        arr = []
        most_followed.each do |hash|    
            arr << Question.find_by_id(hash['id'])
        end
        arr
    end

    def self.followers_for_question_id(question_id)
        id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
            u.id, u.fname, u.lname
            FROM 
            questions_follows q
            LEFT JOIN
            users u 
            ON q.user_id = u.id
            WHERE
            q.question_id = ?
        SQL
        users = []
        id.each do |hash|
            users << User.new(hash)
        end
        users
    end

    def self.followers_for_user_id(user_id)
        id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
            q.id, q.title, q.body, q.user_id
            FROM 
            questions_follows qf
            LEFT JOIN
            questions q
            ON qf.question_id = q.id
            WHERE
            qf.user_id = ?
        SQL
        questions = []
        id.each do |hash|
            questions << Question.new(hash)
        end
        questions
    end

    def self.find_by_id(id)
        id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM 
            questions_follows
            WHERE
            id = ?
        SQL
        return nil unless id.length > 0
        Reply.new(id.first)
    end     

    def self.find_by_user_id(user_id)
        user_id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
            *
            FROM 
            questions_follows
            WHERE
            user_id = ?
        SQL
        return nil unless user_id.length > 0
        Reply.new(user_id.first)
    end     

    def self.find_by_question_id(question_id)
        question_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
            *
            FROM 
            questions_follows
            WHERE
            question_id = ?
        SQL
        return nil unless question_id.length > 0
        Reply.new(question_id.first)
    end     


    def self.find_by_question_id(question_id)
        question_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
            *
            FROM 
            replies
            WHERE
            question_id = ?
        SQL
        return nil unless question_id.length > 0
        Reply.new(question_id.first)
    end     

    def self.find_by_body(body)
        body = QuestionsDatabase.instance.execute(<<-SQL, body)
            SELECT
            *
            FROM 
            replies
            WHERE
            body = ?
        SQL
        return nil unless body.length > 0
        Reply.new(body.first)
    end     

    def self.find_by_parent_id(parent_id)
        parent_id = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
            SELECT
            *
            FROM 
            replies
            WHERE
            parent_id = ?
        SQL
        return nil unless parent_id.length > 0
        Reply.new(parent_id.first)
    end     
end