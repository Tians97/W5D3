require_relative 'questions_database.rb'
require_relative 'question.rb'

class User
    attr_accessor :id
    # def self.all
    #     #it contains many [hashes] (like each row is a hash)
    #     data = QuestionsDatabase.instance.execute("select * from users")
    #     #iterating through each hash, and creating new user instances for each hash
    #     data.map{|datum| Users.new(datum)}
    # end
    def initialize(hash)
        @id = hash['id']
        @fname = hash['fname']
        @lname = hash['lname']
    end


    def update
        raise "#{self} not in database" unless self.id
        QuestionsDatabase.instance.execute(<<-SQL, self.id, self.fname, self.lname)
          UPDATE
            users
          SET
            fname = ?, lname = ?
          WHERE
            id = ?
        SQL
      end
    def

    def authored_questions
        Question.find_by_user_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end



    def self.find_by_name(fname, lname)
        name = QuestionsDatabase.instance.execute(<<-SQL, fname, lname )
            SELECT
            *
            FROM 
            users
            WHERE
            fname = ? AND lname = ?
        SQL
        return nil unless name.length > 0
        # debugger
        User.new(name.first)

    end

    def self.find_by_id(id)
       
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM 
            users
            WHERE
            id = ?
        SQL
        return nil unless user.length > 0
        # debugger
        User.new(user.first)
    end

    def followed_questions
        QuestionsFollows.followers_for_user_id(self.id)
    end

    def liked_questions
        QuestionLikes.liked_questions_for_user_id(self.id)
    end

    def average_karma
        questions = self.authored_questions
        count = 0
        questions.each do |quest_instance|
            count += quest_instance.num_likes
        end
        count.to_f/questions.length
    end

   

end