class User

  attr_reader :id
  attr_accessor :fname, :lname

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    user = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    raise "user with id #{id} does not exist" unless user.length > 0
    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    unless user.length > 0
      raise "user with name #{fname} #{lname} does not exist"
    end
    User.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
    #use_questions::find_by_author_id
  end

  def authored_replies
    Reply.find_by_user_id(@id)
    #use reply :: find by author id
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

end
