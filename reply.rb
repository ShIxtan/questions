
class Reply
  include Savable
  extend Queriable

  attr_accessor :body, :question_id, :author_id, :parent_id
  attr_reader :id

  def self.table
    "replies"
  end

  def self.find_by_author_id author_id
    query = <<-SQL
    SELECT
    *
    FROM
    replies
    WHERE
    author_id = ?
    SQL

    replies = execute(query, author_id)
    replies.map { |reply| new(reply) }
  end

  def self.find_by_question_id question_id
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    replies = execute(query, question_id)
    replies.map { |reply| new(reply) }
  end

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @body = options['body']
    @author_id = options['author_id']
    @parent_id = options['parent_id']
  end

  def author
    User.find_by_id author_id
  end

  def question
    Question.find_by_id question_id
  end

  def parent_reply
    self.class.find_by_id parent_id
  end

  def child_replies
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    replies = execute(query, id)
    replies.map { |reply| self.class.new(reply) }
  end
end
