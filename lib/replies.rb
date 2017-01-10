
class Reply

  def self.find_by_id(id)
    reply = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    raise "reply with id #{id} does not exist" if reply.empty?
    Reply.new(reply.first)
  end

  def self.find_child_by_id(id)
    children = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
    raise "Child replies for reply #{id} don't exist" if children.empty?
    children.map { |child| Reply.new(child) }
  end

  def self.find_by_user_id(user_id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL
    if replies.empty?
      raise "Can't find reply because user id #{user_id} doesn't exist"
    end
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        subject_question_id = ?
    SQL
    if replies.empty?
      raise "Can't find reply because question_id #{question_id} doesn't exist"
    end

    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @subject_question_id = options['subject_question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@subject_question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_reply_id)
  end

  def child_replies
    Reply.find_child_by_id(@id)
    #Only do child replies one-deep; don't find grandchild comments.
  end
end
