

class QuestionFollower
  include Savable
  extend Queriable

  attr_reader :id, :follower_id, :question_id

  def self.table
    "question_followers"
  end

  def initialize(options = {})
    @id = options['id']
    @follower_id = options['follower_id']
    @question_id = options['question_id']
  end

  def self.followers_for_question_id(question_id)
    query = <<-SQL
      SELECT
        users.id, lname, fname
      FROM
        users
      JOIN
        question_followers ON follower_id = users.id
      WHERE
        question_id = ?
    SQL

    followers = execute(query, question_id)
    followers.map { |follower| User.new(follower) }
  end

  def self.followed_questions_for_user_id(user_id)
    query = <<-SQL
      SELECT
        questions.id, title, body, author_id
      FROM
        questions
      JOIN
        question_followers ON question_id = questions.id
      WHERE
        follower_id = ?
    SQL

    questions = execute(query, user_id)
    questions.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    query = <<-SQL
      SELECT
        questions.id, title, body, author_id
      FROM
        questions
      JOIN
        question_followers ON question_id = questions.id
      GROUP BY
        question_id
      ORDER BY
        count(*) DESC
      LIMIT(?)
    SQL

    questions = execute(query, n)
    questions.map { |question| Question.new(question) }
  end
end
