

class Question

  attr_accessor :title, :body

  def self.find_by_id(id)
    question = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
   raise "question with id #{id} does not exist" if question.empty?
   Question.new(question.first)
  end

  def self.find_by_title(title)
    question = QuestionDBConnection.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL
    raise "question with title #{title} does not exist" if question.empty?
    Question.new(question.first)
  end

  def self.find_by_author_id(author_id)

    questions = QuestionDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    raise "question with author_id #{author_id} doesn't exist" if questions.empty?
    questions.map { |question| Question.new(question) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end
end
