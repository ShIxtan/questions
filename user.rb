

class User
  include Savable
  extend Queriable

  attr_accessor :lname, :fname
  attr_reader :id

  def self.table
    "users"
  end

  def self.find_by_name fname, lname
    query = <<-SQL
    SELECT
    *
    FROM
    users
    WHERE
    fname = ? AND lname = ?
    SQL

    users = execute(query, fname, lname)
    users.map { |user| new(user) }.last
  end

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_author_id(id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    QuestionLike.average_karma_for_user_id(id)
  end

end
