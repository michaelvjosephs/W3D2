

class QuestionLike

  def self.find_by_id(id)
    like = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    raise "Like with id #{id} does not exist" if like.empty?
    QuestionLike.new(like.first)
  end

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

end
