require 'sqlite3'
require 'singleton'
require_relative 'users'
require_relative 'replies'
require_relative 'questions'
require_relative 'question_follows'
require_relative 'question_likes'

class QuestionDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

# reply = Reply.find_by_id(1)
# reply2 = Reply.find_by_id(2)
# # p reply.author
# # p reply2.author
# # p reply.question
# # p reply2.question
# p reply.child_replies
#
# p reply2.child_replies
# QuestionFollow.followers_for_question_id(2)

# p QuestionFollow.followed_questions_for_user_id(1)
# p QuestionFollow.followed_questions_for_user_id(3)


# x = Question.find_by_id(1)
# p x.followers
# jon = User.find_by_id(1)
# p jon.followed_questions

p QuestionFollow.most_followed_questions(1)
