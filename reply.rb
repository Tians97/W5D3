require_relative 'questions_database.rb'
require_relative 'user.rb'
class Reply
    attr_accessor :id, :user_id, :question_id, :body, :parent_id
    def initialize(hash)
        @id = hash['id']
        @user_id = hash['user_id']
        @question_id = hash['question_id']
        @body = hash['body']
        @parent_id = hash['parent_id']
    end

    def author
        User.find_by_id(user_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_id)
    end

    def child_reply
        Reply.find_by_parent_id(id)
    end

    def self.find_by_id(id)
        id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM 
            replies
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
            replies
            WHERE
            user_id = ?
        SQL
        return nil unless user_id.length > 0
        replies = []
        user_id.each do |hash|
            replies << Reply.new(hash)
        end
        return replies[0] if replies.length == 1
        replies
        # Reply.new(user_id.first)
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
        replies = []
        question_id.each do |hash|
            replies << Reply.new(hash)
        end
        return replies[0] if replies.length == 1
        replies
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