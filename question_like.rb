
class QuestionLike
  include Savable
  extend Queriable

  attr_reader :id, :liker_id, :question_id

  def self.table
    "question_likes"
  end

  def initialize(options = {})
    @id = options['id']
    @liker_id = options['liker_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question_id(question_id)
    query = <<-SQL
      SELECT
        users.id, fname, lname
      FROM
        users
      JOIN
        question_likes ON liker_id = users.id
      WHERE
        question_id = ?
    SQL

    likers = execute(query, question_id)
    likers.map { |liker| User.new(liker) }
  end

  def self.liked_questions_for_user_id(user_id)
    query = <<-SQL
      SELECT
        questions.id, title, body, author_id
      FROM
        questions
      JOIN
        question_likes ON question_id = questions.id
      WHERE
        liker_id = ?
    SQL

    questions = execute(query, user_id)
    questions.map { |question| User.new(question) }
  end

  def self.num_likes_for_question_id(question_id)
    query = <<-SQL
      SELECT
        COUNT(*) count
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    execute(query, question_id).first['count']
  end

  def self.most_liked_questions(n)
    query = <<-SQL
      SELECT
        questions.id, title, body, author_id
      FROM
        questions
      JOIN
        question_likes ON question_id = questions.id
      GROUP BY
        question_id
      ORDER BY
        count(*) DESC
      LIMIT(?)
    SQL

    questions = execute(query, n)
    questions.map { |question| Question.new(question) }
  end

  def self.average_karma_for_user_id(id)
    query = <<-SQL
    SELECT
      avg(likes)
    FROM (
      SELECT
        count(liker_id) likes
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON question_id = questions.id
      JOIN
        users ON users.id = questions.author_id
      WHERE
        users.id = ?
      GROUP BY
        questions.id
    )
    SQL

    execute(query, id).first.values.first
  end
end
