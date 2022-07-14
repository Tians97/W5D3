require_relative 'questions_database.rb'
require_relative 'reply.rb'
require_relative 'questions_follows.rb'

class Question
    attr_accessor :id, :title, :body, :user_id


    def self.most_liked(n=1)
        QuestionLikes.most_liked_questions(n)
    end

    def likers
        QuestionLikes.likers_for_question_id(self.id)
    end

    def num_likes
        QuestionLikes.num_likers_for_question_id(self.id)
    end

    def author
        User.find_by_id(self.user_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def self.most_followed(n=1)
        QuestionsFollows.most_followed_questions(n)
    end

    def self.find_by_id(id)
        # debugger
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM 
            questions
            WHERE
            id = ?
        SQL
        return nil unless question.length > 0
        Question.new(question.first)
    end

    def self.find_by_title(title)
        title = QuestionsDatabase.instance.execute(<<-SQL, title)
            SELECT
            *
            FROM 
            questions
            WHERE
            title = ?
        SQL
        return nil unless title.length > 0
        Question.new(title.first)
    end

    def self.find_by_body(body)
        body = QuestionsDatabase.instance.execute(<<-SQL, body)
            SELECT
            *
            FROM 
            questions
            WHERE
            body = ?
        SQL
        return nil unless body.length > 0
        Question.new(body.first)
    end 

    def self.find_by_user_id(user_id)
        user_id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
            *
            FROM 
            questions
            WHERE
            user_id = ?
        SQL

        questions = []
        user_id.each do |hash|
            questions << Question.new(hash)
        end
        return questions[0] if questions.length == 1
        questions
        
        # return nil unless user_id.length > 0
        # Question.new(user_id.first)
    end     

    def followers
        QuestionsFollows.followers_for_question_id(self.id)
    end

    def initialize(hash)
        @id = hash['id']
        @title = hash['title']
        @body = hash['body']
        @user_id = hash['user_id']
    end

    def update
        raise "#{self} not in database" unless self.id
        QuestionsDatabase.instance.execute(<<-SQL, self.id, self.title, self.body, self.user_id)
          UPDATE
            questions
          SET
            title = ?, body = ?, user_id = ?
          WHERE
            id = ?
        SQL
    end
end