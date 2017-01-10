

class QuestionFollow

  attr_reader

  def self.find_by_id(id)
    question_follows = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
      SQL
    raise "Follower with id #{id} does not exist" if question_follows.empty?
    QuestionFollow.new(question_follows.first)
  end

  def self.followers_for_question_id(question_id)
    #return users that follow this question.
    followers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON question_follows.user_id = users.id
      WHERE
        question_id = ?
      SQL

    raise "No followers for question #{question_id}" if followers.empty?
    followers.map { |follower| User.new(follower) }
  end

  def self.followed_questions_for_user_id(user_id)
    #any questions that a user is following.
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      WHERE
        user_id = ?
      SQL

    if questions.empty?
      raise "No questions followed for question #{question_id}"
    end

    questions.map { |question| Question.new(question) }
  end


  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.most_followed_questions(n)
    # if n is 1 we want to return question 2 because 2 people are following it.
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
    SELECT
      *
    FROM
      question_follows
    JOIN
      questions ON question_follows.question_id = questions.id
    GROUP BY
      question_id
    ORDER BY
      COUNT(user_id)
    LIMIT
      n
    SQL

    if questions.empty?
      raise 'error'
    end

    questions.map { |question| Question.new(question) }
  end
end
